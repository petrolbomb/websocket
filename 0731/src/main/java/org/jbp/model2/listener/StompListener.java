package org.jbp.model2.listener;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.jbp.model2.service.UsersService;
import org.jbp.model2.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.event.EventListener;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

public class StompListener {
	
	@Autowired
	private SimpMessagingTemplate template;
	
	@Autowired
	private UsersService usersService;
	
	@Autowired
	private Map<String, User> users;
	
	@EventListener
	private void handleSessionConnected(SessionConnectEvent event) {
		StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());
		
		String no = accessor.getNativeHeader("no").get(0);

		User user = usersService.getOne(no);
		
		System.out.println("profile:"+user.getProfile());
		System.out.println("nickname:"+user.getNickname());
		
		users.put(accessor.getSessionId(),user);
		
		System.out.println("유저 들어옴");
		System.out.println("userNo : "+no);
		
		System.out.println("유저수 : " + users.size());
		
		accessor.setSessionId(""+no);
		
		//System.out.println("sessionId:"+accessor.getSessionId());
		
		//System.out.println(accessor.getUser().getName());
		
		//template.convertAndSend("/topic/user/list",users);

		Map<String, Object> map = new ConcurrentHashMap<String, Object>();
		
		map.put("user",user);
		map.put("size",users.size());
		
		//template.convertAndSend("/topic/join",map);
		
	}
	
	@EventListener
	private void handleSessionDisconnect(SessionDisconnectEvent event) {
		StompHeaderAccessor accessor = StompHeaderAccessor.wrap(event.getMessage());

		System.out.println("유저나감! ");
		
		User user = users.get(accessor.getSessionId());
		
		users.remove(accessor.getSessionId());
		
		System.out.println("유저수 : " + users.size());
		
		Map<String, Object> map = new ConcurrentHashMap<String, Object>();
		
		map.put("user",user);
		map.put("size",users.size());
		
		template.convertAndSend("/topic/leave",map);
	}

}
