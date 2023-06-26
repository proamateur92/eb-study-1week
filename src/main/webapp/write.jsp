<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="./js/write.js" defer></script>
    <link rel="stylesheet" type="text/css" href="./css/write.css" />
    <title>게시글 작성</title>
</head>
<body>
<div>
    <h1>게시판 - 등록</h1>
</div>
<%
    BoardDao boardDao = new BoardDao();
    LinkedHashMap<Integer, String> categoryMap = boardDao.getCategoryList();
%>
<form name="form" method="post">
    <div class="row">
        <div class="title">카테고리<span class="point">*</span></div>
        <div>
            <select name="category">
                <option value="0">카테고리 선택</option>
                <%
                    for(Map.Entry<Integer, String> entry : categoryMap.entrySet()) {
                %>
                    <option value="<%= entry.getKey()%>"><%= entry.getValue()%></option>
                <%
                    }
                %>
            </select>
        </div>
    </div>
    <div class="row">
        <div class="title">작성자<span class="point">*</span></div>
        <div>
            <input type="text" name="author">
        </div>
    </div>
    <div class="row">
        <div class="title">비밀번호<span class="point">*</span></div>
        <div>
            <input type="text" name="password" placeholder="비밀번호">
            <input type="text" name="passwordCheck" placeholder="비밀번호 확인">
        </div>
    </div>
    <div class="row">
        <div class="title">제목<span class="point">*</span></div>
        <div>
            <input type="text" name="title" placeholder="제목을 입력해주세요">
        </div>
    </div>
    <div class="row">
        <div class="title">내용<span class="point">*</span></div>
        <div>
            <textarea name="content"></textarea>
        </div>
    </div>
    <div class="row">
        <div class="title">파일 첨부</div>
        <div class="conetent file-wrap">
            <div>
                <input type="text">
                <button>파일찾기</button>
            </div>
            <div>
                <input type="text">
                <button>파일찾기</button>
            </div>
            <div>
                <input type="text">
                <button>파일찾기</button>
            </div>
        </div>
    </div>
</form>
<div>
    <button onclick="location.href='index.jsp'">취소</button>
    <button onclick="insertBoard()">저장</button>
</div>
</body>
</html>
