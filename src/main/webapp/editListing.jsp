<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Base64, java.util.UUID" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Listing - Grocery Gander</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4CAF50;
            --primary-dark: #45a049;
            --secondary-color: #2196F3;
            --text-color: #333;
            --background-color: #f4f4f9;
            --card-background: rgba(255, 255, 255, 0.8);
            --shadow-color: rgba(0, 0, 0, 0.1);
            --transition-speed: 0.3s;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
        }

        .container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
            background: var(--card-background);
            border-radius: 8px;
            box-shadow: 0 4px 6px var(--shadow-color);
            backdrop-filter: blur(10px);
        }

        h1 {
            text-align: center;
            color: var(--primary-color);
            margin-bottom: 2rem;
            font-weight: 700;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 500;
        }

        input[type="text"],
        input[type="number"],
        textarea,
        select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color var(--transition-speed);
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus,
        select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 2px rgba(76, 175, 80, 0.2);
        }

        .file-input-wrapper {
            position: relative;
            overflow: hidden;
            display: inline-block;
        }

        .file-input-wrapper input[type="file"] {
            font-size: 100px;
            position: absolute;
            left: 0;
            top: 0;
            opacity: 0;
        }

        .file-input-wrapper .btn-file-input {
            background-color: var(--secondary-color);
            color: white;
            padding: 0.75rem 1rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            display: inline-block;
            font-weight: 500;
            transition: background-color var(--transition-speed);
        }

        .file-input-wrapper .btn-file-input:hover {
            background-color: #1976D2;
        }

        .submit-btn {
            background-color: var(--primary-color);
            color: white;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: background-color var(--transition-speed), transform var(--transition-speed);
            display: block;
            margin: 2rem auto 0;
        }

        .submit-btn:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }

        .image-preview {
            max-width: 100%;
            height: auto;
            margin-top: 1rem;
            border-radius: 4px;
            box-shadow: 0 2px 4px var(--shadow-color);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .fade-in {
            animation: fadeIn 0.5s ease-in;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }
        }
    </style>
</head>
<body>

<div class="container fade-in">
    <h1>Edit Listing</h1>

    <%
        String listingIdStr = request.getParameter("listing_id");
        int listingId = Integer.parseInt(listingIdStr);
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
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

    <form action="EditListing" method="post" enctype="multipart/form-data" id="editListingForm">
        <input type="hidden" name="listing_id" value="<%= listingId %>">

        <div class="form-group">
            <label for="product_name">Product Name</label>
            <input type="text" id="product_name" name="product_name" value="<%= productName %>" required>
        </div>

        <div class="form-group">
            <label for="price">Price ($)</label>
            <input type="number" id="price" name="price" value="<%= price %>" step="0.01" min="0" required>
        </div>

        <div class="form-group">
            <label for="quantity">Quantity</label>
            <input type="number" id="quantity" name="quantity" value="<%= quantity %>" min="0" required>
        </div>

        <div class="form-group">
            <label for="location">Location</label>
            <input type="text" id="location" name="location" value="<%= location != null ? location : "" %>">
        </div>

        <div class="form-group">
            <label for="description">Description</label>
            <textarea id="description" name="description" rows="4"><%= description != null ? description : "" %></textarea>
        </div>

        <div class="form-group">
            <label for="category">Category</label>
            <select id="category" name="category_id" required>
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
        </div>

        <div class="form-group">
            <label for="image">Product Image</label>
            <div class="file-input-wrapper">
                <button class="btn-file-input" type="button">Choose File</button>
                <input type="file" id="image" name="image" accept="image/*">
            </div>
            <div id="file-name"></div>
            <% if (imageBase64 != null) { %>
                <img src="data:image/jpeg;base64,<%= imageBase64 %>" alt="Current product image" class="image-preview" id="currentImage">
            <% } %>
            <img id="imagePreview" class="image-preview" style="display: none;" alt="New image preview">
        </div>

        <button type="submit" class="submit-btn">Update Listing</button>
    </form>

    <%
            } else {
                out.println("<p>Listing not found.</p>");
            }
        } catch (Exception e) {
            out.println("<p>Error: " + e.getMessage() + "</p>");
            e.printStackTrace();
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
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
        const form = document.getElementById('editListingForm');
        const fileInput = document.getElementById('image');
        const fileNameDisplay = document.getElementById('file-name');
        const imagePreview = document.getElementById('imagePreview');
        const currentImage = document.getElementById('currentImage');

        form.addEventListener('submit', function(e) {
            e.preventDefault();
            if (validateForm()) {
                this.submit();
            }
        });

        fileInput.addEventListener('change', function(e) {
            const fileName = e.target.files[0].name;
            fileNameDisplay.textContent = fileName;

            const reader = new FileReader();
            reader.onload = function(e) {
                imagePreview.src = e.target.result;
                imagePreview.style.display = 'block';
                if (currentImage) {
                    currentImage.style.display = 'none';
                }
            }
            reader.readAsDataURL(e.target.files[0]);
        });

        function validateForm() {
            let isValid = true;
            const requiredFields = form.querySelectorAll('[required]');
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = 'red';
                } else {
                    field.style.borderColor = '';
                }
            });

            if (!isValid) {
                alert('Please fill in all required fields.');
            }

            return isValid;
        }
    });
</script>

</body>
</html>

