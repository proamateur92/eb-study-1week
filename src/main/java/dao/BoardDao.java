package dao;

import dto.BoardDto;
import dto.PageDto;
import com.study.connection.ConnectionTest;

import java.sql.*;
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
    public List<BoardDto> getBoardList(PageDto pageDto, String startDate, String endDate, int categoryId, String keyword) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        List<BoardDto> boardList = new ArrayList<>();

        try {
            conn = ConnectionTest.getConnection();

             String sql = "select * from board where (author like ? or title like ? or content like ?) and category_id = ? and create_date >= ? and create_date <= ? order by id desc  limit ? offset ?";

             if(categoryId == 0) {
                sql = "select * from board where (author like ? or title like ? or content like ?) and create_date >= ? and create_date <= ? order by id desc  limit ? offset ?";
            }

            pstmt = conn.prepareStatement(sql);

            String startTimeStr = "00:00:00";
            String endTimeStr = "23:59:59";

            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setString(3, "%" + keyword + "%");

            System.out.println("startDate= " + startDate + " " + startTimeStr);
            System.out.println("endDate= " + endDate + " " + endTimeStr);
            if(categoryId == 0) {
                pstmt.setTimestamp(4, Timestamp.valueOf(startDate + " " + startTimeStr));
                pstmt.setTimestamp(5, Timestamp.valueOf(endDate + " " + endTimeStr));
                pstmt.setInt(6, pageDto.getNaviSize());
                pstmt.setInt(7, (pageDto.getPage() - 1) * pageDto.getPageSize());
            } else {
                pstmt.setInt(4, categoryId);
                pstmt.setTimestamp(5, Timestamp.valueOf(startDate + " " + startTimeStr));
                pstmt.setTimestamp(6, Timestamp.valueOf(endDate + " " + endTimeStr));
                pstmt.setInt(7, pageDto.getNaviSize());
                pstmt.setInt(8, (pageDto.getPage() - 1) * pageDto.getPageSize());
            }

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
    public int updateBoard(BoardDto boardDto) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;

        System.out.println("UPDATE BOARD DAO");

        try {
            conn = ConnectionTest.getConnection();
            String sql = "update board set category_id = ?, author = ?, title = ?, content = ?, update_date = now() where id = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, boardDto.getCategory_id());
            pstmt.setString(2, boardDto.getAuthor());
            pstmt.setString(3, boardDto.getTitle());
            pstmt.setString(4, boardDto.getContent());
            pstmt.setInt(5, boardDto.getId());

            return pstmt.executeUpdate();
        } catch (Exception e) {
            System.out.println("update Board() = " + e.toString());

        } finally {
            pstmt.close();
            conn.close();
        }

        return -1;
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
    public int getBoardCount(String startDate, String endDate, int categoryId, String keyword) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        int boardCount = 0;

        try {
            String sql = "select count(*) as rowCount from board where (author like ? or title like ? or content like ?) and category_id = ? and create_date >= ? and create_date <= ?";

            if(categoryId == 0) {
                sql = "select count(*) as rowCount from board where (author like ? or title like ? or content like ?) and create_date >= ? and create_date <= ?";
            }

            conn = ConnectionTest.getConnection();
            pstmt = conn.prepareStatement(sql);

            String startTimeStr = "00:00:00";
            String endTimeStr = "23:59:59";

            pstmt.setString(1, "%" + keyword + "%");
            pstmt.setString(2, "%" + keyword + "%");
            pstmt.setString(3, "%" + keyword + "%");

            System.out.println("startDate= " + startDate + " " + startTimeStr);
            System.out.println("endDate= " + endDate + " " + endTimeStr);

            if(categoryId == 0) {
                pstmt.setTimestamp(4, Timestamp.valueOf(startDate + " " + startTimeStr));
                pstmt.setTimestamp(5, Timestamp.valueOf(endDate + " " + endTimeStr));
            } else {
                pstmt.setInt(4, categoryId);
                pstmt.setTimestamp(5, Timestamp.valueOf(startDate + " " + startTimeStr));
                pstmt.setTimestamp(6, Timestamp.valueOf(endDate + " " + endTimeStr));

            }

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
    public int comparePassword(Map<String, Object> map) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        
        System.out.println("COMPARE PASSWORD BOARD DAO");

        int boardId = (int)map.get("boardId");
        String password = (String)map.get("password");

        System.out.println("map = " + map);
        System.out.println("boardId = " + boardId);
        System.out.println("password = " + password);
        try {
            conn = ConnectionTest.getConnection();
            String sql = "select id from board where id = ? and password = ?";
            pstmt = conn.prepareStatement(sql);

            pstmt.setInt(1, boardId);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();
            
            Integer id = null;
            
            while(rs.next()) {
                id = rs.getInt(1);
            };
            
            // 추출된 id가 없다면 0, 있으면 1 반환
            return id == null ? 0 : 1;
        } catch (Exception e) {
            System.out.println("COMPARE PASSWORD() = " + e.toString());
            return -1;
        } finally {
            rs.close();
            pstmt.close();
            conn.close();
        }
    }

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
