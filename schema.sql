-- NutritionTracker PostgreSQL Schema
-- Run this on Railway PostgreSQL database

-- Users table
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL
);

-- User profiles table
CREATE TABLE IF NOT EXISTS user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    age INTEGER,
    weight DOUBLE PRECISION,
    height DOUBLE PRECISION,
    goal VARCHAR(50),
    diet_preference VARCHAR(50),
    fitness_level VARCHAR(50)
);

-- Food items table
CREATE TABLE IF NOT EXISTS food_items (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    calories_per_100g DOUBLE PRECISION,
    protein DOUBLE PRECISION,
    carbs DOUBLE PRECISION,
    fat DOUBLE PRECISION,
    serving_size_g DOUBLE PRECISION,
    serving_description VARCHAR(100),
    category VARCHAR(50)
);

-- Meal logs table
CREATE TABLE IF NOT EXISTS meal_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    food_id INTEGER REFERENCES food_items(id),
    quantity_grams DOUBLE PRECISION,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exercise logs table
CREATE TABLE IF NOT EXISTS exercise_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    activity VARCHAR(100),
    duration_mins INTEGER,
    calories_burned DOUBLE PRECISION,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =============================================
-- Indian Food Items Data (50+ items)
-- =============================================
INSERT INTO food_items (name, calories_per_100g, protein, carbs, fat, serving_size_g, serving_description, category) VALUES
('Roti (Chapati)', 297, 9.0, 52.0, 3.7, 35, '1 roti', 'Breads'),
('Paratha (Plain)', 326, 7.5, 48.0, 11.5, 60, '1 paratha', 'Breads'),
('Paratha (Aloo)', 218, 4.8, 32.0, 8.2, 100, '1 paratha', 'Breads'),
('Naan', 310, 9.0, 55.0, 5.1, 90, '1 naan', 'Breads'),
('Puri', 340, 7.0, 45.0, 15.0, 30, '1 puri', 'Breads'),
('Bhatura', 370, 8.0, 48.0, 16.5, 80, '1 bhatura', 'Breads'),
('Idli', 58, 2.0, 12.0, 0.1, 40, '1 idli', 'South Indian'),
('Dosa (Plain)', 168, 3.9, 28.0, 4.4, 100, '1 dosa', 'South Indian'),
('Dosa (Masala)', 210, 4.5, 32.0, 7.0, 150, '1 masala dosa', 'South Indian'),
('Uttapam', 175, 5.0, 30.0, 4.0, 100, '1 uttapam', 'South Indian'),
('Medu Vada', 220, 7.0, 22.0, 11.0, 50, '1 vada', 'South Indian'),
('Sambar', 45, 2.5, 7.0, 1.0, 150, '1 bowl', 'South Indian'),
('Dal Tadka', 116, 7.0, 17.0, 2.5, 150, '1 bowl', 'Dal'),
('Dal Makhani', 165, 8.0, 20.0, 6.0, 150, '1 bowl', 'Dal'),
('Chana Dal', 130, 8.5, 20.0, 2.0, 150, '1 bowl', 'Dal'),
('Moong Dal', 104, 7.0, 17.0, 0.5, 150, '1 bowl', 'Dal'),
('Rajma', 140, 8.5, 22.0, 1.5, 150, '1 bowl', 'Dal'),
('Chole (Chana Masala)', 164, 8.0, 25.0, 4.5, 150, '1 bowl', 'Dal'),
('Paneer Butter Masala', 198, 9.0, 10.0, 14.0, 150, '1 bowl', 'Paneer'),
('Palak Paneer', 165, 8.5, 9.0, 11.0, 150, '1 bowl', 'Paneer'),
('Paneer Tikka', 265, 18.0, 6.0, 19.0, 100, '4-5 pieces', 'Paneer'),
('Shahi Paneer', 210, 9.0, 9.0, 16.0, 150, '1 bowl', 'Paneer'),
('Paneer Bhurji', 230, 14.0, 6.0, 17.0, 150, '1 bowl', 'Paneer'),
('Chicken Curry', 175, 20.0, 5.0, 9.0, 150, '1 bowl', 'Non-Veg'),
('Chicken Biryani', 198, 15.0, 25.0, 5.0, 200, '1 plate', 'Non-Veg'),
('Mutton Curry', 210, 18.0, 4.0, 14.0, 150, '1 bowl', 'Non-Veg'),
('Fish Curry', 150, 18.0, 5.0, 7.0, 150, '1 bowl', 'Non-Veg'),
('Egg Curry', 145, 11.0, 6.0, 9.0, 150, '1 bowl', 'Non-Veg'),
('Boiled Egg', 155, 13.0, 1.1, 11.0, 50, '1 egg', 'Non-Veg'),
('Omelette (2 eggs)', 190, 14.0, 1.0, 15.0, 100, '1 omelette', 'Non-Veg'),
('Vegetable Biryani', 160, 4.0, 30.0, 3.5, 200, '1 plate', 'Rice'),
('Steamed Rice', 130, 2.7, 28.0, 0.3, 150, '1 bowl', 'Rice'),
('Jeera Rice', 150, 3.0, 30.0, 2.5, 150, '1 bowl', 'Rice'),
('Pulao', 160, 3.5, 30.0, 3.8, 150, '1 bowl', 'Rice'),
('Khichdi', 120, 4.5, 22.0, 1.8, 150, '1 bowl', 'Rice'),
('Upma', 145, 3.5, 22.0, 5.0, 150, '1 bowl', 'Breakfast'),
('Poha', 130, 2.5, 26.0, 2.5, 150, '1 bowl', 'Breakfast'),
('Aloo Paratha with Curd', 280, 8.0, 40.0, 10.0, 160, '1 serving', 'Breakfast'),
('Besan Chilla', 180, 9.0, 22.0, 6.0, 100, '2 chillas', 'Breakfast'),
('Rava Idli', 132, 4.0, 22.0, 3.5, 80, '2 idlis', 'Breakfast'),
('Aloo Sabzi', 110, 2.5, 20.0, 3.0, 150, '1 bowl', 'Sabzi'),
('Gobi Sabzi', 95, 3.0, 14.0, 3.5, 150, '1 bowl', 'Sabzi'),
('Bhindi Masala', 98, 2.5, 13.0, 4.0, 150, '1 bowl', 'Sabzi'),
('Baingan Bharta', 85, 2.0, 12.0, 3.5, 150, '1 bowl', 'Sabzi'),
('Mix Veg Curry', 105, 3.0, 15.0, 4.0, 150, '1 bowl', 'Sabzi'),
('Matar Paneer', 175, 8.0, 14.0, 10.0, 150, '1 bowl', 'Paneer'),
('Dahi (Curd)', 61, 3.5, 4.7, 3.3, 100, '1 small bowl', 'Dairy'),
('Lassi (Sweet)', 125, 3.5, 20.0, 3.5, 200, '1 glass', 'Dairy'),
('Chaas (Buttermilk)', 40, 2.0, 5.0, 1.0, 200, '1 glass', 'Dairy'),
('Paneer (Raw)', 265, 18.0, 3.5, 20.0, 50, '2 cubes', 'Dairy'),
('Samosa', 308, 5.0, 32.0, 18.0, 60, '1 samosa', 'Snacks'),
('Pakora (Mixed)', 280, 6.0, 28.0, 16.0, 80, '4-5 pieces', 'Snacks'),
('Dhokla', 160, 5.0, 28.0, 3.5, 100, '4 pieces', 'Snacks'),
('Banana', 89, 1.1, 23.0, 0.3, 100, '1 medium banana', 'Fruits'),
('Apple', 52, 0.3, 14.0, 0.2, 150, '1 medium apple', 'Fruits'),
('Mango', 60, 0.8, 15.0, 0.4, 150, '1 cup sliced', 'Fruits');