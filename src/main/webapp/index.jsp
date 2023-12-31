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
    <script src="./js/main.js"></script>
    <script src="https://kit.fontawesome.com/c1651245ed.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="css/index.css">
    <link rel="stylesheet" type="text/css" href="css/common.css">
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" />
    <title>게시글 목록</title>
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

    Map<Integer, String> categoryMap = null;

    try {
    // 카테고리 리스트를 위한 map
    categoryMap = boardDao.getCategoryList();

    // 카테고리 값이 카테고리 범위를 초과하면 카테고리 길이만큼 값을 재할당
    categoryType = categoryType > categoryMap.size() ? categoryMap.size() : categoryType;
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>");
        out.println("alert('통신이 불안정합니다. 잠시후 다시 시도해주세요.');");
        out.println("</script>");
    }

    // 페이징 처리
    int boardCount = boardDao.getBoardCount(startDate, endDate, categoryType, getKeyword);
    PageDto pageDto = new PageDto(getPage, boardCount);

    System.out.println("getPage = " + getPage);
    // 해당 조건에 일치하는 게시글 가져오기
    List<BoardDto> boardList = boardDao.getBoardList(pageDto, startDate, endDate, categoryType, getKeyword);

    System.out.println(boardList);
%>
<body>
    <div class="wrap">
        <h1 class="intro">자유 게시판 - 목록</h1>
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
                    <input type="text" id="keyword" value="<%= getKeyword%>" placeholder="검색어를 입력해주세요. (제목 + 작성자 + 내용)"/>
                    <button class="btn btn-primary" onclick="onSearch()">검색</button>
                </div>
            </div>
        </div>
        <div class="table-responsive">
            <div class="count">총 <%= boardCount%>건</div>
            <table class="table table-bordered">
                <% if(boardList != null) { %>
                    <thead class="table-light">
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
                        %>
                        <td>
                            <%
                                if("Y".equals(board.getFile_flag())) {
                            %>
                            <i class="fa-solid fa-paperclip"></i>
                            <%
                                }
                            %>
                        </td>
                        <td class="link" onclick="movePage(<%= pageDto.getPage()%>, 'DETAIL', <%= board.getId()%>)"><%= board.getTitle()%></td>
                        <%
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
        <ul class="pagination justify-content-center">
            <%
                if(boardList != null && pageDto.getIsPrev()) {
            %>
                <li class="page-link" onclick="movePage(1)">first</li>
                <li class="page-link" onclick="movePage(<%= pageDto.getBeginPage() - 1%>)">prev</li>
            <%
                }
                for(int i = pageDto.getBeginPage(); i <= pageDto.getEndPage(); i++) {
                    if(i == pageDto.getPage()) {
            %>
                <li class="page-link selected" onclick="movePage(<%= i%>)"><%= i%></li>
            <%
                        continue;
                    }
            %>
                <li class="page-link" onclick="movePage(<%= i%>)"><%= i%></li>
            <%
                }
                if(boardList != null && pageDto.getIsNext()) {
            %>
            <li class="page-link" onclick="movePage(<%= pageDto.getEndPage() + 1%>)">next</li>
            <li class="page-link" onclick="movePage(<%= pageDto.getTotalPage()%>)">last</li>
            <%
                }
            %>
        </ul>
        <button class="btn btn-primary" onclick="movePage(<%= pageDto.getPage()%> ,'WRITE')">등록</button>
    </div>
</body>
</html>
