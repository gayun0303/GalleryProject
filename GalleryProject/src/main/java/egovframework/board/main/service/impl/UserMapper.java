package egovframework.board.main.service.impl;

import org.egovframe.rte.psl.dataaccess.mapper.Mapper;

import egovframework.board.main.service.BoardVO;
import egovframework.board.main.service.UserVO;

@Mapper("userMapper")
public interface UserMapper {

	public UserVO selectUser(BoardVO boardVO) throws Exception;

	public void insertUser(UserVO userVO) throws Exception;

	public UserVO selectUserById(UserVO userVO) throws Exception;

	public UserVO selectUserByIdAndPassword(UserVO userVO) throws Exception;

}
