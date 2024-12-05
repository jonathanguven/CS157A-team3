<%@ page import="java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<%@ page import="java.sql.*" %>
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
            margin: 50px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            color: var(--primary-color);
            font-weight: 500;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }

        th, td {
            padding: 12px 16px;
            border-bottom: 1px solid var(--border-color);
            text-align: left;
        }

        th {
            background-color: #f8f8f8;
            font-weight: 500;
            text-transform: uppercase;
            font-size: 0.9em;
            color: var(--text-color);
        }

        tr:hover {
            background-color: #f5f5f5;
        }

        tr:last-child td {
            border-bottom: none;
        }

        .actions {
            display: flex;
            gap: 10px;
        }

        button, select {
            font-size: 14px;
            padding: 8px 12px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }

        button {
            background-color: var(--primary-color);
            color: white;
            transition: background-color 0.3s ease, transform 0.1s ease;
        }

        button:hover {
            background-color: var(--secondary-color);
        }

        select {
            border: 1px solid var(--border-color);
            background-color: white;
            color: var(--text-color);
        }

        .error-message {
            text-align: center;
            color: red;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Report Management Dashboard</h2>
        <table>
            <thead>
                <tr>
                    <th>Report ID</th>
                    <th>Listing ID</th>
                    <th>Reason</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    String sql = "SELECT report_id, listing_id, report_reason, status FROM Report WHERE status != 'Resolved'";
                    try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");
                         PreparedStatement ps = conn.prepareStatement(sql);
                         ResultSet rs = ps.executeQuery()) {

                        if (!rs.isBeforeFirst()) {
                            out.println("<tr><td colspan='5'>No unresolved reports found.</td></tr>");
                        } else {
                            while (rs.next()) {
                                int reportId = rs.getInt("report_id");
                                int listingId = rs.getInt("listing_id");
                                String reason = rs.getString("report_reason");
                                String status = rs.getString("status");
                %>
                <tr>
                    <td><%= reportId %></td>
                    <td><%= listingId %></td>
                    <td><%= reason %></td>
                    <td><%= status %></td>
                    <td class="actions">
                        <form action="AdminReportDashboard" method="post" style="margin: 0;">
                            <input type="hidden" name="report_id" value="<%= reportId %>">
                            <select name="status">
                                <option value="Reviewed">Reviewed</option>
                                <option value="Resolved">Resolved</option>
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
                        out.println("<tr><td colspan='5' class='error-message'>Error loading reports: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </tbody>
        </table>
    </div>
</body>
</html>
