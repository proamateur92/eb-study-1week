package dao;

import com.study.connection.ConnectionTest;
import dto.FileDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FileDao {
    // 첨부파일 불러오기
    public List<FileDto> getFileList (Integer boardId) {
        System.out.println("GET FILE LIST");
        System.out.println("boardId = " + boardId);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<FileDto> fileList = new ArrayList<>();

        try {
            conn = ConnectionTest.getConnection();
            String sql = "select * from file where board_id = ? order by id";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, boardId);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                FileDto fileDto = new FileDto();

                fileDto.setBoard_id(rs.getInt("board_id"));
                fileDto.setId(rs.getInt("id"));
                fileDto.setOriginal_name(rs.getString("original_name"));
                fileDto.setSave_name(rs.getString("save_name"));
                fileDto.setDelete_flag(rs.getString("delete_flag"));

                fileList.add(fileDto);
            }
        } catch (Exception e) {
            System.out.println("read fileList = " + e.toString());
            fileList = null;
        }

        System.out.println("fileList = " + fileList);
        return fileList;
    }

    // 파일 저장
    public int saveFile(FileDto fileDto) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 예외처리
        try {
            conn = ConnectionTest.getConnection();
//            String sql = "insert into board (board_id, ranking, original_name, save_name, size, delete_flag, create_date) values (?, ?, ?, ?, ?, 'N', now())";
            String sql = "insert into file (board_id, original_name, save_name, delete_flag, create_date) values (?, ?, ?, 'N', now())";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, fileDto.getBoard_id());
            pstmt.setString(2, fileDto.getOriginal_name());
            pstmt.setString(3, fileDto.getSave_name());

//            pstmt.setInt(1, fileDto.getBoard_id());
//            pstmt.setInt(2, fileDto.getRanking());
//            pstmt.setString(3, fileDto.getOriginal_name());
//            pstmt.setString(4, fileDto.getSave_name());
//            pstmt.setInt(5, fileDto.getSize());

            int rowCount = pstmt.executeUpdate();

            if (rowCount != 1) {
                throw new Exception("file save failed");
            }

            return rowCount;

        } catch (Exception e) {
            System.out.println("file save error = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        return -1;
    }

    // 파일 삭제
    public int deleteFile(FileDto file) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 예외처리
        try {
            conn = ConnectionTest.getConnection();
//            String sql = "insert into board (board_id, ranking, original_name, save_name, size, delete_flag, create_date) values (?, ?, ?, ?, ?, 'N', now())";
            String sql = "delete from file where board_id = ? and id = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, file.getBoard_id());
            pstmt.setInt(2, file.getId());

            int rowCount = pstmt.executeUpdate();

            if (rowCount != 1) {
                throw new Exception("file delete failed");
            }

            return rowCount;

        } catch (Exception e) {
            System.out.println("file save error = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        return -1;
    }

    // 파일 삭제 플래그 수정
    public int updateFileFlag(FileDto fileDto) throws SQLException {
        System.out.println("UPDATE FILE FLAG DAO");
        System.out.println("fileDto = " + fileDto);

        Connection conn = null;
        PreparedStatement pstmt = null;


        try {
            conn = ConnectionTest.getConnection();
            String sql = "update file set delete_flag = ? where board_id = ? and save_name = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setString(1, fileDto.getDelete_flag());
            pstmt.setInt(2, fileDto.getBoard_id());
            pstmt.setString(3, fileDto.getSave_name());

            return pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("update file flag() = " + e.toString());
        } finally {
            pstmt.close();
            conn.close();
        }
        return -1;
    }
}
