package egovframework.board.cmmn;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import egovframework.board.main.service.UserVO;

public class AuthenticInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {

        HttpSession session = request.getSession();
        
    	UserVO loginVO = (UserVO) session.getAttribute("login");
        if(loginVO != null) {
            session.setMaxInactiveInterval(60 * 30);	// 30분
            return true;
        }else {
      	    String loginUrl = "/user/loginView.do";
      	    
      	    response.sendRedirect(request.getContextPath()+loginUrl);
      	    return false;
        }
    }

}