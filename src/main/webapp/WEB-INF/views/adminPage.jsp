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
		<h2>삭제요청 리스트</h2>
		<div>
			<table>
				<thead>
					<tr>
						<th>파일명</th>
						<th>경로</th>
						<th>삭제</th>
					</tr>
				</thead>
				<tbody id="delList">
				</tbody>
			</table>
		</div>
	</div>
</body>

<script>
	fn_getDelList(); //파일 리스트 가져오기

	//삭제요청 리스트 가져오기
	function fn_getDelList(){
		$.ajax({
	 		type:"POST",
			url:"/adminPage/getDelList",
			success: function(result){
				console.log(result.result);
				fn_mkList(result.result);
			},
			error: function(e) {
				console.error(e);
			}
		});
	}

	//파일 리스트 출력
	function fn_mkList(data){
		$("#delList").empty();

		var html = "";
		for(var i in data){
			html += "<tr>";
			html += "<td>"+data[i].FILE_NAME+"</td>";
			html += "<td>"+data[i].FILE_PATH+"</td>";
			html += "<td><button onclick ='fn_fileDel('"+data[i].FILE_PATH+"')'>삭제</a></td>";
			html += "</tr>";
		}

		$("#delList").append(html);
	}

	//파일 삭제
	function fn_fileDel(path,file){
		$.ajax({
			type: "POST",
			url: '/fileDel',
			data: {path:path},
			success: function (result) {
				console.log(result);
				if("SUCC" == result){
					alert("삭제 되었습니다.");
					fn_getDelList(); //삭제요청 리스트 가져오기
				}else{
					alert("파일이 정상적으로 삭제 되지 않았습니다.\n확인 후 다시 시도해 주세요.");
				}
			},
			error: function (e) {
				console.error(e);
			}
		});
	}
</script>
</html>
