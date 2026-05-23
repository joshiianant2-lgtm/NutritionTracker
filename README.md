<div align="center">

# ⚡ NutriTrack
### Smart Nutrition & Fitness Tracker for Indian Food

[![Java](https://img.shields.io/badge/Java-ED8B00?style=for-the-badge&logo=openjdk&logoColor=white)](https://www.java.com)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)](https://www.postgresql.org)
[![Docker](https://img.shields.io/badge/Docker-2CA5E0?style=for-the-badge&logo=docker&logoColor=white)](https://www.docker.com)
[![Bootstrap](https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white)](https://getbootstrap.com)
[![Maven](https://img.shields.io/badge/Apache%20Maven-C71A36?style=for-the-badge&logo=Apache%20Maven&logoColor=white)](https://maven.apache.org)
[![Railway](https://img.shields.io/badge/Railway-131415?style=for-the-badge&logo=railway&logoColor=white)](https://railway.app)

**A fully deployed, production-grade full-stack Java web application for tracking nutrition and fitness — built specifically for Indian food.**

[🚀 Live Demo (Railway)](https://nutritiontracker-production-b76c.up.railway.app) · [🌐 Live Demo (Render)](https://nutritiontracker-7t7h.onrender.com) · [⭐ Star this repo](https://github.com/joshiianant2-lgtm/NutritionTracker)

</div>

---

## 📸 Screenshots

### 🔐 Login & Register
| Login | Register |
|-------|----------|
| ![Login](screenshots/login.png) | ![Register](screenshots/register.png) |

### 📊 Dashboard
![Dashboard](screenshots/dashboard.png)

### 🍽️ Log Meal — 56 Indian Food Items
![Log Meal](screenshots/logmeal.png)

### 🏃 Log Exercise
![Log Exercise](screenshots/logexercise.png)

### 👤 Profile Setup
![Profile](screenshots/profile.png)

### 📱 Mobile Responsive
![Mobile](screenshots/mobile.png)

---

## ✨ Features

- 🔐 **Secure Authentication** — BCrypt password hashing, session-based auth
- 📊 **Smart Dashboard** — Real-time calories consumed, burned, net calories, macro tracking
- 🍽️ **Indian Food Database** — 56 authentic Indian food items across 10 categories (Breads, Dal, Paneer, Rice, South Indian, Non-Veg, Breakfast, Sabzi, Dairy, Snacks, Fruits)
- 🏃 **Exercise Logging** — 8 activities (Running, Walking, Cycling, Swimming, Weights, Yoga, Jump Rope, HIIT) with intensity levels
- 🎯 **Personalized Calorie Targets** — Mifflin-St Jeor BMR equation with goal-based adjustment (Weight Loss / Maintenance / Muscle Gain)
- 📈 **Macro Tracking** — Protein, Carbs, Fat targets calculated from your profile
- 📱 **Mobile Responsive** — Works perfectly on all screen sizes
- 🌐 **Production Deployed** — Live on Railway and Render with Docker

---

## 🛠️ Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| **Language** | Java 17 | Strongly typed, enterprise standard |
| **Web Layer** | Java Servlets + JSP | Core fundamentals without framework abstraction |
| **Database** | PostgreSQL | Production-grade, cloud-compatible |
| **DB Access** | JDBC | Direct SQL, full control |
| **Security** | BCrypt | Industry-standard password hashing |
| **Build** | Apache Maven | Dependency management, WAR packaging |
| **Server** | Apache Tomcat 10.1 | Jakarta EE servlet container |
| **Container** | Docker (multi-stage) | Consistent deployment anywhere |
| **Frontend** | Bootstrap 5 + Custom CSS | Responsive UI with dark theme |
| **Hosting** | Railway + Render | Free tier cloud deployment |

> **No Spring Boot** — Built with raw Servlets and JDBC to deeply understand how Java web applications work at the fundamental level.

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                        BROWSER                              │
│              (JSP Pages — View Layer)                       │
└──────────────────────┬──────────────────────────────────────┘
                       │ HTTP Request
┌──────────────────────▼──────────────────────────────────────┐
│                   TOMCAT SERVER                             │
│            (Servlet Container)                              │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              SERVLETS (Controller Layer)             │   │
│  │  RegisterServlet  LoginServlet  LogMealServlet       │   │
│  │  LogExerciseServlet  ProfileServlet  LogoutServlet   │   │
│  └──────────────────────┬──────────────────────────────┘   │
│                         │                                   │
│  ┌──────────────────────▼──────────────────────────────┐   │
│  │                DAO Layer                             │   │
│  │  UserDAO  MealDAO  ExerciseDAO  UserProfileDAO       │   │
│  └──────────────────────┬──────────────────────────────┘   │
└─────────────────────────┼───────────────────────────────────┘
                          │ JDBC
┌─────────────────────────▼───────────────────────────────────┐
│                   PostgreSQL Database                        │
│   users │ user_profiles │ food_items │ meal_logs │           │
│   exercise_logs                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 🗄️ Database Schema

```sql
-- Users table
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL  -- BCrypt hash
);

-- User profiles table
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    age INTEGER,
    weight DOUBLE PRECISION,   -- kg
    height DOUBLE PRECISION,   -- cm
    goal VARCHAR(50),          -- Weight Loss / Maintenance / Muscle Gain
    diet_preference VARCHAR(50),
    fitness_level VARCHAR(50)
);

-- Food items table (56 Indian foods pre-loaded)
CREATE TABLE food_items (
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
CREATE TABLE meal_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    food_id INTEGER REFERENCES food_items(id),
    quantity_grams DOUBLE PRECISION,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Exercise logs table
CREATE TABLE exercise_logs (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id),
    activity VARCHAR(100),
    duration_mins INTEGER,
    calories_burned DOUBLE PRECISION,
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 📁 Project Structure

```
NutritionTracker/
├── src/
│   └── main/
│       ├── java/
│       │   └── com/nutrition/
│       │       ├── dao/
│       │       │   ├── DBConnection.java       # PostgreSQL connection with SSL handling
│       │       │   ├── UserDAO.java            # User CRUD operations
│       │       │   ├── MealDAO.java            # Meal logging and queries
│       │       │   ├── ExerciseDAO.java        # Exercise logging and queries
│       │       │   └── UserProfileDAO.java     # Profile CRUD operations
│       │       ├── model/
│       │       │   ├── User.java
│       │       │   ├── UserProfile.java
│       │       │   ├── MealLog.java
│       │       │   └── ExerciseLog.java
│       │       └── servlet/
│       │           ├── RegisterServlet.java
│       │           ├── LoginServlet.java
│       │           ├── LogoutServlet.java
│       │           ├── LogMealServlet.java
│       │           ├── LogExerciseServlet.java
│       │           └── ProfileServlet.java
│       └── webapp/
│           ├── dashboard.jsp
│           ├── login.jsp
│           ├── register.jsp
│           ├── logMeal.jsp
│           ├── logExercise.jsp
│           └── profile.jsp
├── schema.sql                                  # Database setup script
├── pom.xml                                     # Maven dependencies
└── Dockerfile                                  # Multi-stage Docker build
```

---

## 🧮 Calorie Calculation Logic

### BMR (Basal Metabolic Rate)
Uses the **Mifflin-St Jeor equation** — the same formula used by professional nutritionists:
```
BMR = (10 × weight_kg) + (6.25 × height_cm) - (5 × age) + 5
```

### Daily Calorie Target
```
Weight Loss  → BMR - 500 kcal (calorie deficit)
Maintenance  → BMR           (maintenance)
Muscle Gain  → BMR + 500 kcal (calorie surplus)
```

### Macro Targets
```
Protein  = weight × 1.6g (maintenance) to weight × 2.2g (muscle gain)
Fat      = 25-30% of total calories ÷ 9
Carbs    = remaining calories ÷ 4
```

### Net Calories
```
Net Calories = Consumed - Burned
Remaining    = Target - Consumed + Burned
```

---

## 🚀 Local Setup

### Prerequisites
- Java 17+
- Maven 3.8+
- PostgreSQL 14+
- Apache Tomcat 10.1

### 1. Clone the repository
```bash
git clone https://github.com/joshiianant2-lgtm/NutritionTracker.git
cd NutritionTracker
```

### 2. Set up PostgreSQL database
```bash
psql -U postgres
CREATE DATABASE nutritiontracker;
\c nutritiontracker
\i schema.sql
```

### 3. Set environment variable
```bash
# Windows
set DATABASE_URL=postgresql://username:password@localhost:5432/nutritiontracker

# Mac/Linux
export DATABASE_URL=postgresql://username:password@localhost:5432/nutritiontracker
```

### 4. Build with Maven
```bash
mvn clean package -DskipTests
```

### 5. Deploy WAR to Tomcat
Copy `target/NutritionTracker.war` to your Tomcat `webapps/ROOT.war`

### 6. Start Tomcat and visit
```
http://localhost:8080
```

---

## 🐳 Docker Setup

```bash
# Build Docker image
docker build -t nutritrack .

# Run container
docker run -p 8080:8080 \
  -e DATABASE_URL=postgresql://user:pass@host:5432/db \
  nutritrack
```

### Dockerfile (Multi-stage build)
```dockerfile
# Stage 1: Build WAR with Maven
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

# Stage 2: Run on Tomcat
FROM tomcat:10.1-jdk17
COPY --from=build /app/target/NutritionTracker.war /usr/local/tomcat/webapps/ROOT.war
EXPOSE 8080
CMD ["catalina.sh", "run"]
```

---

## ☁️ Deployment

The app is deployed on **two platforms simultaneously**:

### Railway (Primary — Faster)
- App and database in same region (US East)
- No cold starts, always on
- Auto-deploys from GitHub on every push

### Render (Backup — Free Forever)
- Free tier with UptimeRobot keeping it awake
- PostgreSQL database (free tier)
- Auto-deploys from GitHub on every push

### Key DBConnection.java Implementation
One of the trickiest parts — handling different URL formats and SSL requirements across platforms:
```java
URI uri = new URI(dbUrl);
// Extract host, port, credentials separately
// Enable SSL for Render, disable for Railway internal network
if (!host.contains("railway.internal")) {
    props.setProperty("sslmode", "require");
    props.setProperty("sslfactory", "org.postgresql.ssl.NonValidatingFactory");
} else {
    props.setProperty("sslmode", "disable");
}
```

---

## 🔮 Future Scope

- [ ] **Spring Boot Migration** — Replace Servlets with Spring MVC, JDBC with Spring Data JPA
- [ ] **REST API** — JSON endpoints for mobile app integration
- [ ] **React Native Mobile App** — Android and iOS support
- [ ] **Food Barcode Scanner** — Open Food Facts API integration
- [ ] **AI Food Recognition** — Photo-based meal logging using Claude/Vision API
- [ ] **Charts & Analytics** — Weekly/monthly trends with Chart.js
- [ ] **Weight Progress Tracker** — Weight history with line charts
- [ ] **Water Intake Tracking** — Daily hydration monitoring
- [ ] **Meal Planning** — Weekly meal planner with shopping list
- [ ] **Push Notifications** — Meal reminders and daily summaries
- [ ] **Microservices Architecture** — Split into independent services with Redis caching

---

## 🧑‍💻 Author

**Anant Joshi**

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/joshiianant2-lgtm)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/YOUR_LINKEDIN)

---

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

<div align="center">

**⭐ If you found this project helpful, please give it a star!**

Built with ❤️ using Java, PostgreSQL, Docker — no shortcuts, just fundamentals.

</div>
