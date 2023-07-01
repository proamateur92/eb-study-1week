<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.LinkedHashMap" %>
<%@ page import="java.time.LocalDate" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
    <script src="./js/write.js" defer></script>
    <link rel="stylesheet" type="text/css" href="css/common.css">
    <link rel="stylesheet" type="text/css" href="./css/write.css" />
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" />
    <title>게시글 작성</title>
</head>
<body>
    <div class="wrap">
        <h1 class="intro">게시판 - 등록</h1>
        <%
            LinkedHashMap<Integer, String> categoryMap = null;
            Integer getPage = null;
            Integer getCategoryType = null;
            String getKeyword = null;
            String getStartDate = null;
            String getEndDate = null;

            try {
                BoardDao boardDao = new BoardDao();
                categoryMap = boardDao.getCategoryList();

                String pageString = request.getParameter("page");
                getPage = Integer.parseInt(pageString == null ? "1" : pageString);

                String categoryTypeString = request.getParameter("category");
                getCategoryType = Integer.parseInt(categoryTypeString == null ? "" : categoryTypeString);

                getKeyword = request.getParameter("keyword") == null ? "" : request.getParameter("keyword");

                String startDate = "";
                String endDate = "";

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
        %>

        <form id="form" method="post" enctype="multipart/form-data">
            <input type="hidden" id="page" name="page" value="<%= getPage%>" />
            <input type="hidden" id="getCategory" name="getCategory" value="<%= getCategoryType%>" />
            <input type="hidden" id="startDate" name="startDate" value="<%= getStartDate%>" />
            <input type="hidden" id="endDate" name="endDate" value="<%= getEndDate%>" />
            <input type="hidden" id="keyword" name="keyword" value="<%= getKeyword%>" />
            <div class="line">
                <div class="as">카테고리<span class="point">*</span></div>
                <div class="user">
                    <select id="category" name="category">
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
            <div class="line">
                <div class="as">작성자<span class="point">*</span></div>
                <div class="user">
                    <input type="text" id="author" name="author" placeholder="작성자를 입력해주세요.">
                </div>
            </div>
            <div class="line">
                <div class="as">비밀번호<span class="point">*</span></div>
                <div class="user password">
                    <input type="password" id="password" name="password" placeholder="비밀번호">
                    <input type="password" id="passwordCheck" name="passwordCheck" placeholder="비밀번호 확인">
                </div>
            </div>
            <div class="line">
                <div class="as">제목<span class="point">*</span></div>
                <div class="user">
                    <input type="text" id="title" name="title" placeholder="제목을 입력해주세요">
                </div>
            </div>
            <div class="line">
                <div class="as">내용<span class="point">*</span></div>
                <div class="user">
                    <textarea class="content" id="content" name="content"></textarea>
                </div>
            </div>
            <div class="line">
                <div class="as">파일 첨부</div>
                <div class="user">
                    <input type="file" name="file" id="file">
                </div>
            </div>
            <div class="btn-box">
                <button type="button" class="btn btn-secondary" onclick="movePage()">취소</button>
                <button type="button" class="btn btn-primary" onclick="insertBoard()">저장</button>
            </div>
        </form>
    </div>
</body>
</html>
