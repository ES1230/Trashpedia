<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Dictonary</title>
</head>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<link rel="stylesheet" href="https://unpkg.com/swiper@6.8.4/swiper-bundle.min.css" />
<link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
<link rel="stylesheet" href="${contextPath}/resources/css/encyclopedia/trashEncyclopedia.css">
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/slick-carousel/1.8.1/slick.min.js"></script>

<body>
	<jsp:include page="../common/header.jsp" />
	<main>
		<div class="ency-background">
			<div class="ency-background-black">
				<div class="encyLogo">
					<p>쓰레기 백과사전</p>
				</div>
				<div class="encyContent1">
				<form method="get" action="${contextPath}/trash/allList">
			        <div class="ency-search-area">
			            <input type="search" name="keyword" class="search-input" placeholder="검색어를 입력하세요" autocomplete="off">
			            <button type="submit" class="search-button" aria-label="Search">search</button>
			        </div>
		        </form>
		        	<!-- 인기태그 -->
					<div class="content-tab">
						<ul class="temp-tab" style="float: left; list-style: none; position: relative; width: 1150px;" aria-hidden="false">
							<c:forEach var="post" items="${popularList}">
					            <li><a onclick="trashDetail(${post.trashNo})" href="#" data-cont="thumb">${post.trashTitle}</a></li>
							</c:forEach>
            			</ul>
          			</div>
				</div>
			</div>
		</div>
 		<div class="recently-outer">
				<div id="recently-garbage-slider" class="recently-garbage-outer">
					<p class="recently-garbage-outer-title"> 최근 업데이트된 쓰레기</p>
					<div class="recently-garbage-inner">
						<c:forEach var="post" items="${trashList}">
							<div class="recently-garbage">
								<div class="garbage-img-outer">
									<img class="popular-garbage-img"
										src="<c:url value='/resources/attachFile/image/${post.changeName}'/>"
										onclick="trashDetail(${post.trashNo})">
								</div>
								<p class="recently-garbage-title">${post.trashTitle}</p>
								<p class="recently-garbage-content">${post.trashInfo}</p>
							</div>
						</c:forEach>
					</div>
				</div>
			</div>
		<div class="recently-outer">
			<div id="recently-garbage-slider2" class="recently-garbage-outer">
				<p class="recently-garbage-outer-title"> 인기쓰레기 </p>
				<div class="recently-garbage-inner">
					<c:forEach var="post" items="${popularList}">
						<div class="recently-garbage">
							<div class="garbage-img-outer">
								<img class="popular-garbage-img" src="<c:url value='/resources/attachFile/image/${post.changeName}'/>" onclick="trashDetail(${post.trashNo})">
							</div>
							<p class="recently-garbage-title">${post.trashTitle}</p>
							<p class="recently-garbage-content">${post.trashInfo}</p>
						</div>
					</c:forEach>
				</div>
			</div>
		</div>	
	</main>
	<button id="scrollUpButton">
		<span class="material-symbols-outlined">arrow_upward</span>
	</button>
	<div class="moreBtnArea">
		<div class="moreBtnBox">
			<button id="moreBtn" onclick="redirectToAllList()">더알아보기</button>
		</div>
	</div>
	<jsp:include page="../common/footer.jsp" />
	<script>
	 	// 스크롤 변화에 따른 header 스타일 변경
		$(window).scroll(function() {
		  var header = $('.header');
		  var headerLinks = $('.header-nav ul li a');
		  var headerRightLink = $('.header-right li a, .header-right li span');
		
		  if ($(window).scrollTop() > 100) {
		    header.addClass('header-scroll');
		    headerLinks.css({
		      color: 'black',
		    });
		    headerRightLink.css({
		      color: 'rgb(88, 88, 88)',
		    });
		  } else {
		    header.removeClass('header-scroll');
		    headerLinks.css({
		      color: '',
		      fontWeight: ''
		    });
		    headerRightLink.css({
		      color: '',
		      fontWeight: ''
		    });
		  }
		});
	 
		let observer = new IntersectionObserver((entries) => {
		  entries.forEach((entry) => {
		    if (entry.isIntersecting) { // 화면에 나타날 때
		      $(entry.target).css({
		        opacity: 1,
		        transform: 'translate(0, -60px)'
		      });
		    } else { // 화면에 나타나지 않을 때
		      $(entry.target).css({
		        opacity: 0,
		        transform: 'none' // 기존의 트랜스폼 효과 제거
		      });
		    }
		  });
		});
	    
		// 슬라이드
	    $(document).ready(function(){
    		//최근 업데이트 된 쓰레기
            $('#recently-garbage-slider .recently-garbage-inner').slick({
                slidesToShow: 4,
                slidesToScroll: 1,
                autoplay: true,
                autoplaySpeed: 2000, // 2초마다 슬라이드 전환
                arrows : true,
                dots: true,
                prevArrow: '<div class="custom-prev"></div>',
                nextArrow: '<div class="custom-next"></div>'
            });

            $('#recently-garbage-slider2 .recently-garbage-inner').slick({
                slidesToShow: 4,
                slidesToScroll: 1,
                autoplay: true,
                autoplaySpeed: 2000, // 2초마다 슬라이드 전환
                arrows : true,
                dots: true,
                prevArrow: '<div class="custom-prev"></div>',
                nextArrow: '<div class="custom-next"></div>'
            });
    	});
		
	    $(document).ready(function() {
	        // 상단 이동 버튼
	        var scrollUpButton = $('#scrollUpButton');

	        $(window).scroll(function() {
	            if ($(this).scrollTop() > 300) {
	                scrollUpButton.show();
	            } else {
	                scrollUpButton.hide();
	            }
	        });
	        
	        scrollUpButton.click(function(){
	        	$('html,body').animate({scrollTop:0},500);
	        	return false;
	        });
	        
	    });

	    //상세페이지로 이동
	    function trashDetail(trashNo) {
	     	location.href = "${contextPath}/trash/detail?trashNo=" + trashNo;
	    }
	    
	    function redirectToAllList() {
	        location.href = "${contextPath}/trash/allList";
	    }
	    
	</script>
</body>
</html>






