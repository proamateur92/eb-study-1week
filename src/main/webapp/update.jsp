<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
    <script src="./js/update.js"></script>
    <title>게시글 수정</title>
    <style>
        .row {
            display: flex;
        }

        .title {
            width: 8rem;
            border: 1px solid black;
        }

        .file-wrap {
            display: flex;
            flex-direction: column;
        }

        .file-box {
            display: flex;
        }

        .point {
            color: red;
        }
    </style>
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

    System.out.println("UPDATE JSP");
    System.out.println("getBoardId = " + getBoardId);

    BoardDao boardDao = new BoardDao();
    BoardDto boardDto = boardDao.getBoard(getBoardId);

    if(boardDto.getId() == null) {
        out.println("<script>");
        out.println("alert('존재하지 않는 게시글입니다.');");
        out.println("</script>");
        response.sendRedirect("index.jsp");
    };

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

    String createDate = sdf.format(boardDto.getCreate_date());
    String updateDate = boardDto.getUpdate_date() == null ? "-" : sdf.format(boardDto.getUpdate_date());

    Map<Integer, String> categoryMap = boardDao.getCategoryList();
%>
<body>
<div>
    <h1>게시판 - 수정</h1>
</div>
<div>
    <input type="hidden" id="boardId" value="<%= getBoardId%>" />
    <input type="hidden" id="page" value="<%= getPage%>" />
    <input type="hidden" id="category" value="<%= getCategoryType%>" />
    <input type="hidden" id="startDate" value="<%= getStartDate%>" />
    <input type="hidden" id="endDate" value="<%= getEndDate%>" />
    <input type="hidden" id="keyword" value="<%= getKeyword%>" />
    <div class="row">
        <div class="title">카테고리<span class="point">*</span></div>
        <select id="categoryId">
            <% for(Map.Entry entry : categoryMap.entrySet()) {
                if(entry.getKey() == boardDto.getCategory_id()) {
            %>
                <option value="<%= entry.getKey()%>" selected><%= entry.getValue()%></option>
            <%
                } else {
            %>
                <option value="<%= entry.getKey()%>"><%= entry.getValue()%></option>
            <% }} %>
        </select>
    </div>
    <div class="row">
        <div class="title">등록일시</div>
        <span><%= createDate%></span>
    </div>
    <div class="row">
        <div class="title">수정일시</div>
        <span><%= updateDate%></span>
    </div>
    <div class="row">
        <div class="title">조회수</div>
        <span><%= boardDto.getView_count()%></span>
    </div>
    <div class="row">
        <div class="title">작성자<span class="point">*</span></div>
        <div>
            <input type="text" id="author" value="<%= boardDto.getAuthor()%>">
        </div>
    </div>
    <div class="row">
        <div class="title">비밀번호<span class="point">*</span></div>
        <div>
            <input type="text" id="password" placeholder="비밀번호">
        </div>
    </div>
    <div class="row">
        <div class="title">제목<span class="point">*</span></div>
        <div>
            <input type="text" id="title" value="<%= boardDto.getTitle()%>">
        </div>
    </div>
    <div class="row">
        <div class="title">내용<span class="point">*</span></div>
        <div>
            <textarea id="content"><%= boardDto.getContent()%></textarea>
        </div>
    </div>
    <div class="row">
        <div class="title">파일 첨부</div>
        <div class="content file-wrap">
            <div class="file-box">
                <div>아이콘</div>
                <span>첨부파일1.pdf</span>
                <button>Download</button>
                <button>X</button>
            </div>
            <div class="file-box">
                <input type="text">
                <button>파일찾기</button>
            </div>
            <div class="file-box">
                <input type="text">
                <button>파일찾기</button>
            </div>
        </div>
    </div>
    <div>
        <button onclick="movePage()">취소</button>
        <button onclick="onUpdate()">저장</button>
    </div>
</div>
</body>
</html>
