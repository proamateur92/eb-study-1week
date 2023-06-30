// 유효성 검사 메시지
const validateArr = ["작성자는 3글자 이상 5글자 미만이며 공백은 포함될 수 없습니다.", "비밀번호는 4글자 이상 16글자 미만이며 공백은 포함될 수 없습니다", "제목은 4글자 이상 100글자 미만이어야 합니다.", "내용은 4글자 이상 200글자 미만이어야 합니다."];

function getData() {
    const id = $('#boardId').val();
    const page = $('#page').val();
    const category = $('#category').val();
    const startDate = $('#startDate').val();
    const endDate = $('#endDate').val();
    let keywordValue = $('#keyword').val();
    keywordValue = keywordValue ? keywordValue : "";

    return {id, page, category, startDate, endDate, keywordValue}
}

function getInputData() {
    const categoryId = $('#categoryId').val();
    const author = $('#author');
    const password = $('#password');
    const title = $('#title');
    const content = $('#content');

    return {categoryId, author, password, title, content};
}

function movePage() {
    const {id, page, category, startDate, endDate, keywordValue} = getData();
    const data = {boardId: id, type: 'CANCEL'};

    $.ajax({
        type : "POST",
        url : "fileFlagAction.jsp",
        data: data,
        success : (result) => {
            console.log("success result");
            console.log(result);

            location.href = 'detail.jsp?id=' + id + '&page=' + page + '&startDate=' + startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
        },
        error: (result, status, error) => {
            console.log("error result");
            alert("오류가 발생했습니다. 잠시후 시도해주세요.");
            // console.log(result.responseText);
            // console.log(status);
            // console.log(error);
        }
    });
    // getKeyword를 바로 가져오면 빈값일 때 아무런 값도 안받아지는 관계로
    // input tag에 값을 담아주었음
}

function validationCheck() {
    const blankReg = /\s/g;

    const {author, password, title, content} = getInputData();

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

    console.log('update validate pass');

    return true;
}

function changeDeleteFlag(boardId, fileName, flag) {
    const data = {boardId, fileName, flag};
    console.log(data);
    $.ajax({
        type : "POST",
        url : "fileFlagAction.jsp",
        // data : "?boardId=" + boardId + "fileName=" + fileName + "flag=" + flag,
        data: data,
        success : (result) => {
            console.log("success result");
            console.log(result);
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

// 수정 로직
function onUpdate(){
    console.log('onUpdate called')
    const {id, page, category, startDate, endDate, keywordValue} = getData();
    const {categoryId, author, password, title, content} = getInputData();

    // console.log(id);
    // console.log(categoryId);
    // console.log(author.val());
    // console.log(password.val());
    // console.log(title.val());
    // console.log(content.val());

    // 유효성 검사
    if(!validationCheck()) return;

    const formData  = new FormData();
    formData.append('boardId', id);
    formData.append('categoryId', categoryId);
    formData.append('author', author.val());
    formData.append('password', password.val());
    formData.append('title', title.val());
    formData.append('content', content.val());

    const files = document.getElementById('file');
    const file = files ? files.files[0] : {};
    formData.append("file", file);

    console.log(file);
    $.ajax({
        type : "POST",
        cache: false,
        processData: false,
        contentType : false,
        url : "updateAction.jsp",
        data : formData,
        // data : data,
        success : (result) => {
            console.log("success result");
            console.log(result);
            console.log(result.msg);
            console.log(result.code);
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

            // 비밀번호가 일치하지 않는 경우
            if(code == "UP_PWD") {
                $('#password').val('');
                $('#password').focus();
                return;
            }

            // 존재하지 않는 게시글일 경우
            if(code == "UP_NO") {
                location.href = 'index.jsp?id=' + id + '&page=' + page + '&startDate=' + startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
                return;
            }

            // 수정 성공
            if(code == "UP_OK") {
                location.href = 'detail.jsp?id=' + id + '&page=' + page + '&startDate=' + startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
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