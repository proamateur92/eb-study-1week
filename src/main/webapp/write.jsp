<%@ page import="com.study.connection.ConnectionTest" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
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
<%
    int i = 10;
%>
    <div>
        <h1>게시판 - 등록 <%= i  %></h1>
    </div>
    <div>
        <div class="row">
            <div class="title">카테고리<span class="point">*</span></div>
            <div>
                <select>
                    <option>1</option>
                    <option>2</option>
                    <option>3</option>
                </select>
            </div>
        </div>
        <div class="row">
            <div class="title">작성자<span class="point">*</span></div>
            <div>
                <input type="text">
            </div>
        </div>
        <div class="row">
            <div class="title">비밀번호<span class="point">*</span></div>
            <div>
                <input type="text" placeholder="비밀번호">
                <input type="text" placeholder="비밀번호 확인">
            </div>
        </div>
        <div class="row">
            <div class="title">제목<span class="point">*</span></div>
            <div>
                <input type="text" placeholder="제목을 입력해주세요">
            </div>
        </div>
        <div class="row">
            <div class="title">내용<span class="point">*</span></div>
            <div>
                <textarea></textarea>
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
    </div>
    <div>
        <button>취소</button>
        <button id="regist">저장</button>
    </div>
</body>
<script>
    const registBtn = document.querySelector('#regist');
    registBtn.addEventListener('click', () => {
    //     예외처리
        location.href='detail.jsp';
    })
</script>
</html>
