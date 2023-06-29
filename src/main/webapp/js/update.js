// 유효성 검사 메시지
const validateArr = ["작성자는 3글자 이상 5글자 미만이며 공백은 포함될 수 없습니다.", "비밀번호는 4글자 이상 16글자 미만이며 공백은 포함될 수 없습니다", "제목은 4글자 이상 100글자 미만이어야 합니다.", "내용은 4글자 이상 200글자 미만이어야 합니다."];


function movePage() {
    const id = $('#boardId').val();
    const page = $('#page').val();
    const category = $('#category').val();
    const startDate = $('#startDate').val();
    const endDate = $('#endDate').val();
    let keywordValue = $('#keyword').val();
    keywordValue = keywordValue ? keywordValue : "";
    // getKeyword를 바로 가져오면 빈값일 때 아무런 값도 안받아지는 관계로
    // input tag에 값을 담아주었음

    location.href = 'detail.jsp?id=' + id + '&page=' + page + '&startDate=' + startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
}

function validationCheck() {
    const blankReg = /\s/g;

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
    const id = $('#boardId').val();
    const page = $('#page').val();
    const category = $('#category').val();
    const startDate = $('#startDate').val();
    const endDate = $('#endDate').val();
    let keywordValue = $('#keyword').val();
    keywordValue = keywordValue ? keywordValue : "";
    // 유효성 검사
    if(!validationCheck()) return;

    const categoryId = $('#categoryId').val();
    const author = $('#author').val();
    const password = $('#password').val();
    const title = $('#title').val();
    const content = $('#content').val();

    const data = {"boardId": id, "categoryId": categoryId, "author": author, "password": password, "title": title, "content": content};
    console.log(data);
    $.ajax({
        type : "POST",
        url : "updateAction.jsp",
        data : JSON.stringify(data),
        // data : data,
        dataType:'json',
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