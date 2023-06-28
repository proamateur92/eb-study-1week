<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.annotation.WebServlet"%>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.Format" %>
<%@ page import="java.text.SimpleDateFormat" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <script src="//code.jquery.com/jquery-3.5.1.min.js" ></script>
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
    if(request.getParameter("boardId") == null) {
        out.println("<script>");
        out.println("alert('잘못된 요청입니다. 게시글 목록으로 이동합니다.');");
        out.println("</script>");
        response.sendRedirect("/");
    };

    Integer getBoardId = Integer.parseInt(request.getParameter("boardId"));

    System.out.println("UPDATE JSP");
    System.out.println("getBoardId = " + getBoardId);

    BoardDao boardDao = new BoardDao();
    BoardDto boardDto = boardDao.getBoard(getBoardId);

    if(boardDto.getId() == null) {
        out.println("<script>");
        out.println("alert('존재하지 않는 게시글입니다.');");
        out.println("</script>");
        response.sendRedirect("/");
    };

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy.MM.dd HH:mm");

    String createDate = sdf.format(boardDto.getCreate_date());
    String updateDate = boardDto.getUpdate_date() == null ? "-" : sdf.format(boardDto.getUpdate_date());

    Map<Integer, String> categoryMap = boardDao.getCategoryList();
%>
<body>
<script>
    const validateArr = ["작성자는 3글자 이상 5글자 미만이어야 합니다.", "비밀번호는 4글자 이상 16글자 미만이어야 합니다.", "제목은 4글자 이상 100글자 미만이어야 합니다.", "내용은 4글자 이상 200글자 미만이어야 합니다."];

    function validationCheck() {
        const blankReg = /\s/;

        let author = $('#author');
        let password = $('#password');
        let title = $('#title');
        let content = $('#content');

        if(author.val().match(blankReg) || !(author.val().length >= 3 && author.val().length < 5)) {
            alert(validateArr[0]);
            author.focus();
            return false;
        }

        if(!(title.val().trim().length >= 4 && title.val().trim().length < 100)) {
            alert(validateArr[2]);
            title.focus();
            return false;
        }

        if(!(content.val().trim().length >= 3 && content.val().trim().length < 2000)) {
            alert(validateArr[3]);
            content.focus();
            return false;
        }

        if(!(password.val().trim().length >= 4 && password.val().trim().length < 16)) {
            alert(validateArr[1]);
            password.focus();
            return false;
        }

        return true;
    }

    // 수정 로직
    function onUpdate(){
        // 유효성 검사
        if(!validationCheck()) return;

        let boardId = $('#boardId').val();
        let categoryId = $('#categoryId').val();
        let author = $('#author').val();
        let password = $('#password').val();
        let title = $('#title').val();
        let content = $('#content').val();

        const data = {"boardId": boardId, "categoryId": categoryId, "author": author, "password": password, "title": title, "content": content};
        console.log("onUpdate function called");
        console.log(data);

        $.ajax({
            type : "POST",
            url : "updateAction.jsp",
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

                if(code == "UP_VAL") {
                    alert(validateArr[msg]);

                    if(msg == 0) $("#author").focus();
                    if(msg == 1) $("#password").focus();
                    if(msg == 2) $("#title").focus();
                    if(msg == 3) $("#content").focus();
                    return;
                }

                alert(msg);
                // console.log(msg);
                // console.log(code);
                // UP_ERR
                // UP_PWD
                // UP_NO
                // UP_VAL
                // UP_OK

                if(code == "UP_PWD") {
                    $('#password').val('');
                    $('#password').focus();
                    return;
                }

                if(code == "UP_NO") {
                    location.href='index.jsp';
                    return;
                }

                if(code == "UP_OK") {
                    location.href = 'detail.jsp?id=' + boardId;
                    return;
                }
            },
            error: (result, status, error) => {
                console.log("error result");

                alert("오류가 발생했습니다. 잠시후 시도해주세요.");
                // console.log(result.responseText);
                // console.log(status);
                // console.log(error);
            }
        });
    }
</script>
<div>
    <h1>게시판 - 수정</h1>
</div>
<div>
    <input type="hidden" id="boardId" value="<%= getBoardId%>" />
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
        <button onclick="location.href='detail.jsp?id=<%= getBoardId%>'">취소</button>
        <button onclick="onUpdate()">저장</button>
    </div>
</div>
</body>
</html>
