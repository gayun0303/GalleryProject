package egovframework.board.main.service.impl;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import egovframework.board.main.service.BoardVO;
import egovframework.board.main.service.FileService;
import egovframework.board.main.service.FileVO;

@Service("fileService")
public class FileServiceImpl extends EgovAbstractServiceImpl implements FileService  {
	
	@Resource(name = "fileMapper")
	private FileMapper fileDAO;
	
	@Resource(name="propertiesService")
	private EgovPropertyService propertiesService;
	
//	private String UPLOAD_DIR = "C:/upload/";

	
	/* 게시글에 첨부된 파일 조회 */
	@Override
	public List<FileVO> selectFileList(BoardVO vo) throws Exception {
		return fileDAO.selectFileList(vo.getBoardId());
	}

	
	/* 파일 리스트 저장 */
	@Override
	public String insertFileList(List<MultipartFile> fileList, BoardVO vo) throws Exception {
		String mainFileId = vo.getMainFileId();
		
		/* 오늘 날짜 폴더로 저장 경로 지정 */
		String today = new SimpleDateFormat("yyMMdd").format(new Date());
		String saveFolder = propertiesService.getString("uploadPath") + File.separator + today;
		
		/* 폴더 없으면 생성 */
		File folder = new File(saveFolder);
		if(!folder.exists())	folder.mkdirs();
		
		/* 여러 파일 각각 등록 */
		for(int i=0; i<fileList.size(); i++) {
			MultipartFile oneFile = fileList.get(i);
//			FileVO fileVO = new FileVO();
			
			/* 원래 파일명, 저장 파일명 */
			String originalFileName = oneFile.getOriginalFilename();
			String saveFileName = UUID.randomUUID().toString()
					+ originalFileName.substring(originalFileName.lastIndexOf('.'));
			
			FileVO fileVO = new FileVO(vo.getBoardId(), originalFileName, today, saveFileName, oneFile.getSize());
			
			// 파일 저장
			oneFile.transferTo(new File(folder, saveFileName));
			fileDAO.insertFile(fileVO);
			
			/* 새 파일 중에 썸네일 있다면 */
			if(!vo.getMainFileIndex().isEmpty()
					&& i == Integer.parseInt(vo.getMainFileIndex())) {
				mainFileId = fileVO.getFileId();
			}
		}
		return mainFileId;
	}

	@Override
	public void deleteDbFile(BoardVO boardVO) throws Exception {
		
		/* db에서 파일 삭제 */
		fileDAO.deleteFile(boardVO.getBoardId());
	}

	/* 실제 파일 삭제 */
	@Override
	public void deleteFile(List<FileVO> fileList) throws Exception {
		for(FileVO fileVO: fileList) {
			File file = new File(propertiesService.getString("uploadPath") + File.separator + fileVO.getFilePath(), fileVO.getSaveName());
			if(file.exists() 
					&& !file.delete()) {
				throw new RuntimeException("파일 삭제 실패: " + File.separator + fileVO.getFilePath() + File.separator + fileVO.getSaveName());
			}
		}
	}

	/* board 수정 시에 x한 파일들 db 데이터를 파일 id로 삭제 */
	@Override
	public void deleteFileListById(List<String> deletedFileIds) throws Exception {
		fileDAO.deleteFileListById(deletedFileIds);
	}
	/* 삭제할 파일 리스트 정보 조회 */
	@Override
	public List<FileVO> selectFileListForDelete(List<String> fileIdList) throws Exception {
		return fileDAO.selectFileListForDelete(fileIdList);
	}

}
