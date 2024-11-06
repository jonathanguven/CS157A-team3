<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>  <!-- Include the header at the top -->

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Grocery Gander</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f0f0f0;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column; /* Stack header on top, form below */
            align-items: center;
        }

        form {
            background-color: white;
            padding: 2rem;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-top: 2rem; /* Space between the form and the header */
            width: 300px; /* Make form width fixed and centered */
        }

        table {
            border-collapse: separate;
            border-spacing: 0 1rem;
        }

        td {
            padding: 0.5rem;
        }

        input[type="text"], input[type="password"], select {
            width: 100%;
            padding: 0.5rem;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box;
        }

        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
        }

        input[type="submit"]:hover {
            background-color: #45a049;
        }

        .hidden {
            display: none;
        }
    </style>
</head>
<body>
    <!-- Your form content -->
    <form action="Register" method="post">
        <table>
            <tr>
                <td><label for="username">User Name</label></td>
                <td><input type="text" id="username" name="username" required></td>
            </tr>
            <tr>
                <td><label for="password">Password</label></td>
                <td><input type="password" id="password" name="password" required></td>
            </tr>
            <tr>
                <td><label for="email">Email</label></td>
                <td><input type="email" id="email" name="email" required></td>
            </tr>
            <tr>
                <td><label for="role">Role</label></td>
                <td>
                    <select id="role" name="role" required onchange="toggleAdminCode()">
                        <option value="user">User</option>
                        <option value="admin">Admin</option>
                    </select>
                </td>
            </tr>
            <tr id="adminCodeRow" class="hidden">
                <td><label for="adminCode">Admin Code</label></td>
                <td><input type="password" id="adminCode" name="adminCode"></td>
            </tr>
            <tr>
                <td></td>
                <td><input type="submit" value="Register"></td>
            </tr>
        </table>
    </form>

    <script>
        function toggleAdminCode() {
            var roleSelect = document.getElementById('role');
            var adminCodeRow = document.getElementById('adminCodeRow');
            var adminCodeInput = document.getElementById('adminCode');

            if (roleSelect.value === 'admin') {
                adminCodeRow.classList.remove('hidden');
                adminCodeInput.required = true;
            } else {
                adminCodeRow.classList.add('hidden');
                adminCodeInput.required = false;
                adminCodeInput.value = ''; // Clear the input when hidden
            }
        }

        // Add form submission event listener
        document.querySelector('form').addEventListener('submit', function(e) {
            var roleSelect = document.getElementById('role');
            var adminCodeInput = document.getElementById('adminCode');

            if (roleSelect.value === 'admin') {
                if (adminCodeInput.value !== 'groceryganderiscool') {
                    e.preventDefault(); // Prevent form submission
                    alert('Invalid admin code. Please try again.');
                }
            }
        });
    </script>
</body>
</html>
