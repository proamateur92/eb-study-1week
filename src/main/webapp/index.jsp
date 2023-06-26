<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>게시글 목록</title>
    <link rel="stylesheet" type="text/css" href="css/main.css">
</head>

<%
    BoardDao boardDao = new BoardDao();

    Map<Integer, String> categoryMap = boardDao.getCategoryList();
    int boardCount = boardDao.getBoardCount();
    List<BoardDto> boardList = boardDao.getBoardList();
%>
<body>
<div>검색 영역</div>
<div>
    <div>총 <%= boardCount%>건</div>
    <table>
        <thead>
        <tr>
            <th>카테고리</th>
            <th>파일</th>
            <th>제목</th>
            <th>작성자</th>
            <th>조회수</th>
            <th>등록 일시</th>
            <th>수정 일시</th>
        </tr>
        </thead>
        <tbody>
<%

        // 날짜 형식 포맷 변환
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

        for(BoardDto board : boardList) {
          String createDate = sdf.format(board.getCreate_date());
          String updateDate = board.getUpdate_date() == null ? "-" : sdf.format(board.getUpdate_date());

          out.print("<tr>");
          out.print("<td>" + categoryMap.get(board.getCategory_id()) + "</td>");
          out.print("<td>" + board.getFile_flag() + "</td>");
          out.print("<td><a href='detail.jsp?id=" + board.getId() + "'>" + board.getTitle() + "</a></td>");
          out.print("<td>" + board.getAuthor() + "</td>");
          out.print("<td>" + board.getView_count() + "</td>");
          out.print("<td>" + createDate + "</td>");
          out.print("<td>" + updateDate + "</td>");
          out.print("</tr>");
    }
%>
        </tbody>
    </table>
</div>
<div>페이징 영역</div>
<button onclick="location.href='write.jsp'">등록</button>

</body>
</html>
