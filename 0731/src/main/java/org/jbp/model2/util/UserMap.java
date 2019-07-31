package org.jbp.model2.util;

import java.util.Enumeration;
import java.util.concurrent.ConcurrentHashMap;

import org.jbp.model2.vo.User;
import org.springframework.stereotype.Component;

@Component(value="users")
public class UserMap extends ConcurrentHashMap<String, User>{
	
	public User get(int no) {
		
		Enumeration<String> enumeration = this.keys();
		
		while(enumeration.hasMoreElements()) {
			User user = this.get(enumeration.nextElement());
			
			if(user.getNo()==no) {
				
				return user;
			}
			
		}//while end
		
		return null;
	}

}
