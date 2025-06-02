<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시글</title>
	<style>
		body {
           font-family: '맑은 고딕', sans-serif;
           margin: 20px;
           background-color: #f8f9fa;
        }
	    .board-container {
	    	background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            max-width: 1000px;
            margin: 0 auto;
	    
	        width: 100%;
	    }
	
	    .board-title {
	        font-size: 20px;
	        font-weight: bold;
	        margin-bottom: 10px;
	        padding-left: 10px;
	    }
	
	    .board-meta {
	        font-size: 14px;
	        color: #555;
	        margin-bottom: 15px;
	        padding-left: 10px;
	    }
	
	    .board-content {
	        min-height: 100px;
	        margin-bottom: 15px;
	        padding: 10px;
	        border: 1px solid #eee;
	        background: #fafafa;
	    }
	    
	    .file-list {
		    display: flex;
		    flex-wrap: wrap;
		    align-items: center;
		    gap: 10px;
		    margin-top: 10px;
		}
		
		.file-list > div {
		    display: flex;
		    flex-direction: column;
		    align-items: center;
		}
	
	    .btn-area {
	    	display: flex;
	        margin-top: 50px;
	    }
	
	    .btn-area button {
	        margin-right: 10px;
	        padding: 6px 12px;
	        cursor: pointer;
	    }
	    
	    img {
	    	max-width: 100px;
	    }
	</style>
	<script src="/lib/jquery-3.7.1.min.js"></script>
	<script type="text/javaScript" language="javascript" defer="defer">
	/* 글 수정 */
	$(document).on("click", "#modifyBtn", function() {
		$("#detailViewForm").attr("action", "/updateBoardView.do").submit();
	});
	
	
	$(document).on("click", "#deleteBtn", function() {
		$("#detailViewForm").attr("action", "/deleteBoard.do").submit();
	});
	
	/* 목록으로 이동 */
	$(document).on("click", "#cancelBtn", function() {
		$("#detailViewForm").attr("action", "/boardList.do").submit();
	});
	
	</script>
</head>
<body>
	<form:form modelAttribute="boardVO" id="detailViewForm" name="detailViewForm" method="post">
    <form:hidden path="boardId"/>
    <form:hidden path="userId"/>
    	<div style="display: flex;">
	        <div class="board-container">
	            <!-- 제목 -->
	            <div class="board-title">
	                <c:out value="${boardVO.title}" />
	            </div>
	
	            <!-- 작성자, 등록일, 조회수 -->
	            <div class="board-meta">
	                작성자: <c:out value="${boardVO.name}" /> |
	                등록일: <fmt:formatDate value="${boardVO.createDate}" pattern="yyyy-MM-dd" /> |
	                조회수: <c:out value="${boardVO.clickCount}" />
	            </div>
	
	            <!-- 내용 -->
	            <div id="boardContent" class="board-content">
	                <c:out value="${boardVO.content}" escapeXml="false"/>
	                
	            </div>
	
	            <!-- 첨부파일 -->
	            <div class="file-list">
	                <b>첨부파일:</b>
	                <c:if test="${not empty boardVO.fileVOList}">
	                    <c:forEach var="oneFile" items="${boardVO.fileVOList}">
	                    	<div>
	                    		<c:if test="${oneFile.fileId == boardVO.mainFileId}">
	                    			<c:set var="mainImgUrl" value="/upload/${oneFile.filePath}/${oneFile.saveName}"/>
	                    		</c:if>
		                        <a href="<c:url value='/file/download.do?filePath=${oneFile.filePath}&saveName=${oneFile.saveName}&originalName=${oneFile.originalName}'/>">
	                    		<img src="/upload/${oneFile.filePath}/${oneFile.saveName}" alt="사진"/>
		                        </a>
	                        </div>
	                    </c:forEach>
	                </c:if>
	                <c:if test="${empty boardVO.fileVOList}">
	                    없음
	                </c:if>
	            </div>	
    			<div class="btn-area">
	                <button type="button" id="modifyBtn">수정</button>
	                <button type="button" id="deleteBtn">삭제</button>
			        <button type="button" id="cancelBtn">목록</button>
			    </div>
	        </div>
        </div>

		<!-- 검색조건 유지 -->
	    <input type="hidden" name="searchType" value="<c:out value='${searchVO.searchType}'/>"/>
	    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
	    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
	    
    </form:form>
	<script>
		$(document).ready(function() {
			var imgUrl = "${mainImgUrl}";
			console.log("imgUrl", imgUrl);
			
			$("#selectedImgTag").attr("src", imgUrl);
		});
	</script>
</body>
</html>