function insertBoard() {
    if(!validationCheck()) return;

    form.action = "writeAction.jsp";
    form.submit();
};

// input 값의 유효성 검사 함수
function validationCheck () {
    // 공백 체크를 위한 정규식
    const blankReg = /\s/;
    // 비밀번호 체크를 위한 정규식 (영문, 숫자, 특수문자 반드시 포함 / 길이 4 ~ 16)
    const passwordReg = /^(?=.*[a-zA-Z])(?=.*[!@#$%^*+=-])(?=.*[0-9]).{4,16}$/;

    const category = form.category.value;
    const author = form.author.value;
    const title = form.title.value;
    const content = form.content.value;
    const password = form.password.value;
    const passwordCheck = form.passwordCheck.value;

    if(category == 0) {
        alert('카테고리를 선택해주세요.');
        form.category.focus();
        return false;
    }

    if(author.trim() == '') {
        alert('작성자를 입력해주세요.');
        form.author.focus();
        return false;
    }

    if(author.match(blankReg)) {
        alert('작성자 이름에는 공백이 포함될 수 없습니다.');
        form.author.focus();
        return false;
    }

    if(!(author.length >= 3 && author.length < 5)) {
        alert('작성자는 3글자 이상, 5글자 미만이어야 합니다.');
        form.author.focus();
        return false;
    }

    if(form.password.value.trim() == '') {
        alert('비밀번호를 입력해주세요.');
        form.password.focus();
        return false;
    }

    if(form.passwordCheck.value.trim() == '') {
        alert('비밀번호를 다시 입력해주세요.');
        form.passwordCheck.focus();
        return false;
    }

    if(!(password.length >= 4 && password.length < 16)) {
        alert('비밀번호는 4글자 이상, 16글자 미만이어야 합니다.');
        form.password.focus();
        return false;
    }

    if(password.match(blankReg)) {
        alert('비밀번호에는 공백이 포함될 수 없습니다.');
        form.password.focus();
        return false;
    }

    if(!passwordReg.test(password)) {
        alert('비밀번호에는 영문, 숫자, 특수문자가 반드시 포함되어야 합니다.');
        form.password.focus();
        return false;
    }

    if(password != passwordCheck) {
        alert('비밀번호가 일치하지 않습니다.');
        form.passwordCheck.focus();
        return false;
    }

    if(title.trim() == '') {
        alert('제목을 입력해주세요.');
        form.title.focus();
        return false;
    }

    if(!(title.length >= 4 && title.length < 100)) {
        alert('제목은 4글자 이상, 100글자 미만이어야 합니다.');
        form.title.focus();
        return false;
    }

    if(content.trim() == '') {
        alert('내용을 입력해주세요.');
        form.content.focus();
        return false;
    }

    if(!(content.length >= 4 && content.length < 2000)) {
        alert('제목은 4글자 이상, 2000글자 미만이어야 합니다.');
        form.content.focus();
        return false;
    }

    return true;
}