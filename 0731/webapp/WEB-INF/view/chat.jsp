<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    
<c:if test="${loginUser==null}">
	<c:redirect url="/index"/>
</c:if>  
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="utf-8">
<title>까까오톡</title>
<c:import url="/WEB-INF/template/link.jsp"/>	
<link rel="stylesheet" href="/css/chat.css" />
</head>
<body>
<c:import url="/WEB-INF/template/header.jsp"/>	
<div id="chattingSection">
	<div id="chatList">
			<h3 class="screen_out">채팅목록</h3>
			<div id="chatListWrap">
			<ul>
		
			</ul>
			</div>
		</div>
		<!--//.chatList -->
		<div id="inputChatBox">
			<form id="msgForm" action=" " method="post">
				<fieldset>
					<legend class="screen_out">메세지 입력폼</legend>
					<label for="msg" class="screen_out">메세지 입력</label> <input
						name="message" autocomplete="off" id="msg" type="text"
						placeholder="메세지를 입력해주세요" />
					<button id="inputBtn" class="btn" type="submit">입력</button>
				</fieldset>
			</form>
		</div>
		<!--//#inputChatBox -->
		</div>
<c:import url="/WEB-INF/template/footer.jsp"/>
<script type="text/template" id="msgTmp">
    <li class="<@ if(sessionId==protocol.sessionId){@>mine<@}@>">
        <div class="card_user">
            <img src="/profile/<@=protocol.user.profile@>" title="<@=protocol.user.nickname@>">
            <strong><@=protocol.user.nickname@></strong>
        </div>
        <div class="box_chat">
            <div class="comments"><@=protocol.msg@></div>
        </div><!--//box_reply-->
    </li>
	</script>
	<script type="text/template" id="helloTmp">
	 <li class="cmd">
     	<img src="/profile/<@=profile@>" title="<@=nickname@>">
     	<span><@=nickname@>님이 들어오셨습니다.</span>
 	</li>
	</script>
	<script type="text/template" id="byeTmp">
	 <li class="cmd">
     	<img src="/profile/<@=profile@>" title="<@=nickname@>">
     	<span><@=nickname@>님이 나가셨습니다.</span>
 	</li>
	</script>
	
	<script>
		
		const msgTmp = _.template($("#msgTmp").html());
		const helloTmp = _.template($("#helloTmp").html());
		const byeTmp = _.template($("#byeTmp").html());

		const $chttingSection = $("#chattingSection");
		const $chatList = $("#chatList ul");
		const $chatListWrap = $("#chatListWrap");
		
		const $msgForm = $("#msgForm");
		const $msg = $("#msg");

		//web socket 
		$msgForm.submit(function(e) {
			
			e.preventDefault();

			const msg = $msg.val().trim();

			if (msg.length==0) {
				alert("메세지를 입력해주세요.");
				return;
			}
			
			stompClient.send("/app/msg",{},msg);
			
		});
		
		function moveScroll() {
			setTimeout(function() {
				
				console.log($chatList.height());
				
				$chatListWrap.scrollTop($chatList.height());
				
			},10);
		}
		
		connect(function() {
			console.log("호출됨!");
			
			
			
			stompClient.subscribe('/topic/msg', function(msg) {
				$msg.val("").focus();
				
				const json = JSON.parse(msg.body);
				
				$chatList.append(msgTmp({protocol:json}));
				moveScroll();
			});
		});
		

	</script>
</body>
</html>
    