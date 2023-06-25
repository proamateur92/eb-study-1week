<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Document</title>
    <style>
        .board-date {
            display: flex;
            justify-content: space-between;
        }

        .board-date > div > span:first-of-type {
            margin-right: 1.5rem;
        }

        .top {
            display: flex;
            justify-content: space-between;

            border-bottom: 2px solid black;

            padding-bottom: 1rem;
            margin-top: 1.5rem;
            margin-bottom: 1rem;
        }

        .category {
            margin-right: 1rem;
        }

        .body > textarea {
            width: 100%;
            min-height: 8rem;

            resize: none;
        }

        .file-wrap {
            display: flex;
            flex-direction: column;

            margin: 1rem 0;
        }

        .file-box {
            display: flex;
        }

        .comment-wrap {
            background-color: blanchedalmond;
            margin-top: 2rem;
        }

        .comment {
            border-bottom: 1px solid black;
            padding-bottom: 1rem;
        }

        .comment-date {
            margin-bottom: 0.3rem;
        }

        .comment-input-box {
            display: flex;
            justify-content: space-between;

            width: 100%;
            min-height: 3rem;

            padding: 1rem 0;
        }

        .comment-input-box > textarea {
            width: 85%;
            resize: none;
        }

        .comment-input-box > button {
            width: 13%;
        }

        .btn-box {
            display: flex;
            justify-content: center;
        }

        .btn-box > button:nth-of-type(2) {
            margin: 0 0.5rem;
        }
    </style>
</head>
<body>
<div>
    <h1>게시판 - 보기</h1>
</div>
<div class="board-date">
    <span>이동복</span>
    <div>
        <span>등록일시 2023.06.25</span>
        <span>수정일시 2023.06.25</span>
    </div>
</div>
<div class="board-wrap">
    <div class="top">
        <div class="top-box">
            <span class="category">[JAVA]</span>
            <span class="title">제목이 출력됩니다.</span>
        </div>
        <span class="view-count">조회수: <span>13</span></span>
    </div>
    <div class="body">
        <textarea>내용이 출력됩니다. 내용이 출력됩니다.</textarea>
    </div>
    <div class="file-wrap">
        <div class="file-box">
            <div>아이콘</div>
            <span>첨부파일1.hwp</span>
        </div>
    </div>
</div>
<div class="comment-wrap">
    <div class="comment">
        <div class="comment-date">2020.03.09 16:32</div>
        <div class="comment-body">댓글이 출력됩니다.</div>
    </div>
    <div class="comment-input-box">
        <textarea placeholder="댓글을 입력해주세요."></textarea>
        <button>등록</button>
    </div>
</div>
<div class="btn-box">
    <button onClick="">목록</button>
    <button>수정</button>
    <button>삭제</button>
</div>
</body>
</html>
