<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.nutrition.model.User" %>
<%@ page import="com.nutrition.model.UserProfile" %>
<%@ page import="com.nutrition.dao.UserProfileDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Profile - NutriTrack</title>
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
            --blue: #4f8eff;
            --blue-dim: rgba(79,142,255,0.1);
            --text: #f0f0f8;
            --muted: #6b6b80;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: var(--bg);
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            min-height: 100vh;
        }

        .navbar {
            background: rgba(10,10,15,0.85);
            backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            padding: 1rem 2rem;
            position: sticky;
            top: 0;
            z-index: 100;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .navbar-brand {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.3rem;
            color: var(--green);
            text-decoration: none;
        }

        .nav-links { display: flex; gap: 0.8rem; }

        .btn-nav {
            background: transparent;
            border: 1px solid var(--border);
            color: var(--muted);
            padding: 0.4rem 1rem;
            border-radius: 8px;
            font-size: 0.85rem;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-nav:hover {
            border-color: var(--green);
            color: var(--green);
        }

        .main {
            max-width: 700px;
            margin: 3rem auto;
            padding: 0 1.5rem;
        }

        .page-title {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1.8rem;
            margin-bottom: 0.3rem;
        }

        .page-subtitle {
            color: var(--muted);
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }

        /* Stats row if profile exists */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-mini {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 1rem;
            text-align: center;
        }

        .stat-mini-label {
            color: var(--muted);
            font-size: 0.75rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.4rem;
        }

        .stat-mini-value {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1.4rem;
            color: var(--green);
        }

        .stat-mini-unit {
            color: var(--muted);
            font-size: 0.75rem;
        }

        /* Target card */
        .target-card {
            background: var(--green-dim);
            border: 1px solid rgba(0,230,118,0.2);
            border-radius: 12px;
            padding: 1.2rem 1.5rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .target-label {
            color: var(--muted);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
        }

        .target-value {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 2rem;
            color: var(--green);
        }

        .target-unit { color: var(--muted); font-size: 0.85rem; }

        .goal-badge {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 0.4rem 1rem;
            font-size: 0.85rem;
            color: var(--green);
        }

        /* Form card */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2rem;
            position: relative;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: var(--blue);
            border-radius: 20px 20px 0 0;
        }

        .card-title {
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1.1rem;
            margin-bottom: 1.5rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-label {
            color: var(--muted);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.5rem;
            display: block;
        }

        .form-control, .form-select {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            padding: 0.75rem 1rem;
            font-family: 'DM Sans', sans-serif;
            transition: all 0.2s;
            width: 100%;
        }

        .form-control:focus, .form-select:focus {
            background: var(--surface2);
            border-color: var(--blue);
            color: var(--text);
            box-shadow: 0 0 0 3px rgba(79,142,255,0.1);
            outline: none;
        }

        .form-select option {
            background: var(--surface2);
            color: var(--text);
        }

        .form-control::placeholder { color: var(--muted); }
        .mb-3 { margin-bottom: 1.2rem; }

        /* Option cards for goal selection */
        .option-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 0.8rem;
        }

        .option-item {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            padding: 0.8rem;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
        }

        .option-item:hover { border-color: var(--blue); }
        .option-item.selected { border-color: var(--blue); background: var(--blue-dim); }
        .option-emoji { font-size: 1.3rem; margin-bottom: 0.3rem; }
        .option-name { font-size: 0.75rem; color: var(--muted); }

        .btn-submit {
            background: var(--blue);
            color: white;
            border: none;
            border-radius: 10px;
            padding: 0.75rem;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1rem;
            width: 100%;
            transition: all 0.2s;
            cursor: pointer;
            margin-top: 1rem;
        }

        .btn-submit:hover {
            background: #6fa3ff;
            transform: translateY(-1px);
        }

        .alert-danger {
            background: rgba(255,79,79,0.1);
            border: 1px solid rgba(255,79,79,0.2);
            color: var(--red);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 0.85rem;
            margin-bottom: 1rem;
        }

        .alert-success {
            background: var(--green-dim);
            border: 1px solid rgba(0,230,118,0.2);
            color: var(--green);
            border-radius: 10px;
            padding: 0.75rem 1rem;
            font-size: 0.85rem;
            margin-bottom: 1rem;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .stats-row { animation: fadeUp 0.3s ease both; }
        .target-card { animation: fadeUp 0.4s ease both; }
        .card { animation: fadeUp 0.5s ease both; }
    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    if(user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserProfileDAO profileDAO = new UserProfileDAO();
    UserProfile profile = profileDAO.getProfile(user.getId());

    String error = request.getParameter("error");
    String success = request.getParameter("success");
%>

<nav class="navbar">
    <a href="dashboard.jsp" class="navbar-brand">⚡ NutriTrack</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="btn-nav">Dashboard</a>
        <a href="logout" class="btn-nav">Logout</a>
    </div>
</nav>

<div class="main">
    <h1 class="page-title">👤 Your Profile</h1>
    <p class="page-subtitle">Set your goals and personal details for accurate tracking</p>

    <% if(error != null) { %>
        <div class="alert-danger"><%= error %></div>
    <% } %>
    <% if(success != null) { %>
        <div class="alert-success">✅ Profile saved successfully!</div>
    <% } %>

    <!-- Show current stats if profile exists -->
    <% if(profile != null && profile.getWeight() > 0) { %>
    <div class="stats-row">
        <div class="stat-mini">
            <div class="stat-mini-label">Weight</div>
            <div class="stat-mini-value"><%= profile.getWeight() %></div>
            <div class="stat-mini-unit">kg</div>
        </div>
        <div class="stat-mini">
            <div class="stat-mini-label">Height</div>
            <div class="stat-mini-value"><%= profile.getHeight() %></div>
            <div class="stat-mini-unit">cm</div>
        </div>
        <div class="stat-mini">
            <div class="stat-mini-label">Age</div>
            <div class="stat-mini-value"><%= profile.getAge() %></div>
            <div class="stat-mini-unit">years</div>
        </div>
    </div>

    <div class="target-card">
        <div>
            <div class="target-label">Daily Calorie Target</div>
            <div class="target-value"><%= String.format("%.0f", profile.getDailyCalorieTarget()) %></div>
            <div class="target-unit">kcal / day based on your goal</div>
        </div>
        <span class="goal-badge"><%= profile.getGoal() %></span>
    </div>
    <% } %>

    <!-- Profile Form -->
    <div class="card">
        <div class="card-title">✏️ Edit Profile</div>

        <form action="saveProfile" method="post">
            <div class="form-row mb-3">
                <div>
                    <label class="form-label">Age</label>
                    <input type="number" name="age" class="form-control"
                           placeholder="e.g. 21" min="10" max="100" required
                           value="<%= profile != null ? profile.getAge() : "" %>">
                </div>
                <div>
                    <label class="form-label">Weight (kg)</label>
                    <input type="number" name="weight" class="form-control"
                           placeholder="e.g. 70" step="0.1" min="1" required
                           value="<%= profile != null ? profile.getWeight() : "" %>">
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label">Height (cm)</label>
                <input type="number" name="height" class="form-control"
                       placeholder="e.g. 175" step="0.1" min="1" required
                       value="<%= profile != null ? profile.getHeight() : "" %>">
            </div>

            <div class="mb-3">
                <label class="form-label">Fitness Goal</label>
                <div class="option-grid">
                    <div class="option-item <%= profile != null && "Weight Loss".equals(profile.getGoal()) ? "selected" : "" %>"
                         onclick="selectOption('goal', 'Weight Loss', this)">
                        <div class="option-emoji">🔥</div>
                        <div class="option-name">Weight Loss</div>
                    </div>
                    <div class="option-item <%= profile != null && "Maintenance".equals(profile.getGoal()) ? "selected" : "" %>"
                         onclick="selectOption('goal', 'Maintenance', this)">
                        <div class="option-emoji">⚖️</div>
                        <div class="option-name">Maintenance</div>
                    </div>
                    <div class="option-item <%= profile != null && "Muscle Gain".equals(profile.getGoal()) ? "selected" : "" %>"
                         onclick="selectOption('goal', 'Muscle Gain', this)">
                        <div class="option-emoji">💪</div>
                        <div class="option-name">Muscle Gain</div>
                    </div>
                </div>
                <input type="hidden" name="goal" id="goalInput"
                       value="<%= profile != null ? profile.getGoal() : "" %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Diet Preference</label>
                <div class="option-grid">
                    <div class="option-item <%= profile != null && "Vegetarian".equals(profile.getDietPreference()) ? "selected" : "" %>"
                         onclick="selectOption('diet', 'Vegetarian', this)">
                        <div class="option-emoji">🥦</div>
                        <div class="option-name">Vegetarian</div>
                    </div>
                    <div class="option-item <%= profile != null && "Non-Vegetarian".equals(profile.getDietPreference()) ? "selected" : "" %>"
                         onclick="selectOption('diet', 'Non-Vegetarian', this)">
                        <div class="option-emoji">🍗</div>
                        <div class="option-name">Non-Veg</div>
                    </div>
                    <div class="option-item <%= profile != null && "Vegan".equals(profile.getDietPreference()) ? "selected" : "" %>"
                         onclick="selectOption('diet', 'Vegan', this)">
                        <div class="option-emoji">🌱</div>
                        <div class="option-name">Vegan</div>
                    </div>
                </div>
                <input type="hidden" name="dietPreference" id="dietInput"
                       value="<%= profile != null ? profile.getDietPreference() : "" %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Fitness Level</label>
                <div class="option-grid">
                    <div class="option-item <%= profile != null && "Beginner".equals(profile.getFitnessLevel()) ? "selected" : "" %>"
                         onclick="selectOption('fitness', 'Beginner', this)">
                        <div class="option-emoji">🌱</div>
                        <div class="option-name">Beginner</div>
                    </div>
                    <div class="option-item <%= profile != null && "Intermediate".equals(profile.getFitnessLevel()) ? "selected" : "" %>"
                         onclick="selectOption('fitness', 'Intermediate', this)">
                        <div class="option-emoji">⚡</div>
                        <div class="option-name">Intermediate</div>
                    </div>
                    <div class="option-item <%= profile != null && "Gym-Goer".equals(profile.getFitnessLevel()) ? "selected" : "" %>"
                         onclick="selectOption('fitness', 'Gym-Goer', this)">
                        <div class="option-emoji">🏋️</div>
                        <div class="option-name">Gym-Goer</div>
                    </div>
                </div>
                <input type="hidden" name="fitnessLevel" id="fitnessInput"
                       value="<%= profile != null ? profile.getFitnessLevel() : "" %>" required>
            </div>

            <button type="submit" class="btn-submit">Save Profile →</button>
        </form>
    </div>
</div>

<script>
    function selectOption(type, value, el) {
        const grids = {
            'goal': 'goalInput',
            'diet': 'dietInput',
            'fitness': 'fitnessInput'
        };
        // Deselect siblings
        el.parentElement.querySelectorAll('.option-item')
          .forEach(i => i.classList.remove('selected'));
        el.classList.add('selected');
        document.getElementById(grids[type]).value = value;
    }
</script>

</body>
</html>