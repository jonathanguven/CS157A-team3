<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.Base64" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Listings - Grocery Gander</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #45a049;
            --background-color: #f4f4f9;
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
            overflow-x: hidden;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        header {
            background: rgba(76, 175, 80, 0.8);
            backdrop-filter: blur(10px);
            color: white;
            padding: 10px 0;
            position: fixed;
            width: 100%;
            z-index: 1000;
            transition: all 0.3s ease;
            height: 80px; /* Added fixed height */
            display: flex;
            align-items: center; /* Center content vertically */
        }

        header h1 {
            margin-top: 10px;
        }

        h1, h2 {
            text-align: center;
            margin: 20px 0;
        }

        .listings-container {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 20px;
            padding-top: 120px; /* Increased from 100px */
        }

        .listing-card {
            background: rgba(255, 255, 255, 0.7);
            border-radius: 15px;
            padding: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            backdrop-filter: blur(4px);
            border: 1px solid rgba(255, 255, 255, 0.18);
            transition: all 0.3s ease;
        }

        .listing-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.45);
        }

        .listing-image {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .listing-details h3 {
            font-size: 1.2em;
            margin-bottom: 10px;
        }

        .listing-details p {
            font-size: 0.9em;
            color: #666;
            margin-bottom: 5px;
        }

        .actions {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
        }

        button {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 10px 15px;
            border-radius: 5px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        button:hover {
            background-color: var(--secondary-color);
            transform: scale(1.05);
        }

        .delete-btn {
            background-color: #ff4444;
        }

        .delete-btn:hover {
            background-color: #cc0000;
        }

        .parallax-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-image: url('https://example.com/path/to/background-image.jpg');
            background-size: cover;
            background-position: center;
            z-index: -1;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        .float-animation {
            animation: float 3s ease-in-out infinite;
        }

        @media (max-width: 768px) {
            .listings-container {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="parallax-bg"></div>
    <header>
        <div class="container">
            <h1>Manage Listings</h1>
        </div>
    </header>

    <div class="container">
        <div class="listings-container">
            <%
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;

                try {
                    // Establish database connection
                    Class.forName("com.mysql.jdbc.Driver");
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");

                    // Get user role and sellerId from session
                    String role = (String) session.getAttribute("role");
                    String sellerId = (String) session.getAttribute("idseller");

                    // If no sellerId in session, try to fetch from cookies
                    if (sellerId == null) {
                        Cookie[] cookies = request.getCookies();
                        if (cookies != null) {
                            for (Cookie cookie : cookies) {
                                if ("idseller".equals(cookie.getName())) {
                                    session.setAttribute("idseller", cookie.getValue());
                                    sellerId = cookie.getValue();
                                    break;
                                }
                            }
                        }
                    }

                    String query;
                    if ("admin".equals(role)) {
                        // Admin sees all listings
                        query = "SELECT l.listing_id, l.product_name, l.price, d.quantity, d.location, d.description, d.image " +
                                "FROM listing l " +
                                "JOIN description d ON l.listing_id = d.listing_id";
                        ps = conn.prepareStatement(query);
                    } else if (sellerId != null) {
                        // Seller only sees their own listings
                        query = "SELECT l.listing_id, l.product_name, l.price, d.quantity, d.location, d.description, d.image " +
                                "FROM listing l " +
                                "JOIN description d ON l.listing_id = d.listing_id " +
                                "WHERE l.idseller = ?";
                        ps = conn.prepareStatement(query);
                        ps.setInt(1, Integer.parseInt(sellerId));
                    } else {
                        // No sellerId, show no listings
                        out.println("<p>No listings available.</p>");
                        return;
                    }

                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int listingId = rs.getInt("listing_id");
                        String productName = rs.getString("product_name");
                        double price = rs.getDouble("price");
                        int quantity = rs.getInt("quantity");
                        String location = rs.getString("location");
                        String description = rs.getString("description");
                        byte[] imageBytes = rs.getBytes("image");

                        String imageBase64 = null;
                        if (imageBytes != null) {
                            imageBase64 = Base64.getEncoder().encodeToString(imageBytes);
                        }
            %>
                <div class="listing-card float-animation">
                    <% if (imageBase64 != null) { %>
                        <img src="data:image/jpeg;base64,<%= imageBase64 %>" class="listing-image" alt="<%= productName %>">
                    <% } else { %>
                        <div class="listing-image" style="background-color: #ddd; display: flex; align-items: center; justify-content: center;">No Image</div>
                    <% } %>
                    <div class="listing-details">
                        <h3><%= productName %></h3>
                        <p>Price: $<%= String.format("%.2f", price) %></p>
                        <p>Quantity: <%= quantity %></p>
                        <p>Location: <%= location != null ? location : "No location" %></p>
                        <p>Description: <%= description != null ? description : "No description" %></p>
                    </div>
                    <div class="actions">
                        <form action="editListing.jsp" method="get">
                            <input type="hidden" name="listing_id" value="<%= listingId %>">
                            <button type="submit">Edit</button>
                        </form>
                        <form action="DeleteListing" method="post">
                            <input type="hidden" name="listing_id" value="<%= listingId %>">
                            <button type="submit" class="delete-btn" onclick="return confirm('Are you sure you want to delete this listing?')">Delete</button>
                        </form>
                    </div>
                </div>
            <%
                    }
                } catch (Exception e) {
                    out.println("<p>Error: " + e.getMessage() + "</p>");
                } finally {
                    // Close database resources
                    if (rs != null) try { rs.close(); } catch (SQLException e) { /* ignored */ }
                    if (ps != null) try { ps.close(); } catch (SQLException e) { /* ignored */ }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { /* ignored */ }
                }
            %>
        </div>
    </div>

    <script>
        // Smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });

        // Parallax effect
        window.addEventListener('scroll', () => {
            const scrolled = window.pageYOffset;
            const parallaxBg = document.querySelector('.parallax-bg');
            parallaxBg.style.transform = `translateY(${scrolled * 0.5}px)`;
        });

        // Header scroll effect
        window.addEventListener('scroll', () => {
            const header = document.querySelector('header');
            if (window.scrollY > 50) {
                header.classList.add('scrolled');
            } else {
                header.classList.remove('scrolled');
            }
        });

        // Micro-animations
        document.querySelectorAll('.listing-card').forEach(card => {
            card.addEventListener('mouseenter', () => {
                card.style.transform = 'scale(1.03)';
            });
            card.addEventListener('mouseleave', () => {
                card.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>

