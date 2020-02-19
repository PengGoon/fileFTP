package com.spring.hoonProject.user;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService{

	@Autowired
	SqlSession sqlSession;

	/* 로그인 - 유저 확인 */
	public Map<String, Object> getUser(Map<String, Object> map) {
		List<Map<String, Object>> result = sqlSession.selectList("com.spring.hoonProject.UserMapper.getUser",map);
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", result);
		return resultMap;
	}
}
