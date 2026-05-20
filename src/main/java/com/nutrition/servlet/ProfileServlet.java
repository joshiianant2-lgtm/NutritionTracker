package com.nutrition.servlet;

import com.nutrition.dao.UserProfileDAO;
import com.nutrition.model.User;
import com.nutrition.model.UserProfile;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/saveProfile")
public class ProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
                          throws ServletException, IOException {

        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if(user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int age = Integer.parseInt(request.getParameter("age"));
        double weight = Double.parseDouble(request.getParameter("weight"));
        double height = Double.parseDouble(request.getParameter("height"));
        String goal = request.getParameter("goal");
        String dietPreference = request.getParameter("dietPreference");
        String fitnessLevel = request.getParameter("fitnessLevel");

        UserProfile profile = new UserProfile();
        profile.setUserId(user.getId());
        profile.setAge(age);
        profile.setWeight(weight);
        profile.setHeight(height);
        profile.setGoal(goal);
        profile.setDietPreference(dietPreference);
        profile.setFitnessLevel(fitnessLevel);

        UserProfileDAO dao = new UserProfileDAO();
        boolean success = dao.saveProfile(profile);

        if(success) {
            // Store profile in session
            session.setAttribute("userProfile", profile);
            response.sendRedirect("profile.jsp?success=true");
        } else {
            response.sendRedirect("profile.jsp?error=Failed to save profile");
        }
    }
}
