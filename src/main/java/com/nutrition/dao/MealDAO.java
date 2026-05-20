package com.nutrition.dao;

import com.nutrition.model.MealLog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class MealDAO {

    // Log a meal using servings (quantity = number of servings)
    public boolean logMeal(MealLog meal) {
        // quantity_grams stores actual grams = servings * serving_size_g
        String sql = "INSERT INTO meal_logs (user_id, food_id, quantity_grams) VALUES (?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, meal.getUserId());
            ps.setInt(2, meal.getFoodId());
            ps.setDouble(3, meal.getQuantityGrams()); // actual grams already calculated
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all foods grouped by category for the card grid
    public Map<String, List<Map<String, Object>>> getFoodsByCategory() {
        Map<String, List<Map<String, Object>>> categorized = new LinkedHashMap<>();
        String sql = "SELECT id, name, calories_per_100g, protein, carbs, fat, " +
                     "serving_size_g, serving_description, category " +
                     "FROM food_items ORDER BY category, name";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                String category = rs.getString("category");
                if (!categorized.containsKey(category)) {
                    categorized.put(category, new ArrayList<>());
                }
                Map<String, Object> food = new LinkedHashMap<>();
                food.put("id", rs.getInt("id"));
                food.put("name", rs.getString("name"));
                food.put("caloriesPer100g", rs.getDouble("calories_per_100g"));
                food.put("protein", rs.getDouble("protein"));
                food.put("carbs", rs.getDouble("carbs"));
                food.put("fat", rs.getDouble("fat"));
                food.put("servingSizeG", rs.getDouble("serving_size_g"));
                food.put("servingDescription", rs.getString("serving_description"));
                // Calories per serving
                double calsPerServing = (rs.getDouble("calories_per_100g") * rs.getDouble("serving_size_g")) / 100;
                food.put("caloriesPerServing", Math.round(calsPerServing));
                categorized.get(category).add(food);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return categorized;
    }

    // Get single food item info (for live preview via AJAX or form submit)
    public Map<String, Object> getFoodById(int foodId) {
        String sql = "SELECT id, name, calories_per_100g, protein, carbs, fat, " +
                     "serving_size_g, serving_description, category FROM food_items WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, foodId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Map<String, Object> food = new LinkedHashMap<>();
                food.put("id", rs.getInt("id"));
                food.put("name", rs.getString("name"));
                food.put("caloriesPer100g", rs.getDouble("calories_per_100g"));
                food.put("protein", rs.getDouble("protein"));
                food.put("carbs", rs.getDouble("carbs"));
                food.put("fat", rs.getDouble("fat"));
                food.put("servingSizeG", rs.getDouble("serving_size_g"));
                food.put("servingDescription", rs.getString("serving_description"));
                return food;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<MealLog> getTodayMeals(int userId) {
        List<MealLog> meals = new ArrayList<>();
        String sql = "SELECT m.id, m.quantity_grams, m.log_date, " +
                     "f.name, f.calories_per_100g, f.protein, f.carbs, f.fat, " +
                     "f.serving_size_g, f.serving_description " +
                     "FROM meal_logs m JOIN food_items f ON m.food_id = f.id " +
                     "WHERE m.user_id = ? AND TRUNC(m.log_date) = TRUNC(SYSDATE) " +
                     "ORDER BY m.log_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MealLog meal = new MealLog();
                meal.setId(rs.getInt("id"));
                meal.setQuantityGrams(rs.getDouble("quantity_grams"));
                meal.setLogDate(rs.getString("log_date"));
                meal.setFoodName(rs.getString("name"));

                double qty = meal.getQuantityGrams();
                meal.setCalories((rs.getDouble("calories_per_100g") * qty) / 100);
                meal.setProtein((rs.getDouble("protein") * qty) / 100);
                meal.setCarbs((rs.getDouble("carbs") * qty) / 100);
                meal.setFat((rs.getDouble("fat") * qty) / 100);

                // Show serving description instead of raw grams
                double servingSizeG = rs.getDouble("serving_size_g");
                String servingDesc = rs.getString("serving_description");
                if (servingSizeG > 0) {
                    double servings = qty / servingSizeG;
                    if (servings == Math.floor(servings)) {
                        meal.setServingDisplay((int)servings + "x " + servingDesc);
                    } else {
                        meal.setServingDisplay(String.format("%.1f", servings) + "x " + servingDesc);
                    }
                } else {
                    meal.setServingDisplay(qty + "g");
                }

                meals.add(meal);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return meals;
    }

    public double getTotalCaloriesToday(int userId) {
        String sql = "SELECT SUM((f.calories_per_100g * m.quantity_grams) / 100) " +
                     "FROM meal_logs m JOIN food_items f ON m.food_id = f.id " +
                     "WHERE m.user_id = ? AND TRUNC(m.log_date) = TRUNC(SYSDATE)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getDouble(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Get macro totals for today
    public double[] getTotalMacrosToday(int userId) {
        // returns [protein, carbs, fat]
        String sql = "SELECT SUM((f.protein * m.quantity_grams) / 100), " +
                     "SUM((f.carbs * m.quantity_grams) / 100), " +
                     "SUM((f.fat * m.quantity_grams) / 100) " +
                     "FROM meal_logs m JOIN food_items f ON m.food_id = f.id " +
                     "WHERE m.user_id = ? AND TRUNC(m.log_date) = TRUNC(SYSDATE)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new double[]{rs.getDouble(1), rs.getDouble(2), rs.getDouble(3)};
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return new double[]{0, 0, 0};
    }
}