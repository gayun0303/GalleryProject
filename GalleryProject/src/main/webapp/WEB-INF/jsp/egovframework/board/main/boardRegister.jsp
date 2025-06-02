<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"      uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="spring"    uri="http://www.springframework.org/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<c:set var="registerFlag" value="${empty boardVO.boardId ? 'create' : 'modify'}"/>
<c:if test="${registerFlag != 'modify' }">
<title>글 작성</title>
</c:if>
<c:if test="${registerFlag == 'modify' }">
<title>글 수정</title>
</c:if>
	<style>
    body {
        font-family: '맑은 고딕', sans-serif;
        margin: 20px;
        background-color: #f8f9fa;
    }
    .form-container {
        background: white;
        max-width: 700px;
        margin: auto;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 0 8px rgba(0,0,0,0.1);
    }
    .form-container table {
        width: 100%;
        border-collapse: collapse;
        table-layout: fixed;
    }
    .form-container td {
        padding: 10px;
        vertical-align: top;
    }
    .form-container label {
        font-weight: bold;
        width: 80px;
    }
    .form-container input[type="text"],
    .form-container div[contenteditable="true"] {
        width: 100%;
        padding: 6px;
        border: 1px solid #ced4da;
        border-radius: 6px;
        font-size: 14px;
    }
    .form-container div[contenteditable="true"] {
        min-height: 150px;
        resize: vertical;
    }
    .form-container input[type="file"] {
        margin-top: 5px;
    }
    .form-container .submit-btn {
        display: inline-block;
        margin-top: 20px;
        padding: 10px 20px;
        background-color: #007bff;
        color: white;
        border-radius: 6px;
        text-decoration: none;
        text-align: center;
    }
    
    .form-container .cancel-btn {
        display: inline-block;
        margin-top: 20px;
        padding: 10px 20px;
        background-color: #d3d3d3;
        color: black;
        border-radius: 6px;
        text-decoration: none;
        text-align: center;
    }
    img {
    	max-width: 100px;
    }
    .preview-img {
	    width: 100px;
	    margin: 5px;
	    border: 2px solid transparent;
	    cursor: pointer;
	    transition: 0.2s;
	  }
	
	  .preview-img.selected {
	    border: 2px solid dodgerblue;
	    box-shadow: 0 0 5px dodgerblue;
	  }
	  .exist-preview-img {
	    width: 100px;
	    margin: 5px;
	    border: 2px solid transparent;
	    cursor: pointer;
	    transition: 0.2s;
	  }
	
	  .exist-preview-img.selected {
	    border: 2px solid dodgerblue;
	    box-shadow: 0 0 5px dodgerblue;
	  }
	  
	  .image-preview-container {
	    display: flex;
	    flex-direction: row;
	    overflow-x: auto;
	    gap: 10px;
	    max-width: 590px;
	}
	
	.image-preview-container .list-group-item {
	    flex: 0 0 auto;
	}
	
	.list-group {
		padding: 0px;
	}
	
	#selectedImgTag {
		margin: 5px;
	}
</style>
	<script src="/lib/jquery-3.7.1.min.js"></script>
	<script type="text/javaScript" language="javascript" defer="defer">
	
	/* 게시글 등록, 수정 */	
	$(document).on("click", "#submitBtn", function() {
		event.preventDefault();
		var title = $('#title').val().trim();
		var content = $("#contentEditor").html().trim();
		
		if(title == "") {
			alert("제목은 필수 입력 항목입니다!");
			event.preventDefault();
			return;
		} else if(content == "") {
			alert("글 내용은 필수 입력 항목입니다!");
			event.preventDefault();
			return;
		} else if($(".preview-img").length == 0) {
			alert("사진을 첨부해주세요!");
			event.preventDefault();
			return;
		} else if($(".selected").length == 0) {
			alert("사진을 눌러서 썸네일을 선택해주세요!");
			event.preventDefault();
			return;
		}
		
		// 저장할 파일 하나씩 DataTransfer에 추가
		var dt = new DataTransfer();
		for(var i = 0; i < fileArray.length; i++) {
			dt.items.add(fileArray[i]);
		}
		
		$("#file")[0].files = dt.files;
		
		$("#contentEditor img").removeAttr("src");
		
		
		$("#content").val($("#contentEditor").html());
		
		
		var action = "<c:url value="${registerFlag == 'create' ? '/addBoard.do' : '/updateBoard.do'}"/>";
		$("#detailForm").attr("action", action).submit();
	});

	$(document).on("click", "#cancelBtn", function() {
		$("#file").remove();
		$("#detailForm").attr("action", "/boardList.do").submit();
	});
	
	/* 첨부 파일 */
	var fileArray = [];
	
	/* 파일 업로드 */
	$(document).on("change", "#file", function(e){
		var allowedTypes = ['image/jpeg', 'image/png', 'image/gif', 'image/webp', 'image/bmp'];
		
		/* 선택한 파일들 배열에 추가 */
		var files = this.files;
		for(var i=0; i<files.length; i++) {
			if (allowedTypes.includes(files[i].type)) {
	            fileArray.push(files[i]);
	        } else {
	            alert(files[i].name + " 은(는) 이미지 파일이 아닙니다.");
	        }
		}
		
		renderFileList();
	
		// 중복 선택 가능하게 초기화
		var oldInput = $("#file");
	    var newInput = oldInput.clone();
	    oldInput.replaceWith(newInput);
	});
		
	/* 파일 리스트 화면 띄우기 */
	function renderFileList() {
		
		var list = $("#newFileList").empty();
		for(var index=0; index < fileArray.length; index++) {
			(function(index) {
				
				var file = fileArray[index];
				var fileReader = new FileReader();
				
				fileReader.onload = function(e) {
					var base64data = e.target.result;
					var img = $("<img>")
					.attr("src", base64data)
					.addClass("preview-img")
					.data("file-index", index);
					
					// 새 파일 등록될 때 mainfileindex랑 같은 index 에는 selected 효과
					if($("#mainFileIndex").val() != "" && index == $("#mainFileIndex").val()) {
						img.addClass("selected");
					}
					
					var btn = $("<button>")
					.text("X")
					.data("index", index)
					.on("click", function(event) {
						event.preventDefault();
						if(!confirm("삭제 하시겠습니까?"))	return;
						
						var i = $(this).data("index");
						fileArray.splice(i, 1);
						if($("#mainFileIndex").val() == i) {
							$("#selectedImgTag").remove();
							$("#mainFileIndex").val(null);
						}
						renderFileList();
					});
					list.append(img);
					list.append(btn);
				};
				
				fileReader.readAsDataURL(file);
			})(index);
		}
	}
	
	/* 사진 클릭하면 썸네일로 지정 */
	$(document).on("click", ".preview-img", function(e) {
		
		$(".preview-img").removeClass("selected");
		$(this).addClass("selected");
		
		$("#selectedImgTag").remove();
		
		/* 클릭한 사진 복사해서 내용에 넣기 */
		var file = $(this).clone()
			.attr("id", "selectedImgTag")
			.removeClass();

		
		$("#contentEditor").focus();
		var sel = window.getSelection();
		
		var range = sel.getRangeAt(0);
		
		range.insertNode(file[0]);
		
		range.setStartAfter(file[0]);
		
		
		var selectedFileId = $(this).data("file-id");
		var selectedFileIndex = $(this).data("file-index");
		$("#mainFileIndex").val(selectedFileIndex);
		$("#mainFileId").val(selectedFileId);
	});
	
	/* editor div에서 이미지 삭제하면 썸네일 선택도 지우기 */
	$(document).on("keyup", "#contentEditor", function() {
		if(!$("#selectedImgTag").length) {
			$("#mainFileIndex").val(null);
			$("#mainFileId").val(null);
			
			$(".preview-img").removeClass("selected");
		}
	});

	/* 기존 파일에서 삭제한 파일 id 리스트 */
	var deletedFileIds = [];

	$(document).on("click", ".deleteExistingFile", function () {
		if(!confirm("삭제 하시겠습니까?")) return;

	    var fileId = $(this).data("file-id");
	    if (fileId) {
	    	deletedFileIds.push(fileId);
	    }
	    if($("#mainFileId").val() == fileId) {
			$("#mainFileId").val(null);
			$("#selectedImgTag").remove();
		}
	    
	    $(this).parent().remove();
	    
	    $("#deleteFileIds").val(deletedFileIds.join(","));
	});
	
	$(document).on("click", "#uploadFileBtn", function() {
		event.preventDefault();
		$("#file").click();
	});
	
	</script>
</head>
<body>
	<div class="form-container">
    <form:form modelAttribute="boardVO" id="detailForm" name="detailForm" enctype="multipart/form-data" method="post">
        <form:hidden path="boardId" />
        <form:hidden path="userId" />
        <form:hidden path="mainFileId" id="mainFileId"/>
        <form:hidden path="mainFileIndex" id="mainFileIndex"/>
        <table>
	        <colgroup>
				<col style="width: 100px;">
				<col style="width: auto;">
			</colgroup>
            <tr>
                <td><label for="name">작성자</label></td>
                <td><c:out value="${boardVO.name}"/></td>
            </tr>
            <tr>
                <td><label for="title">제목</label></td>
                <td><form:input path="title" maxlength="100"/></td>
            </tr>
            <tr>
                <td><label for="content">내용</label></td>
                <td>
                    <c:if test="${registerFlag == 'modify' }">
	                    <div id="contentEditor" contenteditable="true">
	                    	<c:out value="${boardVO.content}" escapeXml="false" />
	                    </div>
                        <form:hidden path="content" />
                    </c:if>
                    <c:if test="${registerFlag != 'modify' }">
                        <div id="contentEditor" contenteditable="true">
                        </div>
                        <form:hidden path="content"/>
                    </c:if>
                </td>
            </tr>
            <tr>
		    	<td><label for="file">첨부파일</label></td>
		    	<td>
	            	<c:if test="${registerFlag == 'modify' }">
		            	<div class="image-preview-container">
				            <input type="hidden" id="deleteFileIds" name="deleteFileIds" value=''/>
				    		<c:forEach var="file" items="${boardVO.fileVOList}">
				    			<div class="list-group-item">
					    			<c:if test="${boardVO.mainFileId == file.fileId }" >
	                    				<c:set var="mainImgUrl" value="/upload/${file.filePath}/${file.saveName}"/>
										<img src="/upload/${file.filePath}/${file.saveName}" data-file-id="${file.fileId}" class="preview-img selected"/>
									</c:if>
									<c:if test="${boardVO.mainFileId != file.fileId }" >
										<img src="/upload/${file.filePath}/${file.saveName}" data-file-id="${file.fileId}" class="preview-img"/>
									</c:if>
						            <button type="button" class="deleteExistingFile" data-file-id="${file.fileId}">X</button>
						        </div>
				    		</c:forEach>
				    	</div>
					</c:if>
					<button type="button" id="uploadFileBtn" >파일선택</button>
					<div class="image-preview-container">
						<input type="file" id="file" class="upload-images_" multiple="multiple" name="file" accept="image/*" style="display:none;">
						<div>
						  <div style="height: auto">
						    <ul id="newFileList" class="list-group">
						    </ul>
						  </div>
						</div>
					</div>
				</td>
            </tr>
        </table>

        <div>
            <button class="submit-btn" id="submitBtn">
                <c:choose>
                    <c:when test="${registerFlag == 'create'}">등록</c:when>
                    <c:otherwise>수정</c:otherwise>
                </c:choose>
            </button>
            <button class="cancel-btn" id="cancelBtn">
            	취소
            </button>
        </div>
        	    <!-- 검색조건 유지 -->
	    <input type="hidden" name="searchType" value="<c:out value='${searchVO.searchType}'/>"/>
	    <input type="hidden" name="searchKeyword" value="<c:out value='${searchVO.searchKeyword}'/>"/>
	    <input type="hidden" name="pageIndex" value="<c:out value='${searchVO.pageIndex}'/>"/>
        
    </form:form>
	<script>
		$(document).ready(function() {
			var imgUrl = "${mainImgUrl}";			
			$("#selectedImgTag").attr("src", imgUrl);
		});
	</script>

</div>
</body>
</html>