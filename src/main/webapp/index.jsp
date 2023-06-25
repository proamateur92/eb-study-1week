<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>list</title>
    <link rel="stylesheet" type="text/css" href="css/main.css">
</head>

<%
    Connection conn1 = null;
    PreparedStatement pstmt1 = null;
    ResultSet rs1 = null;

    Integer rowCount = null;

    try {
        conn1 = ConnectionTest.getConnection();
        String sql1 = "select count(*) as rowCount from board";
        pstmt1 = conn1.prepareStatement(sql1);
        rs1 = pstmt1.executeQuery();

        while(rs1.next()) {
            rowCount = rs1.getInt("rowCount");
        }
    } catch (Exception e) {
        System.out.println("read count boardList = " + e.toString());
    } finally {
        rs1.close();
        pstmt1.close();
        conn1.close();
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        conn = ConnectionTest.getConnection();
        String sql = "select c.name as category, b.* from board b inner join category c on b.category_id = c.id order by b.create_date desc, b.id desc";
        pstmt = conn.prepareStatement(sql);
        rs = pstmt.executeQuery();
%>
<body>
<div>검색 영역</div>
<div>
    <div>총 <%= rowCount%>건</div>
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
        while(rs.next()) {
          String updateDate = rs.getString("update_date");
          updateDate = updateDate == null ? "-" : updateDate.substring(0, 16).replace("-", ".");

          String startDate = rs.getString("create_date").substring(0, 16).replace("-", ".");

          out.print("<tr>");
          out.print("<td>" +rs.getString("category") + "</td>");
          out.print("<td>" +rs.getString("isFile") + "</td>");
          out.print("<td>" +rs.getString("content") + "</td>");
          out.print("<td>" +rs.getString("title") + "</td>");
          out.print("<td>" +rs.getInt("view_count") + "</td>");
          out.print("<td>" + startDate + "</td>");
          out.print("<td>" + updateDate + "</td>");
          out.print("</tr>");
    }
%>
        </tbody>
    </table>
</div>
<div>페이징 영역</div>
<button onclick="location.href='write.jsp'">등록</button>
<%
    } catch (Exception e) {
        System.out.println("read boardList = " + e.toString());
    } finally {
        rs.close();
        pstmt.close();
        conn.close();
    }
%>

</body>
</html>
