<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="dto.BoardDto" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.Map" %>
<%@ page import="dto.FileDto" %>
<%@ page import="dao.FileDao" %>

<%
    System.out.println("WRITE ACTION");

    request.setCharacterEncoding("utf-8");

    final String PWDREG = "^((?=.*\\d)(?=.*[a-zA-Z])(?=.*[\\W]).{4,15})$";
    final String BLANKREG = "(\\s)";

    String message = "게시글을 작성하였습니다.";
    String link = "index.jsp";

    BoardDao boardDao = new BoardDao();
    BoardDto boardDto = new BoardDto();
    FileDao fileDao = new FileDao();

    String getPage = null;
    String getCategory = null;
    String getStartDate = null;
    String getEndDate = null;
    String getKeyword = null;


    try {
        // 파일 다운로드 설정
        String uploadDirectory = "C:\\Users\\kkasu\\Desktop\\게시판 샘플 이미지\\upload";

        System.out.println("uploadDirectory = " + uploadDirectory);

        int maxFileSize = 10 * 1024 * 1024; // 10MB
        String encoding = "UTF-8";
        MultipartRequest multipartRequest = new MultipartRequest(request, uploadDirectory, maxFileSize, encoding, new DefaultFileRenamePolicy());

        String originName = multipartRequest.getOriginalFileName("file");
        String uploadName = multipartRequest.getFilesystemName("file");

        System.out.println("originName = " + originName);
        System.out.println("uploadName = " + uploadName);

        // 입력 값
        Integer categoryId = Integer.parseInt(multipartRequest.getParameter("category"));
        String author = multipartRequest.getParameter("author");
        String password = multipartRequest.getParameter("password");
        String title = multipartRequest.getParameter("title");
        String content = multipartRequest.getParameter("content").replace("\n", "<br>");

        System.out.println("finish get params");

        System.out.println("categoryId = " + categoryId);
        System.out.println("author = " + author);
        System.out.println("password = " + password);
        System.out.println("title = " + title);
        System.out.println("content = " + content);

        // 카테고리 0
        if(categoryId == 0) {
            message = "카테고리를 선택해주세요.";
            System.out.println("cateogy err");
            throw new Exception();
        }

        // 공백 체크를 위한 Matcher 객체 생성
        Matcher blankMatch = Pattern.compile(BLANKREG).matcher(author);

        // author 글자수, 공백 체크
        if(!(author.length() >= 3 && author.length() < 5)) {
            message = "작성자는 3글자 이상 5글자 미만이어야 합니다.";
            System.out.println("작성자 글자수 에러");
            throw new Exception();
        }

        if(blankMatch.find()) {
            System.out.println("작성자 공백에러");
            message = "작성자는 공백이 포함될 수 없습니다.";
            throw new Exception();
        }

        // password 조건 맞추기
        Matcher pwdMatcher = Pattern.compile(PWDREG).matcher(password);
        if(!pwdMatcher.find()) {
            System.out.println("비밀번호 형식 에러");
            message = "비밀번호는 영문, 숫자, 특수문자를 반드시 포함하며, 4~15글자이어야 합니다.";
            throw new Exception();
        }

        // title 글자수 체크, 공백 체크
        if(!(title.length() >= 4 && title.length() < 100)) {
            System.out.println("제목 글자수 에ㅓㄹ");
            message = "제목은 4글자 이상 100글자 미만이어야 합니다.";
            throw new Exception();
        }

        // content 글자수 체크
        if(!(content.length() >= 4 && content.length() < 2000)) {
            System.out.println("내용 글자수 ㅔㅇ러");
            message = "내용은 4글자 이상 2000글자 미만이어야 합니다.";
            throw new Exception();
        }

        // 유효성 검사 통과하면 boardDto에 값 저장
        boardDto.setCategory_id(categoryId);
        boardDto.setAuthor(author);
        boardDto.setPassword(password);
        boardDto.setTitle(title);
        boardDto.setContent(content);
        boardDto.setFile_flag(originName != null && uploadName != null ? "Y" : "N");

        System.out.println("boardDto = " + boardDto);

        try {
            Map<String, Integer> insertMap = boardDao.writeBoard(boardDto);
            System.out.println("insertMap = " + insertMap);

            int errCode = insertMap.get("rowCount");

            getPage = multipartRequest.getParameter("page");
            getCategory = multipartRequest.getParameter("getCategory");
            getStartDate = multipartRequest.getParameter("startDate");
            getEndDate = multipartRequest.getParameter("endDate");
            getKeyword = multipartRequest.getParameter("keyword");

            System.out.println("getPage = " + getPage);
            System.out.println("getCategory = " + getCategory);
            System.out.println("getStartDate = " + getStartDate);
            System.out.println("getEndDate = " + getEndDate);
            System.out.println("getKeyword = " + getKeyword);

            System.out.println("errCode = " + errCode);

            if(errCode != 1) {
                throw new Exception();
            }

            FileDto fileDto = new FileDto();
            fileDto.setBoard_id(insertMap.get("boardId"));
            fileDto.setOriginal_name(originName);
            fileDto.setSave_name(uploadName);

            // 파일 업로드 정보가 있을 때에만 파일 업로드
            if(originName != null && uploadName != null) {
                // insert된 row가 1이 아니라면 에러 발생
                if(1 != fileDao.saveFile(fileDto)) throw new Exception("file save error");
            }

            link = "detail.jsp?id=" + insertMap.get("boardId") + "&page=" + getPage + "&startDate=" + getStartDate + "&endDate=" + getEndDate + "&category=" + getCategory + "&keyword=" + getKeyword;
        } catch (Exception e) {
            // 글 등록이 안됐을 때
            message = "오류가 발생했습니다. 잠시후 다시 시도해주세요.";
            System.out.println("글 등록 실패 - 통신에러");
        }
    } catch (Exception e) {
        System.out.println("유효성 검사 통과 실패");
        e.printStackTrace();
        // 유효성 검사 통과 못했을 때
        link = "write.jsp?page=" + getPage + "&startDate=" + getStartDate + "&endDate=" + getEndDate + "&category=" + getCategory + "&keyword=" + getKeyword;

        out.println("<script>");
        out.println("alert('" + message + "');");
        out.println("location.href='" + link + "';");
        out.println("</script>");

        return;
    }

    System.out.println("글 작성 이후 리스트 페이지로 이동");
    out.println("<script>");
    out.println("alert('" + message + "');");
    out.println("location.href='" + link + "';");
    out.println("</script>");
%>

