<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.net.URLEncoder" %>

<%
    System.out.println("DOWNLOAD ACTION JSP");

    String fileName = request.getParameter("fileName");
    String filePath = "C:\\Users\\kkasu\\Desktop\\게시판 샘플 이미지\\upload\\";

    File file = new File(filePath + fileName);
    String encodeFileName = URLEncoder.encode(fileName, "utf-8").replaceAll("\\+", "%20");

    System.out.println("fileName = " + fileName);
    System.out.println("filePath = " + filePath);
    System.out.println("file = " + file);

    System.out.println("file.exists() = " + file.exists());

    if (file.exists()) {
        System.out.println("file exist");
        System.out.println("file length= " + file.length());

        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=\"" + encodeFileName + "\";");

        try (FileInputStream fileInputStream = new FileInputStream(file);
             OutputStream outputStream = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fileInputStream.read(buffer)) != -1) {
                outputStream.write(buffer, 0, bytesRead);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    } else {
        System.out.println("file no exist");
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
%>