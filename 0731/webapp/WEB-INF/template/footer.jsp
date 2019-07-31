<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
</div><!--//aux -->
</main><!--//content-->
<footer id="footer">
	<div id="policy">
	<h4 class="screen_out">정책 및 약관</h4>
	<ul>
		<li><a href="">회사소개</a></li><!--
	 --><li><a href="">광고</a></li><!--
	 --><li><a href="">검색등록</a></li><!--
	 --><li><a href="">제휴제안</a></li><!--
	 --><li><a href="">이용약관</a></li><!--
	 --><li><a href=""><strong>개인정보이용약관</strong></a></li><!--
	 --><li><a href="">청소년보호정책</a></li><!--
	 --><li><a href="">고객센터</a></li>
	</ul>
</div><!--//policy -->
<address>&copy; 2019 <a href="">jbp.org</a></address>
</footer><!--// footer -->
<script type="text/template" id="userTmp">
<li data-no='<@=user.no@>'>
<img src="/profile/<@=user.profile@>" alt="<@=user.nickname@>" title="<@=user.nickname@>"/>
<h3><@=user.nickname@></h3>
</li>
</script>
<script>
moment.locale("ko");
_.templateSettings = {
	interpolate : /\<\@\=(.+?)\@\>/gim,
	evaluate : /\<\@([\s\S]+?)\@\>/gim,
	escape : /\<\@\-(.+?)\@\>/gim
};

//webSocket stomp client
let stompClient = null;


const userTmp = _.template($("#userTmp").html());

const $usersNum = $("#usersNum");
const $userListWrap = $("#userListWrap");
const $userList = $("#userListWrap ul");

let sessionId = null;

$userListWrap.hover(function() {
	$userListWrap.toggleClass("open");	
},function() {
	$userListWrap.toggleClass("open");
});

function connect(callback) {
	
	let socket = new SockJS('/model2');
	stompClient = Stomp.over(socket);
	// SockJS와 stomp client를 통해 연결을 시도.
	stompClient.connect({'no' :${loginUser.no}},function() {
		
		stompClient.subscribe('/topic/join', function(msg) {
			console.log('/topic/join');
			
			$userList.append(userTmp({user:JSON.parse(msg.body)}));
			
			$usersNum.text(parseInt($usersNum.text())+1);
			/*
			if($chatList) {
				$chatList.append(helloTmp(JSON.parse(msg.body)));
				moveScroll();
			}
			*/
			
		});
		
		stompClient.subscribe('/topic/leave', function(msg) {
			
			const user = JSON.parse(msg.body);
			console.log(user.no);
			
			$userList.children().each(function() {
				
				console.log(this.dataset.no);
				if(this.dataset.no==user.no) {
					$(this).remove();
				}
			});
			/*
			if($chatList) {
				$chatList.append(byeTmp(JSON.parse(msg.body)));
				moveScroll();
			}
			*/
			$usersNum.text(parseInt($usersNum.text())-1);
			
		});
		
		stompClient.subscribe('/user/queue/join', function(msg) {
			console.log('/user/queue/join');
			
			const json = JSON.parse(msg.body);
			
			const userKeys =Object.keys(json.users); 
			
			const users = json.users;
			
			$usersNum.text(userKeys.length);
			
			sessionId = json.sessionId;
			
			$userList.append(userTmp({user:users[sessionId]}));
			
			$.each(userKeys,function() {
				if(sessionId != this) {
					$userList.append(userTmp({user:users[this]}));
				}
			});
			
		});
		
		stompClient.send("/app/hello");
		
		callback();
		
	});
}

function disconnect() {
	if (stompClient !== null) {
		stompClient.disconnect();
	}
	
	console.log("Disconnected");
}

</script>