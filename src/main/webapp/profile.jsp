<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
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
        .profile-container {
            background-color: white;
            padding: 2rem;
            border-radius: 5px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 600px;
            text-align: center;
        }
        .add-product-button {
            width: 120px;
            height: 120px;
            background-color: #4CAF50;
            border: none;
            border-radius: 10px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            color: white;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .add-product-button:hover {
            background-color: #45a049;
        }
        .add-product-button:focus {
            outline: none;
        }
        .plus-icon {
            font-size: 3rem;
        }
        .add-text {
            font-size: 1rem;
            margin-top: 5px; /* Small space between the + and text */
        }
    </style>
</head>
<body>
    <div class="content">
        <div class="profile-container">
            <!-- Display the logged-in user's username -->
            <h2>
                <% 
                    String username = null;
                    Cookie[] cookies = request.getCookies();
                    if (cookies != null) {
                        for (Cookie cookie : cookies) {
                            if (cookie.getName().equals("username")) {
                                username = cookie.getValue();
                                break;
                            }
                        }
                    }

                    if (username != null) {
                        out.print("Welcome, " + username + "!");
                    } else {
                        out.print("Welcome to your Profile!");
                    }
                %>
            </h2>

            <!-- Add New Product Icon with Text Inside the Button -->
            <button class="add-product-button" onclick="location.href='addProduct.jsp'">
                <div class="plus-icon">+</div>
                <div class="add-text">Add New Product</div>
            </button>
        </div>
    </div>
</body>
</html>
