package com.nutrition.model;

public class MealLog {

    private int id;
    private int userId;
    private int foodId;
    private double quantityGrams;
    private String logDate;
    private String foodName;
    private double calories;
    private double protein;
    private double carbs;
    private double fat;
    private String servingDisplay;

    // Constructors
    public MealLog() {}

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getFoodId() { return foodId; }
    public void setFoodId(int foodId) { this.foodId = foodId; }

    public double getQuantityGrams() { return quantityGrams; }
    public void setQuantityGrams(double quantityGrams) { this.quantityGrams = quantityGrams; }

    public String getLogDate() { return logDate; }
    public void setLogDate(String logDate) { this.logDate = logDate; }

    public String getFoodName() { return foodName; }
    public void setFoodName(String foodName) { this.foodName = foodName; }

    public double getCalories() { return calories; }
    public void setCalories(double calories) { this.calories = calories; }

    public double getProtein() { return protein; }
    public void setProtein(double protein) { this.protein = protein; }

    public double getCarbs() { return carbs; }
    public void setCarbs(double carbs) { this.carbs = carbs; }

    public double getFat() { return fat; }
    public void setFat(double fat) { this.fat = fat; }

    public String getServingDisplay() { return servingDisplay; }
    public void setServingDisplay(String servingDisplay) { this.servingDisplay = servingDisplay; }
}