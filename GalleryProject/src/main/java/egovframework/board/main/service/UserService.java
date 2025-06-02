package egovframework.board.main.service;

public interface UserService {

	UserVO selectUser(BoardVO boardVO) throws Exception;

	void insertUser(UserVO userVO) throws Exception;

	UserVO selectUserById(UserVO userVO) throws Exception;

	UserVO selectUserByIdAndPassword(UserVO userVO) throws Exception;
}
