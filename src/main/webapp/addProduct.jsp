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
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/socket.io/4.3.2/socket.io.js"></script>
    <style>
        :root {
            --primary-color: #28a745;
            --primary-hover: #218838;
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

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 30px;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(31, 38, 135, 0.37);
            border: 1px solid rgba(255, 255, 255, 0.18);
            transition: all 0.3s ease;
        }

        .container:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 40px 0 rgba(31, 38, 135, 0.45);
        }

        h1 {
            text-align: center;
            margin-bottom: 30px;
            color: var(--primary-color);
        }

        .form-group {
            margin-bottom: 25px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 500;
        }

        input, select, textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 16px;
            transition: all 0.3s ease;
        }

        input:focus, select:focus, textarea:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(40, 167, 69, 0.2);
        }

        .required::after {
            content: "*";
            color: #dc3545;
            margin-left: 4px;
        }

        button, input[type="submit"] {
            background-color: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 16px;
            font-weight: 500;
        }

        button:hover, input[type="submit"]:hover {
            background-color: var(--primary-hover);
            transform: translateY(-2px);
        }

        #generateDescription {
            background-color: #007bff;
            margin-bottom: 20px;
        }

        #generateDescription:hover {
            background-color: #0056b3;
        }

        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-10px); }
            100% { transform: translateY(0px); }
        }

        .float-animation {
            animation: float 4s ease-in-out infinite;
        }

        .collaboration-indicator {
            position: fixed;
            bottom: 20px;
            right: 20px;
            background: rgba(255, 255, 255, 0.8);
            padding: 10px;
            border-radius: 50%;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }

        .collaboration-indicator::before {
            content: '';
            display: inline-block;
            width: 10px;
            height: 10px;
            background-color: #28a745;
            border-radius: 50%;
            margin-right: 5px;
        }
    </style>
</head>
<body>
    <div class="parallax-bg"></div>
    <div class="container float-animation">
        <h1>Add New Product</h1>

        <form action="addProduct" method="post" enctype="multipart/form-data" id="productForm">
            <div class="form-group">
                <label for="productName" class="required">Product Name:</label>
                <input type="text" id="productName" name="productName" required>
            </div>

            <div class="form-group">
                <label for="image">Product Image (optional):</label>
                <input type="file" id="image" name="image">
            </div>

            <div class="form-group">
                <label for="location">Location (optional):</label>
                <input type="text" id="location" name="location">
            </div>

            <div class="form-group">
                <label for="price" class="required">Price:</label>
                <input type="number" id="price" name="price" step="0.01" required>
            </div>

            <div class="form-group">
                <label for="quantity" class="required">Quantity:</label>
                <input type="number" id="quantity" name="quantity" required>
            </div>

            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description"></textarea>
            </div>

            <button type="button" id="generateDescription" onclick="generateDescription()">Generate me a description</button>

            <div class="form-group">
                <label for="category" class="required">Category:</label>
                <select id="category" name="category" required>
                    <option value="">Select Category</option>
                    <%
                        try {
                            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");
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

            <input type="submit" value="Add Product">
        </form>
    </div>

    <div class="collaboration-indicator" title="Real-time collaboration active"></div>

    <script>
        function generateDescription() {
            const form = document.getElementById('productForm');
            const formData = new FormData(form);
            const imageFile = formData.get('image');

            if (imageFile && imageFile.size > 0) {
                const reader = new FileReader();
                reader.onload = function(event) {
                    const imgBase64 = event.target.result.split(',')[1];
                    sendToGeminiAPI(imgBase64, imageFile.type);
                };
                reader.readAsDataURL(imageFile);
            } else {
                sendToGeminiAPI();
            }
        }

        function sendToGeminiAPI(imgBase64 = '', mimeType = 'image/jpeg') {
            const payload = {
                contents: [{
                    parts: [
                        {"text": "Provide a description for this product."},
                        imgBase64 ? {
                            "inline_data": {
                                "mime_type": mimeType,
                                "data": imgBase64
                            }
                        } : {}
                    ]
                }]
            };
            
            const apiKey = "AIzaSyAaprpvB0GbKrRXK_OvM3XbpWBF_iozjOw";
            fetch(`https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=${apiKey}`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(payload)
            })
            .then(response => response.json())
            .then(data => {
                console.log(data);
                document.getElementById('description').value = data.generated_text;
            })
            .catch(error => {
                console.error('Error:', error);
            });
        }

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

        // Real-time collaboration (simulated)
        const socket = io('http://localhost:3000');
        socket.on('productUpdate', (data) => {
            console.log('Product updated:', data);
            // Update the UI accordingly
        });

        // Micro-animations
        const formInputs = document.querySelectorAll('input, select, textarea');
        formInputs.forEach(input => {
            input.addEventListener('focus', () => {
                input.style.transform = 'scale(1.02)';
            });
            input.addEventListener('blur', () => {
                input.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>

