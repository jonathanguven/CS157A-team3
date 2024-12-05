<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Report Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #2196F3;
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

        .container {
            max-width: 1200px;
            margin: 2rem auto;
            padding: 2rem;
            background-color: #fff;
            border-radius: 15px;
            box-shadow: 0 10px 30px var(--shadow-color);
            transform-style: preserve-3d;
            perspective: 1000px;
        }

        h2 {
            font-size: 2.5rem;
            color: var(--primary-color);
            margin-bottom: 2rem;
            text-align: center;
            transform: translateZ(50px);
            transition: transform 0.3s ease;
        }

        .table-container {
            overflow-x: auto;
            margin-top: 2rem;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 15px;
        }

        thead {
            background-color: var(--primary-color);
            color: #fff;
        }

        th, td {
            padding: 1rem;
            text-align: left;
        }

        th {
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.1em;
        }

        tbody tr {
            background-color: #fff;
            box-shadow: 0 5px 15px var(--shadow-color);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        tbody tr:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 20px var(--shadow-color);
        }

        td a {
            color: var(--secondary-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        td a:hover {
            color: var(--primary-color);
        }

        .actions {
            display: flex;
            gap: 1rem;
            align-items: center;
        }

        select, button {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 5px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        select {
            background-color: #f0f0f0;
        }

        button {
            background-color: var(--secondary-color);
            color: #fff;
        }

        button:hover {
            background-color: var(--primary-color);
        }

        .error-message {
            color: #721c24;
            background-color: #f8d7da;
            border: 1px solid #f5c6cb;
            padding: 1rem;
            border-radius: 5px;
            margin-top: 1rem;
        }

        @media (max-width: 768px) {
            .container {
                padding: 1rem;
            }

            table {
                font-size: 0.9rem;
            }

            th, td {
                padding: 0.75rem;
            }

            .actions {
                flex-direction: column;
                gap: 0.5rem;
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        tbody tr {
            animation: fadeIn 0.5s ease forwards;
            opacity: 0;
        }

        .loading {
            text-align: center;
            font-size: 1.2rem;
            margin-top: 2rem;
        }

        .loading::after {
            content: '...';
            animation: ellipsis 1.5s infinite;
        }

        @keyframes ellipsis {
            0% { content: '.'; }
            33% { content: '..'; }
            66% { content: '...'; }
        }

        .status-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .status-pending { background-color: #ffeeba; color: #856404; }
        .status-reviewed { background-color: #b8daff; color: #004085; }
        .status-resolved { background-color: #c3e6cb; color: #155724; }

        .cube-bg {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: -1;
            opacity: 0.1;
        }

        .cube {
            position: absolute;
            width: 100px;
            height: 100px;
            transform-style: preserve-3d;
            animation: rotateCube 20s infinite linear;
        }

        .cube-face {
            position: absolute;
            width: 100%;
            height: 100%;
            background-color: var(--primary-color);
            opacity: 0.7;
            border: 2px solid #fff;
        }

        .cube-face:nth-child(1) { transform: translateZ(50px); }
        .cube-face:nth-child(2) { transform: rotateY(180deg) translateZ(50px); }
        .cube-face:nth-child(3) { transform: rotateY(-90deg) translateZ(50px); }
        .cube-face:nth-child(4) { transform: rotateY(90deg) translateZ(50px); }
        .cube-face:nth-child(5) { transform: rotateX(-90deg) translateZ(50px); }
        .cube-face:nth-child(6) { transform: rotateX(90deg) translateZ(50px); }

        @keyframes rotateCube {
            0% { transform: rotateX(0deg) rotateY(0deg); }
            100% { transform: rotateX(360deg) rotateY(360deg); }
        }
    </style>
</head>
<body>
    <div class="cube-bg">
        <div class="cube">
            <div class="cube-face"></div>
            <div class="cube-face"></div>
            <div class="cube-face"></div>
            <div class="cube-face"></div>
            <div class="cube-face"></div>
            <div class="cube-face"></div>
        </div>
    </div>
    <div class="container">
        <h2>Report Management Dashboard</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Report ID</th>
                        <th>Listing ID</th>
                        <th>Product Name</th>
                        <th>Reason</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        String sql = "SELECT r.report_id, r.listing_id, l.product_name, r.report_reason, r.status FROM Report r JOIN Listing l ON r.listing_id = l.listing_id WHERE r.status != 'Resolved'";
                        try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");
                             PreparedStatement ps = conn.prepareStatement(sql);
                             ResultSet rs = ps.executeQuery()) {

                            if (!rs.isBeforeFirst()) {
                                out.println("<tr><td colspan='6'>No unresolved reports found.</td></tr>");
                            } else {
                                while (rs.next()) {
                                    int reportId = rs.getInt("report_id");
                                    int listingId = rs.getInt("listing_id");
                                    String productName = rs.getString("product_name");
                                    String reason = rs.getString("report_reason");
                                    String status = rs.getString("status");
                    %>
                    <tr>
                        <td><%= reportId %></td>
                        <td><a href="productDetails.jsp?listing_id=<%= listingId %>"><%= listingId %></a></td>
                        <td><%= productName %></td>
                        <td><%= reason %></td>
                        <td>
                            <span class="status-badge status-<%= status.toLowerCase() %>"><%= status %></span>
                        </td>
                        <td class="actions">
                            <form action="AdminReportDashboard" method="post">
                                <input type="hidden" name="report_id" value="<%= reportId %>">
                                <select name="status">
                                    <option value="Pending" <%= "Pending".equals(status) ? "selected" : "" %>>Pending</option>
                                    <option value="Reviewed" <%= "Reviewed".equals(status) ? "selected" : "" %>>Reviewed</option>
                                    <option value="Resolved" <%= "Resolved".equals(status) ? "selected" : "" %>>Resolved</option>
                                </select>
                                <button type="submit">Update</button>
                            </form>
                        </td>
                    </tr>
                    <%
                                }
                            }
                        } catch (SQLException e) {
                            e.printStackTrace();
                            out.println("<tr><td colspan='6' class='error-message'>Error loading reports: " + e.getMessage() + "</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const rows = document.querySelectorAll('tbody tr');
            rows.forEach((row, index) => {
                row.style.animationDelay = `${index * 0.1}s`;
            });

            const container = document.querySelector('.container');
            const title = document.querySelector('h2');

            container.addEventListener('mousemove', (e) => {
                const { left, top, width, height } = container.getBoundingClientRect();
                const x = (e.clientX - left) / width;
                const y = (e.clientY - top) / height;

                const rotateX = (y - 0.5) * 10;
                const rotateY = (x - 0.5) * 10;

                container.style.transform = `rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
                title.style.transform = `translateZ(50px) rotateX(${-rotateX}deg) rotateY(${-rotateY}deg)`;
            });

            container.addEventListener('mouseleave', () => {
                container.style.transform = 'rotateX(0) rotateY(0)';
                title.style.transform = 'translateZ(50px)';
            });

            // Create multiple cubes in the background
            const cubeContainer = document.querySelector('.cube-bg');
            for (let i = 0; i < 5; i++) {
                const cube = document.createElement('div');
                cube.className = 'cube';
                cube.style.left = `${Math.random() * 100}%`;
                cube.style.top = `${Math.random() * 100}%`;
                cube.style.animationDuration = `${20 + Math.random() * 10}s`;
                for (let j = 0; j < 6; j++) {
                    const face = document.createElement('div');
                    face.className = 'cube-face';
                    cube.appendChild(face);
                }
                cubeContainer.appendChild(cube);
            }
        });
    </script>
</body>
</html>


