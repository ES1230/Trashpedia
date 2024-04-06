<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="com.kks.trashpedia.member.model.vo.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://www.springframework.org/security/tags" prefix="sec" %>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Header</title>
    <!-- 아이콘 -->
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="stylesheet" href="${contextPath}/resources/css/common/header.css">
</head>
<body>
	<c:if test="${not empty alert}">
		<script>
		    alert("${alert}");
		</script>
		<c:remove var="alert" />
	</c:if>

	<header class="header">
    	<div class="header-outer">
            <div class="header-logo">
                <a href="/trashpedia"> TRASHPEDIA </a>
            </div>
            <div class="header-nav">
                <ul>
                    <li id="menu-garbage-dictionary">
                        <div class="header-menu-div">
                           <a href="${contextPath}/trash/list">쓰레기사전</a>
                        </div>
                    </li>
                    <li id="menu-community" class="header-menu-hover">
                        <div class="header-nav-background"></div>
                        <div class="header-menu-div">
                            <a href="${contextPath}/board">커뮤니티</a>
                            <ul class="header-menu-ul">
                            	<li><a href="${contextPath}/board/list?subCategoryNo=1">공지게시판</a></li>
                            	<li><a href="${contextPath}/board/list?subCategoryNo=2">일반게시판</a></li>
                            	<li><a href="${contextPath}/board/list?subCategoryNo=3">건의게시판</a></li>
                                <li><a href="${contextPath}/board/list?subCategoryNo=4">무료나눔게시판</a></li>
                            </ul>
                        </div>
                    </li>
                    <li id="menu-pledge" class="header-menu-hover">
                        <div class="header-menu-div">
                            <a href="${contextPath}/pledge/list?subCategoryNo=5">실천하기</a>
                            <ul class="header-menu-ul">
                                <li><a href="${contextPath}/pledge/list?subCategoryNo=5">실천서약</a></li>
                                <li><a href="${contextPath}/pledge/list?subCategoryNo=6">실천인증</a></li>
                            </ul>
                        </div>
                    </li>
                    <li id="menu-information" class="header-menu-hover">
                        <div class="header-menu-div">
                          	<a href="${contextPath}/information/list?subCategoryNo=7">정보자료글</a>
                            <ul class="header-menu-ul">
                            	<li> <a href="${contextPath}/information/list?subCategoryNo=7">홍보교육자료</a> </li>
                            	<li> <a href="${contextPath}/information/list?subCategoryNo=8">제도교육자료</a> </li>
                            </ul>
                        </div>
                    </li>
                    <li id="menu-garbage-collection">
                        <div class="header-menu-div">
                            <a href="https://www.re.or.kr/comm/searchPickupGISPage.do?enpri_pick_gubun_category1=01#" target="_blank">집앞폐가전수거함</a>
                        </div>
                    </li>
                    <c:if test="${authentication.role == 'ROLE_ADMIN'}">
	                    <li id="menu-garbage-collection">
	                        <div class="header-menu-div">
	                            <a href="${contextPath}/admin">관리자</a>
	                        </div>
	                    </li>
                    </c:if>
                </ul>
            </div>
            <div class="header-search header-search-main">
               <ul class="header-right">
              	<c:if test="${authentication == null}">
	                <!-- 로그인 전 -->
                    <li><span class="material-symbols-outlined icon">login</span><a href="${contextPath}/login">login</a> </li>
                    <li><span class="material-symbols-outlined icon">person </span><a href="${contextPath}/member/join">Signup</a></li>
               </c:if>
               	<c:if test="${authentication != null}">
                    <!-- 로그인 후-->
                    <li><span class="material-symbols-outlined icon">logout</span><a href="${contextPath}/logout">logout</a> </li>
                    <li><span class="material-symbols-outlined icon">person</span><a href="${contextPath}/member/myPage">MyPage</a> </li>
             	</c:if> 
                    <li id="header-search-icon" ><span class="material-symbols-outlined icon">search</span><a>Search</a></li>
                </ul>
            </div>
        </div>
        
    <!-- 검색 팝업 -->
    <div class="search-pop-up">
        <div class="header-logo">
            <a href="mainPage.html"> TRASHPEDIA </a>
        </div>
        <span id="pop-up-X">x</span>
        <span>Search For Trash</span>
        <form method="get" action="${contextPath}/trash/allList">
	        <div class="search-area">
	            <input type="search" name="keyword" class="search-input" placeholder="검색어를 입력하세요" autocomplete="off">
	            <button type="submit" class="search-button" aria-label="Search">search</button>
	        </div>
        </form>
        <div class="search-span">
        </div>
    </div>
    </header>
    <script>
        var header = document.querySelector('.header');

        // 검색 팝업창 내려오기
        document.getElementById('header-search-icon').addEventListener('click', function() {
            document.querySelector('.search-pop-up').style.transitionTimingFunction = 'ease-in-out';
            document.querySelector('.search-pop-up').style.transitionProperty = 'transform';
            document.querySelector('.search-pop-up').style.transitionDuration = '0.6s';
            document.querySelector('.search-pop-up').classList.toggle('active');
        });

        // 검색 팝업창 올라가기
        document.getElementById('pop-up-X').addEventListener('click', function() {
            document.querySelector('.search-pop-up').classList.toggle('active');
        });
        
        // 검색 팝업창 인기쓰레기 
		function fetchData() {
		    var xhr = new XMLHttpRequest();
		    xhr.open("GET", "${contextPath}/trash/popularlist", true);
		    xhr.onreadystatechange = function () {
		        if (xhr.readyState === 4 && xhr.status === 200) {
		            var response = JSON.parse(xhr.responseText);
		            var search = document.querySelector(".search-span");
		            var ul = document.createElement("ul");
		            var span = document.createElement("span");
		            var strong = document.createElement("strong");
		
		            span.textContent = " Popular ";
		            strong.textContent = " #TAG ";
		            span.appendChild(strong);
		
		            ul.appendChild(span);
		
		            response.forEach(function (data) {
		                var li = document.createElement("li");
		                li.textContent = data.trashTitle;
		                //li누르면 input창에 value값 입력
		                li.addEventListener('click', function() {
		               		document.querySelector('.search-input').value = data.trashTitle;
		                })
		                ul.appendChild(li);
		            });
		            search.innerHTML = '';
		            search.appendChild(ul);
		        }
		    };
		    xhr.send();
		}
		fetchData();

        // 스크롤 변화에 따른 header 스타일 변경
        window.addEventListener('scroll', function() {
            // 스크롤 위치가 50보다 크면 배경색 변경
            if (window.scrollY > 50) {
                header.style.backgroundColor = 'rgba(255, 255, 255, 0.7)';
            } else {
                // 마우스 오버 상태가 아닐 때만 기본 색상으로 변경
                if (!header.classList.contains('header-mouseover')) {
                    header.style.backgroundColor = '';
                }
            }
        });
  
    </script>
</body>
</html>