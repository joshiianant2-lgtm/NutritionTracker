package com.nutrition.servlet;

import com.nutrition.dao.UserDAO;
import com.nutrition.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name     = request.getParameter("name");
        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        // Server-side validation
        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=" + URLEncoder.encode("Name is required", "UTF-8"));
            return;
        }
        if (email == null || email.trim().isEmpty() || !email.contains("@")) {
            response.sendRedirect("register.jsp?error=" + URLEncoder.encode("Valid email is required", "UTF-8"));
            return;
        }
        if (password == null || password.length() < 6) {
            response.sendRedirect("register.jsp?error=" + URLEncoder.encode("Password must be at least 6 characters", "UTF-8"));
            return;
        }

        UserDAO dao = new UserDAO();

        // Check if email already registered
        if (dao.emailExists(email.trim())) {
            response.sendRedirect("register.jsp?error=" + URLEncoder.encode("Email already registered. Please login.", "UTF-8"));
            return;
        }

        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim().toLowerCase());
        user.setPassword(password);

        boolean success = dao.registerUser(user);

        if (success) {
            response.sendRedirect("login.jsp?success=" + URLEncoder.encode("Account created! Please login.", "UTF-8"));
        } else {
            response.sendRedirect("register.jsp?error=" + URLEncoder.encode("Registration failed. Try again.", "UTF-8"));
        }
    }
}