<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>
<%@ page import="dto.CommentDto" %>
<%@ page import="dao.CommentDao" %>

<%
    request.setCharacterEncoding("utf-8");

    System.out.println("COMMENT ACTION");
    final String BLANKREG = "(\\s)";

    String message = "댓글 작성하였습니다.";

    CommentDao commentDao = new CommentDao();
    CommentDto commentDto = new CommentDto();

    Integer boardId = null;
    String getPage = null;
    String getCategory = null;
    String getStartDate = null;
    String getEndDate = null;
    String getKeyword = null;

    // insert SQL try-catch
    try {
        System.out.println("id= " + request.getParameter("id"));
        System.out.println("nickname= " + request.getParameter("nickname"));
//        System.out.println(request.getParameter("password"));
        System.out.println("content= " + request.getParameter("content"));

        boardId = Integer.parseInt(request.getParameter("id"));
        String nickname = request.getParameter("nickname");
//        String password = request.getParameter("password");
        String content = request.getParameter("content");

        System.out.println("finish get params");

        // 공백 체크를 위한 Matcher 객체 생성
        Matcher blankMatch = Pattern.compile(BLANKREG).matcher(nickname);

        // 닉네임 글자수, 공백 체크
        if(!(nickname.length() >= 3 && nickname.length() < 5)) {
            message = "닉네임은 3글자 이상 5글자 미만이어야 합니다.";
            System.out.println("닉네임 글자수 에러");
            throw new Exception();
        }

        if(blankMatch.find()) {
            System.out.println("닉네임 공백에러");
            message = "닉네임에는 공백이 포함될 수 없습니다.";
            throw new Exception();
        }

        // content 글자수 체크
        if(!(content.length() >= 4 && content.length() < 2000)) {
            System.out.println("내용 글자수 에러");
            message = "내용은 4글자 이상 500글자 미만이어야 합니다.";
            throw new Exception();
        }

        // 유효성 검사 통과하면 boardDto에 값 저장
        commentDto.setBoard_id(boardId);
        commentDto.setNickname(nickname);
        commentDto.setContent(content);

        System.out.println(commentDto);

        try {
            getPage = request.getParameter("page");
            getCategory = request.getParameter("category");
            getStartDate = request.getParameter("startDate");
            getEndDate = request.getParameter("endDate");
            getKeyword = request.getParameter("keyword");

            System.out.println("getPage = " + getPage);
            System.out.println("getCategory = " + getCategory);
            System.out.println("getStartDate = " + getStartDate);
            System.out.println("getEndDate = " + getEndDate);
            System.out.println("getKeyword = " + getKeyword);

            int errCode = commentDao.writeComment(commentDto);
            System.out.println("errCode = " + errCode);

            if(errCode != 1) {
                throw new Exception();
            }
        } catch (Exception e) {
            // 글 등록이 안됐을 때
            e.printStackTrace();

            message = "오류가 발생했습니다. 잠시후 다시 시도해주세요.";
            System.out.println("댓글 등록 실패 - 통신에러");

            throw new Exception();
        }
    } catch (Exception e) {
        e.printStackTrace();
        System.out.println("유효성 검사 통과 실패");
        // 유효성 검사 통과 못했을 때
        String link = "detail.jsp?id=" + boardId + "&page=" + getPage + "&startDate=" + getStartDate + "&endDate=" + getEndDate + "&category=" + getCategory + "&keyword=" + getKeyword;

        out.println("<script>");
        out.println("alert('" + message + "');");
        out.println("location.href='" + link + "';");
        out.println("</script>");

        return;
    }

    String link = "detail.jsp?id=" + boardId + "&page=" + getPage + "&startDate=" + getStartDate + "&endDate=" + getEndDate + "&category=" + getCategory + "&keyword=" + getKeyword;

    System.out.println("댓글 작성 이후 상세 페이지로 이동");
    System.out.println(link);
    out.println("<script>");
    out.println("location.href='" + link + "';");
    out.println("</script>");
%>

