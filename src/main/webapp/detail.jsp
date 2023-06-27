<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>게시글 상세보기</title>
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
    <link rel="stylesheet" type="text/css" href="./css/detail.css" />
</head>
<script>
    function movePage(type) {
        const form = $('#form');

        let page = "update.jsp";

        if(type == "delete") page = "passwordCheck.jsp";

        form.attr("action", page);
        form.attr("method", "post");
        form.submit();
    };
</script>
<%
    Integer boardId = Integer.parseInt(request.getParameter("id"));
    String message = "";

    // 게시글 번호가 존재하지 않으면
    if(boardId == null) {
        throw new Exception();
    }

    BoardDao boardDao = new BoardDao();

    try {
        LinkedHashMap<Integer, String> categoryMap = boardDao.getCategoryList();
        boolean isIncrease = boardDao.increaseViewCount(boardId);
        BoardDto boardDto = boardDao.getBoard(boardId);

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
%>
<body>
<div>
    <h1>게시판 - 보기</h1>
</div>
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
<div class="comment-wrap">
    <div class="comment">
        <div class="comment-date">2020.03.09 16:32</div>
        <div class="comment-body">댓글이 출력됩니다.</div>
    </div>
    <div class="comment-input-box">
        <textarea placeholder="댓글을 입력해주세요."></textarea>
        <button>등록</button>
    </div>
</div>
<div class="btn-box">
    <form id="form" method="post">
        <input type="hidden" name="boardId" value="<%= boardId%>">
    </form>
    <button onclick="location.href='index.jsp'">목록</button>
    <button onclick="movePage('update')">수정</button>
    <button onclick="movePage('delete')">삭제</button>
</div>
<%
    } catch (Exception e) {
        message = message == null ? "오류가 발생했습니다. 리스트페이지로 이동합니다." : message;

        out.println("<script>");
        out.println("alert('" + message + "');");
        out.println("location.href='index.js'");
        out.println("</script>");
    }
%>
</body>
</html>
