<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.nutrition.model.User" %>
<%@ page import="com.nutrition.dao.MealDAO" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log Meal - NutriTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0a0f;
            --surface: #13131a;
            --surface2: #1c1c27;
            --surface3: #22222f;
            --border: rgba(255,255,255,0.07);
            --border-hover: rgba(255,255,255,0.15);
            --green: #00e676;
            --green-dim: rgba(0,230,118,0.1);
            --green-border: rgba(0,230,118,0.3);
            --red: #ff4f4f;
            --blue: #4f8eff;
            --text: #f0f0f8;
            --muted: #6b6b80;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: var(--bg); font-family: 'DM Sans', sans-serif; color: var(--text); min-height: 100vh; }

        .navbar { background: rgba(10,10,15,0.85); backdrop-filter: blur(20px); border-bottom: 1px solid var(--border); padding: 1rem 2rem; position: sticky; top: 0; z-index: 100; display: flex; align-items: center; justify-content: space-between; }
        .navbar-brand { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.3rem; color: var(--green); text-decoration: none; }
        .nav-links { display: flex; gap: 0.8rem; }
        .btn-nav { background: transparent; border: 1px solid var(--border); color: var(--muted); padding: 0.4rem 1rem; border-radius: 8px; font-size: 0.85rem; text-decoration: none; transition: all 0.2s; }
        .btn-nav:hover { border-color: var(--green); color: var(--green); }

        .main { max-width: 900px; margin: 2.5rem auto; padding: 0 1.5rem; }
        .page-title { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.8rem; margin-bottom: 0.3rem; }
        .page-subtitle { color: var(--muted); font-size: 0.9rem; margin-bottom: 2rem; }

        .alert-danger { background: rgba(255,79,79,0.1); border: 1px solid rgba(255,79,79,0.2); color: var(--red); border-radius: 10px; padding: 0.75rem 1rem; font-size: 0.85rem; margin-bottom: 1.2rem; }
        .alert-success { background: var(--green-dim); border: 1px solid rgba(0,230,118,0.2); color: var(--green); border-radius: 10px; padding: 0.75rem 1rem; font-size: 0.85rem; margin-bottom: 1.2rem; }

        .category-tabs { display: flex; gap: 0.5rem; flex-wrap: wrap; margin-bottom: 1.5rem; }
        .tab-btn { background: var(--surface); border: 1px solid var(--border); color: var(--muted); padding: 0.45rem 1rem; border-radius: 20px; font-size: 0.85rem; cursor: pointer; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
        .tab-btn:hover { border-color: var(--border-hover); color: var(--text); }
        .tab-btn.active { background: var(--green-dim); border-color: var(--green-border); color: var(--green); }

        .search-bar { position: relative; margin-bottom: 1.2rem; }
        .search-bar input { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; color: var(--text); padding: 0.75rem 1rem 0.75rem 2.8rem; font-family: 'DM Sans', sans-serif; font-size: 0.95rem; width: 100%; transition: all 0.2s; }
        .search-bar input:focus { outline: none; border-color: var(--green); box-shadow: 0 0 0 3px rgba(0,230,118,0.08); }
        .search-bar input::placeholder { color: var(--muted); }
        .search-icon { position: absolute; left: 0.9rem; top: 50%; transform: translateY(-50%); color: var(--muted); font-size: 1rem; }

        .food-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(175px, 1fr)); gap: 0.75rem; margin-bottom: 1.5rem; max-height: 420px; overflow-y: auto; padding-right: 4px; }
        .food-grid::-webkit-scrollbar { width: 4px; }
        .food-grid::-webkit-scrollbar-thumb { background: var(--border); border-radius: 4px; }

        .food-card { background: var(--surface); border: 1px solid var(--border); border-radius: 14px; padding: 1rem; cursor: pointer; transition: all 0.2s; position: relative; user-select: none; }
        .food-card:hover { border-color: var(--border-hover); background: var(--surface2); transform: translateY(-2px); }
        .food-card.selected { border-color: var(--green); background: var(--green-dim); }
        .food-card.selected::after { content: '✓'; position: absolute; top: 0.6rem; right: 0.7rem; color: var(--green); font-weight: 700; font-size: 0.9rem; }
        .food-card-name { font-family: 'Syne', sans-serif; font-weight: 600; font-size: 0.88rem; margin-bottom: 0.4rem; line-height: 1.3; }
        .food-card-serving { color: var(--muted); font-size: 0.75rem; margin-bottom: 0.5rem; line-height: 1.3; }
        .food-card-cals { color: var(--green); font-size: 0.82rem; font-weight: 500; }
        .food-card.hidden { display: none; }

        .serving-section { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 1.5rem; margin-bottom: 1.2rem; display: none; animation: fadeUp 0.3s ease both; }
        .serving-section.visible { display: block; }
        .selected-food-name { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.1rem; margin-bottom: 0.2rem; color: var(--green); }
        .selected-food-serving-info { color: var(--muted); font-size: 0.82rem; margin-bottom: 1.2rem; }

        .serving-controls { display: flex; align-items: center; gap: 0.75rem; margin-bottom: 1.2rem; }
        .serving-btn { background: var(--surface2); border: 1px solid var(--border); color: var(--text); width: 40px; height: 40px; border-radius: 10px; font-size: 1.3rem; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; flex-shrink: 0; }
        .serving-btn:hover { border-color: var(--green); color: var(--green); }
        .serving-input-wrap { flex: 1; }
        .serving-label { color: var(--muted); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.3rem; }
        .serving-input { background: var(--surface2); border: 1px solid var(--border); border-radius: 10px; color: var(--text); padding: 0.6rem 0.9rem; font-family: 'DM Sans', sans-serif; font-size: 1rem; width: 100%; transition: all 0.2s; }
        .serving-input:focus { outline: none; border-color: var(--green); box-shadow: 0 0 0 3px rgba(0,230,118,0.08); }

        .quick-servings { display: flex; gap: 0.5rem; margin-bottom: 1.2rem; flex-wrap: wrap; }
        .quick-serving-btn { background: var(--surface2); border: 1px solid var(--border); color: var(--muted); padding: 0.35rem 0.8rem; border-radius: 8px; font-size: 0.8rem; cursor: pointer; transition: all 0.15s; }
        .quick-serving-btn:hover { border-color: var(--green); color: var(--green); }

        .calorie-preview { background: var(--surface2); border: 1px solid var(--border); border-radius: 12px; padding: 1rem 1.2rem; display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.5rem; margin-bottom: 1.2rem; }
        .preview-item { text-align: center; }
        .preview-value { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.1rem; }
        .preview-label { color: var(--muted); font-size: 0.7rem; text-transform: uppercase; letter-spacing: 0.5px; }
        .preview-item:nth-child(1) .preview-value { color: var(--green); }
        .preview-item:nth-child(2) .preview-value { color: #4f8eff; }
        .preview-item:nth-child(3) .preview-value { color: #ffb347; }
        .preview-item:nth-child(4) .preview-value { color: #ff7eb3; }

        .btn-submit { background: var(--green); color: #0a0a0f; border: none; border-radius: 12px; padding: 0.85rem; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1rem; width: 100%; cursor: pointer; transition: all 0.2s; }
        .btn-submit:hover { background: #00ff88; transform: translateY(-1px); }
        .btn-back { display: block; text-align: center; margin-top: 1rem; color: var(--muted); text-decoration: none; font-size: 0.9rem; transition: color 0.2s; }
        .btn-back:hover { color: var(--text); }
        .no-results { text-align: center; color: var(--muted); padding: 2rem; font-size: 0.9rem; display: none; }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(12px); } to { opacity: 1; transform: translateY(0); } }

        /* ── MOBILE ── */
        @media (max-width: 600px) {
            .navbar { padding: 0.9rem 1rem; }
            .navbar-brand { font-size: 1.1rem; }
            .btn-nav { padding: 0.35rem 0.7rem; font-size: 0.78rem; }

            .main { margin: 1.2rem auto; padding: 0 0.9rem; }
            .page-title { font-size: 1.4rem; }
            .page-subtitle { font-size: 0.82rem; margin-bottom: 1rem; }

            .category-tabs { gap: 0.4rem; margin-bottom: 1rem; }
            .tab-btn { padding: 0.35rem 0.7rem; font-size: 0.78rem; }

            .food-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 0.6rem;
                max-height: 360px;
            }
            .food-card { padding: 0.8rem; border-radius: 12px; }
            .food-card-name { font-size: 0.82rem; }
            .food-card-serving { font-size: 0.7rem; }
            .food-card-cals { font-size: 0.75rem; }

            .serving-section { padding: 1rem; }
            .selected-food-name { font-size: 1rem; }

            .calorie-preview { grid-template-columns: repeat(2, 1fr); gap: 0.6rem; }
            .preview-value { font-size: 1rem; }

            .quick-servings { gap: 0.4rem; }
            .quick-serving-btn { padding: 0.3rem 0.6rem; font-size: 0.75rem; }

            .serving-btn { width: 36px; height: 36px; font-size: 1.1rem; }
        }
    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    String error = request.getParameter("error");
    String success = request.getParameter("success");

    MealDAO mealDAO = new MealDAO();
    Map<String, List<Map<String, Object>>> foodsByCategory = mealDAO.getFoodsByCategory();

    StringBuilder foodsJson = new StringBuilder("[");
    boolean firstFood = true;
    for (Map.Entry<String, List<Map<String, Object>>> entry : foodsByCategory.entrySet()) {
        for (Map<String, Object> food : entry.getValue()) {
            if (!firstFood) foodsJson.append(",");
            firstFood = false;
            foodsJson.append("{")
                .append("\"id\":").append(food.get("id")).append(",")
                .append("\"name\":\"").append(((String)food.get("name")).replace("\"","\\\"")).append("\",")
                .append("\"category\":\"").append(entry.getKey().replace("\"","\\\"")).append("\",")
                .append("\"caloriesPer100g\":").append(food.get("caloriesPer100g")).append(",")
                .append("\"protein\":").append(food.get("protein")).append(",")
                .append("\"carbs\":").append(food.get("carbs")).append(",")
                .append("\"fat\":").append(food.get("fat")).append(",")
                .append("\"servingSizeG\":").append(food.get("servingSizeG")).append(",")
                .append("\"servingDescription\":\"").append(((String)food.get("servingDescription")).replace("\"","\\\"")).append("\",")
                .append("\"caloriesPerServing\":").append(food.get("caloriesPerServing"))
                .append("}");
        }
    }
    foodsJson.append("]");
%>

<nav class="navbar">
    <a href="dashboard.jsp" class="navbar-brand">⚡ NutriTrack</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="btn-nav">Dashboard</a>
        <a href="logout" class="btn-nav">Logout</a>
    </div>
</nav>

<div class="main">
    <h1 class="page-title">🍽️ Log a Meal</h1>
    <p class="page-subtitle">Pick a food, choose your servings</p>

    <% if (error != null) { %><div class="alert-danger">⚠️ <%= error %></div><% } %>
    <% if (success != null) { %><div class="alert-success">✅ Meal logged successfully!</div><% } %>

    <div class="category-tabs" id="categoryTabs">
        <button class="tab-btn active" data-category="all">All</button>
        <% for (String cat : foodsByCategory.keySet()) { %>
            <button class="tab-btn" data-category="<%= cat %>"><%= cat %></button>
        <% } %>
    </div>

    <div class="search-bar">
        <span class="search-icon">🔍</span>
        <input type="text" id="searchInput" placeholder="Search foods... e.g. roti, dal, egg">
    </div>

    <div class="food-grid" id="foodGrid">
        <% for (Map.Entry<String, List<Map<String, Object>>> entry : foodsByCategory.entrySet()) {
            for (Map<String, Object> food : entry.getValue()) { %>
                <div class="food-card"
                     data-id="<%= food.get("id") %>"
                     data-category="<%= entry.getKey() %>"
                     data-name="<%= ((String)food.get("name")).toLowerCase() %>"
                     data-calories-per-100g="<%= food.get("caloriesPer100g") %>"
                     data-protein="<%= food.get("protein") %>"
                     data-carbs="<%= food.get("carbs") %>"
                     data-fat="<%= food.get("fat") %>"
                     data-serving-size-g="<%= food.get("servingSizeG") %>"
                     data-serving-desc="<%= food.get("servingDescription") %>"
                     data-cals-per-serving="<%= food.get("caloriesPerServing") %>"
                     onclick="selectFood(this)">
                    <div class="food-card-name"><%= food.get("name") %></div>
                    <div class="food-card-serving"><%= food.get("servingDescription") %></div>
                    <div class="food-card-cals">⚡ <%= food.get("caloriesPerServing") %> kcal/serving</div>
                </div>
        <% } } %>
    </div>
    <div class="no-results" id="noResults">No foods found. Try a different search.</div>

    <div class="serving-section" id="servingSection">
        <div class="selected-food-name" id="selectedFoodName">—</div>
        <div class="selected-food-serving-info" id="selectedServingInfo">—</div>
        <div class="quick-servings">
            <span style="color:var(--muted);font-size:0.8rem;align-self:center;">Quick:</span>
            <button class="quick-serving-btn" onclick="setServings(0.5)">½</button>
            <button class="quick-serving-btn" onclick="setServings(1)">1</button>
            <button class="quick-serving-btn" onclick="setServings(1.5)">1½</button>
            <button class="quick-serving-btn" onclick="setServings(2)">2</button>
            <button class="quick-serving-btn" onclick="setServings(3)">3</button>
        </div>
        <div class="serving-controls">
            <button class="serving-btn" onclick="changeServings(-0.5)">−</button>
            <div class="serving-input-wrap">
                <div class="serving-label">Number of Servings</div>
                <input type="number" id="servingsInput" class="serving-input" value="1" min="0.5" max="20" step="0.5" oninput="updatePreview()">
            </div>
            <button class="serving-btn" onclick="changeServings(0.5)">+</button>
        </div>
        <div class="calorie-preview">
            <div class="preview-item"><div class="preview-value" id="previewCals">0</div><div class="preview-label">Calories</div></div>
            <div class="preview-item"><div class="preview-value" id="previewProtein">0g</div><div class="preview-label">Protein</div></div>
            <div class="preview-item"><div class="preview-value" id="previewCarbs">0g</div><div class="preview-label">Carbs</div></div>
            <div class="preview-item"><div class="preview-value" id="previewFat">0g</div><div class="preview-label">Fat</div></div>
        </div>
        <form action="logMeal" method="post" id="logMealForm">
            <input type="hidden" name="foodId" id="hiddenFoodId">
            <input type="hidden" name="servings" id="hiddenServings">
            <button type="submit" class="btn-submit" onclick="prepareSubmit()">Log Meal →</button>
        </form>
    </div>

    <a href="dashboard.jsp" class="btn-back">← Back to Dashboard</a>
</div>

<script>
    const allFoods = <%= foodsJson.toString() %>;
    let selectedFoodData = null;

    document.getElementById('categoryTabs').addEventListener('click', function(e) {
        if (!e.target.classList.contains('tab-btn')) return;
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        e.target.classList.add('active');
        filterFoods();
    });
    document.getElementById('searchInput').addEventListener('input', filterFoods);

    function filterFoods() {
        const activeTab = document.querySelector('.tab-btn.active').dataset.category;
        const searchVal = document.getElementById('searchInput').value.toLowerCase().trim();
        const cards = document.querySelectorAll('.food-card');
        let visible = 0;
        cards.forEach(card => {
            const catMatch = activeTab === 'all' || card.dataset.category === activeTab;
            const nameMatch = !searchVal || card.dataset.name.includes(searchVal);
            if (catMatch && nameMatch) { card.classList.remove('hidden'); visible++; }
            else card.classList.add('hidden');
        });
        document.getElementById('noResults').style.display = visible === 0 ? 'block' : 'none';
    }

    function selectFood(card) {
        document.querySelectorAll('.food-card.selected').forEach(c => c.classList.remove('selected'));
        card.classList.add('selected');
        selectedFoodData = {
            id: card.dataset.id,
            name: card.querySelector('.food-card-name').textContent,
            caloriesPer100g: parseFloat(card.dataset.caloriesPer100g),
            protein: parseFloat(card.dataset.protein),
            carbs: parseFloat(card.dataset.carbs),
            fat: parseFloat(card.dataset.fat),
            servingSizeG: parseFloat(card.dataset.servingSizeG),
            servingDesc: card.dataset.servingDesc,
            calsPerServing: parseFloat(card.dataset.calsPerServing)
        };
        document.getElementById('selectedFoodName').textContent = selectedFoodData.name;
        document.getElementById('selectedServingInfo').textContent = 'Per serving: ' + selectedFoodData.servingDesc + ' • ' + selectedFoodData.calsPerServing + ' kcal';
        document.getElementById('servingsInput').value = 1;
        document.getElementById('servingSection').classList.add('visible');
        document.getElementById('servingSection').scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        updatePreview();
    }

    function setServings(val) { document.getElementById('servingsInput').value = val; updatePreview(); }
    function changeServings(delta) {
        const input = document.getElementById('servingsInput');
        let val = parseFloat(input.value) + delta;
        if (val < 0.5) val = 0.5; if (val > 20) val = 20;
        input.value = Math.round(val * 2) / 2; updatePreview();
    }
    function updatePreview() {
        if (!selectedFoodData) return;
        const servings = parseFloat(document.getElementById('servingsInput').value) || 1;
        const grams = servings * selectedFoodData.servingSizeG;
        document.getElementById('previewCals').textContent = Math.round((selectedFoodData.caloriesPer100g * grams) / 100);
        document.getElementById('previewProtein').textContent = ((selectedFoodData.protein * grams) / 100).toFixed(1) + 'g';
        document.getElementById('previewCarbs').textContent = ((selectedFoodData.carbs * grams) / 100).toFixed(1) + 'g';
        document.getElementById('previewFat').textContent = ((selectedFoodData.fat * grams) / 100).toFixed(1) + 'g';
    }
    function prepareSubmit() {
        if (!selectedFoodData) return false;
        document.getElementById('hiddenFoodId').value = selectedFoodData.id;
        document.getElementById('hiddenServings').value = document.getElementById('servingsInput').value;
    }
</script>
</body>
</html>
