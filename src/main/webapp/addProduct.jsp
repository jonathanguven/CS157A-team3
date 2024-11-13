<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Product - Grocery Gander</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
        }

        h1 {
            text-align: center;
        }

        form {
            max-width: 600px;
            margin: 0 auto;
        }

        label {
            display: block;
            margin-top: 10px;
        }

        input, select, textarea {
            width: 100%;
            padding: 8px;
            margin-top: 5px;
        }

        .required::after {
            content: "*";
            color: red;
        }

        .form-group {
            margin-bottom: 15px;
        }

        input[type="submit"] {
            width: auto;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 10px 20px;
            cursor: pointer;
            margin-top: 10px;
        }

        input[type="submit"]:hover {
            background-color: #218838;
        }
    </style>
</head>
<body>

    <h1>Add New Product</h1>

    <form action="addProduct" method="post" enctype="multipart/form-data">
        <!-- Product Name -->
        <div class="form-group">
            <label for="productName" class="required">Product Name:</label>
            <input type="text" id="productName" name="productName" required>
        </div>

        <!-- Product Image (Optional) -->
        <div class="form-group">
            <label for="image">Product Image (optional):</label>
            <input type="file" id="image" name="image">
        </div>

        <!-- Location (Optional) -->
        <div class="form-group">
            <label for="location">Location (optional):</label>
            <input type="text" id="location" name="location">
        </div>

        <!-- Price -->
        <div class="form-group">
            <label for="price" class="required">Price:</label>
            <input type="number" id="price" name="price" step="0.01" required>
        </div>

        <!-- Quantity -->
        <div class="form-group">
            <label for="quantity" class="required">Quantity:</label>
            <input type="number" id="quantity" name="quantity" required>
        </div>

        <!-- Description -->
        <div class="form-group">
            <label for="description">Description:</label>
            <textarea id="description" name="description"></textarea>
        </div>

        <!-- Category -->
        <div class="form-group">
            <label for="category" class="required">Category:</label>
            <select id="category" name="category" required>
                <option value="">Select Category</option>
                <%
                    // Query categories and populate the options
                    try {
                        Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery_gander_db", "root", "password");
                        PreparedStatement ps = conn.prepareStatement("SELECT category_id, category_name FROM Category");
                        ResultSet rs = ps.executeQuery();
                        while (rs.next()) {
                %>
                    <option value="<%= rs.getInt("category_id") %>"><%= rs.getString("category_name") %></option>
                <%
                        }
                        rs.close();
                        ps.close();
                        conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </select>
        </div>

        <!-- Submit Button -->
        <input type="submit" value="Add Product">
    </form>

</body>
</html>