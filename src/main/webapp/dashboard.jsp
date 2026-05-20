<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.nutrition.model.User" %>
<%@ page import="com.nutrition.model.UserProfile" %>
<%@ page import="com.nutrition.dao.MealDAO" %>
<%@ page import="com.nutrition.dao.ExerciseDAO" %>
<%@ page import="com.nutrition.dao.UserProfileDAO" %>
<%@ page import="com.nutrition.model.MealLog" %>
<%@ page import="com.nutrition.model.ExerciseLog" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dashboard - NutriTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0a0f;
            --surface: #13131a;
            --surface2: #1c1c27;
            --border: rgba(255,255,255,0.07);
            --green: #00e676;
            --green-dim: rgba(0,230,118,0.1);
            --red: #ff4f4f;
            --red-dim: rgba(255,79,79,0.1);
            --blue: #4f8eff;
            --blue-dim: rgba(79,142,255,0.1);
            --orange: #ffb347;
            --orange-dim: rgba(255,179,71,0.1);
            --pink: #ff7eb3;
            --pink-dim: rgba(255,126,179,0.1);
            --text: #f0f0f8;
            --muted: #6b6b80;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: var(--bg); font-family: 'DM Sans', sans-serif; color: var(--text); min-height: 100vh; }

        /* NAVBAR */
        .navbar {
            background: rgba(10,10,15,0.85);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 1rem 2rem;
            position: sticky; top: 0; z-index: 100;
        }
        .navbar-brand { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.3rem; color: var(--green) !important; letter-spacing: -0.5px; }
        .welcome-text { color: var(--muted); font-size: 0.9rem; }
        .btn-nav {
            background: transparent; border: 1px solid var(--border); color: var(--muted);
            padding: 0.4rem 1rem; border-radius: 8px; font-size: 0.85rem; transition: all 0.2s; text-decoration: none; cursor: pointer;
        }
        .btn-nav:hover { border-color: var(--green); color: var(--green); }
        .btn-nav.logout:hover { border-color: var(--red); color: var(--red); }

        .main { max-width: 1200px; margin: 0 auto; padding: 2rem 1.5rem; }
        .page-title { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.8rem; margin-bottom: 0.3rem; }
        .page-subtitle { color: var(--muted); font-size: 0.9rem; margin-bottom: 2rem; }

        /* STAT CARDS */
        .stat-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1.2rem; margin-bottom: 1.5rem; }
        .stat-card {
            background: var(--surface); border: 1px solid var(--border); border-radius: 16px;
            padding: 1.5rem; position: relative; overflow: hidden; transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-2px); }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px; }
        .stat-card.green::before { background: var(--green); }
        .stat-card.red::before { background: var(--red); }
        .stat-card.blue::before { background: var(--blue); }
        .stat-icon { font-size: 1.5rem; margin-bottom: 0.8rem; }
        .stat-label { color: var(--muted); font-size: 0.8rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.5rem; }
        .stat-value { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 2.5rem; line-height: 1; margin-bottom: 0.3rem; }
        .stat-card.green .stat-value { color: var(--green); }
        .stat-card.red .stat-value { color: var(--red); }
        .stat-card.blue .stat-value { color: var(--blue); }
        .stat-unit { color: var(--muted); font-size: 0.8rem; }
        .stat-badge { display: inline-block; padding: 0.2rem 0.6rem; border-radius: 20px; font-size: 0.75rem; margin-top: 0.5rem; }
        .badge-green { background: var(--green-dim); color: var(--green); }
        .badge-red { background: var(--red-dim); color: var(--red); }
        .badge-blue { background: var(--blue-dim); color: var(--blue); }

        /* CALORIE TARGET */
        .target-card {
            background: var(--surface); border: 1px solid var(--border); border-radius: 16px;
            padding: 1.5rem; margin-bottom: 1.5rem; position: relative; overflow: hidden;
        }
        .target-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px; background: linear-gradient(90deg, var(--green), var(--blue)); }
        .target-header { display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; }
        .target-title { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1rem; }
        .target-numbers { font-size: 0.85rem; color: var(--muted); }
        .progress-bar-wrap { background: var(--surface2); border-radius: 20px; height: 10px; overflow: hidden; margin-bottom: 0.6rem; }
        .progress-bar-fill { height: 100%; border-radius: 20px; transition: width 0.8s ease; }
        .progress-bar-fill.on-track { background: linear-gradient(90deg, #00e676, #00ff88); }
        .progress-bar-fill.over { background: linear-gradient(90deg, var(--orange), var(--red)); }
        .progress-bar-fill.under { background: linear-gradient(90deg, var(--blue), #7eb8ff); }
        .progress-labels { display: flex; justify-content: space-between; font-size: 0.75rem; color: var(--muted); }
        .progress-labels .pct.on-track { color: var(--green); }
        .progress-labels .pct.over { color: var(--red); }
        .progress-labels .pct.under { color: var(--blue); }

        /* MACRO CARDS */
        .macro-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 1.5rem; }
        .macro-card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 1.2rem; text-align: center; position: relative; overflow: hidden; }
        .macro-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px; }
        .macro-card.protein::before { background: var(--blue); }
        .macro-card.carbs::before { background: var(--orange); }
        .macro-card.fat::before { background: var(--pink); }
        .macro-value { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.6rem; margin-bottom: 0.2rem; }
        .macro-card.protein .macro-value { color: var(--blue); }
        .macro-card.carbs .macro-value { color: var(--orange); }
        .macro-card.fat .macro-value { color: var(--pink); }
        .macro-label { color: var(--muted); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.6rem; }
        .macro-bar-wrap { background: var(--surface2); border-radius: 10px; height: 5px; overflow: hidden; }
        .macro-bar-fill { height: 100%; border-radius: 10px; transition: width 0.8s ease; }
        .macro-card.protein .macro-bar-fill { background: var(--blue); }
        .macro-card.carbs .macro-bar-fill { background: var(--orange); }
        .macro-card.fat .macro-bar-fill { background: var(--pink); }
        .macro-target { font-size: 0.72rem; color: var(--muted); margin-top: 0.4rem; }

        /* ACTION CARDS */
        .action-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-bottom: 2rem; }
        .action-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 1.5rem; display: flex; align-items: center; justify-content: space-between; transition: all 0.2s; text-decoration: none; }
        .action-card:hover { border-color: rgba(255,255,255,0.15); transform: translateY(-2px); background: var(--surface2); }
        .action-info h5 { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.1rem; color: var(--text); margin-bottom: 0.3rem; }
        .action-info p { color: var(--muted); font-size: 0.85rem; margin: 0; }
        .action-btn-green { background: var(--green-dim); color: var(--green); border: 1px solid rgba(0,230,118,0.2); padding: 0.5rem 1.2rem; border-radius: 8px; font-size: 0.85rem; font-weight: 500; white-space: nowrap; }
        .action-btn-red { background: var(--red-dim); color: var(--red); border: 1px solid rgba(255,79,79,0.2); padding: 0.5rem 1.2rem; border-radius: 8px; font-size: 0.85rem; font-weight: 500; white-space: nowrap; }

        /* TABLES */
        .table-card { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 1.5rem; margin-bottom: 1.5rem; }
        .table-title { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.1rem; margin-bottom: 1.2rem; display: flex; align-items: center; gap: 0.5rem; }
        .custom-table { width: 100%; border-collapse: collapse; }
        .custom-table th { color: var(--muted); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; padding: 0.6rem 1rem; border-bottom: 1px solid var(--border); font-weight: 500; text-align: left; }
        .custom-table td { padding: 0.9rem 1rem; border-bottom: 1px solid var(--border); font-size: 0.9rem; color: var(--text); }
        .custom-table tr:last-child td { border-bottom: none; }
        .custom-table tr:hover td { background: var(--surface2); }
        .empty-text { color: var(--muted); font-size: 0.9rem; text-align: center; padding: 2rem; }
        .cal-pill { background: var(--green-dim); color: var(--green); padding: 0.2rem 0.6rem; border-radius: 6px; font-size: 0.8rem; }
        .burn-pill { background: var(--red-dim); color: var(--red); padding: 0.2rem 0.6rem; border-radius: 6px; font-size: 0.8rem; }

        /* LOGOUT MODAL */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.7); backdrop-filter: blur(4px);
            z-index: 999; align-items: center; justify-content: center;
        }
        .modal-overlay.show { display: flex; }
        .modal-box {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 20px; padding: 2rem; max-width: 380px; width: 90%;
            text-align: center; animation: fadeUp 0.3s ease both;
        }
        .modal-icon { font-size: 2.5rem; margin-bottom: 1rem; }
        .modal-title { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.2rem; margin-bottom: 0.5rem; }
        .modal-subtitle { color: var(--muted); font-size: 0.88rem; margin-bottom: 1.5rem; }
        .modal-buttons { display: flex; gap: 0.8rem; }
        .btn-cancel { flex: 1; background: var(--surface2); border: 1px solid var(--border); color: var(--muted); padding: 0.7rem; border-radius: 10px; cursor: pointer; font-family: 'DM Sans', sans-serif; font-size: 0.9rem; transition: all 0.2s; }
        .btn-cancel:hover { border-color: var(--border); color: var(--text); }
        .btn-confirm-logout { flex: 1; background: var(--red); border: none; color: white; padding: 0.7rem; border-radius: 10px; cursor: pointer; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 0.9rem; transition: all 0.2s; text-decoration: none; display: flex; align-items: center; justify-content: center; }
        .btn-confirm-logout:hover { background: #ff6b6b; }

        /* ANIMATIONS */
        @keyframes fadeUp { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
        .stat-card { animation: fadeUp 0.4s ease both; }
        .stat-card:nth-child(1) { animation-delay: 0.1s; }
        .stat-card:nth-child(2) { animation-delay: 0.2s; }
        .stat-card:nth-child(3) { animation-delay: 0.3s; }
        .target-card { animation: fadeUp 0.4s ease 0.35s both; }
        .macro-card { animation: fadeUp 0.4s ease both; }
        .macro-card:nth-child(1) { animation-delay: 0.4s; }
        .macro-card:nth-child(2) { animation-delay: 0.45s; }
        .macro-card:nth-child(3) { animation-delay: 0.5s; }
        .table-card { animation: fadeUp 0.4s ease 0.5s both; }
    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }

    MealDAO mealDAO = new MealDAO();
    ExerciseDAO exerciseDAO = new ExerciseDAO();
    UserProfileDAO profileDAO = new UserProfileDAO();

    double caloriesIn  = mealDAO.getTotalCaloriesToday(user.getId());
    double caloriesOut = exerciseDAO.getTotalCaloriesBurnedToday(user.getId());
    double netCalories = caloriesIn - caloriesOut;

    double[] macros = mealDAO.getTotalMacrosToday(user.getId());
    double totalProtein = macros[0];
    double totalCarbs   = macros[1];
    double totalFat     = macros[2];

    UserProfile profile = profileDAO.getProfile(user.getId());
    double calorieTarget = 0;
    double proteinTarget = 0;
    double carbsTarget   = 0;
    double fatTarget     = 0;
    boolean hasProfile   = false;

    if (profile != null) {
        hasProfile = true;
        double bmr = (10 * profile.getWeight()) + (6.25 * profile.getHeight()) - (5 * profile.getAge()) + 5;
        String goal = profile.getGoal();
        if ("Weight Loss".equals(goal))      calorieTarget = bmr - 500;
        else if ("Muscle Gain".equals(goal)) calorieTarget = bmr + 500;
        else                                 calorieTarget = bmr;

        if ("Weight Loss".equals(goal)) {
            proteinTarget = profile.getWeight() * 2.0;
            fatTarget     = calorieTarget * 0.25 / 9;
            carbsTarget   = (calorieTarget - (proteinTarget * 4) - (fatTarget * 9)) / 4;
        } else if ("Muscle Gain".equals(goal)) {
            proteinTarget = profile.getWeight() * 2.2;
            fatTarget     = calorieTarget * 0.28 / 9;
            carbsTarget   = (calorieTarget - (proteinTarget * 4) - (fatTarget * 9)) / 4;
        } else {
            proteinTarget = profile.getWeight() * 1.6;
            fatTarget     = calorieTarget * 0.30 / 9;
            carbsTarget   = (calorieTarget - (proteinTarget * 4) - (fatTarget * 9)) / 4;
        }
    }

    int progressPct = 0;
    String progressClass = "on-track";
    String balanceLabel;

    if (hasProfile && calorieTarget > 0) {
        // FIX: Use netCalories (consumed - burned) for progress, not just consumed
        progressPct = (int) Math.min(Math.max((netCalories / calorieTarget) * 100, 0), 100);
        if (netCalories > calorieTarget * 1.1)      { progressClass = "over";     balanceLabel = "Over Target"; }
        else if (netCalories < calorieTarget * 0.5) { progressClass = "under";    balanceLabel = "Under Target"; }
        else                                         { progressClass = "on-track"; balanceLabel = "On Track"; }
    } else {
        if (netCalories > 200)       balanceLabel = "Calorie Surplus";
        else if (netCalories < -200) balanceLabel = "Calorie Deficit";
        else                         balanceLabel = "Maintenance";
    }

    int proteinPct = proteinTarget > 0 ? (int) Math.min((totalProtein / proteinTarget) * 100, 100) : 0;
    int carbsPct   = carbsTarget   > 0 ? (int) Math.min((totalCarbs   / carbsTarget)   * 100, 100) : 0;
    int fatPct     = fatTarget     > 0 ? (int) Math.min((totalFat     / fatTarget)     * 100, 100) : 0;

    // FIX: remaining = target - consumed + burned (exercise calories add back to budget)
    double remaining = calorieTarget - caloriesIn + caloriesOut;

    List<MealLog> meals         = mealDAO.getTodayMeals(user.getId());
    List<ExerciseLog> exercises = exerciseDAO.getTodayExercises(user.getId());

    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("EEE MMM d");
    String today = sdf.format(new java.util.Date());
%>

<!-- LOGOUT CONFIRMATION MODAL -->
<div class="modal-overlay" id="logoutModal">
    <div class="modal-box">
        <div class="modal-icon">👋</div>
        <div class="modal-title">Logging out?</div>
        <div class="modal-subtitle">You'll need to sign in again to access your dashboard.</div>
        <div class="modal-buttons">
            <button class="btn-cancel" onclick="closeLogoutModal()">Stay</button>
            <a href="logout" class="btn-confirm-logout">Yes, Logout</a>
        </div>
    </div>
</div>

<nav class="navbar d-flex align-items-center justify-content-between">
    <span class="navbar-brand">⚡ NutriTrack</span>
    <div class="d-flex align-items-center gap-3">
        <span class="welcome-text">Hey, <%= user.getName() %> 👋</span>
        <a href="profile.jsp" class="btn-nav">Profile</a>
        <button class="btn-nav logout" onclick="showLogoutModal()">Logout</button>
    </div>
</nav>

<div class="main">
    <h1 class="page-title">Today's Overview</h1>
    <p class="page-subtitle">Track your nutrition and fitness for <%= today %></p>

    <!-- STAT CARDS -->
    <div class="stat-grid">
        <div class="stat-card green">
            <div class="stat-icon">🥗</div>
            <div class="stat-label">Calories Consumed</div>
            <div class="stat-value"><%= String.format("%.0f", caloriesIn) %></div>
            <div class="stat-unit">kcal today</div>
            <span class="stat-badge badge-green"><%= meals.size() %> meal<%= meals.size() != 1 ? "s" : "" %> logged</span>
        </div>
        <div class="stat-card red">
            <div class="stat-icon">🔥</div>
            <div class="stat-label">Calories Burned</div>
            <div class="stat-value"><%= String.format("%.0f", caloriesOut) %></div>
            <div class="stat-unit">kcal today</div>
            <span class="stat-badge badge-red"><%= exercises.size() %> exercise<%= exercises.size() != 1 ? "s" : "" %> logged</span>
        </div>
        <div class="stat-card blue">
            <div class="stat-icon">⚖️</div>
            <div class="stat-label">Net Calories</div>
            <div class="stat-value"><%= String.format("%.0f", netCalories) %></div>
            <div class="stat-unit">kcal balance</div>
            <span class="stat-badge <%= progressClass.equals("over") ? "badge-red" : progressClass.equals("under") ? "badge-blue" : "badge-green" %>"><%= balanceLabel %></span>
        </div>
    </div>

    <!-- CALORIE TARGET PROGRESS -->
    <div class="target-card">
        <div class="target-header">
            <div class="target-title">🎯 Daily Calorie Target</div>
            <% if (hasProfile) { %>
                <div class="target-numbers">
                    <%-- Show net calories vs target (consumed - burned) --%>
                    <span style="color:var(--green);"><%= String.format("%.0f", netCalories) %></span>
                    <span style="color:var(--muted);"> / </span>
                    <span><%= String.format("%.0f", calorieTarget) %> kcal</span>
                    <% if (remaining > 0) { %>
                        &nbsp;·&nbsp;<span style="color:var(--green);"><%= String.format("%.0f", remaining) %> remaining</span>
                    <% } else { %>
                        &nbsp;·&nbsp;<span style="color:var(--red);"><%= String.format("%.0f", Math.abs(remaining)) %> over</span>
                    <% } %>
                </div>
            <% } else { %>
                <div style="font-size:0.82rem;color:var(--muted);">Set profile to see target</div>
            <% } %>
        </div>
        <div class="progress-bar-wrap">
            <div class="progress-bar-fill <%= progressClass %>" style="width:<%= hasProfile ? progressPct : 0 %>%"></div>
        </div>
        <div class="progress-labels">
            <span>0</span>
            <% if (hasProfile) { %>
                <span class="pct <%= progressClass %>"><%= progressPct %>% of daily goal</span>
            <% } else { %>
                <span><a href="profile.jsp" style="color:var(--blue);">Complete your profile to see targets →</a></span>
            <% } %>
            <span><%= hasProfile ? String.format("%.0f", calorieTarget) : "—" %></span>
        </div>
    </div>

    <!-- MACRO SUMMARY -->
    <div class="macro-grid">
        <div class="macro-card protein">
            <div class="macro-label">Protein</div>
            <div class="macro-value"><%= String.format("%.0f", totalProtein) %>g</div>
            <div class="macro-bar-wrap"><div class="macro-bar-fill" style="width:<%= proteinPct %>%"></div></div>
            <div class="macro-target"><% if (hasProfile) { %>Target: <%= String.format("%.0f", proteinTarget) %>g · <%= proteinPct %>%<% } else { %>Set profile for targets<% } %></div>
        </div>
        <div class="macro-card carbs">
            <div class="macro-label">Carbs</div>
            <div class="macro-value"><%= String.format("%.0f", totalCarbs) %>g</div>
            <div class="macro-bar-wrap"><div class="macro-bar-fill" style="width:<%= carbsPct %>%"></div></div>
            <div class="macro-target"><% if (hasProfile) { %>Target: <%= String.format("%.0f", carbsTarget) %>g · <%= carbsPct %>%<% } else { %>Set profile for targets<% } %></div>
        </div>
        <div class="macro-card fat">
            <div class="macro-label">Fat</div>
            <div class="macro-value"><%= String.format("%.0f", totalFat) %>g</div>
            <div class="macro-bar-wrap"><div class="macro-bar-fill" style="width:<%= fatPct %>%"></div></div>
            <div class="macro-target"><% if (hasProfile) { %>Target: <%= String.format("%.0f", fatTarget) %>g · <%= fatPct %>%<% } else { %>Set profile for targets<% } %></div>
        </div>
    </div>

    <!-- ACTION CARDS -->
    <div class="action-grid">
        <a href="logMeal.jsp" class="action-card">
            <div class="action-info">
                <h5>🍽️ Log a Meal</h5>
                <p>Track what you ate today</p>
            </div>
            <span class="action-btn-green">+ Add Meal</span>
        </a>
        <a href="logExercise.jsp" class="action-card">
            <div class="action-info">
                <h5>🏃 Log Exercise</h5>
                <p>Track your workout today</p>
            </div>
            <span class="action-btn-red">+ Add Exercise</span>
        </a>
    </div>

    <!-- MEALS TABLE -->
    <div class="table-card">
        <div class="table-title">🍽️ Today's Meals</div>
        <% if (meals.isEmpty()) { %>
            <p class="empty-text">No meals logged yet. <a href="logMeal.jsp" style="color:var(--green)">Log your first meal →</a></p>
        <% } else { %>
        <table class="custom-table">
            <thead>
                <tr>
                    <th>Food</th>
                    <th>Quantity</th>
                    <th>Calories</th>
                    <th>Protein</th>
                    <th>Carbs</th>
                    <th>Fat</th>
                </tr>
            </thead>
            <tbody>
                <% for (MealLog meal : meals) { %>
                <tr>
                    <td><strong><%= meal.getFoodName() %></strong></td>
                    <td><%= meal.getServingDisplay() != null ? meal.getServingDisplay() : String.format("%.0f", meal.getQuantityGrams()) + "g" %></td>
                    <td><span class="cal-pill"><%= String.format("%.0f", meal.getCalories()) %> kcal</span></td>
                    <td><%= String.format("%.1f", meal.getProtein()) %>g</td>
                    <td><%= String.format("%.1f", meal.getCarbs()) %>g</td>
                    <td><%= String.format("%.1f", meal.getFat()) %>g</td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>

    <!-- EXERCISE TABLE -->
    <div class="table-card">
        <div class="table-title">🏃 Today's Exercises</div>
        <% if (exercises.isEmpty()) { %>
            <p class="empty-text">No exercises logged yet. <a href="logExercise.jsp" style="color:var(--red)">Log your first workout →</a></p>
        <% } else { %>
        <table class="custom-table">
            <thead>
                <tr>
                    <th>Activity</th>
                    <th>Duration</th>
                    <th>Calories Burned</th>
                </tr>
            </thead>
            <tbody>
                <% for (ExerciseLog exercise : exercises) { %>
                <tr>
                    <td><strong><%= exercise.getActivity() %></strong></td>
                    <td><%= exercise.getDurationMins() %> mins</td>
                    <td><span class="burn-pill"><%= String.format("%.0f", exercise.getCaloriesBurned()) %> kcal</span></td>
                </tr>
                <% } %>
            </tbody>
        </table>
        <% } %>
    </div>
</div>

<script>
    function showLogoutModal() {
        document.getElementById('logoutModal').classList.add('show');
    }
    function closeLogoutModal() {
        document.getElementById('logoutModal').classList.remove('show');
    }
    // Close modal if clicking outside
    document.getElementById('logoutModal').addEventListener('click', function(e) {
        if (e.target === this) closeLogoutModal();
    });
</script>

</body>
</html>
