<%@ page import="java.sql.*, java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Product Details</title>
</head>
<body>
    <%
        String listingIdParam = request.getParameter("listing_id");
        if (listingIdParam != null) {
            int listingId = Integer.parseInt(listingIdParam);

            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");
                 PreparedStatement stmt = conn.prepareStatement(
                     "SELECT product_name, price FROM Listing WHERE listing_id = ?")) {

                stmt.setInt(1, listingId);
                ResultSet rs = stmt.executeQuery();

                if (rs.next()) {
                    String productName = rs.getString("product_name");
                    double price = rs.getDouble("price");
    %>
    <h1><%= productName %></h1>
    <p>Price: $<%= price %></p>

    <form action="SubmitReportServlet" method="post">
        <input type="hidden" name="listing_id" value="<%= listingId %>">
        <label for="report_reason">Reason for reporting:</label>
        <textarea name="report_reason" id="report_reason" required></textarea>
        <button type="submit">Submit Report</button>
    </form>
    <%
                } else {
                    out.println("<p>Product not found.</p>");
                }
            } catch (SQLException e) {
                e.printStackTrace();
                out.println("<p>Error loading product details: " + e.getMessage() + "</p>");
            }
        } else {
            out.println("<p>Invalid listing ID.</p>");
        }
    %>
</body>
</html>


