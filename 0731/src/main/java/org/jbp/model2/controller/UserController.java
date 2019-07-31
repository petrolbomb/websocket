package org.jbp.model2.controller;

import javax.servlet.http.HttpSession;

import org.jbp.model2.service.UsersService;
import org.jbp.model2.vo.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
public class UserController {

	@Autowired
	private UsersService usersService;


	@RequestMapping(value = "/join", method = RequestMethod.GET)
	public String join() {

		return "joinForm";
	}

	@RequestMapping(value = "/join", method = RequestMethod.POST)
	public String join(User user) {

		usersService.join(user);

		return "redirect:/";
	}

	@RequestMapping(value = "/session", method = RequestMethod.POST)
	public String asdfasasdfsd(User user, @RequestHeader String referer, HttpSession session, RedirectAttributes ra) {

		Object loginUser = usersService.login(user);

		if (loginUser != null) {
			session.setAttribute("loginUser", loginUser);
			return "redirect:/article";
		} else {
			ra.addFlashAttribute("msg", "아이디나 비밀번호가 틀렸습니다.");
			return "redirect:/index";
		}

	}

	@RequestMapping(value = "/session", method = RequestMethod.DELETE)
	public String asdfasasdfsd(@RequestHeader String referer, HttpSession session) {

		session.removeAttribute("loginUser");

		return "redirect:" + referer;
	}

}
