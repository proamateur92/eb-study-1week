package dto;

import java.sql.Timestamp;
import java.util.Date;

public class FileDto {
    private Integer id;
    private Integer board_id;
    private Integer ranking;
    private String original_name;
    private String save_name;
    private Integer size;
    private String delete_flag;
    private Timestamp create_date;


    public FileDto() {}

    public FileDto(Integer ranking, String original_name, String save_name, Integer size) {
        this.ranking = ranking;
        this.original_name = original_name;
        this.save_name = save_name;
        this.size = size;
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

    public String getDelete_flag() {
        return delete_flag;
    }

    public void setDelete_flag(String delete) {
        delete_flag = delete;
    }

    public Timestamp getCreate_date() {
        return create_date;
    }

    public void setCreate_date(Timestamp create_date) {
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
                ", delete_flag=" + delete_flag +
                ", create_date=" + create_date +
                '}';
    }
}
