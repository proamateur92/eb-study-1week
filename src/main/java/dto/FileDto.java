package dto;

import java.util.Date;

public class FileDto {
    private Integer id;
    private Integer board_id;
    private Integer ranking;
    private String original_name;
    private String save_name;
    private Integer size;
    private boolean isDelete;
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

    public Integer getRanking() {
        return ranking;
    }

    public void setRanking(Integer ranking) {
        this.ranking = ranking;
    }

    public String getOriginal_name() {
        return original_name;
    }

    public void setOriginal_name(String original_name) {
        this.original_name = original_name;
    }

    public String getSave_name() {
        return save_name;
    }

    public void setSave_name(String save_name) {
        this.save_name = save_name;
    }

    public Integer getSize() {
        return size;
    }

    public void setSize(Integer size) {
        this.size = size;
    }

    public boolean isDelete() {
        return isDelete;
    }

    public void setDelete(boolean delete) {
        isDelete = delete;
    }

    public Date getCreate_date() {
        return create_date;
    }

    public void setCreate_date(Date create_date) {
        this.create_date = create_date;
    }

    @Override
    public String toString() {
        return "FileDto{" +
                "id=" + id +
                ", board_id=" + board_id +
                ", ranking=" + ranking +
                ", original_name='" + original_name + '\'' +
                ", save_name='" + save_name + '\'' +
                ", size=" + size +
                ", isDelete=" + isDelete +
                ", create_date=" + create_date +
                '}';
    }
}
