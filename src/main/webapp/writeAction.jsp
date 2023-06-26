<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>

<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    String message = "게시글을 작성하였습니다.";
    String link = "index.jsp";

    BoardDao boardDao = new BoardDao();
    BoardDto boardDto = new BoardDto();

    Integer categoryId = Integer.parseInt(request.getParameter("category"));
    String author = request.getParameter("author");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    System.out.println("categoryId = " + categoryId);
    System.out.println("author = " + author);
    System.out.println("password = " + password);
    System.out.println("title = " + title);
    System.out.println("content = " + content);

    boardDto.setCategory_id(categoryId);
    boardDto.setAuthor(author);
    boardDto.setPassword(password);
    boardDto.setTitle(title);
    boardDto.setContent(content);

    int errCode = boardDao.insertBoard(boardDto);
    // 카테고리 0이면 방지

    if(errCode != 1) {
        message = "오류가 발생했습니다. 잠시후 시도해주세요.";
        link = "write.jsp";
    }

    out.println("<script>");
    out.println("alert('" + message + "');");
    out.println("location.href='" + link + "';");
    out.println("</script>");
%>
</body>
</html>
