package egovframework.board.main.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

public interface BoardService {
	
	/**
	 * 글을 등록한다.
	 */
	String insertBoard(BoardVO vo, List<MultipartFile> fileList) throws Exception;

	/**
	 * 글을 수정한다.
	 */
	void updateBoard(BoardVO vo, List<MultipartFile> fileList, List<String> deletedFileIds) throws Exception;

	/**
	 * 글을 삭제한다.
	 */
	void deleteBoard(BoardVO vo) throws Exception;

	/**
	 * 글 목록을 조회한다.
	 */
	List<?> selectBoardList(SearchVO searchVO) throws Exception;

	/**
	 * 글 총 갯수를 조회한다.
	 */
	int selectBoardListTotCnt(SearchVO searchVO);

	/**
	 * 조회수 증가
	 */
	void increaseClickCount(BoardVO boardVO) throws Exception;
	
	/**
	 * 글을 조회한다.
	 */
	BoardVO selectBoard(BoardVO vo) throws Exception;

}
