<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f0f0f0;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        .content {
            flex: 1;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 2rem;
        }
        .login-container {
            background-color: white;
            padding: 2rem;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 400px;
        }
        h2 {
            text-align: center;
            color: #333;
            margin-top: 0;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-top: 1rem;
        }
        input {
            padding: 0.5rem;
            margin-top: 0.5rem;
            border: 1px solid #ddd;
            border-radius: 3px;
        }
        button {
            margin-top: 1rem;
            padding: 0.5rem;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 3px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #45a049;
        }
        .error-message {
            color: red;
            margin-top: 1rem;
            text-align: center;
        }
        .register-link {
            margin-top: 1rem;
            text-align: center;
        }
        .register-link a {
            color: #4CAF50;
            text-decoration: none;
        }
        .register-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="content">
        <div class="login-container">
            <h2>Login</h2>
            <form action="login" method="post">
                <label for="username">Username:</label>
                <input type="text" id="username" name="username" required>
                
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
                
                <button type="submit">Login</button>
            </form>

            <%-- Display error message if login fails --%>
            <% 
            String error = request.getParameter("error");
            if (error != null && error.equals("1")) {
            %>
                <p class="error-message">Invalid username or password. Please try again.</p>
            <% } %>
            
            <%-- Add the registration link here --%>
            <div class="register-link">
                <p>Not a member? <a href="register.jsp">Register here</a></p>
            </div>
        </div>
    </div>
</body>
</html>
