function movePage(page, type, getId) {
    console.log('type= ' + type);
    console.log('page= ' + page);
    console.log('id= ' + getId);

    const startDate = $('#startDate').val().replaceAll('-', '');
    const endDate = $('#endDate').val().replaceAll('-', '');
    const category = $('#category').val();
    const keyword = $('#keyword').val();

    if(type == 'DETAIL') {
    location.href='detail.jsp?id=' + getId  + '&page=' + page  + '&startDate=' + startDate + '&endDate=' + endDate+ '&category=' + category + '&keyword=' + keyword
    return;
}

    if(type == 'WRITE') {
    location.href='write.jsp?page='+ page + '&startDate=' + startDate + '&endDate=' + endDate+ '&category=' + category + '&keyword=' + keyword
    return;
}

    location.href = 'index.jsp?page='+ page + '&startDate=' + startDate + '&endDate=' + endDate+ '&category=' + category + '&keyword=' + keyword;
}

// 시작 날짜 변경 시 끝 날짜의 최소 범위 변경
function updateMinRange() {
    const getStartDate = $('#startDate');
    const getEndDate = $('#endDate');

    getEndDate.attr('min', getStartDate.val());
}

    // 끝 날짜 변경 시 시작 날짜의 최대 범위 변경
function updateMaxRange() {
    const getStartDate = $('#startDate');
    const getEndDate = $('#endDate');

    getStartDate.attr('max', getEndDate.val());
}

function onSearch() {
    const startDate = $('#startDate').val().replaceAll('-', '');
    const endDate = $('#endDate').val().replaceAll('-', '');
    const category = $('#category').val();
    const keyword = $('#keyword').val();

    location.href = 'index.jsp?page=1&startDate=' + startDate + '&endDate=' + endDate+ '&category=' + category + '&keyword=' + keyword;
}
