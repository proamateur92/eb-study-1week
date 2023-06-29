function getData() {
    const id = $('#boardId').val();
    const page = $('#page').val();
    const category = $('#category').val();
    const startDate = $('#startDate').val();
    const endDate = $('#endDate').val();
    let keywordValue = $('#keyword').val();
    keywordValue = keywordValue ? keywordValue : "";

    return {id, page, category, startDate, endDate, keywordValue};
}
function movePage(type) {
    const {id, page, category, startDate, endDate, keywordValue} = getData();

    if(type == 'LIST') {
        location.href = 'index.jsp?page=' + page + '&startDate=' + startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
        return;
    }

    if(type == 'DELETE') {
        location.href = 'passwordCheck.jsp?id=' + id + '&page=' + page + '&startDate=' +startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
        return;
    }

    location.href = 'update.jsp?id=' + id + '&page=' + page + '&startDate=' + startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
}

function isValidation() {
    const nickname = $('#nickname');
    const content = $('#content');

    console.log(nickname.val());
    console.log(content.val());

    // 공백 체크를 위한 정규식
    const blankReg = /\s/;

    if(!nickname.val().trim() || !(nickname.val().length < 5 && nickname.val().length >= 3)) {
        alert('닉네임은 3글자 이상 5글자 미만이어야 합니다.')
        nickname.focus();
        return false;
    }

    if(nickname.val().match(blankReg)) {
        alert('닉네임에는 공백이 포함될 수 없습니다.');
        nickname.focus();
        return false;
    }

    if(content.val().trim() == "" || !(content.val().length >= 4 && content.val().length < 500)) {
        alert('댓글은 4글자 이상 500글자 미만이어야 합니다.')
        content.focus();
        return false;
    }

    return true;
}

// 댓글 등록
function onCommentSubmit() {
    const {id, page, category, startDate, endDate, keywordValue} = getData();

    const form = $('#commentForm');

    // 유효성 검사
    if(!isValidation()) return;

    console.log('통과');

    form.attr('method', 'POST');
    form.attr('action', 'commentAction.jsp?id=' + id + '&page=' + page + '&startDate=' + startDate + '&endDate=' + endDate+ '&category=' + category + '&keyword=' + keywordValue);

    form.submit();
}