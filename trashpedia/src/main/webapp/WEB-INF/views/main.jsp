<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="<%=request.getContextPath() %>"/>
<!DOCTYPE html>
<html lang="ko" xmlns:th="https://www.thymeleaf.org" xmlns:sec="http://www.thymeleaf.org/extras/spring-security">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>TRASHPEDIA</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<!-- css -->
<link rel="stylesheet" href="${contextPath}/resources/css/main/main.css">
<!-- slick 라이브러리 CSS -->
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.css" />
<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick-theme.css" />
<!-- slick 라이브러리 JS -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/slick-carousel@1.8.1/slick/slick.min.js"></script>
</head>
<body>

	<jsp:include page="common/header.jsp" />

	<div class="backgroundImg">
		<div class="backgroundImg-black">
			<h2 class="scroll_on type_bottom">TRASHPEDIA</h2>
			<h4 class="scroll_on type_bottom">잘 버리는 일부터 시작하세요</h4>
			<h4 class="scroll_on type_bottom">모두를 위한 정보 플랫폼</h4>
			<button id="scrollDownButton">
				<span class="material-symbols-outlined">arrow_downward</span>
			</button>
		</div>
	</div>

	<main>

		<div id="mainVisual" class="showEvent"></div>

		<div class="recently-outer showEvent">
			<img style="width:100%"src="<c:url value='/resources/image/main/mainImg/main_visual.png' />">
			
			<!-- 최근 업데이트된 쓰레기 사전  -->
			<div id="recently-garbage-slider" class="recently-garbage-outer">
				<p id="recently-garbage-outer-title"> 최근 업데이트된 <strong>쓰레기사전</strong> </p>
				<div class="recently-garbage-inner">
					<c:choose>
						<c:when test="${not empty recentlyTrashList}">
							<c:forEach var="post" items="${recentlyTrashList}">
								<div class="recently-garbage">
									<div class="garbage-img-outer">
										<img class="popular-garbage-img"
											src="<c:url value='/resources/attachFile/image/${post.changeName}'/>"
											onclick="trashDetail(${post.trashNo})">
										<p class="recently-garbage-title">${post.trashTitle}</p>
									</div>
									<p class="recently-garbage-content">${post.trashInfo}</p>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="recently-garbage">
								<p>게시글이 없습니다.</p>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			
		</div>

		<!-- 정보자료글-홍보교육자료 -->
		<div class="information-outer showEvent">
			<a class="information-outer-title" href=""><strong>홍보교육자료</strong>
				<img src="<c:url value='/resources/image/main/mainImg/common-arrow-anchor.png'/>">
			</a> 
			<div id="information-content-slider" >
				<c:choose>
					<c:when test="${not empty informationList}">
						<c:forEach var="post" items="${informationList}">
							<div class="information-content-outer" onclick="informationDetail(${post.postNo})">
								<div class="information-image-outer">
									<img class="information-image-element" height="400" src="<c:url value='/resources/attachFile/image/${post.changeName}'/>">
								</div>
								<div class="information-text-outer">
									<p class="information-title">${post.title}</p>
									<p class="information-content">
									    <c:out value="${post.content.replaceAll('<.*?>', '').replaceAll('&lt;', '<').replaceAll('&gt;', '>')}" />
									</p>
								</div>
							</div>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<div class="information-content-outer">
							<p>게시글이 없습니다.</p>
						</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<!-- 실천인증 슬라이더  -->
		<div class="pledge-outer recently-outer showEvent" style="background-color : #ebf3d3">
			<div class="pledge-img-outer">
				<img src="<c:url value='/resources/image/main/mainImg/자원순환.png' />">
			</div>
			<div id="pledge-slider" class="recently-garbage-outer">
				<p id="pledge-slider-p"> 아래 실천하고 있는 자원순환 서약 이미지를 클릭한 다음 서명에 동참해주세요! </p>
				<div class="recently-garbage-inner">
					<c:choose>
						<c:when test="${not empty pledgeCList}">
							<c:forEach var="post" items="${pledgeCList}">
								<div class="recently-garbage">
									<div class="garbage-img-outer">
										<img class="popular-garbage-img"
											src="<c:url value='/resources/attachFile/image/${post.changeName}'/>"
											onclick="pledgeDetail(${post.postNo})">
									</div>
								</div>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<div class="recently-garbage">
								<p>게시글이 없습니다.</p>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
				<div class="mainMoreA">
					<a href="${contextPath}/pledge/list?bigCategoryNo=2&subCategoryNo=5">더보기</a>
				</div>
			</div>
		</div>

		<div class="showEvent">
			<div class="content-outer">
				<p id="contentP1">환경을 위한 습관</p>
				<p id="contentP2">함께하는 자원순환의 첫 걸음</p>
				<p id="contentP3"> Go Green with <span>TRESHPEDIA</span> </p>
			</div>
			<!-- 배경이미지 -->
			<img class="green-img" src="<c:url value='/resources/image/main/mainImg/greenBackImg.jpg' />" alt="Green Background Image">
			
			<!-- 공지사항 / 실천서약 -->
			<div id="popularPost">
				<div id="popularPostBack">
					<section class="backSection"></section>
				</div>
				<div class="posts-container">
				
					<!-- 왼쪽: 공지게시글-->
					<div id="noticePostsDiv">
						<span class="post-title">공지사항</span> 
						<span class="more-btn"><a href="${contextPath}/board/list?bigCategoryNo=1&subCategoryNo=1">더보기</a></span>
						<div class="noticePostImg">
							<a href="${contextPath}/board/list?bigCategoryNo=1&subCategoryNo=1"> 
								<img src="https://www.recycling-info.or.kr/act4r/cmm/image/view.do?id=agenfileupload_202310260443191071&ext=jpg">
							</a>
						</div>
					</div>
					<!-- 오른쪽: 실천인증 게시글 리스트 -->
					<div id="instagramPostsDiv">
						<span class="post-title">자원순환 실천인증</span> <span class="more-btn">
						 <a href="${contextPath}/pledge/list?bigCategoryNo=2&subCategoryNo=6">더보기</a></span>
						<div class="instagram-posts-list">
							<c:choose>
								<c:when test="${not empty pledgeList}">
									<c:forEach var="post" items="${pledgeList}">
										<div class="post-container" onclick="pledgeDetail(${post.postNo})">
											<img src="<c:url value='/resources/attachFile/image/${post.changeName}'/>" alt="Instagram Image"> 
												<span class="insta-logo"> 
												<img class="snsimg" src="https://www.recycling-info.or.kr/act4r/taglive_img/instagram.png"
												social-name="instagram" alt="instagram">
											</span>
										 <div class="post-overlay">
								            <p><c:out value="${post.content.replaceAll('<.*?>', '').replaceAll('&lt;', '<').replaceAll('&gt;', '>')}" /></p>
								        </div>
										</div>
									</c:forEach>
								</c:when>
								<c:otherwise>
									<div class="post-container">
										<p>게시글이 없습니다.</p>
									</div>
								</c:otherwise>
							</c:choose>
						</div>
					</div>
					
				</div>
			</div>
		</div>

	</main>
	
	<button id="scrollUpButton">
		<span class="material-symbols-outlined">arrow_upward</span>
	</button>

	<jsp:include page="common/footer.jsp" />

	<script>
		// IntersectionObserver 설정
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
	
		// 화면 내릴 때 "showEvent" 클래스 가진 요소 하나씩 나타나기 이벤트
		$('.showEvent').each(function() {
			observer.observe(this);
		});
	    
    
	    // 슬라이드
	    $(document).ready(function(){
	    		//최근 업데이트 된 쓰레기사전
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
	    		//정보자료글
	            $('#information-content-slider').slick({
	                slidesToShow: 1,
	                slidesToScroll: 1,
	                autoplay: true,
	                autoplaySpeed: 3000,
	                arrows : true,
	                dots: true,
	                prevArrow: '<div class="custom-prev"></div>',
	                nextArrow: '<div class="custom-next"></div>'
	            });
	          // 자원순환 서약 이미지
	            $('#pledge-slider .recently-garbage-inner').slick({
	                slidesToShow: 4,
	                slidesToScroll: 1,
	                autoplay: true,
	                autoplaySpeed: 3000
	            });
	    });
	
	   
	    $(document).ready(function() {
	        // 스크롤 다운 버튼 
	        $("#scrollDownButton").click(function() {
	            $("body, html").animate({ 
	                scrollTop: 1200 
	            }, 1800); 
	        });
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
	        	$('html,body').animate({scrollTop:0},600);
	        	return false;
	        });
	    });
	    

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
	    
	    // 메인 이미지 스크롤 효과
	    $(document).ready(function() {
	        const $counters = $(".scroll_on");
	        const exposurePercentage = 100; // ex) 스크롤 했을 때 $counters 컨텐츠가 화면에 100% 노출되면 숫자가 올라감
	        const loop = true; // 애니메이션 반복 여부설정 (true로 설정할 경우, 요소가 화면에서 사라질 때 다시 숨겨짐)
	
	        // 윈도우의 스크롤 이벤트 모니터링
	        $(window).on('scroll', function() {
	            // 각 "scroll_on" 클래스를 가진 요소에 대해 반복
	            $counters.each(function() {
	                const $el = $(this);
	                const rect = $el[0].getBoundingClientRect();
	                const winHeight = window.innerHeight; // 현재 브라우저 창의 높이
	                const contentHeight = rect.bottom - rect.top; // 요소의 높이
	                
	                // 요소가 화면에 특정 비율만큼 노출될 때 처리
	                if (rect.top <= winHeight - (contentHeight * exposurePercentage / 100) && rect.bottom >= (contentHeight * exposurePercentage / 100)) {
	                    $el.addClass('active');
	                }
	                // 요소가 화면에서 완전히 사라졌을 때 처리
	                if (loop && (rect.bottom <= 0 || rect.top >= window.innerHeight)) {
	                    $el.removeClass('active');
	                }
	            });
	        }).scroll();
	    });
	    
	    // 쓰레기사전 상세페이지로 이동
	    function trashDetail(trashNo) {
	     	location.href = "${contextPath}/trash/detail?trashNo=" + trashNo;
	    }
	    
	    // 홍보교육자료 상세보기페이지 이동
	    function informationDetail(postNo) {
	    	location.href = "${contextPath}/information/detail/" + postNo;
    	}
	    
	    // 상세페이지 이동
	    function pledgeDetail(postNo) {
	    	location.href = "${contextPath}/pledge/detail/" + postNo;
    	}
	    
    </script>

</body>
</html>