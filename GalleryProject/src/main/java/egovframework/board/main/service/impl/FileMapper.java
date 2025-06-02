package egovframework.board.main.service.impl;

import java.util.List;
import org.egovframe.rte.psl.dataaccess.mapper.Mapper;
import egovframework.board.main.service.FileVO;

@Mapper("fileMapper")
public interface FileMapper {
	void insertFile(FileVO fileVO) throws Exception;
	
	/* 실제 파일 삭제 */
	void deleteFile(String boardId) throws Exception;
	
	List<FileVO> selectFileList(String boardId) throws Exception;

	void deleteFileListById(List<String> deleteFileIds) throws Exception;

	List<FileVO> selectFileListForDelete(List<String> fileIdList) throws Exception;

}