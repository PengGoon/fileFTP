package com.spring.hoonProject;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.spring.hoonProject.user.UserService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);

	@Autowired
	private FtpService ftpService;
	@Autowired
	private UserService userService;
	@Autowired
	private AdminService adminService;

	/* 메인(로그인페이지) */
	@RequestMapping("/")
	public String main() {
		return "login";
	}

	@RequestMapping("/login")
	@ResponseBody
	public Map<String, Object> login(@RequestParam Map<String, Object> map) {
		return userService.getUser(map);
	}

	/* FTP페이지 */
	@RequestMapping("/ftpPage")
	public String ftpPage() {
		return "ftpPage";
	}

	/* FTP리스트 불러오기 */
	@RequestMapping("/ftpPage/getFTPList")
	@ResponseBody
	public List<Map<String, Object>> getFTPList(HttpServletRequest request) {
		String paramPath = request.getParameter("path");
		return ftpService.getFTPList(paramPath);
	}

	/* 파일업로드 */
	@RequestMapping("/fileUpload")
	@ResponseBody
	public String upload(MultipartHttpServletRequest mtf){
		String resultCode = ftpService.upload(mtf);
		return resultCode;
	}

	/* 파일다운로드 */
	@RequestMapping("/fileDownload")
	public void fileDownload(HttpServletRequest request, HttpServletResponse responce){
		String paramPath = request.getParameter("path");
		String paramFile = request.getParameter("file");
		ftpService.fileDownload(responce, paramPath, paramFile);
	}

	/* 파일삭제요청 */
	@RequestMapping("/fileDelReq")
	public String fileDelReq(@RequestParam Map<String, Object> map){
		return ftpService.fileDelReq(map);
	}

	/* 관리자페이지 */
	@RequestMapping("/adminPage")
	public String adminPage() {
		return "adminPage";
	}

	/* 삭제요청리스트 불러오기 */
	/**
	 * @param request
	 * @return
	 */
	@RequestMapping("/adminPage/getDelList")
	@ResponseBody
	public Map<String, Object> getDelList(HttpServletRequest request) {
		return adminService.getDelList();
	}

	/* 파일다운로드 */
	@RequestMapping("/fileDel")
	public String fileDel(HttpServletRequest request){
		String paramPath = request.getParameter("path");
		return ftpService.fileDel(paramPath);
	}
}
