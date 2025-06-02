<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원가입</title>
	<style>
		body {
            font-family: '맑은 고딕', sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        
        .form-container {
	        background: white;
	        max-width: 400px;
	        margin: auto;
	        padding: 30px;
	        border-radius: 12px;
	        box-shadow: 0 0 8px rgba(0,0,0,0.1);
	    }
	    
	    .form-container table {
	        width: 100%;
	        border-collapse: collapse;
	    }
	    .form-container td {
	        padding: 10px;
	        vertical-align: top;
	    }
	    .form-container label {
	        font-weight: bold;
	        display: inline-block;
	        width: 80px;
	    }
	    
	    .form-container button {
	        display: inline-block;
	        margin-top: 20px;
	        padding: 10px 20px;
	        background-color: #d3d3d3;
	        color: black;
	        border-radius: 6px;
	        text-decoration: none;
	        text-align: center;
	        border: none;
	        cursor: pointer;
	    }
	    .form-container input, password {
	        width: 100%;
	        padding: 6px;
	        border: 1px solid #ced4da;
	        border-radius: 6px;
	        font-size: 14px;
	    }
	</style>
<script src="/lib/jquery-3.7.1.min.js"></script>
<script type="text/javaScript" language="javascript" defer="defer">

	/* 회원가입 */
	$(document).on("click", "#registerBtn", function() {
		var id = $("#id").val().trim();
		var password = $("#password").val().trim();
		var passwordConfirm = $("#passwordConfirm").val().trim();
		var name = $("#name").val().trim();
		
		/* 아이디는 영문 또는 숫자로 5~15자
		비번은 영문, 숫자, 특수문자 다 1개 이상 10~25자 */
		var isId = /^[0-9a-zA-Z]{5,15}$/;
		var isPassword = /^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[$`~!@$!%*#^?&\\(\\)\-_=+]).{10,25}$/;
		
		if(id =="") {
			alert("아이디는 필수 입력 항목입니다!");
			return;
		} else if (password == "") {
			alert("비밀번호는 필수 입력 항목입니다!");
			return;
		} else if (name == "") {
			alert("이름은 필수 입력 항목입니다!");
			return;
		} else if (!isId.test(id)) {
			alert("아이디는 5~15자리의 영문자 또는 숫자 조합으로 작성해주세요!");
			return;
		}  else if (!isPassword.test(password)) {
			alert("비밀번호는 10~25자리의 영문자, 숫자, 특수문자 조합으로 작성해주세요!");
			return;
		}
		
		if(password != passwordConfirm) {
			alert("비밀번호 확인이 일치하지 않습니다!");
			return;
		}
		
		$("#registerForm").attr("action", "/user/addUser.do").submit();
		
	});
	
	/* 취소 */
	$(document).on("click", "#cancelBtn", function() {
		$("#registerForm").attr("action", "/boardList.do").submit();
	});
	
</script>
</head>
<body>
	<!-- 아이디 중복 -->
	<c:if test="${not empty alertMsg}">
	    <script>
	        alert("${alertMsg}");
	    </script>
    </c:if>
	<div class="form-container">
    <form:form modelAttribute="userVO" id="registerForm" name="registerForm" method="post">
		<table>
			<tr>
				<td><label for="id">아이디</label></td>
				<td><form:input path="id" maxlength="100" /></td>
			</tr>
			<tr>
				<td><label for="password">비밀번호</label></td>
				<td><form:password path="password" maxlength="100" /></td>
			</tr>
			<tr>
				<td><label for="passwordConfirm">비밀번호 확인</label></td>
				<td><input type="password" id="passwordConfirm" maxlength="100" /></td>
			</tr>
			<tr>
				<td><label for="name">이름</label></td>
				<td><form:input path="name" maxlength="100" /></td>
			</tr>
		</table>
    </form:form>
    <button id="registerBtn">회원가입</button>
    <button id="cancelBtn">취소</button>
	</div>
</body>
</html>