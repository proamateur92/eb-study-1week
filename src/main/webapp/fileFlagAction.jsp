<%@ page import="dto.FileDto" %>
<%@ page import="dao.FileDao" %>
<%@ page import="java.util.List" %><%
    System.out.println("FILE FLAG ACTION JSP");
    Integer boardId = Integer.parseInt(request.getParameter("boardId"));
    String fileName = request.getParameter("fileName");
    Boolean flag = Boolean.parseBoolean(request.getParameter("flag"));
    String type = request.getParameter("type");

    System.out.println("boardId = " + boardId);
    System.out.println("fileName = " + fileName);
    System.out.println("flag = " + flag);
    System.out.println("type = " + type);

    FileDao fileDao = new FileDao();


    // 수정 취소의 경우
    if("CANCEL".equals(type)) {
        System.out.println("if update cancel:");

        try {
            List<FileDto> fileList = fileDao.getFileList(boardId);
            System.out.println("fileList = " + fileList);

            for(FileDto file : fileList) {
                FileDto fileDto = new FileDto();

                if("Y".equals(file.getDelete_flag())) {
                    fileDto.setBoard_id(boardId);
                    fileDto.setSave_name(file.getSave_name());
                    fileDto.setDelete_flag("N");

                    fileDao.updateFileFlag(fileDto);
                }
            }
            out.println("OK");
            return;
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(500, "failed to change file delete flag");
        }

    }

    FileDto fileDto = new FileDto();

    fileDto.setBoard_id(boardId);
    fileDto.setSave_name(fileName);
    fileDto.setDelete_flag(flag ? "Y" : "N");

    // 플래그 수정 로직
    int rowCount = fileDao.updateFileFlag(fileDto);

    if(rowCount != 1) {
        response.sendError(500, "failed to change file delete flag");
    }

    out.println("OK");
%>