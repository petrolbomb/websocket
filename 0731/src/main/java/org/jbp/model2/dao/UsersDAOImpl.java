package org.jbp.model2.dao;

import org.apache.ibatis.session.SqlSession;
import org.jbp.model2.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class UsersDAOImpl implements UsersDAO {
	
	@Autowired
	private SqlSession session;
	
	@Override
	public User selectLogin(User user) {
		return session.selectOne("users.selectLogin",user);
	}
	
	public int insert(User user) {
		return session.insert("users.insert", user);
	}

	public int selectCheckId(String id) {
		return session.selectOne("users.selectCheckId", id);
	}// selectCheckId() end

	public int selectCheckNickname(String nickname) {
		return session.selectOne("users.selectCheckNickname", nickname);
	}// selectCheckId() end

	@Override
	public User selectOne(String no) {
		return session.selectOne("users.selectOne",no);
	}
}
