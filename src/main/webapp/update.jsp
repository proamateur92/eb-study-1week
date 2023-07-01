<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.util.List" %>
<%@ page import="dto.FileDto" %>
<%@ page import="dao.FileDao" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
    <script src="./js/update.js"></script>
    <script src="https://kit.fontawesome.com/c1651245ed.js" crossorigin="anonymous"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="css/common.css">
    <link rel="stylesheet" type="text/css" href="./css/update.css" />
    <title>게시글 수정</title>
<%
    String startDate = "";
    String endDate = "";

    Integer getPage = null;
    Integer getCategoryType = null;

    String getStartDate = null;
    String getEndDate = null;
    String getKeyword = null;

    Integer getBoardId = null;

    BoardDao boardDao = new BoardDao();
    String message = "";

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
        message = "".equals(message) ? "오류가 발생했습니다. 게시글 목록으로 이동합니다." : message;

        out.println("<script>");
        out.println("alert('" + message + "');");
        out.println("location.href='index.jsp'");
        out.println("</script>");

        return;
    }

    System.out.println("UPDATE JSP");
    System.out.println("getBoardId = " + getBoardId);

    FileDao fileDao = new FileDao();

    BoardDto boardDto = boardDao.getBoard(getBoardId);

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

    String createDate = sdf.format(boardDto.getCreate_date());
    String updateDate = boardDto.getUpdate_date() == null ? "-" : sdf.format(boardDto.getUpdate_date());

    // 카테고리 리스트
    Map<Integer, String> categoryMap = boardDao.getCategoryList();

    // 파일 리스트
    List<FileDto> fileList = fileDao.getFileList(getBoardId);
%>
<body>
    <div class="wrap">
        <h1 class="intro">게시판 - 수정</h1>
        <form enctype="multipart/form-data">
            <input type="hidden" id="boardId" value="<%= getBoardId%>" />
            <input type="hidden" id="page" value="<%= getPage%>" />
            <input type="hidden" id="category" value="<%= getCategoryType%>" />
            <input type="hidden" id="startDate" value="<%= getStartDate%>" />
            <input type="hidden" id="endDate" value="<%= getEndDate%>" />
            <input type="hidden" id="keyword" value="<%= getKeyword%>" />
            <div class="line">
                <div class="as">카테고리<span class="point">*</span></div>
                <div class="user">
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
            </div>
            <div class="line">
                <div class="as"><span>등록일시</span></div>
                <div class="user"><span><%= createDate%></span></div>
            </div>
            <div class="line">
                <div class="as"><span>수정일시</span></div>
                <div class="user"><span><%= updateDate%></span></div>
            </div>
            <div class="line">
                <div class="as"><span>조회수</span></div>
                <div class="user"><span><%= boardDto.getView_count()%></span></div>
            </div>
            <div class="line">
                <div class="as"><span>작성자<span class="point">*</span></span></div>
                <div class="user">
                    <input type="text" id="author" value="<%= boardDto.getAuthor()%>">
                </div>
            </div>
            <div class="line">
                <div class="as">
                    <span>비밀번호<span class="point">*</span></span>
                </div>
                <div class="user">
                    <input type="password" id="password" placeholder="비밀번호">
                </div>
            </div>
            <div class="line">
                <div class="as">
                    <span>제목<span class="point">*</span></span>
                </div>
                <div class="user">
                    <input type="text" id="title" value="<%= boardDto.getTitle()%>">
                </div>
            </div>
            <div class="line">
                <div class="as">내용<span class="point">*</span></div>
                <div class="user">
                    <textarea class="content" id="content"><%= boardDto.getContent().replace("<br>", "\n")%></textarea>
                </div>
            </div>
            <div class="line">
                <div class="as"><span>파일 첨부</span></div>
                <div class="user">
                    <%
                        for(int i = 0; i < fileList.size(); i++) {
                    %>
                        <div class="file-box">
                            <i class="fa-solid fa-paperclip"></i>
                            <span class="file-name"><%= fileList.get(i).getOriginal_name()%></span>
                            <button class="btn btn-primary">
                                <a href="downloadAction.jsp?fileName=<%= fileList.get(i).getSave_name()%>">
                                    Download
                                </a>
                            </button>
                            <button type="button" class="x btn btn-danger" onclick="changeDeleteFlag(<%= getBoardId%>, '<%= fileList.get(i).getSave_name()%>', true)">X</button>
                        </div>
                    <%
                        }
                        for(int i = 1 - (fileList.size()); i > 0; i--) {
                    %>
                        <div class="file-box">
                            <input type="file" id="file">
                        </div>
                    <%
                        }
                    %>
                </div>
            </div>
            <div class="btn-box">
                <button class="btn btn-secondary" type="button" onclick="movePage()">취소</button>
                <button class="btn btn-primary" type="button" onclick="onUpdate()">저장</button>
            </div>
        </form>
    </div>
</body>
</html>
