<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="utf-8">
	<title>MODEL2 게시판</title>
	<c:import url="/WEB-INF/template/link.jsp"/>
	<link rel="stylesheet" href="/css/main.css" />
</head>
<body>
	<c:import url="/WEB-INF/template/header.jsp"/>

<c:import url="/WEB-INF/template/footer.jsp"/>
<script type="text/template" id="articlesTmp">
<h2 class="title"><i class="far fa-list-alt"></i> 게시글 목록</h2>	
<@ if(articles.length==0) {@>	
	<p class="no_article">
		<i class="fas fa-skull-crossbones"></i> 아직 게시글이 없습니다.
	</p>
<@}else { @>
	<select id="size">
		<option value="3" <@if(size==3){@>selected<@}@>>3개씩 보기</option>
		<option value="5" <@if(size==5){@>selected<@}@>>5개씩 보기</option>
		<option value="10" <@if(size==10){@>selected<@}@>>10개씩 보기</option>
		<option value="20" <@if(size==20){@>selected<@}@>>20개씩 보기</option>
	</select>
<ul id="articleList">
<@ _.each(articles,function(article){ @>
	<li class="article">
		<a href="/article/<@=article.no@>">
			<div class="card_user">
				<img src="/profile/<@=article.profile@>" width="100" />
	<strong><@=article.writer@></strong>
</div>
<h3 class="title"><@=article.title@></h3>
<time><@=moment(article.regdate).fromNow()@></time>
<strong class="comment"><i class="fa fa-comment"></i> <@=article.replies@></strong>
<span class="hit"><i class="fa fa-eye"></i>  <@=article.hit@></span>
<div class="btn_like">
	<i class="fas fa-heart"></i>
	<i class="far fa-heart"></i>
	<span class="screen_out">좋아요</span>
	<strong class="num_like"><@=article.likes@></strong>
			</div>
		</a>
	</li>
<@})@>
</ul>
<@=paginate@>
<@} @>
</script>
<script src="/js/underscore-min.js"></script>
<script src="/js/moment-with-locales.js"></script>
<script>

//한국시간으로 변경
moment.locale("ko");

_.templateSettings = {interpolate: /\<\@\=(.+?)\@\>/gim,evaluate: /\<\@([\s\S]+?)\@\>/gim,escape: /\<\@\-(.+?)\@\>/gim};


	//템플릿
	const articlesTmp = 
		_.template($("#articlesTmp").html());
	

	//--------- size 변경 ---------
	
	const $aux = $("#content .aux");
	
	$aux.on("change","#size",function(){
		
		//사이즈를 이전사이즈에 넣기
		oldSize = size;
		
		size = $(this).val();
		
		pop = false;
		
		getArticles();
		
	});//change() end
	//---------- size 변경 --------
	
	let size = ${size!=null?size:3};
	let page = ${page!=null?page:1};
	//이전 사이즈 번호
	let oldSize = size;
	//pop되었는지 확인
	let pop = false;
	
	// articles를 불러와서 출력하는 함수
	function getArticles() {
		
		$.ajax({
			url:"/ajax/article/size/"+size+"/page/"+page,
			dataType:"json",
			type:"GET",
			error:function(){
				alert("에러!!");
			},
			success:function(json) {
				
				console.log(json.articles);
				
				if(page==1 || json.articles.length>0 ) {
					let html = articlesTmp({"articles":json.articles,
				         "paginate":json.paginate});
		 	
 					$aux.html(html);	
 					
 					
 					if(!pop) {
 						//pop이 아닌경우에	
 												
	 					var state = { 'page': page, 'size': size };
	 					var title = '게시글 목록'; 
	 					var url = '/article/size/'+size+"/page/"+page;
						
	 					//상태를 저장
	 					history.pushState(state, title, url);

 					}//if end
 					
				}else {
					
					//해당 페이지에 글이 없기 때문에
					//1페이지로 보냄
					
					let total = (page*oldSize)-
					(oldSize-$(".article").length);
					
					//console.log(total);
					//console.log(Math.ceil(total/size));
					
					page =Math.ceil(total/size);
					getArticles();
					
				}//if~else end
			}//success end
		});//ajax() end
		
	}//getArticles end
	
	
	//이전, 이후에 호출
	$(window).on('popstate', function(event) {
		
		  var state = event.originalEvent.state;
		  
		 // alert("length:"+history.length);
		  
		    page = state.page;
		    size = state.size;
		    
		    console.log("popstate");
		    console.log(page);
		    console.log(size);
		  
		    pop = true;
		    
			getArticles();
	});
	
	
	getArticles();
	
	$aux.on("click",".paginate a",function(e){
		e.preventDefault();
		
		page = this.dataset.no;
		
		pop = false;
		
		getArticles();
		
	});//click() end
	
	
	connect(function() {
		
		
	});
	
	
</script>
</body>
</html>
    

    
    
    
    
    
    
    