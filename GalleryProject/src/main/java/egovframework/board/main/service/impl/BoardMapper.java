package egovframework.board.main.service.impl;

import java.util.List;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.board.main.service.BoardVO;
import egovframework.board.main.service.SearchVO;

@Mapper("boardMapper")
public interface BoardMapper {
	/**
	 * 글을 등록한다.
	 */
	void insertBoard(BoardVO vo) throws Exception;

	/**
	 * 글을 수정한다.
	 */
	void updateBoard(BoardVO vo) throws Exception;

	/**
	 * 글을 삭제한다.
	 */
	void deleteBoard(BoardVO vo) throws Exception;

	/**
	 * 글을 조회한다.
	 */
	BoardVO selectBoard(BoardVO vo) throws Exception;

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

}
