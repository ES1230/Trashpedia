<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="<%=request.getContextPath()%>" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>실천게시글</title>
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="${contextPath}/resources/css/pledge/pledgeDetailView.css">
	<!-- toast ui editor css -->
	<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
	<link rel="stylesheet" href="https://uicdn.toast.com/editor/3.0.2/toastui-editor.min.css" >
</head>
<body>

	<jsp:include page="../common/header.jsp" />

	<main>
		<div class="container">
			<!-- 제목 -->
			<div class="content-title-outer">
				<p>${post.title}</p>
				<span>작성자</span> 
				<span class="title-count"> ${post.userName} &nbsp; &nbsp;| </span> 
				<span>수정일</span>
				<span class="title-count"> ${post.modifyDate} &nbsp; &nbsp;| </span> 
				<span>조회수</span> <span class="title-count">${post.hitsNo}</span>
			</div>

			<!-- 이미지/첨부파일  -->
			<div class="content-attach-outer">
				<div class="content-attach-inner">
					<p><strong> &nbsp; &nbsp;첨부파일&nbsp;</strong></p>
					<c:if test="${attachment eq null}">
						<span>첨부파일 없음</span>
					</c:if>
					<c:if test="${not empty attachment}">
						<span>
						 	<a href="<c:url value='/resources/attachFile/file/${attachment.changeName}'/>"
							download="${attachment.originName}">${attachment.originName}</a>
						</span>
					</c:if>
				</div>
			</div>

			<!-- 내용  -->
			<div class="content-outer">
				<div class="toast-custom-viewer"></div>
				<div class="post-buttons">
					<a href="${contextPath}/pledge/list?bigCategoryNo=${post.bigCategoryNo}&subCategoryNo=${post.subCategoryNo}">
						<button class="btn-list">목록</button>
					</a>
					<!-- 게시글 작성자만 수정/삭제 가능  -->
					<c:if test="${post.userName == authentication.userName}">
						<a href="${contextPath}/update?bigCategoryNo=${post.bigCategoryNo}&subCategoryNo=${post.subCategoryNo}&postNo=${post.postNo}&type=1">
							<button class="btn-edit">수정</button></a>
						<button onclick="confirmDelete(${post.postNo}, ${post.boardNo}, ${post.bigCategoryNo}, ${post.subCategoryNo})">삭제</button>
					</c:if>
					<button class="btn-report" onclick="openReportModal()">신고</button>
				</div>
			</div>
			
			<!-- 신고 모달창 -->
			<div id="reportModal" class="modal">
			    <div class="modal-content">
			        <span class="close" onclick="closeReportModal()">&times;</span>
			        <h2>신고 내용</h2>
			        <textarea id="reportContent" placeholder="신고 내용을 입력하세요"></textarea>
					<div id="reportButtonContainer">
						<div id="reportButton" onclick="confirmSubmitReport()">제출</div>
			        </div>
			    </div>
			</div>

			<!-- 댓글  -->
			<div class="reply-outer">
				<div class="reply-outer-top-area">
					<span class="reply_title"> 댓글 </span> | <span class="reply_count"
						id="rcount">0</span>
				</div>

				<!-- 댓글 작성 -->
				<div class="comment-section">
					<textarea class="comment-input" name="replyContent" id="replyContent" rows="2" cols="50"
						style="resize: none; width: 100%;" placeholder="댓글을 입력하세요"></textarea>
					<button class="comment-button" onclick="insertComment()">등록</button>
				</div>

				<div class="reply-outer-content-area">
					<table class="reply-table" id="replyArea">
						<thead>
							<tr class="reply-table-title">
								<th>작성자</th>
								<th>내용</th>
								<th>작성일</th>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="3">댓글이 없습니다.</td>
							</tr>
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</main>

	<jsp:include page="../common/footer.jsp" />

	<script>

		const loginUser = `${authentication}`;
		const loginUserNo = `${authentication.userNo}`;
		const writeUser = `${post.userName}`;
	
		// toast viewer
		const editor = toastui.Editor.factory({
            el : document.querySelector(".toast-custom-viewer"),
            viewer:true,
            initialValue :  `${post.content}`
        });
	
	    // 게시글삭제확인
	    function confirmDelete(postNo, boardNo, bigCategoryNo, subCategoryNo) {
	        var result = confirm("게시글을 삭제하시겠습니까?");
	        if (result) {
	            var deleteUrl = "${contextPath}/pledge/delete/" + postNo + "?boardNo=" + boardNo;
	            window.location.href = deleteUrl;
	        } 
	    }
	
	    //댓글목록조회
 	    function selectCommentList(){
	    	$.ajax({
    		 	url: "${contextPath}/pledge/selectCommentList",
    		    data: { boardNo: ${post.boardNo}, userNo: ${post.userNo}},
    		    success: function (result) {
    		        let comments = "";
    		        for (let comment of result) {
    		            comments += "<tr>";
    		            comments += "<td>" + comment.userName + "</td>";
    		            comments += "<td><p>" + comment.content + "</p>";
    		            if('${authentication.userName}' == comment.userName){
	    		            comments += "<div class='comment-buttons'>" +
	    		                        "<button onclick='showCommentUpdateForm("+comment.commentNo+",this)' class='btn-edit'> 수정 </button>" +
	    		                        "<button onclick='deleteComment(" + comment.commentNo + ")' class='btn-delete'> 삭제 </button>" +
	    		                        "</div></td>";
    		            }
    		            comments += "<td>" + comment.createDate + "</td>";
    		            comments += "</tr>";
    		        }
    		        $("#replyArea tbody").html(comments);
    		        $("#rcount").html(result.length);
    		    },
    		    error: function (xhr, status, error) {
    		        console.log(" 댓글조회에러:", status, error);
    		    }
	    	})
	    }
 	   selectCommentList();
 	   
 	   //댓글등록
 	   function insertComment(){
 		   
 		   if(loginUser){
	 		   $.ajax({
	 			  url: "${contextPath}/pledge/insertComment",
	 			  data : {
	 				 boardNo: ${post.boardNo}, 
	 				 userNo: loginUserNo,
	 				 content : $("#replyContent").val()
	 			  },
	 			  type : 'post',
	 			  success : function(result){
	 				  if(result>0){
	 					  alert("댓글이 등록되었습니다.");
	 				  }else{
	 					  alert("댓글등록이 실패하였습니다.");
	 				  }
	 				  $("#replyContent").val("");
	 				 selectCommentList();
	 			  },
	 			  error: function (xhr, status, error) {
					console.log(" 댓글등록에러:", status, error);
					}
	 		   })
 		   }else{
 			    alert("댓글을 등록하려면 로그인이 필요합니다.");
 		   }
 		  
 	   }
 	   
 	   //댓글수정 form 생성
 	   function showCommentUpdateForm(commentNo, btn){
 		   
 		   // 댓글 수정할 수 있는 textarea 생성
 		   const textarea = document.createElement("textarea"); 
 		   textarea.style.width = "100%"; // 너비 100%로 설정
 		   textarea.style.height = "50px"; // 높이 50px로 설정
 		   textarea.style.resize = "none"; // 리사이즈 비활성화
 		   
 		   const button = document.createElement("button");
 		   button.innerText = "수정하기";
 		   button.style.marginTop = "5px"; 
 		   button.style.backgroundColor = "#5acb5a"; 
 		   button.style.color = "white";
 		   button.style.border = '0';
           button.style.padding = '3px 15px';
 		   
 		   //댓글내용 textarea에 복사
 		   let td = btn.parentElement.parentElement;
 		   let pTag = td.querySelector('p');
 		   let content = pTag.innerText;
 		   textarea.innerHTML = content; 
 		   
 		   //td 비우고 새로 추가
 		   td.innerHTML = "";
 		   td.append(textarea);
 		   td.append(button);
 		   
 		   button.addEventListener("click",function(){
 			   updateComment(commentNo,textarea);
 			})
 	   }
 	   
 	   //댓글수정
 	   function updateComment(commentNo, textarea){
 		   let comment = { commentNo, content : textarea.value };
 		   
 		   $.ajax({
				url: "${contextPath}/pledge/updateComment/" + commentNo,
				data : JSON.stringify(comment),
				contentType : 'application/json;charset=utf-8',
 			  	type : 'put',
 			  	success : function(result){
 			  		if(result>0){
						alert("댓글이 수정되었습니다.");
					}else{
						alert("댓글수정 실패했습니다.");
					}
					selectCommentList(); 
 			  	},
 			  	error: function (xhr, status, error) {
 		            console.error("댓글수정 오류 발생: ", status, error);
 		        }
 		   })
 	   }
 	   
 	   //댓글삭제
 	   function deleteComment(commentNo){
 		   if(confirm('댓글을 삭제하시겠습니까?')){
 			   $.ajax({
 				  url: "${contextPath}/pledge/deleteComment/" + commentNo,
 				  type : 'delete',
 				  success : function(result){
 					  if(result>0){
						alert("댓글이 삭제되었습니다.");
						selectCommentList();
					}else{
						alert("댓글삭제실패");
						}
					}
 			   })
 		   }
 	   }
 	   
 	  // ------- 신고 모달 -------
  	  
		// 모달 열기
		function openReportModal() {
			if(loginUser){
		    	document.getElementById("reportModal").style.display = "block";
			}else{
				 alert("로그인이 필요합니다.");
			}
		}
		
		// 모달 닫기
		function closeReportModal() {
		    document.getElementById("reportModal").style.display = "none";
		}
		
	    // 신고 제출 재확인
	    function confirmSubmitReport() {
	        var reportContent = document.getElementById("reportContent").value;
	        if (reportContent.trim() !== "") {
	            var result = confirm("이 게시글을 신고하시겠습니까?\n확인을 누르면 신고가 제출됩니다.");
	            if (result) {
	                submitReport(); // 제출 함수 호출
	            }
	        } else {
	            alert("신고 내용을 입력하세요.");
	        }
	    }

	    // 신고 제출
	    function submitReport() {
	        var reportContent = document.getElementById("reportContent").value;
	        var postNo = `${post.postNo}`;
	        
	        $.ajax({
	            url:  "${contextPath}/report/insertBoardReport",
	            method: "POST",
	            data: { 
	            	reportContent: reportContent,
	            	userNo : loginUserNo,
	            	reportTargetNo : postNo
	            },
	            success: function(result) {
	            	if(result == 2){
	            		alert("기존에 제출하신 이력이 있습니다.\n마이페이지에서 진행상황 확인 부탁드립니다.");
	            	}else if(result==1){
		                alert("신고가 제출되었습니다: " + reportContent);
		                closeReportModal();
	            	}else{
	            		alert("신고 제출에 실패했습니다.");	
	            	}
	            },
	            error: function(xhr, status, error) {
	                console.error("서버 오류:", status, error);
	                alert("신고 제출에 실패했습니다.");
	            }
	        });
	    }
 	   
    
    </script>
</body>
</html>