package com.nutrition.dao;

import com.nutrition.model.UserProfile;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserProfileDAO {

    public boolean saveProfile(UserProfile profile) {
        // Check if profile already exists
        if(getProfile(profile.getUserId()) != null) {
            return updateProfile(profile);
        } else {
            return insertProfile(profile);
        }
    }

    private boolean insertProfile(UserProfile profile) {
        String sql = "INSERT INTO user_profiles (user_id, age, weight, height, goal, diet_preference, fitness_level) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, profile.getUserId());
            ps.setInt(2, profile.getAge());
            ps.setDouble(3, profile.getWeight());
            ps.setDouble(4, profile.getHeight());
            ps.setString(5, profile.getGoal());
            ps.setString(6, profile.getDietPreference());
            ps.setString(7, profile.getFitnessLevel());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.out.println("DB ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    private boolean updateProfile(UserProfile profile) {
        String sql = "UPDATE user_profiles SET age=?, weight=?, height=?, goal=?, " +
                     "diet_preference=?, fitness_level=? WHERE user_id=?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, profile.getAge());
            ps.setDouble(2, profile.getWeight());
            ps.setDouble(3, profile.getHeight());
            ps.setString(4, profile.getGoal());
            ps.setString(5, profile.getDietPreference());
            ps.setString(6, profile.getFitnessLevel());
            ps.setInt(7, profile.getUserId());
            ps.executeUpdate();
            return true;

        } catch (SQLException e) {
            System.out.println("DB ERROR: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public UserProfile getProfile(int userId) {
        String sql = "SELECT * FROM user_profiles WHERE user_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                UserProfile profile = new UserProfile();
                profile.setId(rs.getInt("id"));
                profile.setUserId(rs.getInt("user_id"));
                profile.setAge(rs.getInt("age"));
                profile.setWeight(rs.getDouble("weight"));
                profile.setHeight(rs.getDouble("height"));
                profile.setGoal(rs.getString("goal"));
                profile.setDietPreference(rs.getString("diet_preference"));
                profile.setFitnessLevel(rs.getString("fitness_level"));
                return profile;
            }

        } catch (SQLException e) {
            System.out.println("DB ERROR: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}
