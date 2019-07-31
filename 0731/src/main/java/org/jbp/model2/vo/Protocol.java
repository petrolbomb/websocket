package org.jbp.model2.vo;

public class Protocol {
	
	private String nickname, profile, msg, sessionId;
	
	public Protocol() {
		// TODO Auto-generated constructor stub
	}
	
	public Protocol(String nickname, String profile, String sessionId) {
		super();
		this.nickname = nickname;
		this.profile = profile;
		this.sessionId = sessionId;
	}


	public String getSessionId() {
		return sessionId;
	}


	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}


	public String getNickname() {
		return nickname;
	}

	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getProfile() {
		return profile;
	}

	public void setProfile(String profile) {
		this.profile = profile;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public void setUser(Protocol user) {
		this.nickname= user.getNickname();
		this.profile = user.getProfile();
		this.sessionId = user.getSessionId();
	}
	

}
