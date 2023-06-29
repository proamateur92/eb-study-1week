package dto;

import java.sql.Timestamp;
import java.util.Date;

public class CommentDto {
    private Integer id;
    private Integer board_id;
    private String nickname;
    private String password;
    private String content;
    private Timestamp create_date;

    public CommentDto() {}

    public CommentDto(Integer id, Integer board_id, String nickname, String password, String content, Timestamp create_date) {
        this.id = id;
        this.board_id = board_id;
        this.nickname = nickname;
        this.password = password;
        this.content = content;
        this.create_date = create_date;
    }

    public String getNickname() {
        return nickname;
    }

    public void setNickname(String nickname) {
        this.nickname = nickname;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getBoard_id() {
        return board_id;
    }

    public void setBoard_id(Integer board_id) {
        this.board_id = board_id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Timestamp getCreate_date() {
        return create_date;
    }

    public void setCreate_date(Timestamp create_date) {
        this.create_date = create_date;
    }

    @Override
    public String toString() {
        return "CommentDto{" +
                "id=" + id +
                ", board_id=" + board_id +
                ", content='" + content + '\'' +
                ", create_date=" + create_date +
                '}';
    }
}
