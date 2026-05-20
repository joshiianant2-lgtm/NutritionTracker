package com.nutrition.servlet;

import com.nutrition.dao.MealDAO;
import com.nutrition.model.MealLog;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/logMeal")
public class LogMealServlet extends HttpServlet {

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
            int foodId = Integer.parseInt(request.getParameter("foodId"));
            double servings = Double.parseDouble(request.getParameter("servings"));

            if (servings <= 0 || servings > 20) {
                response.sendRedirect("logMeal.jsp?error=Invalid+serving+amount");
                return;
            }

            MealDAO dao = new MealDAO();
            Map<String, Object> food = dao.getFoodById(foodId);

            if (food == null) {
                response.sendRedirect("logMeal.jsp?error=Food+not+found");
                return;
            }

            double servingSizeG = (Double) food.get("servingSizeG");
            double actualGrams = servings * servingSizeG;

            MealLog meal = new MealLog();
            meal.setUserId(userId);
            meal.setFoodId(foodId);
            meal.setQuantityGrams(actualGrams);

            boolean success = dao.logMeal(meal);

            if (success) {
                response.sendRedirect("logMeal.jsp?success=true");
            } else {
                response.sendRedirect("logMeal.jsp?error=Failed+to+log+meal");
            }

        } catch (NumberFormatException e) {
            response.sendRedirect("logMeal.jsp?error=Invalid+input+values");
        }
    }
}