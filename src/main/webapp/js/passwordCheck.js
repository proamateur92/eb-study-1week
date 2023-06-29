function movePage() {
    let keywordValue = $('#keyword').val();
    keywordValue = keywordValue ? keywordValue : "";

    const id = $('#boardId').val();
    const page = $('#page').val();
    const category = $('#category').val();
    const startDate = $('#startDate').val();
    const endDate = $('#endDate').val();

    location.href = 'detail.jsp?id=' + id + '&page=' + page + '&startDate=' + startDate + '&endDate=' + endDate + '&category=' + category + '&keyword=' + keywordValue;
}

function onDelete(){
    const id = $('#boardId').val();
    const password = $('#password');

    if(!(password.val().trim().length >= 4 && password.val().trim().length < 16)) {
        alert('비밀번호는 4글자 이상 16글자 미만이어야 합니다.')
        return;
    }
    const data = {"boardId": id, "password": password.val()};

    $.ajax({
        type : "POST",
        url : "deleteAction.jsp",
        data : JSON.stringify(data),
        // data : data,
        dataType:'json',
        success : (result) => {
            const code = result.code;
            const msg = result.msg;

            alert(msg);
            console.log(msg);
            console.log(code);

            if(code == "DEL_PWD") {
                password.val('');
                password.focus();
            } else {
                location.href = 'index.jsp'
            }
        },
        error: (result) => {
            // console.log("error result");

            alert(result.message);
        }
    });
}