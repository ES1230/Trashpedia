package com.kks.trashpedia.board.model.vo;

import java.sql.Date;
import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
public class Board {
	private int boardNo;
	private int postNo;
	private int userNo;
	private int subCategoryNo;
	private String status;
	
	// adminMain - boardCharts
	private String orderDay;
	private int countBoard;
	
	// adminMemberManagement - board
	private String title;
	private String subCategoryName;
	private String bigCategoryName;
	
	// adminMemberManagement - boardDetail
	private String content;
	private Date createDate;
	private Date modifyDate;
	
	// adminMemberDetail - commentDetail
	private String commentContent;
	
	private List<ImgAttachment> imgAttachment; //첨부이미지
	private Attachment attachment; //첨부파일
}
