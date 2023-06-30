package dao;

import com.study.connection.ConnectionTest;
import dto.CommentDto;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommentDao {
    // 댓글 작성
    public int writeComment (CommentDto commentDto) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        System.out.println("DAO WRITE COMMENT");
        System.out.println("commentDto = " + commentDto);
        // 예외처리
        try {
            conn = ConnectionTest.getConnection();
            String sql = "insert into comment (board_id, nickname, password, content, create_date) values (?, ?, '1234', ?, now())";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, commentDto.getBoard_id());
            pstmt.setString(2, commentDto.getNickname());
            pstmt.setString(3, commentDto.getContent());

            int rowCount = pstmt.executeUpdate();

            System.out.println("rowCount = " + rowCount);

            if (rowCount != 1) {
                throw new Exception("comment insert failed");
            }

            System.out.println("COMMENT INSERT SUCCESS");
            return rowCount;

        } catch (Exception e) {
            System.out.println("comment insert error = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        System.out.println("COMMENT INSERT FAIL");
        return -1;
    }

    // 댓글 불러오기
    public List<CommentDto> getCommentList (Integer boardId) {
        System.out.println("GET COMMENTLIST");
        System.out.println("boardId = " + boardId);

        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<CommentDto> commentList = new ArrayList<>();

        try {
            conn = ConnectionTest.getConnection();
            String sql = "select * from comment where board_id = ? order by id desc";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, boardId);

            rs = pstmt.executeQuery();

            while(rs.next()) {
                CommentDto commentDto = new CommentDto();

                commentDto.setId(rs.getInt("id"));
                commentDto.setBoard_id(rs.getInt("board_id"));
                commentDto.setNickname(rs.getString("nickname"));
                commentDto.setContent(rs.getString("content"));
                commentDto.setPassword(rs.getString("password"));
                commentDto.setCreate_date(rs.getTimestamp("create_date"));

                commentList.add(commentDto);
            }
        } catch (Exception e) {
            System.out.println("read commentList = " + e.toString());
            commentList = null;
        }

        System.out.println("commentList = " + commentList);
        return commentList;
    }

    // 댓글 삭제
    public int deleteComment (CommentDto commentDto) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        System.out.println("DAO DELETE COMMENT");
        System.out.println("commentDto = " + commentDto);
        // 예외처리
        try {
            conn = ConnectionTest.getConnection();
            String sql = "delete from comment where board_id = ? and id = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, commentDto.getBoard_id());
            pstmt.setInt(2, commentDto.getId());

            int rowCount = pstmt.executeUpdate();

            System.out.println("rowCount = " + rowCount);

            if (rowCount != 1) {
                throw new Exception("comment delete failed");
            }

            System.out.println("DELETE SUCCESS");
            return rowCount;

        } catch (Exception e) {
            System.out.println("comment delete error = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        System.out.println("COMMENT DELETE FAIL");
        return -1;
    }
}
