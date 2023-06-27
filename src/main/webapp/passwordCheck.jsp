<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
    <title>비밀번호 확인</title>
</head>
<body>
<script>
    function onDelete(){
        let boardId = $('#id').val();
        let password = $('#password').val();

        console.log(boardId);
        console.log(password);

        const data = {"boardId": boardId, "password": password};

        $.ajax({
            type : "POST",
            url : "deleteAction.jsp",
            data : JSON.stringify(data),
            // data : data,
            dataType:'json',
            success : (result) => {
                console.log("success result");
                // console.log(result);
                // console.log(result.msg);
                // console.log(result.code);
                const code = result.code;
                const msg = result.msg;

                alert(msg);
                console.log(msg);
                console.log(code);

                if(code == "DEL_PWD") {
                    $('#password').val('');
                    $('#password').focus();
                } else {
                    location.href = 'index.jsp'
                }
            },
            error: (result, status, error) => {
                console.log("error result");

                alert(result.message);
                location.href = 'detail.jsp/id=' + boardId;
                // console.log(result.responseText);
                // console.log(status);
                // console.log(error);
            }
        });
    }
</script>
<%
    // 게시글 id값이 없으면 게시글 목록 페이지로 이동
    if(request.getParameter("boardId") == null) {
        response.sendRedirect("index.jsp");
    }

    Integer getBoardId = Integer.parseInt(request.getParameter("boardId"));
    System.out.println("비밀번호 체크 페이지");
    System.out.println("getBoardId = " + getBoardId);

%>
    <div>
        <h1>비밀번호 확인</h1>
    </div>
    <div>
        비밀번호
        <input type="hidden" id="id" value="<%= getBoardId%>" />
        <input type="password" id="password" placeholder="비밀번호를 입력해 주세요." />
        <button onclick="location.href='detail.jsp?id=<%= getBoardId%>'">취소</button>
        <button onclick="onDelete()">확인</button>
    </div>
</body>
</html>
