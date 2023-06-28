<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="dto.PageDto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="https://code.jquery.com/jquery-1.11.3.js"></script>
    <title>게시글 목록</title>
    <link rel="stylesheet" type="text/css" href="css/main.css">
</head>

<%
    // 현재 페이지 값 가져오기
    String getPageString = request.getParameter("page");
    Integer getPage = Integer.parseInt(getPageString == null ? "1" : getPageString);

    // 현재 카테고리 타입 가져오기
    String getCategory = request.getParameter("category");
    Integer categoryType = Integer.parseInt(getCategory == null ? "0" : getCategory);

    // 키워드 가져오기
    String getKeyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");

    // 현재 날짜 가져오기
    String getStartDate = request.getParameter("startDate");
    String getEndDate = request.getParameter("endDate");

    String startDate = "";
    String endDate = "";

    try {
        startDate = getStartDate.substring(0, 4) + "-" +  getStartDate.substring(4,6) + "-" + getStartDate.substring(6,8);
        endDate = getEndDate.substring(0, 4) + "-" +  getEndDate.substring(4,6) + "-" + getEndDate.substring(6,8);

        // 올바른 시간 형식인지 체크
        LocalDate localStartDate = LocalDate.parse(startDate);
        LocalDate localEndDate = LocalDate.parse(endDate);

        // 범위 값이 맞지 않으면 날짜 동일하게 처리
        if(Integer.parseInt(getStartDate) > Integer.parseInt(getEndDate)) {
            startDate = endDate;
        }
    } catch (Exception e) {
        Calendar cal = Calendar.getInstance();
        cal.setTime(new Date());
        SimpleDateFormat ymdForm = new SimpleDateFormat("yyyyMMdd");

        endDate = ymdForm.format(cal.getTime());
        cal.add(Calendar.YEAR, -1);
        startDate = ymdForm.format(cal.getTime());

        response.sendRedirect("index.jsp?page=1&startDate=" + startDate + "&endDate=" + endDate+ "&category=" + categoryType + "&keyword=" + getKeyword);
        return;
    }

    BoardDao boardDao = new BoardDao();

    Map<Integer, String> categoryMap = boardDao.getCategoryList();

    // 페이징 처리
    int boardCount = boardDao.getBoardCount(startDate, endDate, categoryType, getKeyword);
    PageDto pageDto = new PageDto(getPage, boardCount);

    // 해당 조건에 일치하는 게시글 가져오기
    List<BoardDto> boardList = boardDao.getBoardList(pageDto, startDate, endDate, categoryType, getKeyword);
%>
<script>
    function movePage(page) {
        const startDate = $('#startDate').val().replaceAll('-', '');
        const endDate = $('#endDate').val().replaceAll('-', '');
        const category = $('#category').val();
        const keyword = $('#keyword').val();

        location.href = 'index.jsp?page='+ page + '&startDate=' + startDate + '&endDate=' + endDate+ '&category=' + category + '&keyword=' + keyword;
    }

    // 시작 날짜 변경 시 끝 날짜의 최소 범위 변경
    function updateMinRange() {
        const getStartDate = $('#startDate');
        const getEndDate = $('#endDate');

        getEndDate.attr('min', getStartDate.val());
    }

    // 끝 날짜 변경 시 시작 날짜의 최대 범위 변경
    function updateMaxRange() {
        const getStartDate = $('#startDate');
        const getEndDate = $('#endDate');

        getStartDate.attr('max', getEndDate.val());
    }

    function onSearch() {
        const startDate = $('#startDate').val().replaceAll('-', '');
        const endDate = $('#endDate').val().replaceAll('-', '');
        const category = $('#category').val();
        const keyword = $('#keyword').val();

        location.href = 'index.jsp?page=1&startDate=' + startDate + '&endDate=' + endDate+ '&category=' + category + '&keyword=' + keyword;
    }
</script>
<body>
<h1>자유 게시판 - 목록</h1>
<input type="hidden" id="page" value="<%= pageDto.getPage()%>" />
<div class="search-wrap">
    <div class="date-box">
        등록일
        <input type="date" id="startDate" value="<%= startDate%>" max="<%= endDate%>" oninput="updateMinRange()"/>
        ~
        <input type="date" id="endDate" value="<%= endDate%>" min="<%= startDate%>" oninput="updateMaxRange()"/>
    </div>
    <div class="search-box">
        <select id="category" class="category">
            <option value="0">전체 카테고리</option>
            <% for(Map.Entry entry : categoryMap.entrySet()) {
                if(entry.getKey() == categoryType) {
            %>
            <option value="<%= entry.getKey()%>" selected><%= entry.getValue()%></option>
            <%
            } else {
            %>
            <option value="<%= entry.getKey()%>"><%= entry.getValue()%></option>
            <% }} %>
        </select>
        <div class="keyword-box">
            <input type="text" id="keyword" value="<%= getKeyword%>"/>
            <button onclick="onSearch()">검색</button>
        </div>
    </div>
</div>
<div>
    <div>총 <%= boardCount%>건</div>
    <table>
        <% if(boardList != null) { %>
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
        <% } %>
        <tbody>
<%
        // 날짜 형식 포맷 변환
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

        if(boardList != null) {
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
        } else {
            out.println("<h1>게시글이 존재하지 않습니다.</h1>");
        }
%>
        </tbody>
    </table>
</div>
<div class="pagination">
    <%
        if(boardList != null && pageDto.getIsPrev()) {
    %>
        <button class="first" onclick="movePage(1)"><</button>
        <button class="prev" onclick="movePage(<%= pageDto.getBeginPage() - 1%>)"><<</button>
    <%
        }
    %>
    <div class="number">
        <%
            for(int i = pageDto.getBeginPage(); i <= pageDto.getEndPage(); i++) {
                if(i == pageDto.getPage()) {
        %>
            <button class="page selected" onclick="movePage(<%= i%>)"><%= i%></button>
        <%
                    continue;
                }
        %>
            <button class="page" onclick="movePage(<%= i%>)"><%= i%></button>
        <%
            }
        %>
    </div>
    <%
        if(boardList != null && pageDto.getIsNext()) {
    %>
    <button class="next" onclick="movePage(<%= pageDto.getEndPage() + 1%>)">></button>
    <button class="last" onclick="movePage(<%= pageDto.getTotalPage()%>)">>></button>
    <%
        }
    %>

</div>
<button onclick="location.href='write.jsp'">등록</button>

</body>
</html>
