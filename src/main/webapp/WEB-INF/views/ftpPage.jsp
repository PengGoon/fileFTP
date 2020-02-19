<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<html>
<head>
	<title>Login</title>
	<style>
		table {
	    	width: 100%;
	    	border: 1px solid #444444;
	    	border-collapse: collapse;
	   	}
	   	th, td {
    		border: 1px solid #444444;
  		}
	</style>
</head>
<body>
	<div>
		<h2>FTP LIST</h2>
		<span id="rootPath" ></span>
		<div>
			<table>
				<thead>
					<tr>
						<th>파일명</th>
						<th>다운로드</th>
						<th>삭제요청</th>
					</tr>
				</thead>
				<tbody id="fileList">
				</tbody>
			</table>
<!-- 			<span>ID : </span><input type="text" id="userId"/> -->
<!-- 		</div> -->
<!-- 		<div> -->
<!-- 			<span>PW : </span><input type="password" id="userPw"/> -->
<!-- 		</div> -->
<!-- 		<div> -->
<!-- 			<button id="login">로그인</button> -->
		</div>
		<div>
			<form id="fileForm" action="/fileUpload" method="post" enctype="multipart/form-data">
			    <input type="file" name="file" placeholder="파일 선택" /><br/>
			    <input type="button" id="uploadBtn" value="업로드">
			</form>
		</div>
	</div>
</body>

<script>
	var currPage = "C:/siwanPage";
	fn_getFTPList(currPage); //파일 리스트 가져오기

	$("#uploadBtn").on("click",function(){
		fn_fileUpload(currPage);
	});

	//파일 리스트 가져오기
	function fn_getFTPList(path){
		currPage = path;
		$("#rootPath").text("");
		var pathArray = path.split("/");
		var pagePath = "";
		for(var i in pathArray){
			pagePath += pathArray[i];
			if(i < pathArray.length-1) pagePath += "/";
			console.log(pagePath);
			$("#rootPath").append("<a href='javascript:void(0)' onclick=fn_getFTPList('"+pagePath+"')>"+pathArray[i]+"</a>");
			if(i < pathArray.length-1) $("#rootPath").append(" / ");
		}

		$.ajax({
	 		type:"POST",
			url:"/ftpPage/getFTPList",
	 		data : {path:path},
			success: function(result){
				console.log(result);
				fn_setFileList(result);
			},
			error: function(e) {
				console.error(e);
			}
		});
	}

	//파일 리스트 출력
	function fn_setFileList(data){
		$("#fileList").empty();

		var html = "";
		for(var i in data){
			var fn = "";
			var downBtn = "";
			var delReqBtn = "";

			if("F" == data[i].fileFlag){
				fn = 'fn_fileDownload("'+data[i].filePath+'","'+data[i].fileName+'")';
				downBtn = '<button onclick=fn_fileDownload("'+data[i].filePath+'","'+data[i].fileName+'")>다운로드</button>';
				delReqBtn = '<button onclick=fn_fileDelReq("'+data[i].filePath+'","'+data[i].fileName+'")>삭제요청</button>';
			}else if("D" == data[i].fileFlag){
				fn = 'fn_getFTPList("'+data[i].filePath+'")';
			}
			html += "<tr>";
			html += "<td><a href='javascript:void(0)' onclick ='"+fn+"'>"+data[i].fileName+"</a></td>";
			html += "<td>"+downBtn+"</td>";
			html += "<td>"+delReqBtn+"</td>";
			html += "</tr>";
		}

		$("#fileList").append(html);
	}

	//파일 업로드
	function fn_fileUpload(path){
		var formData = new FormData($('#fileForm')[0]);

		$.ajax({
			type: "POST",
			enctype: 'multipart/form-data',
			url: '/fileUpload',
			data: formData,
			processData: false,
			contentType: false,
			success: function (result) {
				console.log(result);
				if("SUCC" == result){
					alert("업로드 되었습니다.");
					fn_getFTPList(path); //파일 리스트 가져오기
				}else{
					alert("파일이 정상적으로 업로드 되지 않았습니다.\n파일을 확인해주세요.");
				}
			},
			error: function (e) {
				console.error(e);
			}
		});
	}

	//파일 다운로드
	function fn_fileDownload(path,file){
		$.ajax({
			type: "POST",
			url: '/fileDownload',
			data: {path:path, file:file},
			success: function (result) {
				console.log(result);

			},
			error: function (e) {
				console.error(e);
			}
		});
	}

	//파일 삭제요청
	function fn_fileDelReq(path,file){
		var param = {};
		param.path = path;
		param.file = file;

		$.ajax({
			type: "POST",
			url: '/fileDelReq',
			data: param,
			success: function (result) {
				console.log(result);
			},
			error: function (e) {
				console.error(e);
			}
		});
	}
</script>
</html>
