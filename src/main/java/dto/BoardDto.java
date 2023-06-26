package dto;

import java.sql.Timestamp;

public class BoardDto {
    private Integer id;
    private Integer category_id;
    private String content;
    private String title;
    private String author;
    private String password;
    private Integer view_count;
    private String file_flag;
    private Timestamp create_date;
    private Timestamp update_date;

    public BoardDto() {};

    public BoardDto(Integer id, Integer category_id, String content, String title, String author, String password, Integer view_count, String file_flag, Timestamp create_date, Timestamp update_date) {
        this.id = id;
        this.category_id = category_id;
        this.content = content;
        this.title = title;
        this.author = author;
        this.password = password;
        this.view_count = view_count;
        this.file_flag = file_flag;
        this.create_date = create_date;
        this.update_date = update_date;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getCategory_id() {
        return category_id;
    }

    public void setCategory_id(Integer category_id) {
        this.category_id = category_id;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public Integer getView_count() {
        return view_count;
    }

    public void setView_count(Integer view_count) {
        this.view_count = view_count;
    }

    public Timestamp getCreate_date() {
        return create_date;
    }

    public void setCreate_date(Timestamp create_date) {
        this.create_date = create_date;
    }

    public Timestamp getUpdate_date() {
        return update_date;
    }

    public void setUpdate_date(Timestamp update_date) {
        this.update_date = update_date;
    }

    public String getFile_flag() {
        return file_flag;
    }

    public void setFile_flag(String file_flag) {
        this.file_flag = file_flag;
    }

    @Override
    public String toString() {
        return "BoardDto{" +
                "id=" + id +
                ", category_id=" + category_id +
                ", content='" + content + '\'' +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", password='" + password + '\'' +
                ", view_count=" + view_count +
                ", file_flag='" + file_flag + '\'' +
                ", create_date=" + create_date +
                ", update_date=" + update_date +
                '}';
    }
}
