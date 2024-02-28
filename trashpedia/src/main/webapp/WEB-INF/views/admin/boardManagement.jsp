<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>boardManagement</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <link rel="stylesheet" href="${contextPath}/resources/css/admin/boardManagement.css">
</head>
<jsp:include page="../common/header.jsp"/>
<body class="body">
    <jsp:include page="../common/sidebar.jsp"/>
    <div class="content-wrapper">
        <div class="content">
            <section class="search-section">
                <div class="search-container">
                    <div class="search-title">게시글 관리</div>
                </div>
            </section>
            <input class="trash-write" type="button" onclick="writeBoard()" value="글쓰기">
            <section class="board-section">
                <div class="category-container">
                    <div class="inner-category-container">
                        <div class="category-title-wrapper bigCategory-title">
                        	<div class="bigCategory-title title">빅 카테고리</div>
            				<div class="board-subtitle">총 ${fn:length(bcl)+1}개</div>
                        </div>
                        <div class="bigCategoryList list">
                        <c:forEach var="bcl" items="${bcl}">
                            <div class="item" onclick='loadSubCategoryList(${bcl.bigCategoryNo})'>
                                <div class="icon">😃</div>
                                <div class="subtitle">${bcl.bigCategoryName}</div>
                            </div>
                        </c:forEach>
                            <div class="item">
                                <div class="icon">😃</div>
                                <div class="subtitle">관리자</div>
                            </div>
                        </div>
                    </div>
                    <div class="inner-category-container">
                        <div class="category-title-wrapper subCategory-title"></div>
                        <div class="subCategoryList list"></div>
                    </div>
                </div>
                <div class="board-container">
                    <div class="board-title-wrapper board-List-title">
	                    <div class="boardList-title title">게시글 리스트</div>
	           			<div class="boardList-subtitle">총 0개</div>
                    </div>
                    <div class="input">
                        <select name="condition" id="boardFilterSelect">
                            <option value="boardNo" selected>번호</option>
                            <option value="title">제목</option>
                        </select>
                    </div>
                    <table>
					    <thead class="board-thead"></thead>
					    <tbody class="boardList list"></tbody>
					</table>
					<select name="condition" id="boardSearchFilterSelect">
                        <option value="boardNo" selected>번호</option>
                        <option value="title">제목</option>
                        <option value="content">내용</option>
                    </select>
                    <input type="search" name="boardSearch" id="boardSearch" placeholder="Search">
                    <input type="button" id="search" value="검색" onclick="boardSearch()">
                </div>
                <div class="board-container">
                    <div class="board-title title">게시글 상세</div>
                    <div class="boardDetail list"></div>
                </div>
            </section>
        </div>
    </div>
    <script>
	    var isLoading = false;
	    var offset = 0;
	    var boardSelectedValue = 'boardNo';
	    var boardSearchSelect = '';
	    var boardSearchValue = '';
	    var subCategoryNo = 2;
	    var scCount = 0;
	    var scChange = false;
		
	    $(document).ready(function() {
	    	loadSubCategoryList(1);
	    	loadBoardListData(subCategoryNo, boardSearchSelect, boardSearchValue);
	    });
	    $('.boardList').scroll(function() {
	        if($(this).scrollTop() + $(this).innerHeight() + 70 >= $(this)[0].scrollHeight) {
	            if (!isLoading) {
	                isLoading = true;
	                loadBoardListData(subCategoryNo, boardSearchSelect, boardSearchValue);
	            }
	        }
	    });
	    
	    $('#boardFilterSelect').change(function(){
	    	boardSelectedValue = $(this).val();
	    	$('.boardList').empty();
	    	boardOffset = 0;
	    	loadBoardListData(subCategoryNo, boardSearchSelect, boardSearchValue);
	    });
	    
	    function boardSearch(){
	    	boardSearchSelect = $('#boardSearchFilterSelect').val();
	    	boardSearchValue = $('#boardSearch').val();
	    	$('#boardSearch').val('');
	    	$('.boardList').empty();
	    	offset = 0;
	    	loadBoardListData(subCategoryNo, boardSearchSelect, boardSearchValue);
	    }
	
	    function loadSubCategoryList(bigCategoryNo) {
	        $.ajax({
	            url: '${contextPath}/admin/getSubCategoryList',
	            type: 'GET',
	            dataType: 'json',
	            data: {bigCategoryNo},
	            success: function(data) {
	            	if(data.length != 0){
		                updateSubCategoryTable(data);
		                isLoading = false;
	            	}
	            },
	            error: function(xhr, status, error) {
	                console.error('Error: ' + error);
	                isLoading = false;
	            }
	        });
	    }
	    function updateSubCategoryTable(data) {
	        let count = document.querySelector('.subCategory-title');
	        let userList = document.querySelector('.subCategoryList');
	        count.innerHTML = '';
	        userList.innerHTML = '';
	        let title = '<div class="subCategory-title title">서브 카테고리</div>';
            title += '<div class="board-subtitle">총 '+data.length+'개</div>';
            count.innerHTML += title;
	        for (let i = 0; i < data.length; i++) {
	            let row = '<div class="item" onclick="loadBoardListData('+data[i].subCategoryNo+')">';
	            row += '<div class="subtitle">'+data[i].subCategoryName+'</div>';
	            row += '</div>';
	            userList.innerHTML += row;
	        }
	    }
	    function loadBoardCount(subCategoryNo){
	    	$.ajax({
	    		url: '${contextPath}/admin/loadBoardCount',
	    		type: 'GET',
	    		dataType: 'json',
	    		data:{subCategoryNo},
	    		success: function(data){
	    			scCount = data;
	    		}
	    	})
	    }
	    
	    function loadBoardListData(sn, boardSearchSelect, boardSearchValue) {
	    	if(subCategoryNo != sn){
	    		console.log("초기화");
		    	subCategoryNo = sn;
		    	scChange = true;
		    	offset = 0;
	    	} else {
	    		scChange = false;
	    	}
	    	if(boardSearchSelect == undefined){
	    		boardSearchSelect = null;
	    		boardSearchValue = null;
	    	}
	        $.ajax({
	            url: '${contextPath}/admin/loadBoardListData',
	            type: 'GET',
	            dataType: 'json',
	            data: {page: offset, size: 20, subCategoryNo: sn, sort: boardSelectedValue, searchSelect: boardSearchSelect, searchValue: boardSearchValue},
	            success: function(data) {
	            	if(data.content.length != 0){
		                updateBoardTable(data);
		                offset += 1;
		                isLoading = false;
	            	}
	            },
	            error: function(xhr, status, error) {
	                console.error('Error: ' + error);
	                isLoading = false;
	            }
	        });
	    }

	    function updateBoardTable(data) {
	    	loadBoardCount(subCategoryNo);
	        let count = document.querySelector('.board-List-title');
	        let userList = document.querySelector('.boardList');
	        let list = data.content;
	        count.innerHTML = '';
	        if(scChange){
	        	userList.innerHTML = '';
	        }
	        let title = '<div class="boardList-title title">게시글 리스트</div>';
            title += '<div class="boardList-subtitle">총 '+scCount+'개</div>';
            count.innerHTML += title;
	        for (let i = 0; i < list.length; i++) {
	            let row = '<tr class="item" onclick="loadBoardDetailData('+list[i].boardNo+')">';
	            row += '<td class="subtitle">'+list[i].boardNo+'</td>';
	            row += '<td class="subtitle">'+list[i].title+'</td>';
	            row += '<td class="subtitle">'+list[i].createDate+'</td>';
	            row += '</tr>';
	            userList.innerHTML += row;
	        }
	    }
	    
	    function loadBoardDetailData(boardNo) {
	        $.ajax({
	            url: '${contextPath}/admin/loadBoardDetailData',
	            type: 'GET',
	            dataType: 'json',
	            data: { boardNo },
	            success: function(data) {
	            	if(data.length != 0){
	            		updateBoardDetailTable(data);
		                isLoading = false;
	            	}
	            },
	            error: function(xhr, status, error) {
	                console.error('Error: ' + error);
	                isLoading = false;
	            }
	        });
	    }
	    function updateBoardDetailTable(data) {
	        let userList = document.querySelector('.boardDetail');
	        userList.innerHTML = '';
	        let row = '<div class="item">';
			row += '<div class="icon">😃</div>';
			row += '<div class="detailtitle">작성자: </div>'
			row += '<div class="subtitle">'+data.userNickname+'</div>'
			row += '</div>';
	        row += '<div class="item">';
			row += '<div class="icon">😃</div>';
			row += '<div class="detailtitle">제목 : </div>'
			row += '<div class="subtitle">'+data.title+'</div>'
			row += '</div>';
	        row += '<div class="content-item">';
			row += '<div class="content-icon">😃</div>';
			row += '<div class="content-detailtitle">내용 : </div>'
			row += '<div class="subtitle">'+data.content+'</div>'
			row += '</div>';
	        row += '<div class="item">';
			row += '<div class="icon">😃</div>';
			row += '<div class="detailtitle">작성일 : </div>'
			row += '<div class="subtitle">'+data.createDate+'</div>'
			row += '</div>';
	        row += '<div class="item">';
			row += '<div class="icon">😃</div>';
			row += '<div class="detailtitle">수정일 : </div>'
			if(data.modifyDate != null){
				row += '<div class="subtitle">'+data.modifyDate+'</div>'
			} else {
				row += '<div class="subtitle">수정 없음</div>'
			}
			row += '</div>';
	        row += '<div class="item">';
			row += '<div class="icon">😃</div>';
			row += '<div class="detailtitle">상세보기 : </div>'
			row += '<div class="subtitle"><button onclick="location.href="/detail?boardNo='+data.boardNo+'">상세보기</button></div>'
			row += '</div>';
			row += '</div>';
            userList.innerHTML += row;
	    }
	    
        function writeBoard(){
            location.href = "adminBoard.html";
        }
    </script>
</body>