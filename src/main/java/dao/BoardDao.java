package dao;

import dto.BoardDto;
import com.study.connection.ConnectionTest;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class BoardDao {

    // 게시글 등록
    public int insertBoard(BoardDto boardDto) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        // 예외처리
        try {
            conn = ConnectionTest.getConnection();
            String sql = "insert into board (category_id, author, password, title, content, view_count, file_flag, create_date) values (?, ?, ?, ?, ?, 0, 'N', now())";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, boardDto.getCategory_id());
            pstmt.setString(2, boardDto.getAuthor());
            pstmt.setString(3, boardDto.getPassword());
            pstmt.setString(4, boardDto.getTitle());
            pstmt.setString(5, boardDto.getContent());

            int rowCount = pstmt.executeUpdate();

            if (rowCount != 1) {
                throw new Exception("board insert failed");
            }

            return rowCount;

        } catch (Exception e) {
            System.out.println("insert error = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        return -1;
    }

    // 모든 게시글 불러오기
    public List<BoardDto> getBoardList() throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<BoardDto> boardList = new ArrayList<>();

        try {

            conn = ConnectionTest.getConnection();
            String sql = "select * from board order by create_date desc, id desc";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while(rs.next()) {
                BoardDto boardDto = new BoardDto();

                boardDto.setCategory_id(rs.getInt("category_id"));
                boardDto.setId(rs.getInt("id"));
                boardDto.setTitle(rs.getString("title"));
                boardDto.setContent(rs.getString("content"));
                boardDto.setAuthor(rs.getString("author"));
                boardDto.setView_count(rs.getInt("view_count"));
                boardDto.setFile_flag(rs.getString("file_flag"));
                boardDto.setCreate_date(rs.getTimestamp("create_date"));
                boardDto.setUpdate_date(rs.getTimestamp("update_date"));

                boardList.add(boardDto);
            }
        } catch (Exception e) {
            System.out.println("read boardList = " + e.toString());
            boardList = null;
        }

        return boardList;
    }

    // 게시글 정보 가져오기
    public BoardDto getBoard(Integer boardId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionTest.getConnection();
            String sql = "select * from board where id = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, boardId);

            rs = pstmt.executeQuery();

            BoardDto boardDto = new BoardDto();

            while(rs.next()) {
                boardDto.setId(boardId);
                boardDto.setCategory_id(rs.getInt("category_id"));
                boardDto.setAuthor(rs.getString("author"));
                boardDto.setTitle(rs.getString("title"));
                boardDto.setContent(rs.getString("content"));
                boardDto.setFile_flag(rs.getString("file_flag"));
                boardDto.setView_count(rs.getInt("view_count"));
                boardDto.setCreate_date(rs.getTimestamp("create_date"));
                boardDto.setUpdate_date(rs.getTimestamp("update_date"));
            }

            return boardDto;

        } catch (Exception e) {
            System.out.println("get Board() = " + e.toString());

        } finally {
            rs.close();
            pstmt.close();
            conn.close();
        }

        return null;
    };

    // 게시글 수정
    public int updateBoard(BoardDto boardDto) {
        return 0;
    };
    
    
    // 게시글 삭제
    public int deleteBoard(Map<String, String> map) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        System.out.println("DELETE BOARD DAO");
        System.out.println("map = " + map);
        try {
            conn = ConnectionTest.getConnection();
            String sql = "delete from board where id = ? and password = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, Integer.parseInt(map.get("boardId")));
            pstmt.setString(2, map.get("password"));

            return pstmt.executeUpdate();

        } catch (Exception e) {
            System.out.println("delete Board() = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        return -1;
    };

    // 게시글 갯수
    public int getBoardCount() throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        int boardCount = 0;

        try {
            conn = ConnectionTest.getConnection();
            String sql1 = "select count(*) as rowCount from board";
            pstmt = conn.prepareStatement(sql1);
            rs = pstmt.executeQuery();

            while(rs.next()) {
                boardCount = rs.getInt("rowCount");
            }
        } catch (Exception e) {
            System.out.println("read count boardList = " + e.toString());
        } finally {
            rs.close();
            pstmt.close();
            conn.close();
        }

        return boardCount;
    }
    
    // 비밀번호 체크
    public boolean comparePassword(Map map) {
        return false;
    };

    // 조회수 증가
    public boolean increaseViewCount(Integer boardId) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionTest.getConnection();

            String sql = "update board set view_count = view_count + 1 where id = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, boardId);

            int rowCount = pstmt.executeUpdate();

            if(rowCount != 1) {
                throw new Exception("increase view count error");
            }

            return true;
        } catch (Exception e) {
            System.out.println("increase view() = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        return false;
    };

    // 카테고리 목록 가져오기
    public LinkedHashMap<Integer, String> getCategoryList() throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = ConnectionTest.getConnection();
            String sql = "select * from category order by id";
            pstmt = conn.prepareStatement(sql);
            rs = pstmt.executeQuery();

            LinkedHashMap<Integer, String> map = new LinkedHashMap<>();

            while(rs.next()) {
                map.put(rs.getInt("id"), rs.getString("name"));
            }

            return map;
        } catch (Exception e) {
            System.out.println("get categoryList() = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        return null;
    };
}