<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>

<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<html>
<head>
	<title>Login</title>
</head>
<body>
	<div>
		<div>
			<span>ID : </span><input type="text" id="userId"/>
		</div>
		<div>
			<span>PW : </span><input type="password" id="userPw"/>
		</div>
		<div>
			<button id="login">로그인</button>
		</div>
	</div>
</body>

<script>
	$("#userId").val("admin");
	$("#userPw").val("0000");
	$("#login").on("click",function(){
		var userId = $("#userId").val().trim();
		var userPw = $("#userPw").val().trim();

		var param = {};
		param.userId = userId;
		param.userPw = userPw;

		$.ajax({
			type:"POST",
			url:"/login",
			data : param,
			success: function(result){
				console.log(result);
				if(result.result.length > 0){
					if("A" == result.result[0].USER_STATUS){
						location.href = "/adminPage";
					}else{
						location.href = "/ftpPage";
					}
				}else{
					alert("ID 또는 PW가 틀렸습니다.");
					$("#userId").val("");
					$("#userPw").val("");
					return false;
				}
			},
			error: function(e) {
				console.error(e);
			}
		});
	});
</script>
</html>
