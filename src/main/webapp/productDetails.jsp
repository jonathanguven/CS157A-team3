<%@ page import="java.sql.*, java.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Product Details - <%= request.getParameter("listing_id") != null ? request.getParameter("listing_id") : "Product" %></title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #FF9800;
            --background-color: #f0f4f8;
            --text-color: #333;
            --shadow-color: rgba(0, 0, 0, 0.1);
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

        .product-container {
            max-width: 1200px;
            margin: 40px auto;
            background-color: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 10px 30px var(--shadow-color);
        }

        .product-header {
            padding: 30px;
            background: linear-gradient(135deg, var(--primary-color), var(--secondary-color));
            color: #fff;
            text-align: center;
        }

        .product-header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }

        .product-details {
            display: flex;
            flex-wrap: wrap;
            padding: 30px;
            gap: 30px;
        }

        .product-image {
            flex: 1 1 300px;
            max-width: 500px;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 15px var(--shadow-color);
        }

        .product-image img {
            width: 100%;
            height: auto;
            object-fit: cover;
        }

        .product-info {
            flex: 2 1 400px;
        }

        .product-info h2 {
            font-size: 2.2em;
            color: var(--primary-color);
            margin-bottom: 20px;
        }

        .product-info p {
            margin-bottom: 15px;
            font-size: 1.1em;
        }

        .product-info .price {
            font-size: 1.8em;
            color: var(--secondary-color);
            font-weight: bold;
        }

        .product-info .description {
            background-color: #f9f9f9;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
        }

        .report-form {
            padding: 30px;
            background-color: #f1f1f1;
            border-top: 1px solid #ddd;
        }

        .report-form h3 {
            margin-bottom: 20px;
            color: #e74c3c;
            font-size: 1.5em;
        }

        .report-form textarea {
            width: 100%;
            height: 120px;
            padding: 15px;
            border: 1px solid #ccc;
            border-radius: 10px;
            resize: vertical;
            font-size: 1em;
        }

        .report-form button {
            margin-top: 15px;
            padding: 12px 25px;
            background-color: #e74c3c;
            border: none;
            color: #fff;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1em;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .alert {
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
            animation: fadeIn 0.5s ease;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-left: 5px solid #28a745;
        }

        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 5px solid #dc3545;
        }

        @media (max-width: 768px) {
            .product-details {
                flex-direction: column;
            }
            .product-image {
                max-width: 100%;
            }
        }
    </style>
</head>
<body>
    <div class="product-container">
        <div class="product-header">
            <h1>Product Details</h1>
        </div>

        <%
        String successParam = request.getParameter("success");
        if ("report_submitted".equals(successParam)) {
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> Report submitted successfully.
            </div>
        <%
        }

        String listingIdParam = request.getParameter("listing_id");
        if (listingIdParam == null || listingIdParam.trim().isEmpty()) {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i> Invalid listing ID.
            </div>
        <%
        } else {
            int listingId = 0;
            try {
                listingId = Integer.parseInt(listingIdParam);
            } catch (NumberFormatException e) {
        %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> Invalid listing ID format.
                </div>
        <%
                return;
            }

            String sql = "SELECT l.listing_id, l.product_name, l.price, d.description, d.image, d.quantity, d.location " +
                         "FROM Listing l " +
                         "LEFT JOIN Description d ON l.listing_id = d.listing_id " +
                         "WHERE l.listing_id = ?";
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setInt(1, listingId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        String productName = rs.getString("product_name");
                        double price = rs.getDouble("price");
                        String description = rs.getString("description");
                        Blob imageBlob = rs.getBlob("image");
                        int quantity = rs.getInt("quantity");
                        String location = rs.getString("location");

                        String base64Image = "";
                        String imageType = "jpeg";
                        if (imageBlob != null) {
                            byte[] imageBytes = imageBlob.getBytes(1, (int) imageBlob.length());
                            base64Image = Base64.getEncoder().encodeToString(imageBytes);
                        }
        %>
        <div class="product-details">
            <div class="product-image">
                <% if (!base64Image.isEmpty()) { %>
                    <img src="data:image/<%= imageType %>;base64,<%= base64Image %>" alt="<%= productName %>">
                <% } else { %>
                    <img src="https://via.placeholder.com/400x300?text=No+Image" alt="No Image Available">
                <% } %>
            </div>
            <div class="product-info">
                <h2><%= productName %></h2>
                <p class="price"><i class="fas fa-tag"></i> $<%= String.format("%.2f", price) %></p>
                <p class="quantity"><i class="fas fa-boxes"></i> Quantity: <%= quantity %></p>
                <p class="location"><i class="fas fa-map-marker-alt"></i> Location: <%= (location != null && !location.trim().isEmpty()) ? location : "N/A" %></p>
                <div class="description">
                    <p><i class="fas fa-info-circle"></i> <strong>Description:</strong></p>
                    <p><%= (description != null && !description.trim().isEmpty()) ? description : "No description available." %></p>
                </div>
            </div>
        </div>

        <div class="report-form">
            <h3><i class="fas fa-exclamation-circle"></i> Report This Listing</h3>
            <form action="SubmitReportServlet" method="post">
                <input type="hidden" name="listing_id" value="<%= listingId %>">
                <textarea name="report_reason" id="report_reason" placeholder="Describe why you're reporting this listing..." required></textarea>
                <button type="submit"><i class="fas fa-paper-plane"></i> Submit Report</button>
            </form>
        </div>

        <%
                    } else {
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-triangle"></i> Listing not found.
            </div>
        <%
                    }
                }
            } catch (SQLException e) {
        %>
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-triangle"></i> Error: <%= e.getMessage() %>
                </div>
        <%
                e.printStackTrace();
            }
        }
        %>
    </div>
</body>
</html>



