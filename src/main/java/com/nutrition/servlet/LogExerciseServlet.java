package com.nutrition.servlet;

import com.nutrition.dao.ExerciseDAO;
import com.nutrition.model.ExerciseLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/logExercise")
public class LogExerciseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        Integer userId = (Integer) session.getAttribute("userId");

        if (userId == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            String activity = request.getParameter("activity");
            int duration = Integer.parseInt(request.getParameter("duration"));
            String intensity = request.getParameter("intensity");

            if (activity == null || activity.trim().isEmpty()) {
                response.sendRedirect("logExercise.jsp?error=Please+select+an+activity");
                return;
            }
            if (duration <= 0 || duration > 600) {
                response.sendRedirect("logExercise.jsp?error=Invalid+duration");
                return;
            }
            if (intensity == null || intensity.trim().isEmpty()) {
                intensity = "Moderate";
            }

            ExerciseDAO dao = new ExerciseDAO();
            double userWeight = dao.getUserWeight(userId);

            ExerciseLog exercise = new ExerciseLog();
            exercise.setUserId(userId);
            exercise.setActivity(activity);
            exercise.setDurationMins(duration);
            exercise.setIntensity(intensity);
            exercise.setUserWeight(userWeight);

            boolean success = dao.logExercise(exercise);

            if (success) {
                response.sendRedirect("logExercise.jsp?success=true");
            } else {
                response.sendRedirect("logExercise.jsp?error=Failed+to+log+exercise");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("logExercise.jsp?error=Invalid+input+values");
        }
    }
}