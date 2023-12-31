<%@ page import="java.time.LocalDate" %>
<%@ page import="dao.BoardDao" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
    <script src="./js/passwordCheck.js"></script>
    <link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css" />
    <link rel="stylesheet" type="text/css" href="css/passwordCheck.css">
    <link rel="stylesheet" type="text/css" href="css/common.css">
    <title>비밀번호 확인</title>
</head>
<body>
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
        message = "".equals(message) ? "오류가 발생했습니다. 게시글 목록으로 이동합니다." : message;
        out.println("<script>");
        out.println("alert('"+ message + "');");
        out.println("location.href='index.jsp'");
        out.println("</script>");
        return;
    }

    System.out.println("비밀번호 체크 페이지");
    System.out.println("getBoardId = " + getBoardId);
%>
   <div class="wrap">
        <h1 class="intro">비밀번호 확인</h1>
       <div class="check-box">
           <input type="hidden" id="boardId" value="<%= getBoardId%>" />
           <input type="hidden" id="page" value="<%= getPage%>" />
           <input type="hidden" id="category" value="<%= getCategoryType%>" />
           <input type="hidden" id="startDate" value="<%= getStartDate%>" />
           <input type="hidden" id="endDate" value="<%= getEndDate%>" />
           <input type="hidden" id="keyword" value="<%= getKeyword%>" />
           <div class="line">
               <div class="as">비밀번호</div>
               <div class="user">
                   <input type="password" id="password" placeholder="비밀번호를 입력해 주세요." />
               </div>
           </div>
           <div class="btn-box">
               <button class="btn btn-secondary" onclick="movePage()">취소</button>
               <button class="btn btn-primary" onclick="onDelete()">확인</button>
           </div>
        </div>
   </div>
</body>
</html>
