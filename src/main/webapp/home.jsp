<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.util.Base64" %>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Grocery Gander - Your Local Produce Marketplace</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #FFA000;
            --accent-color: #FF5722;
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
            height: 80vh;
            display: flex;
            align-items: center;
            justify-content: center;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
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
            animation: fadeInUp 1s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(20px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .hero h1 {
            font-size: 4rem;
            margin-bottom: 1rem;
            text-shadow: 2px 2px 4px rgba(0,0,0,0.5);
        }

        .hero p {
            font-size: 1.5rem;
            max-width: 800px;
            margin: 0 auto 2rem;
            text-shadow: 1px 1px 2px rgba(0,0,0,0.5);
        }

        .cta-button {
            display: inline-block;
            background-color: var(--accent-color);
            color: white;
            padding: 1rem 2rem;
            border-radius: 50px;
            text-decoration: none;
            font-size: 1.2rem;
            font-weight: 600;
            transition: all 0.3s ease;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }

        .cta-button:hover {
            background-color: #e64a19;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0,0,0,0.15);
        }

        .section-title {
            font-size: 2.5rem;
            text-align: center;
            margin: 3rem 0;
            color: var(--primary-color);
            position: relative;
        }

        .section-title::after {
            content: '';
            display: block;
            width: 100px;
            height: 4px;
            background-color: var(--accent-color);
            margin: 1rem auto 0;
        }

        .product-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 2rem;
        }

        .product-card {
            background-color: var(--card-background);
            border-radius: 15px;
            box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: all 0.3s ease;
            position: relative;
        }

        .product-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 15px 30px rgba(0, 0, 0, 0.2);
        }

        .product-image {
            width: 100%;
            height: 250px;
            object-fit: cover;
            transition: transform 0.3s ease;
        }

        .product-card:hover .product-image {
            transform: scale(1.05);
        }

        .product-info {
            padding: 1.5rem;
        }

        .product-name {
            font-size: 1.4rem;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--primary-color);
        }

        .product-location {
            font-size: 1rem;
            color: #666;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .product-location i {
            margin-right: 0.5rem;
            color: var(--secondary-color);
        }

        .product-price {
            font-size: 1.3rem;
            font-weight: 600;
            color: var(--accent-color);
            margin-bottom: 0.5rem;
        }

        .product-quantity {
            font-size: 1rem;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
        }

        .product-quantity i {
            margin-right: 0.5rem;
            color: var(--secondary-color);
        }

        .product-description {
            font-size: 1rem;
            margin-bottom: 1rem;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }

        .view-more {
            display: inline-block;
            background-color: var(--secondary-color);
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .view-more:hover {
            background-color: #e69500;
            transform: translateY(-2px);
        }

        .features {
            display: flex;
            justify-content: space-around;
            flex-wrap: wrap;
            margin: 4rem 0;
        }

        .feature {
            text-align: center;
            max-width: 300px;
            margin: 2rem;
        }

        .feature i {
            font-size: 3rem;
            color: var(--primary-color);
            margin-bottom: 1rem;
        }

        .feature h3 {
            font-size: 1.5rem;
            margin-bottom: 1rem;
            color: var(--secondary-color);
        }

        .feature p {
            font-size: 1rem;
            color: #666;
        }

        .testimonials {
            background-color: #e8f5e9;
            padding: 4rem 0;
            margin: 4rem 0;
        }

        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 2rem;
        }

        .testimonial {
            background-color: white;
            padding: 2rem;
            border-radius: 15px;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        .testimonial p {
            font-style: italic;
            margin-bottom: 1rem;
        }

        .testimonial-author {
            font-weight: 600;
            color: var(--primary-color);
        }

        .newsletter {
            background-color: var(--primary-color);
            color: white;
            padding: 4rem 0;
            text-align: center;
        }

        .newsletter h2 {
            font-size: 2.5rem;
            margin-bottom: 1rem;
        }

        .newsletter p {
            font-size: 1.2rem;
            margin-bottom: 2rem;
            max-width: 600px;
            margin-left: auto;
            margin-right: auto;
        }

        .newsletter-form {
            display: flex;
            justify-content: center;
            max-width: 500px;
            margin: 0 auto;
        }

        .newsletter-input {
            flex-grow: 1;
            padding: 1rem;
            font-size: 1rem;
            border: none;
            border-radius: 25px 0 0 25px;
        }

        .newsletter-button {
            background-color: var(--accent-color);
            color: white;
            border: none;
            padding: 1rem 2rem;
            font-size: 1rem;
            font-weight: 600;
            border-radius: 0 25px 25px 0;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        .newsletter-button:hover {
            background-color: #e64a19;
        }

        @media (max-width: 768px) {
            .hero h1 {
                font-size: 3rem;
            }

            .hero p {
                font-size: 1.2rem;
            }

            .product-grid {
                grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            }

            .features {
                flex-direction: column;
                align-items: center;
            }

            .newsletter-form {
                flex-direction: column;
            }

            .newsletter-input, .newsletter-button {
                width: 100%;
                border-radius: 25px;
                margin-bottom: 1rem;
            }
        }
    </style>
</head>
<body>
    <div class="hero">
        <div class="hero-content">
            <h1>Welcome to Grocery Gander</h1>
            <p>Discover fresh, local produce and artisanal goods from farmers and makers in your community</p>
            <a href="#featured-products" class="cta-button">Explore Products</a>
        </div>
    </div>

    <div class="container">
        <section id="featured-products">
            <h2 class="section-title">Featured Products</h2>
            <div class="product-grid">
                <%
                    // Database connection parameters
                    String DB_URL = "jdbc:mysql://localhost:3306/GroceryGander";
                    String DB_USER = "root";
                    String DB_PASSWORD = "password";
   
                    // Get the search query from the request parameter
                    String searchQuery = request.getParameter("query");

                    // Base query to fetch product details
                    String query = "SELECT l.listing_id, l.product_name, l.price, d.quantity, d.location, d.description, d.image " +
                                   "FROM listing l " +
                                   "JOIN description d ON l.listing_id = d.listing_id " +
                                   "ORDER BY RAND() LIMIT 8"; // Randomly select 8 products

                    try {
                        Class.forName("com.mysql.cj.jdbc.Driver");
                        Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                        PreparedStatement stmt = conn.prepareStatement(query);
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
        </section>

        <section class="features">
            <div class="feature">
                <i class="fas fa-leaf"></i>
                <h3>Fresh & Local</h3>
                <p>Support local farmers and enjoy the freshest produce straight from the source.</p>
            </div>
            <div class="feature">
                <i class="fas fa-hand-holding-heart"></i>
                <h3>Community-Driven</h3>
                <p>Connect with local producers and build a stronger, more sustainable community.</p>
            </div>
            <div class="feature">
                <i class="fas fa-seedling"></i>
                <h3>Seasonal Variety</h3>
                <p>Discover a wide range of seasonal fruits, vegetables, and artisanal products.</p>
            </div>
        </section>

        <section class="testimonials">
            <h2 class="section-title">What Our Customers Say</h2>
            <div class="testimonial-grid">
                <div class="testimonial">
                    <p>"Grocery Gander has transformed the way I shop for produce. The quality and freshness are unmatched!"</p>
                    <p class="testimonial-author">- Sarah J.</p>
                </div>
                <div class="testimonial">
                    <p>"I love supporting local farmers through this platform. It's a win-win for everyone involved."</p>
                    <p class="testimonial-author">- Mike T.</p>
                </div>
                <div class="testimonial">
                    <p>"The variety of products available is amazing. I've discovered so many new local delicacies!"</p>
                    <p class="testimonial-author">- Emily R.</p>
                </div>
            </div>
        </section>
    </div>

    <section class="newsletter">
        <div class="container">
            <h2>Stay Updated</h2>
            <p>Subscribe to our newsletter for the latest updates on fresh produce and local events.</p>
            <form class="newsletter-form" action="subscribeNewsletter" method="post">
                <input type="email" name="email" placeholder="Enter your email" required class="newsletter-input">
                <button type="submit" class="newsletter-button">Subscribe</button>
            </form>
        </div>
    </section>

    <script>
        // Smooth scroll for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                document.querySelector(this.getAttribute('href')).scrollIntoView({
                    behavior: 'smooth'
                });
            });
        });

        // Lazy loading for images
        document.addEventListener("DOMContentLoaded", function() {
            var lazyImages = [].slice.call(document.querySelectorAll("img.lazy"));

            if ("IntersectionObserver" in window) {
                let lazyImageObserver = new IntersectionObserver(function(entries, observer) {
                    entries.forEach(function(entry) {
                        if (entry.isIntersecting) {
                            let lazyImage = entry.target;
                            lazyImage.src = lazyImage.dataset.src;
                            lazyImage.classList.remove("lazy");
                            lazyImageObserver.unobserve(lazyImage);
                        }
                    });
                });

                lazyImages.forEach(function(lazyImage) {
                    lazyImageObserver.observe(lazyImage);
                });
            }
        });
    </script>
</body>
</html>

