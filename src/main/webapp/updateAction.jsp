<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="dao.BoardDao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="dto.BoardDto" %>
<%@page import="org.json.JSONObject"%>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.util.regex.Pattern" %>
<%
    request.setCharacterEncoding("utf-8");
//    System.out.println("UPDATE ACTION JSP");

    // 변수 세팅

    // DTO
    BoardDto boardDto = new BoardDto();

    // DAO
    BoardDao boardDao = new BoardDao();

    // json 타입 반환을 위한 객체
    JSONObject jobj = new JSONObject();

    // json 반환 값
    String message = "게시글을 수정하였습니다.";
    String code = "UP_OK";

    // 변수 세팅 끝

    // JSON 데이터를 받기 위한 처리 로직
    String jsonString = getJsonString(request);

//    System.out.println("jsonString = " + jsonString);

    // 넘어온 값이 없다면 예외처리
    if("".equals(jsonString)) {
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        code = "UP_ERR";

        responsePrint(jobj, message, code, response, out);
        return;
    }

    // JSON 데이터를 파싱하여 필요한 값 가져오기
    JSONObject json = new JSONObject(jsonString);

    // 받아온 값 할당
    try {
        boardDto.setId(json.getInt("boardId"));
        boardDto.setCategory_id(json.getInt("categoryId"));
        boardDto.setAuthor(json.getString("author").trim());
        boardDto.setPassword(json.getString("password"));
        boardDto.setTitle(json.getString("title").trim());
        boardDto.setContent(json.getString("content").trim());
    } catch(Exception e) {
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

    // 비밀번호 체크
    Map<String, Object> boardMap = new HashMap<>();
    boardMap.put("boardId", boardDto.getId());
    boardMap.put("password", boardDto.getPassword());

    // 0: 비밀번호 불일치
    // 1: 비밀번호 일치
    // -1: 문제 발생
    int resultNumber = boardDao.comparePassword(boardMap);

    if(resultNumber == 0) {
        message = "비밀번호가 일치하지 않습니다.";
        code = "UP_PWD";

        responsePrint(jobj, message, code, response, out);
        return;
    }

    if(resultNumber == -1) {
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        code = "UP_ERR";

        responsePrint(jobj, message, code, response, out);
        return;
    }

    // row 삭제 결과 반환
    int rowCount = boardDao.updateBoard(boardDto);

    if(rowCount != 1) {
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        code = "UP_ERR";
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

        if(!Pattern.matches("^[\\w]*$", author) || !(author.trim().length() >= 3 && author.trim().length() < 5)) return 0;
        if(!(password.trim().length() >= 4 && author.trim().length() < 16)) return 1;
        if(!(title.length() >= 4 && title.length() < 100)) return 2;
        if(!(content.length() >= 4 && content.length() < 2000)) return 3;

        return -1;
    }
%>
<%!
    private String getJsonString(HttpServletRequest request) throws IOException {
        StringBuilder sb = new StringBuilder();
        BufferedReader br = request.getReader();
        String line;

        while ((line = br.readLine()) != null) {
            sb.append(line);
        }

        return sb.toString();
    }

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