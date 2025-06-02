package egovframework.board.main.web;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.egovframe.rte.fdl.property.EgovPropertyService;
import org.egovframe.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.board.main.service.BoardService;
import egovframework.board.main.service.BoardVO;
import egovframework.board.main.service.SearchVO;
import egovframework.board.main.service.UserVO;

@Controller
public class BoardController {
	
	@Resource(name="boardService")
	private BoardService boardService;
	
	@Resource(name="propertiesService")
	private EgovPropertyService propertiesService;
	
	
	/** 
	 * 게시글 목록 조회
	 */
	@RequestMapping(value = "/boardList.do")
	public String selectBoardList(@ModelAttribute("searchVO") SearchVO searchVO, ModelMap model) throws Exception {
		

		/** context-properties.xml에 각각 10으로 저장되어 있음 */
		searchVO.setPageUnit(propertiesService.getInt("pageUnit"));
		searchVO.setPageSize(propertiesService.getInt("pageSize"));

		/** 
		 * 페이징
		 * 현재 페이지 인덱스, 한 페이지 크기, 페이지 개수로
		 * 현제 패이지에서 첫 글 인덱스, 마지막 글 인덱스를 받아옴
		 *  */
		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setCurrentPageNo(searchVO.getPageIndex());
		paginationInfo.setRecordCountPerPage(searchVO.getPageUnit());
		paginationInfo.setPageSize(searchVO.getPageSize());

		searchVO.setFirstIndex(paginationInfo.getFirstRecordIndex());
		searchVO.setLastIndex(paginationInfo.getLastRecordIndex());
		searchVO.setRecordCountPerPage(paginationInfo.getRecordCountPerPage());

		/** 글 목록 조회 */
		List<?> boardList = boardService.selectBoardList(searchVO);
		
		model.addAttribute("boardList", boardList);

		/** 게시글 전체 개수 */
		int totCnt = boardService.selectBoardListTotCnt(searchVO);
		paginationInfo.setTotalRecordCount(totCnt);
		
		model.addAttribute("paginationInfo", paginationInfo);
		
		return "main/boardList";
		
	}
	
	/** 
	 * 게시글 등록 화면으로 이동
	 */
	@RequestMapping(value = "/addBoardView.do", method = RequestMethod.POST)
	public String addBoardView(HttpSession session,
			@ModelAttribute("searchVO") SearchVO searchVO,
			@ModelAttribute("boardVO") BoardVO boardVO,
			ModelMap model) throws Exception {
		
		// modify 구분
		boardVO.setBoardId(null);
		
		// 로그인 정보 조회
		UserVO userVO = (UserVO) session.getAttribute("login");
		if ( userVO != null ){
			boardVO.setName(userVO.getName());
			boardVO.setUserId(userVO.getUserId());
		}
		model.addAttribute("boardVO", boardVO);
		
		return "main/boardRegister";
		
	}
	
	/** 
	 * 게시글 등록
	 */
	@RequestMapping(value = "/addBoard.do", method = RequestMethod.POST)
	public String addBoard(@ModelAttribute("searchVO") SearchVO searchVO, 
			@ModelAttribute("boardVO") BoardVO boardVO, 
			@RequestParam("file") List<MultipartFile> fileList,
			RedirectAttributes redirectAttributes)
					throws Exception {
		
		boardService.insertBoard(boardVO, fileList);
		redirectAttributes.addFlashAttribute("searchVO", searchVO);
		return "redirect:/boardList.do";
	}
	
	/** 
	 * 게시글 수정 화면으로 이동
	 */
	@RequestMapping(value = "/updateBoardView.do", method = RequestMethod.POST)
	public String updateBoardView(HttpSession session,
			@ModelAttribute("searchVO") SearchVO searchVO,
			BoardVO boardVO,
			ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
			
			UserVO loginUserVO = (UserVO) session.getAttribute("login");
			
			// 현재 로그인한 사용자와 글 작성자 비교
			if(!boardVO.getUserId().equals(loginUserVO.getUserId())) {
				redirectAttributes.addFlashAttribute("alertMsg", "작성자만 수정할 수 있습니다.");
				redirectAttributes.addFlashAttribute("searchVO", searchVO);
				redirectAttributes.addFlashAttribute("boardVO", boardVO);
				return "redirect:/postBridge.do";
				
			}
			model.addAttribute("boardVO", boardService.selectBoard(boardVO));
		return "main/boardRegister";
	}
	/** 
	 * 게시글 수정
	 */
	@RequestMapping(value = "/updateBoard.do", method = RequestMethod.POST)
	public String updateBoard(@ModelAttribute("searchVO") SearchVO searchVO,
			BoardVO boardVO,
			@RequestParam("deleteFileIds") String deletedFileIdsString,
			@RequestParam("file") List<MultipartFile> fileList,
			ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
			
		List<String> deletedFileIds = new ArrayList<>();
		if (deletedFileIdsString != null && !deletedFileIdsString.trim().isEmpty()) {
		    deletedFileIds = Arrays.asList(deletedFileIdsString.split(","));
		}
		
		boardService.updateBoard(boardVO, fileList, deletedFileIds);
		
		redirectAttributes.addFlashAttribute("searchVO", searchVO);
		redirectAttributes.addFlashAttribute("boardVO", boardVO);
		return "redirect:/postBridge.do";
//		model.addAttribute("searchVO", searchVO);
//		model.addAttribute("boardVO", boardVO);
//		return "forward:/boardDetailView.do";
		
	}
	
	@RequestMapping(value = "/postBridge.do")
	public String postBridge() {
		return "main/postBridge";
	}
	
	/** 
	 * 게시글 조회 화면으로 이동한다.
	 */
	@RequestMapping(value = "/boardDetailView.do", method = RequestMethod.POST)
	public String boardView(
			SearchVO searchVO, BoardVO boardVO, 
			ModelMap model) throws Exception {
		
		model.addAttribute("boardVO", boardService.selectBoard(boardVO));
		
		return "main/boardView";
	}
	
	/** 
	 * 게시글 삭제
	 */
	@RequestMapping(value = "/deleteBoard.do", method = RequestMethod.POST)
	public String deleteBoard(HttpSession session,
			@ModelAttribute("searchVO") SearchVO searchVO,
			BoardVO boardVO,
			ModelMap model,
			RedirectAttributes redirectAttributes) throws Exception {
		
		UserVO loginUserVO = (UserVO) session.getAttribute("login");
		
		if(!boardVO.getUserId().equals(loginUserVO.getUserId())) {
			redirectAttributes.addFlashAttribute("alertMsg", "작성자만 삭제할 수 있습니다.");
			redirectAttributes.addFlashAttribute("searchVO", searchVO);
			redirectAttributes.addFlashAttribute("boardVO", boardVO);
			return "redirect:/postBridge.do";
		}

		boardService.deleteBoard(boardVO);
			
		redirectAttributes.addFlashAttribute("searchVO", searchVO);
		return "redirect:/boardList.do";
		
	}
	
}
