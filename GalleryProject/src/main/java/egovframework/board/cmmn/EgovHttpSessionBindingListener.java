package egovframework.board.cmmn;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

public class EgovHttpSessionBindingListener implements HttpSessionBindingListener  {

	public EgovHttpSessionBindingListener() {
		// TODO Auto-generated constructor stub
	}

	@Override
	public void valueBound(HttpSessionBindingEvent arg0) {
		if (EgovMultiLoginPreventor.findByLoginId(arg0.getName())){
			EgovMultiLoginPreventor.invalidateByLoginId(arg0.getName());
//			arg0.getSession().setAttribute("MultiLogin", "second");
		}
		EgovMultiLoginPreventor.loginUsers.put(arg0.getName(), arg0.getSession());
		
	}

	@Override
	public void valueUnbound(HttpSessionBindingEvent arg0) {
		EgovMultiLoginPreventor.loginUsers.remove(arg0.getName(), arg0.getSession());
		
	}

}
