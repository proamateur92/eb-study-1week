function insertBoard() {
    if(!validationCheck()) return;

    const form = $('#form');
    form.attr('action', 'writeAction.jsp');
    form.submit();
};

// input 값의 유효성 검사 함수
function validationCheck () {
    // 공백 체크를 위한 정규식
    const blankReg = /\s/;
    // 비밀번호 체크를 위한 정규식 (영문, 숫자, 특수문자 반드시 포함 / 길이 4 ~ 16)
    const passwordReg = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{4,16}$/;

    const category = $('#category');
    const author = $('#author');
    const title = $('#title');
    const content = $('#content');
    const password = $('#password');
    const passwordCheck = $('#passwordCheck');

    if(category.val() == 0) {
        alert('카테고리를 선택해주세요.');
        category.focus();
        return false;
    }

    if(author.val().trim() == '') {
        alert('작성자를 입력해주세요.');
        author.focus();
        return false;
    }

    if(author.val().match(blankReg)) {
        alert('작성자 이름에는 공백이 포함될 수 없습니다.');
        author.focus();
        return false;
    }

    if(!(author.val().length >= 3 && author.val().length < 5)) {
        alert('작성자는 3글자 이상, 5글자 미만이어야 합니다.');
        author.focus();
        return false;
    }

    if(password.val().trim() == '') {
        alert('비밀번호를 입력해주세요.');
        password.focus();
        return false;
    }

    if(passwordCheck.val().trim() == '') {
        alert('비밀번호를 다시 입력해주세요.');
        passwordCheck.focus();
        return false;
    }

    if(!(password.val().length >= 4 && password.val().length < 16)) {
        alert('비밀번호는 4글자 이상, 16글자 미만이어야 합니다.');
        password.focus();
        return false;
    }

    if(password.val().match(blankReg)) {
        alert('비밀번호에는 공백이 포함될 수 없습니다.');
        password.focus();
        return false;
    }

    if(!passwordReg.test(password.val())) {
        alert('비밀번호에는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다.');
        password.focus();
        return false;
    }

    if(password.val() != passwordCheck.val()) {
        alert('비밀번호가 일치하지 않습니다.');
        passwordCheck.focus();
        return false;
    }

    if(title.val().trim() == '') {
        alert('제목을 입력해주세요.');
        title.focus();
        return false;
    }

    if(!(title.val().length >= 4 && title.val().length < 100)) {
        alert('제목은 4글자 이상, 100글자 미만이어야 합니다.');
        title.focus();
        return false;
    }

    if(content.val().trim() == '') {
        alert('내용을 입력해주세요.');
        content.focus();
        return false;
    }

    if(!(content.val().length >= 4 && content.val().length < 2000)) {
        alert('제목은 4글자 이상, 2000글자 미만이어야 합니다.');
        content.focus();
        return false;
    }

    return true;
}