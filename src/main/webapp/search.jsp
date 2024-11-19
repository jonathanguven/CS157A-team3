<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Search Results</title>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
<style>
    /* Styles for the search results page */
    .product-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 2rem;
        margin-top: 2rem;
    }

    .product-card {
        background-color: #fff;
        border-radius: 8px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        overflow: hidden;
        transition: transform 0.3s ease;
    }

    .product-card:hover {
        transform: translateY(-5px);
    }

    .product-image {
        width: 100%;
        height: 200px;
        object-fit: cover;
    }

    .product-info {
        padding: 1rem;
    }

    .product-name {
        font-size: 1.2rem;
        font-weight: bold;
        margin-bottom: 0.5rem;
    }

    .product-location {
        font-size: 0.9rem;
        color: #666;
        margin-bottom: 0.5rem;
    }

    .product-price {
        font-size: 1.1rem;
        color: #4CAF50;
        font-weight: bold;
    }

    .view-more {
        display: inline-block;
        margin-top: 1rem;
        background-color: #FFA000;
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 4px;
        text-decoration: none;
        transition: background-color 0.3s ease;
    }

    .view-more:hover {
        background-color: #e69500;
    }
</style>
</head>
<body>
<div class="container">
    <h1>Search Results</h1>
    <div class="product-grid">
        <%
            // Database connection parameters
            String DB_URL = "jdbc:mysql://localhost:3306/userdb";
            String DB_USER = "root";
            String DB_PASSWORD = "mysql";

            // Get the search query from the request parameter
            String searchQuery = request.getParameter("query");

            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                    String query = "SELECT l.listing_id, l.product_name, l.price, d.quantity, d.location, d.description, d.image " +
                                   "FROM listing l " +
                                   "JOIN description d ON l.listing_id = d.listing_id " +
                                   "WHERE l.product_name LIKE ?";

                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setString(1, "%" + searchQuery.trim() + "%");

                    ResultSet rs = stmt.executeQuery();

                    boolean hasResults = false;

                    while (rs.next()) {
                        hasResults = true;
                        int listingId = rs.getInt("listing_id");
                        String productName = rs.getString("product_name");
                        double price = rs.getDouble("price");
                        int quantity = rs.getInt("quantity");
                        String location = rs.getString("location");
                        String description = rs.getString("description");
                        byte[] imageBytes = rs.getBytes("image");
                        String imageData = (imageBytes != null) ? "data:image/jpg;base64," +
                                           Base64.getEncoder().encodeToString(imageBytes) : "https://via.placeholder.com/300x200?text=No+Image";
        %>
                <div class="product-card">
                    <img src="<%= imageData %>" alt="<%= productName %>" class="product-image">
                    <div class="product-info">
                        <h2 class="product-name"><%= productName %></h2>
                        <p class="product-location"><i class="fas fa-map-marker-alt"></i> <%= location != null ? location : "Location not specified" %></p>
                        <p class="product-price">$<%= String.format("%.2f", price) %></p>
                        <p class="product-description"><%= description != null ? description : "No description available" %></p>
                        <a href="productDetails.jsp?listing_id=<%= listingId %>" class="view-more">View Details</a>
                    </div>
                </div>
        <%
                    }

                    if (!hasResults) {
        %>
                <p>No results found for "<%= searchQuery %>".</p>
        <%
                    }

                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
            } else {
        %>
                <p>Please enter a search term.</p>
        <%
            }
        %>
    </div>
</div>
</body>
</html>


