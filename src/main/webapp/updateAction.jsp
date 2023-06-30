<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="dao.BoardDao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="dto.BoardDto" %>
<%@page import="org.json.JSONObject"%>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="dao.FileDao" %>
<%@ page import="dto.FileDto" %>
<%@ page import="java.util.List" %>
<%@ page import="dao.FileHandler" %>
<%
    System.out.println("UPDATE ACTION JSP");

    // DTO
    BoardDto boardDto = new BoardDto();
    FileDto fileDto = new FileDto();

    // DAO
    BoardDao boardDao = new BoardDao();
    FileDao fileDao = new FileDao();

    // json 반환 값
    JSONObject jobj = new JSONObject();

    String message = "게시글을 수정하였습니다.";
    String code = "UP_OK";

    // 값을 받아오기 위한, File 저장을 위한 객체
    String uploadDirectory = "C:\\Users\\kkasu\\Desktop\\게시판 샘플 이미지\\upload";

    int maxFileSize = 10 * 1024 * 1024; // 10MB
    String encoding = "UTF-8";
    MultipartRequest multipartRequest = new MultipartRequest(request, uploadDirectory, maxFileSize, encoding, new DefaultFileRenamePolicy());

    System.out.println("MultipartRequest");

    try {
        // 받아온 값 할당
        boardDto.setId(Integer.parseInt(multipartRequest.getParameter("boardId")));
        boardDto.setCategory_id(Integer.parseInt(multipartRequest.getParameter("categoryId")));
        boardDto.setAuthor(multipartRequest.getParameter("author").trim());
        boardDto.setPassword(multipartRequest.getParameter("password"));
        boardDto.setTitle(multipartRequest.getParameter("title").trim());
        boardDto.setContent(multipartRequest.getParameter("content").replace("\n","<br>").trim());
        fileDto.setBoard_id(Integer.parseInt(multipartRequest.getParameter("boardId")));

        System.out.println("boardDto = " + boardDto);
    } catch(Exception e) {
        e.printStackTrace();
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        code = "UP_ERR";
        responsePrint(jobj, message, code, response, out);
        return;
    }

    // 데이터 유효성 검사
    int validateCode = validateData(boardDto);

    // 유효성 검사 통과 실패할 경우
    if(validateCode != -1) {
        message = "" + validateCode;
        code = "UP_VAL";

        responsePrint(jobj, message, code, response, out);
        return;
    }

    // 존재하는 게시글인지 먼저 체크해주기
    if(boardDao.getBoard(boardDto.getId()).getId() == null) {
        message = "존재하지 않는 게시글입니다.";
        code = "UP_NO";

        responsePrint(jobj, message, code, response, out);
        return;
    };

    System.out.println("UPDATE ACTION VALIDATE PASS");

    // 비밀번호 체크
    Map<String, Object> boardMap = new HashMap<>();
    boardMap.put("boardId", boardDto.getId());
    boardMap.put("password", boardDto.getPassword());

    // 0: 비밀번호 불일치
    // 1: 비밀번호 일치
    // -1: 문제 발생
    int resultNumber = boardDao.comparePassword(boardMap);

    if(resultNumber == 0) {
        System.out.println("비밀번호 일치 x");
        message = "비밀번호가 일치하지 않습니다.";
        code = "UP_PWD";

        System.out.println("PASSWORD CONPARE FAIL");
        responsePrint(jobj, message, code, response, out);
        return;
    }

    if(resultNumber == -1) {
        System.out.println("PASSWORD CONPARE ERROR");
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        code = "UP_ERR";

        responsePrint(jobj, message, code, response, out);
        return;
    }

    System.out.println("UPDATE ACTION VALIDATE PASS");

    // row 수정 결과 반환
    int rowCount = boardDao.updateBoard(boardDto);

    if(rowCount != 1) {
        System.out.println("rowCount != -1");
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        code = "UP_ERR";
    }

    System.out.println("UPDATE SUCCESS");

    String originName = multipartRequest.getOriginalFileName("file");
    String uploadName = multipartRequest.getFilesystemName("file");

    fileDto.setOriginal_name(originName);
    fileDto.setSave_name(uploadName);

    // 삭제 플래그가 Y처리된 파일은 삭제
    List<FileDto> getFileList = fileDao.getFileList(fileDto.getBoard_id());

    System.out.println("getFileList = " + getFileList);

    for(FileDto file : getFileList) {
        if("Y".equals(file.getDelete_flag())) {
            System.out.println("플래그가 Y인 파일");
            System.out.println("file = " + file);
            // 삭제 로직
            FileHandler.deleteFileFromDir(file);
            fileDao.deleteFile(file);
        }
    }

    if(!(originName == null && uploadName == null)) {
        int insertRowCount = fileDao.saveFile(fileDto);

        if(insertRowCount != 1) {
            message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
            code = "UP_ERR";

            throw new Exception("insert file error");
        }
    }

    responsePrint(jobj, message, code, response, out);
%>
<%!
    private int validateData(BoardDto boardDto) throws Exception {
        // 작성자 3~5
        // 비밀번호 4~16
        // 제목 4~100
        // 내용 4~200
        String author = boardDto.getAuthor();
        String password = boardDto.getPassword();
        String title = boardDto.getTitle();
        String content = boardDto.getContent();

        final String BLANKREG = "(\\s)";

        Matcher matcher = Pattern.compile(BLANKREG).matcher(author);
        // 작성자가 공백이 포함되어 있거나 글자수의 길이 범위와 일치하지 않을 경우
        if(matcher.find() || !(author.trim().length() >= 3 && author.trim().length() < 5)) return 0;

        // 비밀번호의 길이 범위가 일치하지 않을 경우
        matcher = Pattern.compile(BLANKREG).matcher(password);
        if(matcher.find() || !(password.trim().length() >= 4 && author.trim().length() < 16)) return 1;

        // 제목 길이 범위가 일치하지 않을 경우
        if(!(title.length() >= 4 && title.length() < 100)) return 2;

        // 내용의 길이 범위가 일치하지 않을 경우
        if(!(content.length() >= 4 && content.length() < 2000)) return 3;

        return -1;
    }
%>
<%!
    private void responsePrint(JSONObject jObj, String message, String code, HttpServletResponse response, javax.servlet.jsp.JspWriter out) throws Exception {
        jObj.put("msg", message);
        jObj.put("code", code);

        // 응답시 json 타입 명시
        response.setContentType("application/json");

        // JSON 객체를 문자열로 변환 후
        // AJAX 응답으로 JSON 데이터 전송
        out.print(jObj.toString());
    }
%>