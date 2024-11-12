<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Grocery Gander</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4CAF50;
            --primary-hover: #45a049;
            --background-color: #f7f7f7;
            --card-background: #ffffff;
            --text-color: #333333;
            --text-light: #666666;
            --error-color: #ff4444;
        }

        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        .wave-container {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            overflow: hidden;
            z-index: -1;
        }

        .wave {
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 100px;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1440 320"><path fill="%234CAF50" fill-opacity="0.2" d="M0,192L48,197.3C96,203,192,213,288,229.3C384,245,480,267,576,250.7C672,235,768,181,864,181.3C960,181,1056,235,1152,234.7C1248,235,1344,181,1392,154.7L1440,128L1440,320L1392,320C1344,320,1248,320,1152,320C1056,320,960,320,864,320C768,320,672,320,576,320C480,320,384,320,288,320C192,320,96,320,48,320L0,320Z"></path></svg>');
            background-size: 1440px 100px;
            animation: wave 10s linear infinite;
        }

        .wave:nth-child(2) {
            bottom: 10px;
            opacity: 0.5;
            animation: wave 7s linear infinite;
        }

        .wave:nth-child(3) {
            bottom: 20px;
            opacity: 0.3;
            animation: wave 5s linear infinite;
        }

        @keyframes wave {
            0% {
                transform: translateX(0);
            }
            100% {
                transform: translateX(-1440px);
            }
        }

        .content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
            position: relative;
            z-index: 1;
        }

        .login-container {
            background-color: var(--card-background);
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }

        h2 {
            text-align: center;
            color: var(--text-color);
            margin-bottom: 1.5rem;
            font-size: 1.5rem;
            font-weight: 600;
        }

        form {
            display: flex;
            flex-direction: column;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-color);
            font-weight: 600;
        }

        input {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        input:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        button {
            background-color: var(--primary-color);
            color: white;
            padding: 0.75rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: var(--primary-hover);
        }

        .error-message {
            color: var(--error-color);
            margin-top: 1rem;
            text-align: center;
            font-size: 0.875rem;
        }

        .register-link {
            margin-top: 1rem;
            text-align: center;
            font-size: 0.875rem;
        }

        .register-link a {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="wave-container">
        <div class="wave"></div>
        <div class="wave"></div>
        <div class="wave"></div>
    </div>
    <div class="content">
        <div class="login-container">
            <h2>Welcome Back to Grocery Gander</h2>
            <form action="login" method="post">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" required>
                </div>
                
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" required>
                </div>
                
                <button type="submit">Log In</button>
            </form>

            <%-- Display error message if login fails --%>
            <% 
            String error = request.getParameter("error");
            if (error != null && error.equals("1")) {
            %>
                <p class="error-message">Invalid username or password. Please try again.</p>
            <% } %>
            
            <div class="register-link">
                <p>Not a member? <a href="register.jsp">Sign up now</a></p>
            </div>
        </div>
    </div>
</body>
</html>

