<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<header id="header">
	<h1><a href="/"><img src="/img/logo.png" width="40"/><strong>ODEL2</strong> Board</a></h1>
	<a id="chatLink" href="/chat"><i class="far fa-comment-dots"></i> 채팅</a>
	<div id="loginBox">
        <h2 class="screen_out">유저정보</h2>
        <img
         src="/profile/${loginUser.profile}" width="60" height="60" 
         alt="${loginUser.nickname }" 
         title="${loginUser.nickname }"/>
        <button form="logoutForm" class="btn"><i class="fas fa-sign-out-alt"></i> 로그아웃</button>
		<form id="logoutForm" action="/session" method="post">
			<input type="hidden" name="_method" value="DELETE">
		</form>
    </div><!--// loginBox  -->
   
</header>
<main id="content">
<div id="userListWrap">
		<h2>현재 접속자 <span id="usersNum"></span>명</h2>
		<div id="userListBox">
		<ul>
			
			
		</ul>
		</div>
	</div>
	<div class="aux">