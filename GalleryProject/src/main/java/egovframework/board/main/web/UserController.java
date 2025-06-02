package egovframework.board.main.web;

import javax.annotation.Resource;
import javax.servlet.http.HttpSession;

import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import egovframework.board.cmmn.EgovHttpSessionBindingListener;
import egovframework.board.cmmn.EgovMultiLoginPreventor;
import egovframework.board.main.service.UserService;
import egovframework.board.main.service.UserVO;

@Controller
@RequestMapping("/user")
public class UserController {
	
	@Resource(name="userService")
	private UserService userService;

	@RequestMapping(value = "/loginView.do")
	public String loginView(@ModelAttribute("userVO") UserVO userVO, ModelMap model) {
		model.addAttribute("userVO", new UserVO());
		return "main/login";
	}
	
	/* 로그인 */
    @RequestMapping(value="/login.do",method=RequestMethod.POST)
    public String loginCheck(HttpSession session,
    		UserVO userVO, RedirectAttributes redirectAttributes) throws Exception{
        String returnURL = "";
        
        EgovHttpSessionBindingListener listener = new EgovHttpSessionBindingListener();
        
        if ( session.getAttribute("login") != null ){
        	String userId = ((UserVO) session.getAttribute("login")).getUserId();
        	EgovMultiLoginPreventor.loginUsers.remove(userId, session);
        	session.removeAttribute("login");
        }
        
		/* 로그인 시도 */
        UserVO vo = userService.selectUserByIdAndPassword(userVO);
        
		/* 로그인 성공 */
        if ( vo != null ){
			/* 세션에 저장 */
            session.setAttribute("login", vo);
            session.setAttribute(vo.getUserId(), listener);
            returnURL = "redirect:/boardList.do";
        } else { // 로그인 실패
        	redirectAttributes.addFlashAttribute("alertMsg", "아이디 또는 비밀번호가 틀렸습니다.");
            returnURL = "redirect:/user/loginView.do";
        }
        
        return returnURL;
    }
  
	/* 로그아웃 */
    @RequestMapping(value="/logout.do")
    public String logout(HttpSession session) {
    	session.invalidate(); // 세션 초기화
        return "redirect:/user/loginView.do";
    }
    
	/* 회원가입 페이지로 이동 */
    @RequestMapping(value = "/addUserView.do")
	public String registerView(@ModelAttribute("userVO") UserVO userVO, ModelMap model) {
		model.addAttribute("userVO", new UserVO());
		return "main/userRegister";
	}
    
	/* 회원가입 */
	@RequestMapping(value = "/addUser.do", method = RequestMethod.POST)
	public String addBoard(@ModelAttribute("userVO") UserVO userVO, ModelMap model)
					throws Exception {
		if(userService.selectUserById(userVO) == null) {
			userService.insertUser(userVO);
		} else {
//			userVO.setId(null);
			model.addAttribute("userVO", userVO);
			model.addAttribute("alertMsg", "이미 존재하는 아이디입니다.");
			return "main/userRegister";
		}
		model.addAttribute("userVO", new UserVO());
		return "main/login";
	}
}
