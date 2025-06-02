package egovframework.board.main.service;

import java.util.Date;
import java.util.List;

import org.apache.commons.lang3.builder.ToStringBuilder;


public class BoardVO {
	
	private String boardId;	// 게시글 id
	private String title;	// 게시글 제목
	private String name;		// 작성자 이름
	private String userId;		// 작성자 id
	
	private Date createDate;	// 게시글 작성일시
	private int clickCount;		// 조회수
	private String content;		// 게시글 내용
	
	private List<FileVO>	fileVOList;
	private FileVO fileVO;
	private String mainFileId;
	private String mainFileIndex;

	public BoardVO() {
	}

	public String getBoardId() {
		return boardId;
	}

	public void setBoardId(String boardId) {
		this.boardId = boardId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public Date getCreateDate() {
		return createDate;
	}

	public void setCreateDate(Date createDate) {
		this.createDate = createDate;
	}

	public int getClickCount() {
		return clickCount;
	}

	public void setClickCount(int clickCount) {
		this.clickCount = clickCount;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public List<FileVO> getFileVOList() {
		return fileVOList;
	}

	public void setFileVOList(List<FileVO> fileVOList) {
		this.fileVOList = fileVOList;
	}

	public String getMainFileId() {
		return mainFileId;
	}

	public void setMainFileId(String mainFileId) {
		this.mainFileId = mainFileId;
	}

	public FileVO getFileVO() {
		return fileVO;
	}

	public void setFileVO(FileVO fileVO) {
		this.fileVO = fileVO;
	}

	public String getMainFileIndex() {
		return mainFileIndex;
	}

	public void setMainFileIndex(String mainFileIndex) {
		this.mainFileIndex = mainFileIndex;
	}

	@Override
	public String toString() {
		return ToStringBuilder.reflectionToString(this);
	}
	
}
