<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="dto.CommentDto" %>
<%@ page import="java.util.*" %>
<%@ page import="dto.FileDto" %>
<%@ page import="dao.CommentDao" %>
<%@ page import="dao.FileDao" %>
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
    <script src="https://kit.fontawesome.com/c1651245ed.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="./css/common.css" />
    <link rel="stylesheet" type="text/css" href="./css/detail.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" />
<%
    String startDate = "";
    String endDate = "";

    Integer getPage = null;
    Integer getCategoryType = null;

    String getStartDate = null;
    String getEndDate = null;
    String getKeyword = null;

    Integer getBoardId = null;

    String message = "";
    BoardDao boardDao = new BoardDao();

    // 게시글 번호가 없으면
    try {
        getBoardId = Integer.parseInt(request.getParameter("id"));
        Integer targetBoardId = boardDao.getBoard(getBoardId).getId();

        System.out.println("targetBoardId = " + targetBoardId);

        if(targetBoardId == null) {
            message = "존재하지 않는 게시글입니다.";
            throw new Exception("NO EXIST BOARD");
        }

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
        message = "".equals(message) ? "오류가 발생했습니다. 리스트페이지로 이동합니다." : message;
        out.println("<script>");
        out.println("alert('" + message + "');");
        out.println("location.href='index.jsp'");
        out.println("</script>");
        return;
    }

    CommentDao commentDao = new CommentDao();
    FileDao fileDao = new FileDao();

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
        List<FileDto> fileList = new ArrayList();

        System.out.println("commentList = " + commentList);

        // 댓글 불러오기
        commentList = commentDao.getCommentList(getBoardId);

        // 첨부 파일 가져오기
        fileList = fileDao.getFileList(getBoardId);
%>
<body>
    <div class="wrap">
        <h1 class="intro">게시판 - 보기</h1>

        <input type="hidden" id="keyword" value="<%= getKeyword%>"/>
        <input type="hidden" id="boardId" value="<%= getBoardId%>">
        <input type="hidden" id="page" value="<%= getPage%>" />
        <input type="hidden" id="category" value="<%= getCategoryType%>" />
        <input type="hidden" id="startDate" value="<%= getStartDate%>" />
        <input type="hidden" id="endDate" value="<%= getEndDate%>" />

        <div class="board-date">
            <span><%= boardDto.getAuthor()%></span>
            <div class="board-date">
                <span>등록일시 <%= createDate%></span>
                <span>수정일시 <%= updateDate%></span>
            </div>
        </div>
        <div class="board-wrap">
            <div class="top">
                <div class="top-box">
                    <span class="category">[<%= categoryName%>]</span>
                    <span class="title"><%= boardDto.getTitle()%></span>
                </div>
                <span class="view-count">조회수: <span><%= boardDto.getView_count()%></span></span>
            </div>
            <div class="board-body">
                <%= boardDto.getContent().replace("<br>", "\n")%>
            </div>
            <div class="file-wrap">
                <%
                    for(FileDto file : fileList) {
                        if("N".equals(file.getDelete_flag())) {
                %>
                    <div class="file-box">
                        <a href="downloadAction.jsp?fileName=<%= file.getSave_name()%>">
                            <i class="fa-solid fa-download"></i>
                            <span><%= file.getOriginal_name()%></span>
                        </a>
                    </div>
                <%
                        }
                    }
                %>
            </div>
        </div>
        <form id="commentForm">
        <%
                for(CommentDto comment: commentList) {
                    String formattedCommentDate = sdf.format(comment.getCreate_date());
        %>
            <div class="comment">
                <div class="comment-top">
                    <span class="nickname"><%= comment.getNickname()%></span>
                    <span class="date"><%= formattedCommentDate%></span>
                </div>
                <div class="comment-body">
                    <%= comment.getContent()%>
                </div>
            </div>
        <%
                }
        %>
            <div class="input-wrap">
                <div class="info-box">
                    <input type="text" id="nickname" name="nickname" class="nickname" placeholder="닉네임" />
                    <input type="text" id="password" name="password" style="display: none" class="info-password" />
                </div>
                <div class="input-box">
                    <textarea id="content" name="content" placeholder="댓글을 입력해주세요."></textarea>
                    <button class="btn btn-primary" type="button" onclick="onCommentSubmit()">등록</button>
                </div>
            </div>
        </form>
        <div class="btn-box">
            <button class="btn btn-primary" onclick="movePage('LIST')">목록</button>
            <button class="btn btn-success" onclick="movePage('UPDATE')">수정</button>
            <button class="btn btn-danger" onclick="movePage('DELETE')">삭제</button>
        </div>
    </div>
<%
    } catch (Exception e) {
        message = "".equals(message) ? "오류가 발생했습니다. 리스트페이지로 이동합니다." : message;

        out.println("<script>");
        out.println("alert('" + message + "');");
        out.println("location.href=index.jsp?&page=" + getPage + "&startDate=" + startDate + "&endDate=" + endDate+ "&category=" + getCategoryType + "&keyword=" + getKeyword);
        out.println("</script>");
    }
%>
</body>
</html>
