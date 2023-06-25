<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<%
    // 카테고리 0이면 방지
    String categoryId = request.getParameter("category");
    String author = request.getParameter("author");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String content = request.getParameter("content");

    System.out.println("categoryId = " + categoryId);
    System.out.println("author = " + author);
    System.out.println("password = " + password);
    System.out.println("title = " + title);
    System.out.println("content = " + content);

    // 예외처리

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        conn = ConnectionTest.getConnection();
        String sql = "insert into board (category_id, author, password, title, content, view_count, isFile, create_date) values (?, ?, ?, ?, ?, 0, 'N', now())";
        pstmt = conn.prepareStatement(sql);

        pstmt.setInt(1, Integer.parseInt(categoryId));
        pstmt.setString(2, author);
        pstmt.setString(3, password);
        pstmt.setString(4, title);
        pstmt.setString(5, content);

        int rowCount = pstmt.executeUpdate();

        if(rowCount != 1) {
            throw new Exception("board insert failed");
        }

        out.print("<script>location.href='index.jsp';</script>");
    } catch (Exception e) {
        System.out.println("insert error = " + e.toString());
    } finally {
        pstmt.close();
        conn.close();
    }

    out.print("<script>location.href='write.jsp';</script>");
%>
</body>
</html>
