<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.grocerygander.model.Seller" %>
<%@ include file="header.jsp" %>

<%-- Check if the user is not an admin --%>
<% 
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equals("admin")) {
%>

<script type="text/javascript">
    // Show an alert popup with the message
    alert("You must be an admin to view this page.");

    // Redirect the user to home.jsp after the alert
    window.location.href = "home.jsp";
</script>

<% 
        // End the page execution after the redirect script
        return;  
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Seller List</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: solid 1px #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>

    <h2>Seller List</h2>

    <!-- Form to update seller status -->
    <form action="sellers" method="post">
        <table>
            <tr>
                <th>Seller ID</th>
                <th>User ID</th>
                <th>Email</th>
                <th>Status</th>
                <th>NO</th>
                <th>YES</th>
            </tr>
            <% 
            List<Seller> listSeller = (List<Seller>) request.getAttribute("listSeller");
            if (listSeller != null && !listSeller.isEmpty()) {
                for (Seller seller : listSeller) { 
                    String status = seller.getIsApproved();
            %>
            <tr>
                <td><%= seller.getIdseller() %></td>
                <td><%= seller.getUserId() %></td>
                <td><%= seller.getEmail()%></td>
                <td><%= status %></td>
                <td><input type="radio" name="status_<%= seller.getIdseller() %>" value="denied" <%= "pending".equals(status) ? "checked" : "" %>></td>
                <td><input type="radio" name="status_<%= seller.getIdseller() %>" value="approved" <%= "approved".equals(status) ? "checked" : "" %>></td>
            </tr>
            <% 
                }
            } else {
            %>
            <tr><td colspan="6">No sellers found!</td></tr>
            <% 
            }
            %>
        </table>
        <input type="submit" value="Update Seller Status">
    </form>

</body>
</html>
