package dto;

import java.util.Date;

public class CommentDto {
    private Integer id;
    private Integer board_id;
    private String content;
    private Date create_date;

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

    public Date getCreate_date() {
        return create_date;
    }

    public void setCreate_date(Date create_date) {
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
