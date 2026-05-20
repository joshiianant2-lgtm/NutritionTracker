package com.nutrition.servlet;

import com.nutrition.dao.UserDAO;
import com.nutrition.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet{
	
	  protected void doPost(HttpServletRequest request,
              HttpServletResponse response)
              throws ServletException, IOException {

String email = request.getParameter("email");
String password = request.getParameter("password");

UserDAO dao = new UserDAO();
User user = dao.loginUser(email, password);

if (user != null) {
HttpSession session = request.getSession();
session.setAttribute("user", user);
session.setAttribute("userId", user.getId());
session.setAttribute("userName", user.getName());
response.sendRedirect("dashboard.jsp");
} else {
response.sendRedirect("login.jsp?error=Invalid email or password");
}
}
}
