package egovframework.board.cmmn;

import java.util.Iterator;
import java.util.concurrent.ConcurrentHashMap;

import javax.servlet.http.HttpSession;

public class EgovMultiLoginPreventor {

	public static ConcurrentHashMap<String, HttpSession> loginUsers = new ConcurrentHashMap<String, HttpSession>();
	
    public static boolean findByLoginId(String loginId){
        return loginUsers.containsKey(loginId);
    }
 
    public static void invalidateByLoginId(String loginId){
            
        Iterator<String> iterator = loginUsers.keySet().iterator();
        while (iterator.hasNext()) {
            String key = iterator.next();

            if (key.equals(loginId)) {
                loginUsers.get(key).invalidate();
            }
        }
        
    }

}
