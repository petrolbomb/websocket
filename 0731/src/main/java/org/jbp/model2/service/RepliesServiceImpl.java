package org.jbp.model2.service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.jbp.model2.dao.ArticlesDAO;
import org.jbp.model2.dao.RepliesDAO;
import org.jbp.model2.util.PaginateUtil;
import org.jbp.model2.vo.PageVO;
import org.jbp.model2.vo.Reply;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class RepliesServiceImpl implements
RepliesService{
	

	@Autowired
	private RepliesDAO repliesDAO;
	@Autowired
	private ArticlesDAO articlesDAO;
	@Autowired
	private PaginateUtil paginateUtil;
	
	
	@Override
	public Map<String, Object> getReplies(int articleNo, int pageNo) {
		Map<String, Object> map = new ConcurrentHashMap<String, Object>();
		
		PageVO pageVO = new PageVO(pageNo, 5,articleNo);
		
		map.put("replies", repliesDAO.selectList(pageVO));
		
		int total = repliesDAO.selectTotal(articleNo);
		
		map.put("paginate", paginateUtil.getPaginate(pageNo, total, 5, 5, "ajax/article/"+articleNo+"/reply"));
		
		map.put("total",total);
		
		return map;
	}
	
	@Override
	public boolean remove(int no) {
		return 1== repliesDAO.delete(no);
	}
	
	@Override
	@Transactional
	public boolean register(Reply reply) {
		
		repliesDAO.insert(reply);
		articlesDAO.updateReplies(reply.getArticleNo());
		
		return true;
	}
	
}
