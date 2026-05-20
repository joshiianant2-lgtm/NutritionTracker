package com.nutrition.dao;

import com.nutrition.model.ExerciseLog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ExerciseDAO {

    // MET values adjusted by intensity: Light=0.75x, Moderate=1x, Intense=1.25x
    private double getMET(String activity, String intensity) {
        double base;
        switch (activity) {
            case "Running":         base = 9.8;  break;
            case "Cycling":         base = 7.5;  break;
            case "Swimming":        base = 8.0;  break;
            case "Walking":         base = 3.5;  break;
            case "Weight Training": base = 5.0;  break;
            case "Yoga":            base = 3.0;  break;
            case "Jump Rope":       base = 11.0; break;
            case "HIIT":            base = 10.0; break;
            default:                base = 5.0;
        }
        if ("Light".equals(intensity))   return base * 0.75;
        if ("Intense".equals(intensity)) return base * 1.25;
        return base; // Moderate = default
    }

    // Fetch real user weight from profile, fallback 70kg
    public double getUserWeight(int userId) {
        String sql = "SELECT weight FROM user_profiles WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                double w = rs.getDouble("weight");
                if (w > 0) return w;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 70.0;
    }

    public boolean logExercise(ExerciseLog exercise) {
        double met = getMET(exercise.getActivity(), exercise.getIntensity());
        double weight = exercise.getUserWeight() > 0 ? exercise.getUserWeight() : 70.0;
        double calories = met * weight * (exercise.getDurationMins() / 60.0);
        exercise.setCaloriesBurned(Math.round(calories * 100.0) / 100.0);

        String sql = "INSERT INTO exercise_logs (user_id, activity, duration_mins, calories_burned) " +
                     "VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, exercise.getUserId());
            ps.setString(2, exercise.getActivity());
            ps.setInt(3, exercise.getDurationMins());
            ps.setDouble(4, exercise.getCaloriesBurned());
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<ExerciseLog> getTodayExercises(int userId) {
        List<ExerciseLog> exercises = new ArrayList<>();
        // PostgreSQL: use CURRENT_DATE instead of TRUNC(SYSDATE)
        String sql = "SELECT * FROM exercise_logs WHERE user_id = ? " +
                     "AND log_date::date = CURRENT_DATE ORDER BY log_date DESC";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ExerciseLog exercise = new ExerciseLog();
                exercise.setId(rs.getInt("id"));
                exercise.setUserId(rs.getInt("user_id"));
                exercise.setActivity(rs.getString("activity"));
                exercise.setDurationMins(rs.getInt("duration_mins"));
                exercise.setCaloriesBurned(rs.getDouble("calories_burned"));
                exercise.setLogDate(rs.getString("log_date"));
                exercises.add(exercise);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return exercises;
    }

    public double getTotalCaloriesBurnedToday(int userId) {
        // PostgreSQL: use CURRENT_DATE instead of TRUNC(SYSDATE)
        String sql = "SELECT SUM(calories_burned) FROM exercise_logs " +
                     "WHERE user_id = ? AND log_date::date = CURRENT_DATE";
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
}