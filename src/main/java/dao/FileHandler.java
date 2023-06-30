package dao;

import dto.FileDto;

import java.io.File;
import java.util.List;

public class FileHandler {
    public static void deleteFileFromDir(FileDto targetFile) {
        System.out.println("파일 삭제 로직 호출");
        
        String filePath = "C:\\Users\\kkasu\\Desktop\\게시판 샘플 이미지\\upload\\";

            File file = new File(filePath + targetFile.getSave_name());
            if (file.exists()) {
                boolean deleted = file.delete();
                if (deleted) {
                    System.out.println("파일이 성공적으로 삭제되었습니다.");
                } else {
                    System.out.println("파일 삭제에 실패했습니다.");
                }
            } else {
                System.out.println("파일이 존재하지 않습니다.");
            }
        }
}
