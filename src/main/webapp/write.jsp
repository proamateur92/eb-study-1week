<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.Connection" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Document</title>
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

        .point {
            color: red;
        }
    </style>
</head>

<body>
<div>
    <h1>게시판 - 등록</h1>
</div>
<form action="writeProc.jsp">
    <div class="row">
        <div class="title">카테고리<span class="point">*</span></div>
        <div>
            <select name="category">
                <option value="0">카테고리 선택</option>
                <%
                    Connection conn = null;
                    PreparedStatement pstmt = null;
                    ResultSet rs = null;

                    try {
                        conn = ConnectionTest.getConnection();
                        String sql = "select * from category order by id";
                        pstmt = conn.prepareStatement(sql);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                %>
                <option value="<%= rs.getInt("id")%>"><%= rs.getString("name")%></option>
                <%
                        }
                    } catch (Exception e) {
                        System.out.println("read count boardList = " + e.toString());
                    } finally {
                        rs.close();
                        pstmt.close();
                        conn.close();
                    }
                %>
            </select>
        </div>
    </div>
    <div class="row">
        <div class="title" name="author">작성자<span class="point">*</span></div>
        <div>
            <input type="text" name="author">
        </div>
    </div>
    <div class="row">
        <div class="title">비밀번호<span class="point">*</span></div>
        <div>
            <input type="text" name="password" placeholder="비밀번호">
            <input type="text" placeholder="비밀번호 확인">
        </div>
    </div>
    <div class="row">
        <div class="title">제목<span class="point">*</span></div>
        <div>
            <input type="text" name="title" placeholder="제목을 입력해주세요">
        </div>
    </div>
    <div class="row">
        <div class="title">내용<span class="point">*</span></div>
        <div>
            <textarea name="content"></textarea>
        </div>
    </div>
    <div class="row">
        <div class="title">파일 첨부</div>
        <div class="conetent file-wrap">
            <div>
                <input type="text">
                <button>파일찾기</button>
            </div>
            <div>
                <input type="text">
                <button>파일찾기</button>
            </div>
            <div>
                <input type="text">
                <button>파일찾기</button>
            </div>
        </div>
    </div>
    <div>
        <button id="cancel-btn">취소</button>
        <button type="submit">저장</button>
    </div>
</form>
</body>
<script>
    const cancletBtn = document.querySelector('#cancel-btn');
    cancletBtn.addEventListener('click', () => {
        //     예외처리
        window.history.back();
    })
</script>
</html>
