<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="dto.PageDto" %>
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
    String getPageString = request.getParameter("page");
    Integer getPage = Integer.parseInt(getPageString == null ? "1" : getPageString);

    BoardDao boardDao = new BoardDao();

    Map<Integer, String> categoryMap = boardDao.getCategoryList();

    // 페이징 처리
    int boardCount = boardDao.getBoardCount();
    PageDto pageDto = new PageDto(getPage, boardCount);

    List<BoardDto> boardList = boardDao.getBoardList(pageDto);
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
          String getTitle = board.getTitle().length() >= 80 ? board.getTitle().substring(0, 51) + "..." : board.getTitle();
          out.print("<tr>");
          out.print("<td>" + categoryMap.get(board.getCategory_id()) + "</td>");
          out.print("<td>" + board.getFile_flag() + "</td>");
          out.print("<td><a href='detail.jsp?id=" + board.getId() + "'>" + getTitle + "</a></td>");
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
<div class="pagination">
    <%
        if(pageDto.getIsPrev()) {
    %>
        <a href="index.jsp?page=1"><div class="first"><<</div></a>
        <a href="index.jsp?page=<%= pageDto.getBeginPage() - 1%>"><div class="prev"><</div></a>
    <%
        }
    %>
    <div class="number">
        <%
            for(int i = pageDto.getBeginPage(); i <= pageDto.getEndPage(); i++) {
                if(i == pageDto.getPage()) {
        %>
            <a href="index.jsp?page=<%= i%>"><div class="page selected"><%= i%></div></a>
        <%
                    continue;
                }
        %>
             <a href="index.jsp?page=<%= i%>"><div class="page"><%= i%></div></a>
        <%
            }
        %>
    </div>
    <%
        if(pageDto.getIsNext()) {
    %>
     <a href="index.jsp?page=<%= pageDto.getEndPage() + 1%>"><div class="next">></div></a>
     <a href="index.jsp?page=<%= pageDto.getTotalPage()%>"><div class="last">>></div></a>
    <%
        }
    %>

</div>
<button onclick="location.href='write.jsp'">등록</button>

</body>
</html>
