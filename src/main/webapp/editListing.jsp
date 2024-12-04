<%@ page import="java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.io.*, java.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Listing - Grocery Gander</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        h2 {
            text-align: center;
            margin-top: 20px;
        }
        form {
            width: 60%;
            margin: 0 auto;
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        label {
            font-weight: bold;
            margin-top: 10px;
        }
        input[type="text"],
        input[type="number"],
        input[type="file"],
        textarea,
        select {
            width: 100%;
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 10px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>

<h2>Edit Listing</h2>

<%
    String listingIdStr = request.getParameter("listing_id");
    int listingId = Integer.parseInt(listingIdStr);
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");
        String query = "SELECT l.listing_id, l.product_name, l.price, d.quantity, d.location, d.description, d.image, l.category_id " +
                       "FROM listing l " +
                       "JOIN description d ON l.listing_id = d.listing_id " +
                       "WHERE l.listing_id = ?";
        ps = conn.prepareStatement(query);
        ps.setInt(1, listingId);
        rs = ps.executeQuery();

        if (rs.next()) {
            String productName = rs.getString("product_name");
            double price = rs.getDouble("price");
            int quantity = rs.getInt("quantity");
            String location = rs.getString("location");
            String description = rs.getString("description");
            byte[] imageBytes = rs.getBytes("image");
            String imageBase64 = (imageBytes != null) ? Base64.getEncoder().encodeToString(imageBytes) : null;
            int categoryId = rs.getInt("category_id");

            // Fetch categories for the dropdown
            String categoryQuery = "SELECT category_id, category_name FROM category";
            PreparedStatement categoryPs = conn.prepareStatement(categoryQuery);
            ResultSet categoryRs = categoryPs.executeQuery();
%>

<form action="EditListing" method="post" enctype="multipart/form-data">
    <input type="hidden" name="listing_id" value="<%= listingId %>">

    <label for="product_name">Product Name:</label>
    <input type="text" name="product_name" value="<%= productName %>" required>

    <label for="price">Price:</label>
    <input type="number" name="price" value="<%= price %>" step="0.01" required>

    <label for="quantity">Quantity:</label>
    <input type="number" name="quantity" value="<%= quantity %>" required>

    <label for="location">Location:</label>
    <input type="text" name="location" value="<%= location != null ? location : "" %>">

    <label for="description">Description:</label>
    <textarea name="description" rows="4"><%= description != null ? description : "" %></textarea>

    <label for="category">Category:</label>
    <select name="category_id" required>
        <option value="">Select a category</option>
        <%
            while (categoryRs.next()) {
                int category = categoryRs.getInt("category_id");
                String categoryName = categoryRs.getString("category_name");
        %>
            <option value="<%= category %>" <%= category == categoryId ? "selected" : "" %>><%= categoryName %></option>
        <%
            }
        %>
    </select>

    <label for="image">Image:</label>
    <input type="file" name="image">

    <button type="submit">Update Listing</button>
</form>

<%
        } else {
            out.println("<p>Listing not found.</p>");
        }
    } catch (SQLException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("<p>Error closing database resources: " + e.getMessage() + "</p>");
        }
    }
%>

</body>
</html>
