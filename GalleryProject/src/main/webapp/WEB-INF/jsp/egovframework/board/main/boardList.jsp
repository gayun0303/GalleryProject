<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>게시판</title>
	<style>
		.board-grid {
		    display: grid;
		    grid-template-columns: repeat(5, 1fr);
		    gap: 20px;
		    padding: 20px 0;
		}
		
		.board-card {
		    border: 1px solid #ddd;
		    border-radius: 8px;
		    overflow: hidden;
		    background: #fff;
		    cursor: pointer;
		    transition: box-shadow 0.2s ease;
		    height: 230px;
		    display: flex;
		    flex-direction: column;
		}
		
		.board-card:hover {
		    box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
		}
		
		.thumbnail-wrapper {
		    width: 100%;
		    height: 120px;
		    overflow: hidden;
		    display: flex;
		    align-items: center;
		    justify-content: center;
		    background: #f5f5f5;
		}
		
		.thumbnail {
		    max-width: 100%;
		    max-height: 100%;
		    object-fit: cover;
		}
		
		.card-text {
		    padding: 10px;
		    flex-grow: 1;
		    display: flex;
		    flex-direction: column;
		    justify-content: space-between;
		}
		
		.title {
		    font-weight: bold;
		    font-size: 14px;
		    white-space: nowrap;
		    overflow: hidden;
		    text-overflow: ellipsis;
		    margin-bottom: 8px;
		}
		
		.meta {
		    font-size: 12px;
		    color: #666;
		    display: flex;
		    justify-content: space-between;
		}
        body {
            font-family: '맑은 고딕', sans-serif;
            margin: 20px;
            background-color: #f8f9fa;
        }
        #search {
        	    width: 340px;
   				margin: 0 auto;
        }
        #search ul {
            list-style: none;
            padding: 0;
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }
        #search select, #search input {
            padding: 5px;
        }
        #search a {
            display: inline-block;
            padding: 6px 12px;
            background-color: #007bff;
            color: white;
            text-decoration: none;
            border-radius: 4px;
        }
        #content_box {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            max-width: 1000px;
            margin: 0 auto;
        }
        #paging {
            margin-top: 20px;
            text-align: center;
        }
        .other-page-label {
        	display: inline-block;
        	color: black;
        	cursor: pointer;
        }
        .write-btn {
            display: inline-block;
            margin-top: 10px;
            padding: 8px 16px;
            color: black;
            text-decoration: none;
            border-radius: 6px;
            border: none;
            cursor: pointer;
        }
        #login-cntainer a {
        	display: inline-block;
            margin-top: 10px;
            padding: 8px 16px;
            text-decoration: none;
            border-radius: 6px;
            color: black;
            border: 1px solid #ddd;
        }
    </style>
	<script src="/lib/jquery-3.7.1.min.js"></script>
	<script type="text/javaScript" language="javascript" defer="defer">

	/* 글쓰기 */
	$(document).on("click", "#addBoardBtn", function(){
		event.preventDefault();
		$("#listForm").attr("action", "/addBoardView.do").submit();
	});
	
	/* 글 조회 */
	$(document).on("click", "#selectBoardView", function(){
		event.preventDefault();
		$("#boardId").val($(this).data("board-id"));
		$("#listForm").attr("action", "/boardDetailView.do").submit();
	});
	
	/* 검색 */
	$(document).on("click", "#searchBtn", function() {
		event.preventDefault();
		$("#pageIndex").val(1);
		$("#listForm").attr("action", "/boardList.do").submit();
	});
	
	 function fn_board_link_page(pageNo){
		 $("#pageIndex").val(pageNo);
		 $("#listForm").attr("action", "/boardList.do").submit();
     }
     
	</script>
</head>
<body>
	<div id="login-cntainer">
	    <c:choose>
		    <c:when test="${not empty sessionScope.login}">
		        <p><strong>${sessionScope.login.name}</strong> 님, 환영합니다!</p>
		        <a href="/user/logout.do">로그아웃</a>
		    </c:when>
		    <c:otherwise>
		        <a href="/user/loginView.do">로그인</a>
		        <a href="/user/addUserView.do">회원가입</a>
		    </c:otherwise>
		</c:choose>
	</div>
	<form:form modelAttribute="searchVO" id="listForm" name="listForm">
        <input type="hidden" name="boardId" id="boardId"/>
        <div id="search">
            <ul>
                <li>
                    <form:select path="searchType">
                        <form:option value="false" label="제목" />
                        <form:option value="true" label="작성자" />
                    </form:select>
                </li>
                <li>
                    <form:input path="searchKeyword"/>
                </li>
                <li>
                    <button id="searchBtn" class="search-btn">검색</button>
                </li>
            </ul>
        </div>

        <div id="content_box">
        	<div>전체 <c:out value="${paginationInfo.totalRecordCount}"/>건</div>
        	<div class="board-grid">
			    <c:forEach var="boardVO" items="${boardList}">
			        <div class="board-card" id="selectBoardView" data-board-id="${boardVO.boardId}">
			        
			            <div class="thumbnail-wrapper">
			                <c:if test="${not empty boardVO.fileVO}">
			                    <img src="/upload/${boardVO.fileVO.filePath}/${boardVO.fileVO.saveName}" alt="썸네일" class="thumbnail"/>
			                </c:if>
			            </div>
			            <div class="card-text">
			                <div class="title"><c:out value="${boardVO.title}" /></div>
			                <div class="meta">작성자: <c:out value="${boardVO.name}" /></div>
			                <div class="meta">
			                    <span><fmt:formatDate value="${boardVO.createDate}" pattern="yyyy-MM-dd" /></span>
			                    <span>조회수: <c:out value="${boardVO.clickCount}" /></span>
			                </div>
			            </div>
			        </div>
			    </c:forEach>
			</div>

            <!-- 페이지 -->
            <div id="paging">
                <ui:pagination paginationInfo="${paginationInfo}" type="custom" jsFunction="fn_board_link_page" />
                <form:hidden path="pageIndex" id="pageIndex" />
            </div>

            <!-- 글쓰기 버튼 -->
            <button id="addBoardBtn" class="write-btn">글쓰기</button>
        </div>
    </form:form>

</body>
</html>