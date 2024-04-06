<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<c:url var="currentUrl" value="/trashpedia/pledge/list">
    <c:param name="subCategoryNo" value="${currentSubCategoryNo}" />
    <c:param name="bigCategoryNo" value="${currentBigCategoryNo}" />
</c:url>
<c:set var="subCategoryNo" value="${param.subCategoryNo}" />
<c:set var="bigCategoryNo" value="${param.bigCategoryNo}" />
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>실천하기</title>
	<!-- jQuery -->
	<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="${contextPath}/resources/css/pledge/pledge.css">
</head>
<body>

    <jsp:include page="../common/header.jsp"/>
    
    <main>
    	
        <div class="practice-section">
            <p>실천하기</p>
            <p>Reduce Reuse Recycle Recovery</p>
        </div>
        <div class="participant-section"> 
            <div class="participant-section-outer">
                <p>오늘까지 <span class="participant-count" id="dynamicCount">${countSignature}</span>명 참여</p>
            </div>
        </div>
        <div class="content-section">
            <div class="content-section-outer">
                <div class="content-title"> 
                	<!-- 실천서약,인증 이동 탭  -->
                    <div class="content-tab">
                    	<a href="${contextPath}/pledge/list?bigCategoryNo=2&subCategoryNo=5">
                        	<span id="pledgeBtn" onclick="pledgeShow()"> 실천서약 </span>
                        </a>
                        <a href="${contextPath}/pledge/list?bigCategoryNo=2&subCategoryNo=6">
                        	<span id="certificationBtn" onclick="certificationShow()"> 실천인증 </span>
                        </a>
                    </div>
                    <!-- 검색 -->
                    <div class="content-search">
	                    <select name="condition" id="board-search-filter-select">
			                <option value="title" selected>제목</option>
			                <option value="content">내용</option>
			                <option value="postNo" >번호</option>
						</select>
                        <input type="search" class="board-search-input" name="keyword" id="keyword" placeholder="검색어를 입력하세요.">
                        <button type="button" class="board-search-button" onclick="boardSearch()">
                        	<span id="searchButton" class="material-symbols-outlined icon">search</span>
                        </button> 
                    </div>
                </div>
                <!-- 게시글 내용 -->
				<div class="pledge">
				    <div class="content-outer" id="boardContentOuter"> </div>
				    <div class="content-outer" id="noPostMessage"><h1>해당하는 게시글이 없습니다.</h1></div>
				</div>
				<!-- 페이징바  -->
				<div class="board-pageBar paging-button"></div>
			</div>
            <!-- 게시글등록 -->
			<c:if test="${not empty authentication}">
				<div class="insert-area">
					<a
						href="${pageContext.request.contextPath}/write?subCategoryNo=${subCategoryNo}&type=1">
						<button id="insertButton">게시글 등록하기</button>
					</a>
				</div>
			</c:if>
		</div>
    </main>
    
    <jsp:include page="../common/footer.jsp"/>
    
    <script>
    
    	//----- 숫자 카운팅
        // 시작 숫자
        var currentCount = 0;
        // 목표 숫자
        var targetCount = parseInt($("#dynamicCount").text().replace(/,/g, ''), 10);
        // 숫자 업데이트
        function updateCount() {
            document.getElementById('dynamicCount').textContent = currentCount.toLocaleString();
            // 목표 카운트에 도달하면 중지
            if (currentCount < targetCount) {
                let timeoutValue;
                if (currentCount <= targetCount - 200 ) {  timeoutValue = 60; } 
                else if (currentCount <= targetCount - 40) {  timeoutValue = 80; } 
                else if (currentCount <= targetCount - 12) { timeoutValue = 110; } 
                else if (currentCount <= targetCount - 5) { timeoutValue = 170; } 
                else{ timeoutValue = 450; }

                setTimeout(function() {
                    if (targetCount - currentCount <= 30) {  currentCount += 1; } 
                    else if (targetCount - currentCount <= 100) { currentCount += 10; } 
                    else {  currentCount += 100; }
                    updateCount();
                }, timeoutValue);
            }
        }
        updateCount();

        
        //----- 페이징,검색
        var boardFilterValue = 'boardNo';
	    var boardSearchSelect = null;
	    var boardSearchValue = null;
		
	    //실천서약,실천인증 탭 선택
		function pledgeShow() {
	        $("#pledgeBtn").css("background-color", "#5bbf5b");
	        localStorage.setItem('selectedTab', 'pledge');
	        getBoardList(0, boardSearchSelect, boardSearchValue);
	    }
	
	    function certificationShow() {
	        $("#certificationBtn").css("background-color", "#5bbf5b");
	        localStorage.setItem('selectedTab', 'certification');
	        getBoardList(0, boardSearchSelect, boardSearchValue);
	    }
	    
	    $(document).ready(function () {
	    	var subCategoryNoValue = `${param.subCategoryNo}`;
	    	var bigCategoryNoValue = `${param.bigCategoryNo}`;
	    	
	    	if(subCategoryNoValue =='5'){ 
	    		pledgeShow();
	    	}else{ 
	    		certificationShow(); 
	    	}
	    });
	    
        /* 검색 */
	    function boardSearch(){
	    	boardSearchSelect = $('#board-search-filter-select').val();
	    	boardSearchValue = $('.board-search-input').val();
	    	$('.board-search-input').val('');
	    	$('.board-list').empty();
	    	getBoardList(0, boardSearchSelect, boardSearchValue);
	    }
        
	 	// 게시글 리스트 조회
	    function getBoardList(page, boardSearchSelect, boardSearchValue) {
	        $.ajax({
	            url: '${contextPath}/pledge/loadListData',
	            type: 'GET',
	            dataType: 'json',
	            data: {
	                page: page, size: 8, sort: boardFilterValue,
	                searchSelect: boardSearchSelect,
	                searchValue: boardSearchValue,
	                subCategoryNo : ${subCategoryNo}
	            },
	            success: function(data) {
	                if(data.content.length != 0){
	                    updateBoardTable(data.content);
	                    updateBoardPagination(data);
	                    $('#noPostMessage').hide();
	                    $('#boardContentOuter').show();
	                } else {
	                    $('#noPostMessage').show();
	                    $('#boardContentOuter').hide();
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error('Error: ' + error);
	                $('#noPostMessage').show();
	                $('#boardContentOuter').hide();
	            }
	        });
	    }
	    
	    // 게시글 반복문 돌리기
	    function updateBoardTable(data) {
		    let userList = document.querySelector('.content-outer');
		    userList.innerHTML = '';
		
		    for (let i = 0; i < data.length; i++) {
		        let post = data[i];
		        let postNo = post.postNo;
		        
		        // 게시글 요소 생성
		        let postElement = document.createElement('div');
		        postElement.className = 'img-area';
		     	postElement.setAttribute('onclick', 'pledgeDetail(' + postNo + ')');
		        
		        // 숨겨진 input 요소 추가
		        let titleInput = document.createElement('input');
		        titleInput.type = 'hidden';
		        titleInput.value = post.title;
		
		        let subCategoryNoInput = document.createElement('input');
		        subCategoryNoInput.type = 'hidden';
		        subCategoryNoInput.name = 'subCategoryNo';
		        subCategoryNoInput.value = post.subCategoryNo;
		
		        // 이미지 요소 생성
		        let imgElement = document.createElement('img');
		        imgElement.src = '${contextPath}/resources/attachFile/image/' + post.changeName;
		        imgElement.className = 'content-img';
		
		     	// 이미지 위 icon 생성
		        let icoClone = document.createElement('span');
		        icoClone.className = 'ico-clone';
		        
		        // 생성한 요소들을 게시글 요소에 추가
		        postElement.appendChild(titleInput);
		        postElement.appendChild(subCategoryNoInput);
		        postElement.appendChild(imgElement);
		        postElement.appendChild(icoClone);
		
		        // 게시글 요소를 userList에 추가
		        userList.appendChild(postElement);
		    }
		}

	    /* 페이징바 추가 */
	    function updateBoardPagination(data) {
	        let userPaging = document.querySelector('.board-pageBar');
	        // userPaging이 null인지 확인
	        if (userPaging) {
	            let pagination = '';

	            if (!data.empty) {
	                if (!data.first) {
	                    pagination += '<button class="pagingBtn" onclick="getBoardList(' + (data.number - 1) + ',\'' + boardSearchSelect + '\',\'' + boardSearchValue + '\')"><</button>';
	                }
	                for (let i = 0; i < data.totalPages; i++) {
	                    if (i >= data.number - 5 && i <= data.number + 5) {
	                        pagination += '<button ';
	                        if (i === data.number) {
	                            pagination += 'class="pagingBtn active"';
	                        }
	                        pagination += 'class="pagingBtn" onclick="getBoardList(' + i + ',\'' + boardSearchSelect + '\',\'' + boardSearchValue + '\')">' + (i + 1) + '</button>';
	                    }
	                }
	                if (!data.last) {
	                    pagination += '<button class="pagingBtn" onclick="getBoardList(' + (data.number + 1) + ',\'' + boardSearchSelect + '\',\'' + boardSearchValue + '\')">></button>';
	                }
	            }
	            userPaging.innerHTML = pagination;
	        } else {
	            console.error('Error: .board-pageBar element not found.');
	        }
	    }
        
	    // 상세페이지 이동
	    function pledgeDetail(postNo) {
	    	location.href = "${contextPath}/pledge/detail/" + postNo;
    	}
		
		
    </script>
</body>
</html>