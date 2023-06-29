<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="dto.CommentDto" %>
<%@ page import="java.util.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>게시글 상세보기</title>
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
    <script src="./js/detail.js"></script>
    <link rel="stylesheet" type="text/css" href="./css/detail.css" />
</head>
<%
    String startDate = "";
    String endDate = "";

    Integer getPage = null;
    Integer getCategoryType = null;

    String getStartDate = null;
    String getEndDate = null;
    String getKeyword = null;

    Integer getBoardId = null;

    // 게시글 번호가 없으면
    try {
        getBoardId = Integer.parseInt(request.getParameter("id"));

        String pageString = request.getParameter("page");
        getPage = Integer.parseInt(pageString == null ? "1" : pageString);

        String categoryTypeString = request.getParameter("category");
        getCategoryType = Integer.parseInt(categoryTypeString == null ? "0" : categoryTypeString);

        getKeyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");

        // 현재 날짜 가져오기
        getStartDate = request.getParameter("startDate");
        getEndDate = request.getParameter("endDate");

        startDate = getStartDate.substring(0, 4) + "-" +  getStartDate.substring(4,6) + "-" + getStartDate.substring(6,8);
        endDate = getEndDate.substring(0, 4) + "-" +  getEndDate.substring(4,6) + "-" + getEndDate.substring(6,8);

        // 올바른 시간 형식인지 체크
        LocalDate.parse(startDate);
        LocalDate.parse(endDate);

        // 범위 값이 맞지 않으면 날짜 동일하게 처리
        if(Integer.parseInt(getStartDate) > Integer.parseInt(getEndDate)) {
            getStartDate = getEndDate;
        }
    } catch (Exception e) {
        out.println("<script>");
        out.println("alert('잘못된 요청입니다. 게시글 목록으로 이동합니다.');");
        out.println("</script>");
        response.sendRedirect("index.jsp");
        return;
    }

    String message = "";

    BoardDao boardDao = new BoardDao();

    try {
        LinkedHashMap<Integer, String> categoryMap = boardDao.getCategoryList();
        boolean isIncrease = boardDao.increaseViewCount(getBoardId);
        BoardDto boardDto = boardDao.getBoard(getBoardId);

        // 해당 id의 게시글이 존재하지 않는 경우
        if(boardDto == null) {
            message = "존재하지 않는 게시물입니다.";
        }

        // 해당 id의 게시글의 조회수 쿼리의 문제가 있는 경우
        if(!isIncrease) {
            throw new Exception();
        }

        // 카테고리 이름 가져오기
        String categoryName = categoryMap.get(boardDto.getCategory_id());

        // 날짜 형식 포맷 변환
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

        String createDate = sdf.format(boardDto.getCreate_date());
        String updateDate = boardDto.getUpdate_date() == null ? "-" : sdf.format(boardDto.getUpdate_date());

        List<CommentDto> commentList = new ArrayList();

        System.out.println("commentList = " + commentList);
        commentList = boardDao.getCommentList(getBoardId);
%>
<body>
<div>
    <h1>게시판 - 보기</h1>
</div>

<input type="hidden" id="keyword" value="<%= getKeyword%>"/>
<input type="hidden" id="boardId" value="<%= getBoardId%>">
<input type="hidden" id="page" value="<%= getPage%>" />
<input type="hidden" id="category" value="<%= getCategoryType%>" />
<input type="hidden" id="startDate" value="<%= getStartDate%>" />
<input type="hidden" id="endDate" value="<%= getEndDate%>" />

<div class="board-date">
    <span><%= boardDto.getAuthor()%></span>
    <div>
        <span>등록일시 <%= createDate%></span>
        <span>수정일시 <%= updateDate%></span>
    </div>
</div>
<div class="board-wrap">
    <div class="top">
        <div class="top-box">
            <span class="category"><%= categoryName%></span>
            <span class="title"><%= boardDto.getTitle()%></span>
        </div>
        <span class="view-count">조회수: <span><%= boardDto.getView_count()%></span></span>
    </div>
    <div class="body">
        <textarea readonly><%= boardDto.getContent()%></textarea>
    </div>
    <div class="file-wrap">
        <div class="file-box">
            <div>아이콘</div>
            <span>첨부파일1.hwp</span>
        </div>
    </div>
</div>
<form id="commentForm">
<%
        for(CommentDto comment: commentList) {
            String formattedCommentDate = sdf.format(comment.getCreate_date());
%>
    <div class="comment">
        <div class="top">
            <span class="nickname"><%= comment.getNickname()%></span>
            <span class="date"><%= formattedCommentDate%></span>
        </div>
        <div class="body">
            <span><%= comment.getContent()%></span>
        </div>
    </div>
<%
        }
%>
    <div class="input-wrap">
        <div class="info-box">
            <input type="text" id="nickname" name="nickname" class="nickname" />
            <input type="text" id="password" name="password" style="display: none" class="info-password" />
        </div>
        <div class="input-box">
            <textarea id="content" name="content" placeholder="댓글을 입력해주세요."></textarea>
            <button type="button" onclick="onCommentSubmit()">등록</button>
        </div>
    </div>
</form>
<div class="btn-box">
    <button onclick="movePage('LIST')">목록</button>
    <button onclick="movePage('UPDATE')">수정</button>
    <button onclick="movePage('DELETE')">삭제</button>
</div>
<%
    } catch (Exception e) {
        message = message == null ? "오류가 발생했습니다. 리스트페이지로 이동합니다." : message;

        out.println("<script>");
        out.println("alert('" + message + "');");
        out.println("location.href=index.jsp?id=" + getBoardId + "&page=" + getPage + "&startDate=" + startDate + "&endDate=" + endDate+ "&category=" + getCategoryType + "&keyword=" + getKeyword);
        out.println("</script>");
    }
%>
</body>
</html>
