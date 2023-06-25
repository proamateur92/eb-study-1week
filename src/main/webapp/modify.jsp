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

        .file-box {
            display: flex;
        }

        .point {
            color: red;
        }
    </style>
</head>
<body>
<div>
    <h1>게시판 - 수정</h1>
</div>
<div>
    <div class="row">
        <div class="title">카테고리<span class="point">*</span></div>
        <span>Java</span>
    </div>
    <div class="row">
        <div class="title">등록일시</div>
        <span>2022.04.08 12:32</span>
    </div>
    <div class="row">
        <div class="title">수정일시</div>
        <span>-</span>
    </div>
    <div class="row">
        <div class="title">조회수</div>
        <span>31</span>
    </div>
    <div class="row">
        <div class="title">작성자<span class="point">*</span></div>
        <div>
            <input type="text" value="이동복">
        </div>
    </div>
    <div class="row">
        <div class="title">비밀번호<span class="point">*</span></div>
        <div>
            <input type="text" placeholder="비밀번호">
        </div>
    </div>
    <div class="row">
        <div class="title">제목<span class="point">*</span></div>
        <div>
            <input type="text" value="서비스 개발자로 커리어 전환하기">
        </div>
    </div>
    <div class="row">
        <div class="title">내용<span class="point">*</span></div>
        <div>
            <textarea>* 진행방식</textarea>
        </div>
    </div>
    <div class="row">
        <div class="title">파일 첨부</div>
        <div class="conetent file-wrap">
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
</div>
<div>
    <div>
        <button>취소</button>
        <button>저장</button>
    </div>
</body>
</html>
