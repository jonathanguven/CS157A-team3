<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to Grocery Gander - Fresh Local Produce</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #FFA000;
            --background-color: #f4f4f4;
            --text-color: #333;
            --card-background: #ffffff;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Poppins', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        .hero {
            background-image: url('https://images.unsplash.com/photo-1542838132-92c53300491e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1950&q=80');
            background-size: cover;
            background-position: center;
            height: 60vh;
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

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
        }

        .product-card {
            background-color: var(--card-background);
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
            font-weight: 600;
            margin-bottom: 0.5rem;
        }

        .product-location {
            font-size: 0.9rem;
            color: #666;
            margin-bottom: 0.5rem;
        }

        .product-price {
            font-size: 1.1rem;
            font-weight: 600;
            color: var(--primary-color);
            margin-bottom: 0.5rem;
        }

        .product-quantity {
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
        }

        .product-description {
            font-size: 0.9rem;
            margin-bottom: 0.5rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .view-more {
            display: inline-block;
            background-color: var(--secondary-color);
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
    <div class="hero">
        <div class="hero-content">
            <h1>Welcome to Grocery Gander</h1>
            <p>Discover fresh, local produce from farmers in your area</p>
        </div>
    </div>

    <div class="container">
        <div class="product-grid" id="productGrid">
            <%
                // Database connection parameters
                String DB_URL = "jdbc:mysql://localhost:3306/userdb";
                String DB_USER = "root";
                String DB_PASSWORD = "mysql";

                // Get the search query from the request parameter
                String searchQuery = request.getParameter("query");

                // Base query to fetch product details
                String query = "SELECT l.listing_id, l.product_name, l.price, d.quantity, d.location, d.description, d.image " +
                               "FROM listing l " +
                               "JOIN description d ON l.listing_id = d.listing_id";

                // Add a WHERE clause if a search query is provided
                if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                    query += " WHERE l.product_name LIKE ?";
                }

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                    PreparedStatement stmt = conn.prepareStatement(query);

                    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                        stmt.setString(1, "%" + searchQuery.trim() + "%");
                    }

                    ResultSet rs = stmt.executeQuery();

                    // Iterate through the result set and render the products
                    while (rs.next()) {
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
                        <p class="product-quantity"><i class="fas fa-cubes"></i> <%= quantity %> available</p>
                        <p class="product-description"><%= description != null ? description : "No description available" %></p>
                        <a href="productDetails.jsp?listing_id=<%= listingId %>" class="view-more">View Details</a>
                    </div>
                </div>
            <%
                    }

                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</body>
</html>


