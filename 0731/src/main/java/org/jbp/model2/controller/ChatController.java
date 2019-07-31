package org.jbp.model2.controller;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import javax.annotation.Resource;

import org.jbp.model2.vo.User;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.messaging.simp.annotation.SendToUser;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class ChatController {
	
	@Resource(name="users")
	private Map<String, User> users;
	
	@RequestMapping(value="/chat",method=RequestMethod.GET)
	public void chat() {
		
	}
	
	@MessageMapping("/hello") // 받는곳
	@SendToUser(value="/queue/join") // 보내는곳
	public Map<String, Object> ss(SimpMessageHeaderAccessor accessor) throws Exception {
		
		System.out.println("/hello 드러옴!");
		
		Map<String, Object> map = new ConcurrentHashMap<String, Object>();
		
		map.put("sessionId",accessor.getSessionId());
		map.put("users",users);
		
		return map;
	}
	
	@MessageMapping("/msg") // 받는곳
	@SendTo("/topic/msg") // 보내는곳
	public Map<String, Object> asdfs(String msg, SimpMessageHeaderAccessor accessor) throws Exception {
		
		System.out.println("/msg 들어옴!");

		System.out.println(msg);
		
		Map<String, Object> map = new ConcurrentHashMap<String, Object>();
		
		map.put("user",users.get(accessor.getSessionId()));
		map.put("sessionId",accessor.getSessionId());
		map.put("msg",msg);
		
		return map;
	}
	

}
