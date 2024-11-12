<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>  <!-- Include the header at the top -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join Grocery Gander - Smart Shopping Starts Here</title>
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
        }

        .hero {
            background-image: url('https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');
            background-size: cover;
            background-position: center;
            height: 50vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            position: relative;
        }

        .hero::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero h1 {
            font-size: 3rem;
            margin-bottom: 1rem;
        }

        .hero p {
            font-size: 1.2rem;
            max-width: 600px;
            margin: 0 auto;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
            display: flex;
            flex-wrap: wrap;
            justify-content: space-between;
            align-items: flex-start;
        }

        .content {
            flex: 1;
            min-width: 300px;
            margin-right: 2rem;
        }

        .content h2 {
            font-size: 2rem;
            margin-bottom: 1rem;
        }

        .features {
            list-style-type: none;
            margin-top: 1rem;
        }

        .features li {
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .features li::before {
            content: '✓';
            color: var(--primary-color);
            margin-right: 0.5rem;
            font-weight: bold;
        }

        .card {
            background-color: var(--card-background);
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            padding: 2rem;
            width: 100%;
            max-width: 400px;
        }

        .card-title {
            color: var(--text-color);
            font-size: 1.5rem;
            font-weight: bold;
            text-align: center;
            margin-bottom: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: var(--text-color);
            font-weight: 600;
        }

        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ccc;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s ease;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
        }

        .btn {
            display: inline-block;
            background-color: var(--primary-color);
            color: white;
            padding: 0.75rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            width: 100%;
            transition: background-color 0.3s ease;
        }

        .btn:hover {
            background-color: var(--primary-hover);
        }

        .hidden {
            display: none;
        }

        .error-message {
            color: var(--error-color);
            font-size: 0.875rem;
            margin-top: 0.5rem;
        }

        @media (max-width: 768px) {
            .container {
                flex-direction: column;
            }

            .content {
                margin-right: 0;
                margin-bottom: 2rem;
            }

            .card {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <section class="hero">
        <div class="hero-content">
            <h1>Welcome to Grocery Gander</h1>
            <p>Join our community of smart shoppers and start saving on your grocery bills today!</p>
        </div>
    </section>

    <div class="container">
        <div class="content">
            <h2>Why Join Grocery Gander?</h2>
            <p>Grocery Gander is your ultimate companion for smarter grocery shopping. Our platform helps you find the best deals, compare prices, and plan your shopping trips efficiently.</p>
            <ul class="features">
                <li>Compare prices across multiple stores</li>
                <li>Create and manage shopping lists</li>
                <li>Get personalized deals and recommendations</li>
                <li>Track your spending and savings</li>
                <li>Connect with other savvy shoppers</li>
            </ul>
        </div>

        <div class="card">
            <h2 class="card-title">Create Your Account</h2>
            <form action="Register" method="post" id="registerForm">
                <div class="form-group">
                    <label for="username">Username</label>
                    <input type="text" id="username" name="username" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="password">Password</label>
                    <input type="password" id="password" name="password" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="role">Role</label>
                    <select id="role" name="role" class="form-control" required onchange="toggleAdminCode()">
                        <option value="user">User</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <div id="adminCodeGroup" class="form-group hidden">
                    <label for="adminCode">Admin Code</label>
                    <input type="password" id="adminCode" name="adminCode" class="form-control">
                    <p id="adminCodeError" class="error-message hidden">Invalid admin code. Please try again.</p>
                </div>
                <button type="submit" class="btn">Join Grocery Gander</button>
            </form>
        </div>
    </div>

    <script>
        function toggleAdminCode() {
            var roleSelect = document.getElementById('role');
            var adminCodeGroup = document.getElementById('adminCodeGroup');
            var adminCodeInput = document.getElementById('adminCode');

            if (roleSelect.value === 'admin') {
                adminCodeGroup.classList.remove('hidden');
                adminCodeInput.required = true;
            } else {
                adminCodeGroup.classList.add('hidden');
                adminCodeInput.required = false;
                adminCodeInput.value = ''; // Clear the input when hidden
            }
        }

        document.getElementById('registerForm').addEventListener('submit', function(e) {
            var roleSelect = document.getElementById('role');
            var adminCodeInput = document.getElementById('adminCode');
            var adminCodeError = document.getElementById('adminCodeError');

            if (roleSelect.value === 'admin') {
                if (adminCodeInput.value !== 'groceryganderiscool') {
                    e.preventDefault(); // Prevent form submission
                    adminCodeError.classList.remove('hidden');
                } else {
                    adminCodeError.classList.add('hidden');
                }
            }
        });
    </script>
</body>
</html>

