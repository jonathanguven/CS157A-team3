<%@ page import="java.sql.*, jakarta.servlet.*, jakarta.servlet.http.*, java.util.Base64" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="header.jsp" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Listings - Grocery Gander</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f4f4f9;
        }
        header {
            background-color: #4CAF50;
            color: white;
            padding: 10px 0;
            text-align: center;
        }
        h2 {
            text-align: center;
            margin-top: 20px;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: white;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        td {
            color: #555;
        }
        button {
            background-color: #4CAF50;
            color: white;
            padding: 8px 12px;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        button:hover {
            background-color: #45a049;
        }
        .actions {
            display: flex;
            justify-content: space-around;
        }
        .listing-image {
            max-width: 100px;
            max-height: 100px;
        }
    </style>
</head>
<body>

    <h2>Listings Overview</h2>
    
    <table>
        <tr>
            <th>Listing ID</th>
            <th>Product Name</th>
            <th>Price</th>
            <th>Quantity</th>
            <th>Location</th>
            <th>Description</th>
            <th>Image</th> <!-- Added Image column -->
            <th>Actions</th>
        </tr>

        <%
            String sellerId = (String) session.getAttribute("idseller");
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

            if (sellerId != null) {
                // Database logic to retrieve listings including the image
                Connection conn = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                
                try {
                    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/userdb", "root", "mysql");
                    String query = "SELECT l.listing_id, l.product_name, l.price, d.quantity, d.location, d.description, d.image " +
                                   "FROM listing l " +
                                   "JOIN description d ON l.listing_id = d.listing_id " +
                                   "WHERE l.idseller = ?";
                    ps = conn.prepareStatement(query);
                    ps.setInt(1, Integer.parseInt(sellerId));
                    rs = ps.executeQuery();

                    while (rs.next()) {
                        int listingId = rs.getInt("listing_id");
                        String productName = rs.getString("product_name");
                        double price = rs.getDouble("price");
                        int quantity = rs.getInt("quantity");
                        String location = rs.getString("location");
                        String description = rs.getString("description");
                        byte[] imageBytes = rs.getBytes("image"); // Fetch image as bytes

                        String imageBase64 = null;
                        if (imageBytes != null) {
                            // Convert the image bytes to base64 for embedding in HTML
                            imageBase64 = Base64.getEncoder().encodeToString(imageBytes);
                        }
        %>

        <tr>
            <td><%= listingId %></td>
            <td><%= productName %></td>
            <td><%= price %></td>
            <td><%= quantity %></td>
            <td><%= location != null ? location : "No location" %></td>
            <td><%= description != null ? description : "No description" %></td>
            <td>
                <%
                    if (imageBase64 != null) {
                %>
                <img src="data:image/jpeg;base64,<%= imageBase64 %>" class="listing-image" alt="Product Image">
                <%
                    } else {
                %>
                No image
                <%
                    }
                %>
            </td>
            <td class="actions">
                <form action="editListing.jsp" method="get" style="display:inline;">
    <input type="hidden" name="listing_id" value="<%= listingId %>">
    <button type="submit">Edit</button>
</form>


                <form action="DeleteListing" method="post" style="display:inline;">
                    <input type="hidden" name="listing_id" value="<%= listingId %>">
                    <button type="submit" onclick="return confirm('Are you sure you want to delete this listing?')">Delete</button>
                </form>
            </td>
        </tr>

        <%
                    }
                } catch (SQLException e) {
                    out.println("<tr><td colspan='8'>Error fetching listings: " + e.getMessage() + "</td></tr>");
                } finally {
                    try {
                        if (rs != null) rs.close();
                        if (ps != null) ps.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        out.println("<tr><td colspan='8'>Error closing database resources: " + e.getMessage() + "</td></tr>");
                    }
                }
            } else {
                out.println("<tr><td colspan='8'>You have no existing listings.</td></tr>");
            }
        %>       
    </table>
</body>
</html>
