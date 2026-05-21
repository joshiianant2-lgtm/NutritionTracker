<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - NutriTrack</title>
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
            --text: #f0f0f8;
            --muted: #6b6b80;
        }

        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            background-color: var(--bg);
            font-family: 'DM Sans', sans-serif;
            color: var(--text);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }

        .glow-bg {
            position: fixed;
            width: 600px;
            height: 600px;
            background: radial-gradient(circle, rgba(0,230,118,0.04) 0%, transparent 70%);
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            pointer-events: none;
        }

        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 20px;
            padding: 2.5rem;
            width: 100%;
            max-width: 420px;
            position: relative;
            z-index: 1;
        }

        .card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 2px;
            background: var(--green);
            border-radius: 20px 20px 0 0;
        }

        .brand {
            font-family: 'Syne', sans-serif;
            font-weight: 800;
            font-size: 1.5rem;
            color: var(--green);
            margin-bottom: 0.3rem;
        }

        .subtitle {
            color: var(--muted);
            font-size: 0.9rem;
            margin-bottom: 2rem;
        }

        .form-label {
            color: var(--muted);
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 0.5rem;
        }

        .form-control {
            background: var(--surface2);
            border: 1px solid var(--border);
            border-radius: 10px;
            color: var(--text);
            padding: 0.75rem 1rem;
            font-family: 'DM Sans', sans-serif;
            transition: all 0.2s;
            font-size: 1rem;
        }

        .form-control:focus {
            background: var(--surface2);
            border-color: var(--green);
            color: var(--text);
            box-shadow: 0 0 0 3px rgba(0,230,118,0.1);
        }

        .form-control::placeholder { color: var(--muted); }

        .btn-login {
            background: var(--green);
            color: #0a0a0f;
            border: none;
            border-radius: 10px;
            padding: 0.75rem;
            font-family: 'Syne', sans-serif;
            font-weight: 700;
            font-size: 1rem;
            width: 100%;
            transition: all 0.2s;
            margin-top: 0.5rem;
        }

        .btn-login:hover {
            background: #00ff88;
            transform: translateY(-1px);
        }

        .divider {
            text-align: center;
            color: var(--muted);
            font-size: 0.85rem;
            margin: 1.2rem 0;
        }

        .link {
            color: var(--green);
            text-decoration: none;
            font-weight: 500;
        }

        .link:hover { color: #00ff88; }

        .alert-danger {
            background: rgba(255,79,79,0.1);
            border: 1px solid rgba(255,79,79,0.2);
            color: var(--red);
            border-radius: 10px;
            font-size: 0.85rem;
            margin-bottom: 1rem;
        }

        @keyframes fadeUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .card { animation: fadeUp 0.4s ease both; }

        @media (max-width: 480px) {
            .card { padding: 1.5rem; border-radius: 16px; }
            .brand { font-size: 1.3rem; }
        }
    </style>
</head>
<body>
<div class="glow-bg"></div>

<div class="card">
    <div class="brand">⚡ NutriTrack</div>
    <div class="subtitle">Welcome back — login to continue</div>

    <% String error = request.getParameter("error");
       if(error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <form action="login" method="post">
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control"
                   placeholder="your@email.com" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Password</label>
            <input type="password" name="password" class="form-control"
                   placeholder="••••••••" required>
        </div>
        <button type="submit" class="btn-login">Login →</button>
    </form>

    <div class="divider">
        Don't have an account? <a href="register.jsp" class="link">Register here</a>
    </div>
</div>
</body>
</html>
