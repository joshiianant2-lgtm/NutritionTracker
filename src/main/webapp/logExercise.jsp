<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.nutrition.model.User" %>
<%@ page import="com.nutrition.dao.ExerciseDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Log Exercise - NutriTrack</title>
    <link href="https://fonts.googleapis.com/css2?family=Syne:wght@400;600;700;800&family=DM+Sans:wght@300;400;500&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0a0f; --surface: #13131a; --surface2: #1c1c27; --surface3: #22222f;
            --border: rgba(255,255,255,0.07); --border-hover: rgba(255,255,255,0.15);
            --green: #00e676; --green-dim: rgba(0,230,118,0.1);
            --red: #ff4f4f; --red-dim: rgba(255,79,79,0.1); --red-border: rgba(255,79,79,0.3);
            --text: #f0f0f8; --muted: #6b6b80;
        }
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { background-color: var(--bg); font-family: 'DM Sans', sans-serif; color: var(--text); min-height: 100vh; }

        .navbar { background: rgba(10,10,15,0.85); backdrop-filter: blur(20px); border-bottom: 1px solid var(--border); padding: 1rem 2rem; position: sticky; top: 0; z-index: 100; display: flex; align-items: center; justify-content: space-between; }
        .navbar-brand { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 1.3rem; color: var(--green); text-decoration: none; }
        .nav-links { display: flex; gap: 0.8rem; }
        .btn-nav { background: transparent; border: 1px solid var(--border); color: var(--muted); padding: 0.4rem 1rem; border-radius: 8px; font-size: 0.85rem; text-decoration: none; transition: all 0.2s; }
        .btn-nav:hover { border-color: var(--green); color: var(--green); }

        .main { max-width: 700px; margin: 2.5rem auto; padding: 0 1.5rem; }
        .page-title { font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1.8rem; margin-bottom: 0.3rem; }
        .page-subtitle { color: var(--muted); font-size: 0.9rem; margin-bottom: 1.2rem; }

        .alert-danger { background: rgba(255,79,79,0.1); border: 1px solid rgba(255,79,79,0.2); color: var(--red); border-radius: 10px; padding: 0.75rem 1rem; font-size: 0.85rem; margin-bottom: 1rem; }
        .alert-success { background: var(--green-dim); border: 1px solid rgba(0,230,118,0.2); color: var(--green); border-radius: 10px; padding: 0.75rem 1rem; font-size: 0.85rem; margin-bottom: 1rem; }

        .weight-badge { display: inline-flex; align-items: center; gap: 0.4rem; background: var(--surface); border: 1px solid var(--border); border-radius: 20px; padding: 0.3rem 0.9rem; font-size: 0.78rem; color: var(--muted); margin-bottom: 1.5rem; }
        .weight-badge span { color: var(--text); font-weight: 500; }

        .section-card { background: var(--surface); border: 1px solid var(--border); border-radius: 20px; padding: 1.5rem; margin-bottom: 1rem; position: relative; animation: fadeUp 0.4s ease both; }
        .section-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 2px; background: var(--red); border-radius: 20px 20px 0 0; }
        .section-title { color: var(--muted); font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 1rem; }

        .activity-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 0.7rem; }
        .activity-card { background: var(--surface2); border: 1px solid var(--border); border-radius: 14px; padding: 1rem 0.5rem; text-align: center; cursor: pointer; transition: all 0.2s; user-select: none; }
        .activity-card:hover { border-color: var(--border-hover); background: var(--surface3); transform: translateY(-2px); }
        .activity-card.selected { border-color: var(--red); background: var(--red-dim); }
        .activity-card.selected .activity-name { color: var(--red); }
        .activity-emoji { font-size: 1.6rem; margin-bottom: 0.4rem; }
        .activity-name { font-size: 0.72rem; color: var(--muted); font-weight: 500; transition: color 0.2s; }
        .activity-met { font-size: 0.65rem; color: var(--muted); margin-top: 0.2rem; opacity: 0.7; }

        .intensity-row { display: flex; gap: 0.6rem; }
        .intensity-btn { flex: 1; background: var(--surface2); border: 1px solid var(--border); border-radius: 10px; padding: 0.7rem; text-align: center; cursor: pointer; transition: all 0.2s; font-family: 'DM Sans', sans-serif; }
        .intensity-btn:hover { border-color: var(--border-hover); }
        .intensity-btn.active-light { border-color: #4f8eff; background: rgba(79,142,255,0.1); color: #4f8eff; }
        .intensity-btn.active-moderate { border-color: #ffb347; background: rgba(255,179,71,0.1); color: #ffb347; }
        .intensity-btn.active-intense { border-color: var(--red); background: var(--red-dim); color: var(--red); }
        .intensity-label { font-size: 0.85rem; font-weight: 600; }
        .intensity-desc { font-size: 0.68rem; color: var(--muted); margin-top: 0.2rem; }

        .quick-durations { display: flex; gap: 0.5rem; margin-bottom: 1rem; flex-wrap: wrap; }
        .quick-dur-btn { background: var(--surface2); border: 1px solid var(--border); color: var(--muted); padding: 0.4rem 0.9rem; border-radius: 8px; font-size: 0.82rem; cursor: pointer; transition: all 0.15s; font-family: 'DM Sans', sans-serif; }
        .quick-dur-btn:hover { border-color: var(--red); color: var(--red); }
        .duration-row { display: flex; align-items: center; gap: 0.7rem; }
        .dur-btn { background: var(--surface2); border: 1px solid var(--border); color: var(--text); width: 42px; height: 42px; border-radius: 10px; font-size: 1.3rem; cursor: pointer; display: flex; align-items: center; justify-content: center; transition: all 0.15s; flex-shrink: 0; }
        .dur-btn:hover { border-color: var(--red); color: var(--red); }
        .duration-input { background: var(--surface2); border: 1px solid var(--border); border-radius: 10px; color: var(--text); padding: 0.65rem 1rem; font-family: 'DM Sans', sans-serif; font-size: 1rem; flex: 1; transition: all 0.2s; text-align: center; }
        .duration-input:focus { outline: none; border-color: var(--red); box-shadow: 0 0 0 3px rgba(255,79,79,0.08); }

        .calorie-preview { background: var(--surface); border: 1px solid var(--border); border-radius: 16px; padding: 1.2rem 1.5rem; display: flex; align-items: center; justify-content: space-between; margin-bottom: 1rem; }
        .preview-cals { font-family: 'Syne', sans-serif; font-weight: 800; font-size: 2.5rem; color: var(--red); }
        .preview-unit { color: var(--muted); font-size: 0.85rem; margin-left: 0.3rem; }
        .preview-details { text-align: right; }
        .preview-detail-row { font-size: 0.8rem; color: var(--muted); margin-bottom: 0.2rem; }
        .preview-detail-row span { color: var(--text); font-weight: 500; }
        .no-selection-msg { color: var(--muted); font-size: 0.85rem; font-style: italic; }

        .btn-submit { background: var(--red); color: white; border: none; border-radius: 12px; padding: 0.85rem; font-family: 'Syne', sans-serif; font-weight: 700; font-size: 1rem; width: 100%; cursor: pointer; transition: all 0.2s; }
        .btn-submit:hover { background: #ff6b6b; transform: translateY(-1px); }
        .btn-back { display: block; text-align: center; margin-top: 1rem; color: var(--muted); text-decoration: none; font-size: 0.9rem; transition: color 0.2s; }
        .btn-back:hover { color: var(--text); }

        @keyframes fadeUp { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }

        /* ── MOBILE ── */
        @media (max-width: 600px) {
            .navbar { padding: 0.9rem 1rem; }
            .navbar-brand { font-size: 1.1rem; }
            .btn-nav { padding: 0.35rem 0.7rem; font-size: 0.78rem; }

            .main { margin: 1.2rem auto; padding: 0 0.9rem; }
            .page-title { font-size: 1.4rem; }
            .page-subtitle { font-size: 0.82rem; }

            .section-card { padding: 1rem; border-radius: 14px; }

            .activity-grid { grid-template-columns: repeat(4, 1fr); gap: 0.4rem; }
            .activity-card { padding: 0.7rem 0.2rem; border-radius: 10px; }
            .activity-emoji { font-size: 1.3rem; margin-bottom: 0.2rem; }
            .activity-name { font-size: 0.62rem; }
            .activity-met { display: none; }

            .intensity-row { gap: 0.4rem; }
            .intensity-btn { padding: 0.55rem 0.3rem; }
            .intensity-label { font-size: 0.75rem; }
            .intensity-desc { font-size: 0.6rem; }

            .quick-durations { gap: 0.4rem; }
            .quick-dur-btn { padding: 0.35rem 0.65rem; font-size: 0.75rem; }

            .dur-btn { width: 38px; height: 38px; font-size: 1.1rem; }

            .calorie-preview { flex-direction: column; gap: 0.8rem; align-items: flex-start; padding: 1rem; }
            .preview-cals { font-size: 2rem; }
            .preview-details { text-align: left; }
        }
    </style>
</head>
<body>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) { response.sendRedirect("login.jsp"); return; }
    int userId = (int) session.getAttribute("userId");
    String error = request.getParameter("error");
    String success = request.getParameter("success");
    ExerciseDAO exerciseDAO = new ExerciseDAO();
    double userWeight = exerciseDAO.getUserWeight(userId);
    boolean hasProfile = userWeight != 70.0;
%>

<nav class="navbar">
    <a href="dashboard.jsp" class="navbar-brand">⚡ NutriTrack</a>
    <div class="nav-links">
        <a href="dashboard.jsp" class="btn-nav">Dashboard</a>
        <a href="logout" class="btn-nav">Logout</a>
    </div>
</nav>

<div class="main">
    <h1 class="page-title">🏃 Log Exercise</h1>
    <p class="page-subtitle">Select activity, intensity and duration</p>

    <div class="weight-badge">
        ⚖️ Calculating for: <span><%= userWeight %>kg</span>
        <% if (!hasProfile) { %>&nbsp;·&nbsp;<a href="profile.jsp" style="color:#4f8eff;font-size:0.75rem;">Update profile</a><% } %>
    </div>

    <% if (error != null) { %><div class="alert-danger">⚠️ <%= error %></div><% } %>
    <% if (success != null) { %><div class="alert-success">✅ Exercise logged successfully!</div><% } %>

    <form action="logExercise" method="post" id="exerciseForm">
        <input type="hidden" name="activity" id="activityInput">
        <input type="hidden" name="intensity" id="intensityInput" value="Moderate">

        <div class="section-card">
            <div class="section-title">Step 1 — Choose Activity</div>
            <div class="activity-grid">
                <div class="activity-card" onclick="selectActivity('Running', this)" data-met="9.8">
                    <div class="activity-emoji">🏃</div><div class="activity-name">Running</div><div class="activity-met">High intensity</div>
                </div>
                <div class="activity-card" onclick="selectActivity('Walking', this)" data-met="3.5">
                    <div class="activity-emoji">🚶</div><div class="activity-name">Walking</div><div class="activity-met">Low intensity</div>
                </div>
                <div class="activity-card" onclick="selectActivity('Cycling', this)" data-met="7.5">
                    <div class="activity-emoji">🚴</div><div class="activity-name">Cycling</div><div class="activity-met">Medium intensity</div>
                </div>
                <div class="activity-card" onclick="selectActivity('Swimming', this)" data-met="8.0">
                    <div class="activity-emoji">🏊</div><div class="activity-name">Swimming</div><div class="activity-met">Full body</div>
                </div>
                <div class="activity-card" onclick="selectActivity('Weight Training', this)" data-met="5.0">
                    <div class="activity-emoji">🏋️</div><div class="activity-name">Weights</div><div class="activity-met">Strength</div>
                </div>
                <div class="activity-card" onclick="selectActivity('Yoga', this)" data-met="3.0">
                    <div class="activity-emoji">🧘</div><div class="activity-name">Yoga</div><div class="activity-met">Flexibility</div>
                </div>
                <div class="activity-card" onclick="selectActivity('Jump Rope', this)" data-met="11.0">
                    <div class="activity-emoji">⚡</div><div class="activity-name">Jump Rope</div><div class="activity-met">Cardio burst</div>
                </div>
                <div class="activity-card" onclick="selectActivity('HIIT', this)" data-met="10.0">
                    <div class="activity-emoji">🔥</div><div class="activity-name">HIIT</div><div class="activity-met">Max burn</div>
                </div>
            </div>
        </div>

        <div class="section-card">
            <div class="section-title">Step 2 — Choose Intensity</div>
            <div class="intensity-row">
                <div class="intensity-btn" onclick="selectIntensity('Light', this)">
                    <div class="intensity-label">🌿 Light</div><div class="intensity-desc">Easy, can talk freely</div>
                </div>
                <div class="intensity-btn active-moderate" onclick="selectIntensity('Moderate', this)">
                    <div class="intensity-label">⚡ Moderate</div><div class="intensity-desc">Steady, some effort</div>
                </div>
                <div class="intensity-btn" onclick="selectIntensity('Intense', this)">
                    <div class="intensity-label">🔥 Intense</div><div class="intensity-desc">Hard, max effort</div>
                </div>
            </div>
        </div>

        <div class="section-card">
            <div class="section-title">Step 3 — Set Duration</div>
            <div class="quick-durations">
                <span style="color:var(--muted);font-size:0.8rem;align-self:center;">Quick:</span>
                <button type="button" class="quick-dur-btn" onclick="setDuration(15)">15 min</button>
                <button type="button" class="quick-dur-btn" onclick="setDuration(30)">30 min</button>
                <button type="button" class="quick-dur-btn" onclick="setDuration(45)">45 min</button>
                <button type="button" class="quick-dur-btn" onclick="setDuration(60)">60 min</button>
                <button type="button" class="quick-dur-btn" onclick="setDuration(90)">90 min</button>
            </div>
            <div class="duration-row">
                <button type="button" class="dur-btn" onclick="changeDuration(-5)">−</button>
                <input type="number" id="durationInput" name="duration" class="duration-input" value="30" min="1" max="600" oninput="updatePreview()">
                <button type="button" class="dur-btn" onclick="changeDuration(5)">+</button>
            </div>
        </div>

        <div class="calorie-preview">
            <div>
                <div style="color:var(--muted);font-size:0.72rem;text-transform:uppercase;letter-spacing:1px;margin-bottom:0.5rem;">Estimated Burn</div>
                <div style="display:flex;align-items:baseline;">
                    <div class="preview-cals" id="previewCals">—</div>
                    <div class="preview-unit" id="previewUnit"></div>
                </div>
                <div id="noSelectionMsg" class="no-selection-msg" style="margin-top:0.3rem;">Select an activity first</div>
            </div>
            <div class="preview-details" id="previewDetails" style="display:none;">
                <div class="preview-detail-row">Activity: <span id="detailActivity">—</span></div>
                <div class="preview-detail-row">Duration: <span id="detailDuration">—</span></div>
                <div class="preview-detail-row">Intensity: <span id="detailIntensity">Moderate</span></div>
                <div class="preview-detail-row">Weight: <span><%= userWeight %>kg</span></div>
            </div>
        </div>

        <button type="submit" class="btn-submit" onclick="return validateForm()">Log Exercise →</button>
    </form>

    <a href="dashboard.jsp" class="btn-back">← Back to Dashboard</a>
</div>

<script>
    const USER_WEIGHT = <%= userWeight %>;
    let selectedMET = 0, intensityMultiplier = 1.0;

    function selectActivity(name, el) {
        document.querySelectorAll('.activity-card').forEach(c => c.classList.remove('selected'));
        el.classList.add('selected');
        document.getElementById('activityInput').value = name;
        selectedMET = parseFloat(el.dataset.met);
        updatePreview();
    }
    function selectIntensity(level, el) {
        document.querySelectorAll('.intensity-btn').forEach(b => b.classList.remove('active-light','active-moderate','active-intense'));
        if (level === 'Light') { el.classList.add('active-light'); intensityMultiplier = 0.75; }
        else if (level === 'Moderate') { el.classList.add('active-moderate'); intensityMultiplier = 1.0; }
        else { el.classList.add('active-intense'); intensityMultiplier = 1.25; }
        document.getElementById('intensityInput').value = level;
        document.getElementById('detailIntensity').textContent = level;
        updatePreview();
    }
    function setDuration(mins) { document.getElementById('durationInput').value = mins; updatePreview(); }
    function changeDuration(delta) {
        const input = document.getElementById('durationInput');
        let val = parseInt(input.value) + delta;
        if (val < 1) val = 1; if (val > 600) val = 600;
        input.value = val; updatePreview();
    }
    function updatePreview() {
        const duration = parseInt(document.getElementById('durationInput').value) || 0;
        const activityName = document.getElementById('activityInput').value;
        if (!selectedMET || !activityName) {
            document.getElementById('previewCals').textContent = '—';
            document.getElementById('previewUnit').textContent = '';
            document.getElementById('noSelectionMsg').style.display = 'block';
            document.getElementById('previewDetails').style.display = 'none';
            return;
        }
        const calories = selectedMET * intensityMultiplier * USER_WEIGHT * (duration / 60.0);
        document.getElementById('previewCals').textContent = Math.round(calories);
        document.getElementById('previewUnit').textContent = 'kcal';
        document.getElementById('noSelectionMsg').style.display = 'none';
        document.getElementById('previewDetails').style.display = 'block';
        document.getElementById('detailActivity').textContent = activityName;
        document.getElementById('detailDuration').textContent = duration + ' mins';
    }
    function validateForm() {
        if (!document.getElementById('activityInput').value) { alert('Please select an activity!'); return false; }
        const dur = document.getElementById('durationInput').value;
        if (!dur || dur < 1) { alert('Please enter a valid duration!'); return false; }
        return true;
    }
</script>
</body>
</html>
