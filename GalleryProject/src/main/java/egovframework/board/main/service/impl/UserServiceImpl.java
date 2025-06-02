package egovframework.board.main.service.impl;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import egovframework.board.main.service.BoardVO;
import egovframework.board.main.service.UserService;
import egovframework.board.main.service.UserVO;

@Service("userService")
public class UserServiceImpl implements UserService {

	@Resource
	UserMapper userDAO;

	@Override
	public UserVO selectUser(BoardVO boardVO) throws Exception {
		return userDAO.selectUser(boardVO);
	}

	@Override
	public void insertUser(UserVO userVO) throws Exception {
		userDAO.insertUser(userVO);
	}

	@Override
	public UserVO selectUserById(UserVO userVO) throws Exception {
		return userDAO.selectUserById(userVO);
	}

	@Override
	public UserVO selectUserByIdAndPassword(UserVO userVO) throws Exception {
		return userDAO.selectUserByIdAndPassword(userVO);
	}

}
