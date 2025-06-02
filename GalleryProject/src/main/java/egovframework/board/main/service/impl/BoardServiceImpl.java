package egovframework.board.main.service.impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.board.main.service.BoardService;
import egovframework.board.main.service.BoardVO;
import egovframework.board.main.service.FileService;
import egovframework.board.main.service.FileVO;
import egovframework.board.main.service.SearchVO;

@Service("boardService")
public class BoardServiceImpl extends EgovAbstractServiceImpl implements BoardService {


	@Resource(name = "boardMapper")
	private BoardMapper boardDAO;
	
	@Resource(name = "fileService")
	private FileService fileService;
	
	/**
	 * 글을 등록한다.
	 */
	@Override
	public String insertBoard(BoardVO vo, List<MultipartFile> fileList) throws Exception {
		
		// 글 저장
		boardDAO.insertBoard(vo);
		
		String mainFileId = null;
		// 파일 있다면 저장
		if(fileList != null 
				&& !fileList.isEmpty()
				&& fileList.get(0).getSize() > 0) {
			mainFileId = fileService.insertFileList(fileList, vo);
		}
		
		if(mainFileId != null) {
			vo.setMainFileId(mainFileId);
			boardDAO.updateBoard(vo);
		}
		
		return null;
	}

	/**
	 * 글을 수정한다.
	 */
	@Override
	public void updateBoard(BoardVO vo, List<MultipartFile> fileList, List<String> deletedFileIds) throws Exception {
		
		/* 기존 파일 중에 삭제한 파일 id list로 파일 정보 조회 */
		List<FileVO> deleteFileList = null;
		if(deletedFileIds != null 
				&& !deletedFileIds.isEmpty()) {
			deleteFileList = fileService.selectFileListForDelete(deletedFileIds);
			/* db에 파일 삭제 */
			fileService.deleteFileListById(deletedFileIds);
		}
		
		String mainFileId = null;
		/* 추가 파일 등록 */
		if(fileList != null
				&& !fileList.isEmpty()
				&& fileList.get(0).getSize() > 0) {
			mainFileId = fileService.insertFileList(fileList, vo);
		}
		
		if(mainFileId != null) {
			vo.setMainFileId(mainFileId);
		}
		
		/* 글 수정 */
		boardDAO.updateBoard(vo);
		
		/* 실제 파일 삭제 */
		if(deletedFileIds != null && !deletedFileIds.isEmpty()) {
			fileService.deleteFile(deleteFileList);
		}
		
	}

	/**
	 * 글을 삭제한다.
	 */
	@Override
	public void deleteBoard(BoardVO boardVO) throws Exception {
		
		/* boardid 기준으로 삭제할 파일 선택 */
		List<FileVO> fileListForDelete = fileService.selectFileList(boardVO);
		
		/* 파일 db 삭제 */
		if(fileListForDelete != null 
				&& !fileListForDelete.isEmpty()
				&& fileListForDelete.size() > 0) {
			fileService.deleteDbFile(boardVO);
		}
		
		/* 글 삭제 */
		boardDAO.deleteBoard(boardVO);
		
		/* 실제 파일 삭제 */
		if(fileListForDelete != null 
				&& !fileListForDelete.isEmpty()
				&& fileListForDelete.size() > 0) {
			fileService.deleteFile(fileListForDelete);
		}
	}
	
	/**
	 * 글을 조회한다.
	 */
	@Override
	public BoardVO selectBoard(BoardVO boardVO) throws Exception {
		
		/* 선택한 글 조회수 증가 */
		increaseClickCount(boardVO);
		
		BoardVO result = boardDAO.selectBoard(boardVO);
		
		/* 파일 목록 가져오기 */
		result.setFileVOList(fileService.selectFileList(boardVO));

		return result;
	}
	
	/**
	 * 조회수 증가
	 */
	@Override
	public void increaseClickCount(BoardVO boardVO) throws Exception {
		boardDAO.increaseClickCount(boardVO);
	}

	/**
	 * 글 목록을 조회한다.
	 */
	@Override
	public List<?> selectBoardList(SearchVO searchVO) throws Exception {
		
		List<?> boardList = boardDAO.selectBoardList(searchVO);
		
		/* 조회한 글이 없다면 빈 리스트 전달해준다. */
		if (boardList == null || boardList.isEmpty()) {
		    boardList = new ArrayList<>();
		}
		
		return boardList;
	}

	/**
	 * 검색한 글의 총 갯수를 조회한다.
	 */
	@Override
	public int selectBoardListTotCnt(SearchVO searchVO) {
		return boardDAO.selectBoardListTotCnt(searchVO);
	}

}
