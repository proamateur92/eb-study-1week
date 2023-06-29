<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="dao.BoardDao" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="dto.BoardDto" %>
<%@page import="org.json.JSONObject"%>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.IOException" %>
<%
    // JSON 데이터를 받기 위한 처리 로직
    String jsonString = getJsonString(request);

    // 넘어온 값이 없다면 예외처리
    if("".equals(jsonString)) {
        JSONObject jobj = new JSONObject();

        String message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        String delCode = "DEL_ERR";

        responsePrint(jobj, message, delCode, response, out);
        return;
    }

    System.out.println("jsonString = " + jsonString);
    // JSON 데이터를 파싱하여 필요한 값 가져오기
    JSONObject json = new JSONObject(jsonString);

    String getBoardId = json.getString("boardId");
    String getPassword = json.getString("password");

    // json 타입 반환을 위한 객체
    JSONObject jobj = new JSONObject();

    String message = "게시글을 삭제하였습니다.";
    String delCode = "DEL_OK";

    // 게시글 번호 혹은 비밀번호가 null일 경우
    // 정상적인 페이지로 요청이 온 경우에는 게시글 번호가 안넘어올 수 없음 - 정상적이지 않은 요청 의심
    // 숫자 체크 필요
    // 비밀번호 null은 유효성 검사 차원으로 처리하면 될듯
    if(getBoardId == null || getPassword == null) {
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        delCode = "DEL_ERR";

        responsePrint(jobj, message, delCode, response, out);
        return;
   }

    BoardDao boardDao = new BoardDao();

    // 존재하는 게시글인지 뭔저 체크해주기
    BoardDto boardDto = boardDao.getBoard(Integer.parseInt(getBoardId));

    System.out.println("boardDto = " + boardDto);

    // 해당 id 값의 게시글이 없는 경우
    if(boardDto.getId() == null) {
        message = "존재하지 않는 게시글입니다.";
        delCode = "DEL_NO";

        responsePrint(jobj, message, delCode, response, out);
        return;
    }

    // 삭제 파라미터를 위한 map
    Map<String, String> map = new HashMap<>();

    map.put("boardId", getBoardId);
    map.put("password", getPassword);

    // row 삭제 결과 반환
    int rowCount = boardDao.deleteBoard(map);

    if(rowCount == 0) {
        message = "비밀번호가 일치하지 않습니다.";
        delCode = "DEL_PWD";
    } else if(rowCount == -1) {
        message = "오류가 발생하였습니다. 잠시후 다시 시도해주세요.";
        delCode = "DEL_ERR";
    }

    responsePrint(jobj, message, delCode, response, out);
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

    private void responsePrint(JSONObject jObj, String message, String delCode, HttpServletResponse response, javax.servlet.jsp.JspWriter out) throws Exception {
        jObj.put("msg", message);
        jObj.put("code", delCode);

        // 응답시 json 타입 명시
        response.setContentType("application/json");

        // JSON 객체를 문자열로 변환 후
        // AJAX 응답으로 JSON 데이터 전송
        out.print(jObj.toString());
    }
%>