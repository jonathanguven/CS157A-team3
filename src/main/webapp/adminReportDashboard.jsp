<%@ page import="java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Report Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #4CAF50;
            --secondary-color: #45a049;
            --background-color: #f4f4f9;
            --text-color: #333;
            --border-color: #e0e0e0;
        }

        body {
            font-family: 'Roboto', Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: var(--background-color);
            color: var(--text-color);
            line-height: 1.6;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }

        h2 {
            text-align: center;
            margin: 40px 0;
            color: var(--primary-color);
            font-weight: 500;
        }

        .table-container {
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            margin-bottom: 40px;
        }

        table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0;
        }

        th, td {
            padding: 16px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }

        th {
            background-color: #f8f8f8;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9em;
            letter-spacing: 0.5px;
        }

        tr:last-child td {
            border-bottom: none;
        }

        tr:hover {
            background-color: #f5f5f5;
            transition: background-color 0.3s ease;
        }

        .actions {
            display: flex;
            justify-content: center;
        }

        button {
            background-color: var(--primary-color);
            color: white;
            padding: 8px 16px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
            transition: background-color 0.3s ease, transform 0.1s ease;
            font-weight: 500;
        }

        button:hover {
            background-color: var(--secondary-color);
            transform: translateY(-1px);
        }

        button:active {
            transform: translateY(0);
        }

        .error-message {
            background-color: #ffebee;
            color: #c62828;
            padding: 16px;
            border-radius: 4px;
            margin-bottom: 20px;
            text-align: center;
        }

        @media (max-width: 768px) {
            .container {
                padding: 10px;
            }

            th, td {
                padding: 12px;
            }

            .actions {
                flex-direction: column;
            }

            button {
                margin-top: 8px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Report Management Dashboard</h2>
        
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Report ID</th>
                        <th>Listing ID</th>
                        <th>Product Name</th>
                        <th>Report Reason</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    // Get the user role from the session to ensure only admin can view
                    String role = (String) session.getAttribute("role");

                    // Check if the user is an admin
                    if (!"admin".equalsIgnoreCase(role)) {
                        out.println("<tr><td colspan='6'><div class='error-message'>Unauthorized access. Admins only.</div></td></tr>");
                        return;
                    }

                    // Database connection setup
                    Connection conn = null;
                    PreparedStatement ps = null;
                    ResultSet rs = null;

                    try {
                        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");

                        // Query to fetch unresolved reports
                        String query = "SELECT r.report_id, r.listing_id, l.product_name, r.report_reason, r.status " +
                                       "FROM Report r " +
                                       "JOIN Listing l ON r.listing_id = l.listing_id " +
                                       "WHERE r.status != 'Resolved'";

                        ps = conn.prepareStatement(query);
                        rs = ps.executeQuery();

                        if (!rs.next()) {
                            out.println("<tr><td colspan='6'>No unresolved reports found.</td></tr>");
                        } else {
                            // Loop through the results and display them
                            do {
                                int reportId = rs.getInt("report_id");
                                int listingId = rs.getInt("listing_id");
                                String productName = rs.getString("product_name");
                                String reportReason = rs.getString("report_reason");
                                String status = rs.getString("status");
                %>

                <tr>
                    <td><%= reportId %></td>
                    <td><%= listingId %></td>
                    <td><%= productName %></td>
                    <td><%= reportReason %></td>
                    <td><%= status %></td>
                    <td class="actions">
                        <form action="AdminReportDashboard" method="post">
                            <input type="hidden" name="report_id" value="<%= reportId %>">
                            <button type="submit">Resolve</button>
                        </form>
                    </td>
                </tr>

                <% 
                            } while (rs.next());
                        }
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='6'><div class='error-message'>Error fetching reports: " + e.getMessage() + "</div></td></tr>");
                    } finally {
                        try {
                            if (rs != null) rs.close();
                            if (ps != null) ps.close();
                            if (conn != null) conn.close();
                        } catch (SQLException e) {
                            out.println("<tr><td colspan='6'><div class='error-message'>Error closing database resources: " + e.getMessage() + "</div></td></tr>");
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>

