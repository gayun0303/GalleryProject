<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/lib/jquery-3.7.1.min.js"></script>
</head>
<body>
	<c:if test="${not empty alertMsg}">
	    <script>
	        alert("${alertMsg}");
	    </script>
    </c:if>
    <form:form modelAttribute="boardVO" id="postForm" method="post" action="${pageContext.request.contextPath}/boardDetailView.do">
        <input type="hidden" name="boardId" value="<c:out value='${boardVO.boardId}'/>" /><%-- 
        <input type="hidden" name="title" value="<c:out value='${boardVO.title}'/>" />
        <input type="hidden" name="content" value="<c:out value='${boardVO.content}'/>" /> --%>
        <input type="hidden" name="searchType" value="<c:out value='${searchVO.searchType}'/>"/>
	    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
	    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
        <!-- 필요한 값들 다 넣어주기 -->
    </form:form>
    <script>
        $("#postForm").submit();
    </script>

</body>
</html>