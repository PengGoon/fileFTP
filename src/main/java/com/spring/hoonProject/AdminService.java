package com.spring.hoonProject;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AdminService {

	@Autowired
	SqlSession sqlSession;

	public Map<String, Object> getDelList() {
		List<Map<String, Object>> result = sqlSession.selectList("com.spring.hoonProject.AdminMapper.getDelList");
		Map<String, Object> resultMap = new HashMap<String, Object>();
		resultMap.put("result", result);
		return resultMap;
	}
}
