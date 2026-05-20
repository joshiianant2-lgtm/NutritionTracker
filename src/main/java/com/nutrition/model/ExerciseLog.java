package com.nutrition.model;

public class ExerciseLog {

    private int id;
    private int userId;
    private String activity;
    private int durationMins;
    private double caloriesBurned;
    private String logDate;
    private String intensity;   // Light, Moderate, Intense
    private double userWeight;  // fetched from user_profiles

    public ExerciseLog() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getActivity() { return activity; }
    public void setActivity(String activity) { this.activity = activity; }

    public int getDurationMins() { return durationMins; }
    public void setDurationMins(int durationMins) { this.durationMins = durationMins; }

    public double getCaloriesBurned() { return caloriesBurned; }
    public void setCaloriesBurned(double caloriesBurned) { this.caloriesBurned = caloriesBurned; }

    public String getLogDate() { return logDate; }
    public void setLogDate(String logDate) { this.logDate = logDate; }

    public String getIntensity() { return intensity; }
    public void setIntensity(String intensity) { this.intensity = intensity; }

    public double getUserWeight() { return userWeight; }
    public void setUserWeight(double userWeight) { this.userWeight = userWeight; }
}