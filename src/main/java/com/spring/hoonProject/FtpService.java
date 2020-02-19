package com.spring.hoonProject;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

@Service
public class FtpService {

	@Autowired
	SqlSession sqlSession;

	/* FTP리스트 불러오기 */
	public List<Map<String, Object>> getFTPList(String paramPath) {
		List<Map<String,Object>> resultList = new ArrayList<Map<String,Object>>();

		File path = new File(paramPath);
		File[] fileList = path.listFiles();

		for(int i=0; i<fileList.length; i++) {
			Map<String, Object> resultMap = new HashMap<String,Object>();
			String fileFlag = "";
			if(fileList[i].isFile()) fileFlag = "F";
			if(fileList[i].isDirectory()) fileFlag = "D";

			resultMap.put("filePath", fileList[i].getPath().replace("\\", "/"));
			resultMap.put("fileName", fileList[i].getName());
			resultMap.put("fileFlag", fileFlag);
			resultList.add(resultMap);
		}
		return resultList;
	}

	/* 파일업로드 */
	public String upload(MultipartHttpServletRequest mtf){
		MultipartFile file = mtf.getFile("file");

		String fileName = file.getOriginalFilename();
		if("".equals(fileName)) {
			return "ERR";
		}
	    // 파일 이름 변경
	    UUID uuid = UUID.randomUUID();
	    String saveName = uuid + "_" + fileName;

	    File saveFile = new File("C:\\siwanPage",saveName); // 저장할 폴더 이름, 저장할 파일 이름

	    try {
	        file.transferTo(saveFile); // 업로드 파일에 saveFile이라는 껍데기 입힘
	        return "SUCC";
	    } catch (IOException e) {
	    	return "ERR";
	    }
	}

	/* 파일다운로드 */
	public void fileDownload(HttpServletResponse response, String paramPath ,String paramFile){
		try {
	        byte[] fileByte = FileUtils.readFileToByteArray(new File(paramPath));
	         response.setContentType("application/octet-stream");
	         response.setContentLength(fileByte.length);
	         response.setHeader("Content-Disposition",  "attachment; fileName=\""+URLEncoder.encode(paramFile, "UTF-8")+"\";");
	         response.getOutputStream().write(fileByte);
	         response.getOutputStream().flush();
	         response.getOutputStream().close();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	public String fileDelReq(Map<String, Object> map) {
		int result = sqlSession.insert("com.spring.hoonProject.fileMapper.fileDelReq",map);
		if(result > 0) {
			return "SUCC";
		}else {
			return "ERR";
		}
	}

	public String fileDel(String path) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("path", path);

		File file = new File(path);
		if(file.exists()) {
			if(file.delete()) {
				int result = sqlSession.update("com.spring.hoonProject.fileMapper.fileDel",map);
				if(result > 0) {
					return "SUCC";
				}else {
					return "ERR";
				}
			} else {
				return "ERR";
			}
		} else {
			return "ERR";
		}
	}
}
