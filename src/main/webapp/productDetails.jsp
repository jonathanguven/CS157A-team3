<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details - Grocery Gander</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #34D399;
            --secondary-color: #F59E0B;
            --background-color: #F3F4F6;
            --text-color: #1F2937;
            --card-background: #FFFFFF;
            --border-color: #E5E7EB;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.5;
        }

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: var(--card-background);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            border-radius: 12px;
        }

        .product-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 3rem;
        }

        .product-image-container {
            position: relative;
            overflow: hidden;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        .product-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-image:hover {
            transform: scale(1.05);
        }

        .product-info {
            display: flex;
            flex-direction: column;
        }

        .product-name {
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--text-color);
            margin-bottom: 1rem;
            line-height: 1.2;
        }

        .product-meta {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
            padding-bottom: 1.5rem;
            border-bottom: 1px solid var(--border-color);
        }

        .product-price {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-color);
        }

        .product-quantity {
            font-size: 1rem;
            color: var(--text-color);
            background-color: var(--background-color);
            padding: 0.5rem 1rem;
            border-radius: 20px;
        }

        .product-location {
            font-size: 1rem;
            color: var(--text-color);
            margin-bottom: 1.5rem;
        }

        .product-description {
            font-size: 1.1rem;
            line-height: 1.6;
            color: var(--text-color);
            margin-bottom: 2rem;
        }

        .back-link {
            display: inline-flex;
            align-items: center;
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .back-link:hover {
            color: var(--secondary-color);
        }

        .back-link svg {
            width: 20px;
            height: 20px;
            margin-right: 0.5rem;
        }

        .error-message {
            background-color: #FEE2E2;
            color: #DC2626;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }

        .error-message svg {
            width: 24px;
            height: 24px;
            margin-right: 0.5rem;
        }

        @media (max-width: 768px) {
            .product-grid {
                grid-template-columns: 1fr;
            }

            .product-image-container {
                aspect-ratio: 1 / 1;
            }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .slide-up {
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { transform: translateY(20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
    </style>
</head>
<body>
    <div class="container fade-in">
        <%
            // Database connection parameters
            String DB_URL = "jdbc:mysql://localhost:3306/GroceryGander";
            String DB_USER = "root";
            String DB_PASSWORD = "password";

            // Get the listing_id from the request parameter
            String listingIdParam = request.getParameter("listing_id");
            if (listingIdParam != null) {
                int listingId = Integer.parseInt(listingIdParam);

                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                    // Query to retrieve product details
                    String query = "SELECT l.product_name, l.price, d.quantity, d.location, d.description, d.image " +
                                   "FROM listing l " +
                                   "JOIN description d ON l.listing_id = d.listing_id " +
                                   "WHERE l.listing_id = ?";

                    PreparedStatement stmt = conn.prepareStatement(query);
                    stmt.setInt(1, listingId);

                    ResultSet rs = stmt.executeQuery();

                    if (rs.next()) {
                        String productName = rs.getString("product_name");
                        double price = rs.getDouble("price");
                        int quantity = rs.getInt("quantity");
                        String location = rs.getString("location");
                        String description = rs.getString("description");
                        byte[] imageBytes = rs.getBytes("image");
                        String imageData = (imageBytes != null) ? "data:image/jpg;base64," + 
                                           Base64.getEncoder().encodeToString(imageBytes) : "https://via.placeholder.com/800x800?text=No+Image";
        %>
                <div class="product-grid">
                    <div class="product-image-container slide-up">
                        <img src="<%= imageData %>" alt="<%= productName %>" class="product-image">
                    </div>
                    <div class="product-info slide-up">
                        <h1 class="product-name"><%= productName %></h1>
                        <div class="product-meta">
                            <p class="product-price">$<%= String.format("%.2f", price) %></p>
                            <p class="product-quantity"><%= quantity %> available</p>
                        </div>
                        <p class="product-location">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                <circle cx="12" cy="10" r="3"></circle>
                            </svg>
                            <%= location != null ? location : "Location not specified" %>
                        </p>
                        <p class="product-description"><%= description != null ? description : "No description available" %></p>
                    </div>
                </div>
                <a href="home.jsp" class="back-link">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="19" y1="12" x2="5" y2="12"></line>
                        <polyline points="12 19 5 12 12 5"></polyline>
                    </svg>
                    Back to Listings
                </a>
        <%
                    } else {
        %>
                        <div class="error-message">
                            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                <circle cx="12" cy="12" r="10"></circle>
                                <line x1="12" y1="8" x2="12" y2="12"></line>
                                <line x1="12" y1="16" x2="12.01" y2="16"></line>
                            </svg>
                            Product not found.
                        </div>
        <%
                    }

                    rs.close();
                    stmt.close();
                    conn.close();
                } catch (Exception e) {
        %>
                    <div class="error-message">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <polygon points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2"></polygon>
                            <line x1="12" y1="8" x2="12" y2="12"></line>
                            <line x1="12" y1="16" x2="12.01" y2="16"></line>
                        </svg>
                        Error: <%= e.getMessage() %>
                    </div>
        <%
                    e.printStackTrace();
                }
            } else {
        %>
                <div class="error-message">
                    <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="12" y1="8" x2="12" y2="12"></line>
                        <line x1="12" y1="16" x2="12.01" y2="16"></line>
                    </svg>
                    Invalid product ID.
                </div>
        <%
            }
        %>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const productImage = document.querySelector('.product-image');
            if (productImage) {
                productImage.addEventListener('mousemove', function(e) {
                    const { left, top, width, height } = this.getBoundingClientRect();
                    const x = (e.clientX - left) / width;
                    const y = (e.clientY - top) / height;
                    this.style.transformOrigin = `${x * 100}% ${y * 100}%`;
                });
            }
        });
    </script>
</body>
</html>


