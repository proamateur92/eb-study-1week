package dto;

public class PageDto {
    // totalCount 게시글 총 갯수
    // page 현재페이지
    // pageSize 페이지 당 게시글
    // naviSize 네비게이션 사이즈
    // beginPage 시작 페이지 범위
    // endPage 끝 페이지 범위
    // totalPage 최대 페이지
    // isPrev 이전 페이지 범위 보여주기
    // isNext 다음 페이지 범위 보여주기
    // isStart 시작 페이지 이동 보여주기
    // isEnd 마지막 페이지 이동 보여주기

    private Integer totalCount;
    private Integer page;
    private Integer pageSize = 10;
    private Integer naviSize = 10;
    private Integer beginPage;
    private Integer endPage;
    private Integer totalPage;
    private boolean isPrev;
    private boolean isNext;

    public PageDto(Integer totalCount) {
        this(1, totalCount);
    }

    public PageDto(Integer page, Integer totalCount) {
        // 게시글 갯수가 0 미만이면 0으로 초기화
        this.totalCount = totalCount < 0 ? 0 : totalCount;
        
        // 페이지 총 갯수 초기화
        this.totalPage = (int)Math.ceil((double)totalCount / pageSize);

        // page 값이 없거나 1미만이면 1로 초기화
        // page 값이 페이지 총 갯수를 초과하면 최대 페이지로 초기화
        if(page > this.totalPage) {
            this.page = this.totalPage;
        } else if(page == null || page < 1) {
            this.page = 1;
        } else {
            this.page = page;
        }

        // 네비게이션의 시작 범위 초기화
        this.beginPage = (page - 1) / naviSize * naviSize + 1;
        
        // 네비게이션의 마지막 범위 초기화
        this.endPage = Math.min(beginPage + naviSize - 1, totalPage);
        this.isPrev = beginPage > naviSize;
        this.isNext = totalPage / naviSize * 10 >= endPage;
    }

    public Integer getTotalCount() {
        return totalCount;
    }

    public void setTotalCount(Integer totalCount) {
        this.totalCount = totalCount;
    }

    public Integer getPage() {
        return page;
    }

    public void setPage(Integer page) {
        this.page = page;
    }

    public Integer getPageSize() {
        return pageSize;
    }

    public void setPageSize(Integer pageSize) {
        this.pageSize = pageSize;
    }

    public Integer getNaviSize() {
        return naviSize;
    }

    public void setNaviSize(Integer naviSize) {
        this.naviSize = naviSize;
    }

    public Integer getBeginPage() {
        return beginPage;
    }

    public void setBeginPage(Integer beginPage) {
        this.beginPage = beginPage;
    }

    public Integer getEndPage() {
        return endPage;
    }

    public void setEndPage(Integer endPage) {
        this.endPage = endPage;
    }

    public Integer getTotalPage() {
        return totalPage;
    }

    public void setTotalPage(Integer totalPage) {
        this.totalPage = totalPage;
    }

    public boolean getIsPrev() {
        return isPrev;
    }

    public void setIsPrev(boolean prev) {
        isPrev = prev;
    }

    public boolean getIsNext() {
        return isNext;
    }

    public void setIsNext(boolean next) {
        isNext = next;
    }

    @Override
    public String toString() {
        return "PageDto{" +
                "totalCount=" + totalCount +
                ", page=" + page +
                ", pageSize=" + pageSize +
                ", naviSize=" + naviSize +
                ", beginPage=" + beginPage +
                ", endPage=" + endPage +
                ", totalPage=" + totalPage +
                ", isPrev=" + isPrev +
                ", isNext=" + isNext +
                '}';
    }
}
