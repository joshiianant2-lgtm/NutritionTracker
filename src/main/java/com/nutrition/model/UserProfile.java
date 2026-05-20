

	package com.nutrition.model;

	public class UserProfile {

	    private int id;
	    private int userId;
	    private int age;
	    private double weight;
	    private double height;
	    private String goal;
	    private String dietPreference;
	    private String fitnessLevel;

	    public UserProfile() {}

	    public int getId() { return id; }
	    public void setId(int id) { this.id = id; }

	    public int getUserId() { return userId; }
	    public void setUserId(int userId) { this.userId = userId; }

	    public int getAge() { return age; }
	    public void setAge(int age) { this.age = age; }

	    public double getWeight() { return weight; }
	    public void setWeight(double weight) { this.weight = weight; }

	    public double getHeight() { return height; }
	    public void setHeight(double height) { this.height = height; }

	    public String getGoal() { return goal; }
	    public void setGoal(String goal) { this.goal = goal; }

	    public String getDietPreference() { return dietPreference; }
	    public void setDietPreference(String dietPreference) { 
	        this.dietPreference = dietPreference; 
	    }

	    public String getFitnessLevel() { return fitnessLevel; }
	    public void setFitnessLevel(String fitnessLevel) { 
	        this.fitnessLevel = fitnessLevel; 
	    }

	    // BMR Calculation (Mifflin-St Jeor for male, approximate)
	    public double calculateBMR() {
	        if(weight == 0 || height == 0 || age == 0) return 0;
	        return (10 * weight) + (6.25 * height) - (5 * age) + 5;
	    }

	    // Daily calorie target based on goal
	    public double getDailyCalorieTarget() {
	        double bmr = calculateBMR();
	        if(bmr == 0) return 0;
	        switch(goal != null ? goal : "") {
	            case "Weight Loss": return bmr - 500;
	            case "Muscle Gain": return bmr + 500;
	            default: return bmr;
	        }
	    }
	}

