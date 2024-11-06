<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Retrieve username from cookies to identify the user
    String username = null;
    Cookie[] cookies = request.getCookies();
    if (cookies != null) {
        for (Cookie cookie : cookies) {
            if (cookie.getName().equals("username")) {
                username = cookie.getValue();
                break;
            }
        }
    }

    // Check if the user is logged in
    if (username != null) {
        try {
            // Connect to the database
            Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/grocery_gander_db", "root", "password");

            // Get the user's user_id
            PreparedStatement psUser = conn.prepareStatement("SELECT user_id FROM user WHERE username = ?");
            psUser.setString(1, username);
            ResultSet rsUser = psUser.executeQuery();

            if (rsUser.next()) {
                int userId = rsUser.getInt("user_id");

                // Check if a seller request already exists for this user
                PreparedStatement psCheckSeller = conn.prepareStatement("SELECT * FROM seller WHERE user_id = ?");
                psCheckSeller.setInt(1, userId);
                ResultSet rsSeller = psCheckSeller.executeQuery();

                if (rsSeller.next()) {
                    // If a request already exists
                    out.println("<div style='display: flex; justify-content: center; align-items: center; height: 100vh;'>");
                    out.println("<p style='font-family: Arial, sans-serif; text-align: center; padding: 20px; background-color: #f0f0f0; border-radius: 8px;'>You have already submitted a seller request. Please wait for admin approval.</p>");
                    out.println("</div>");
                } else {
                    // If no request exists, insert the new seller request
                    PreparedStatement psSeller = conn.prepareStatement("INSERT INTO seller (user_id, is_approved) VALUES (?, 0)");
                    psSeller.setInt(1, userId);
                    psSeller.executeUpdate();

                    // Success message
                    out.println("<div style='display: flex; justify-content: center; align-items: center; height: 100vh;'>");
                    out.println("<p style='font-family: Arial, sans-serif; text-align: center; padding: 20px; background-color: #f0f0f0; border-radius: 8px;'>Your request to become a seller has been submitted. An admin will review and approve your request.</p>");
                    out.println("</div>");
                    
                    psSeller.close();
                }

                rsSeller.close();
                psCheckSeller.close();
            } else {
                out.println("<div style='display: flex; justify-content: center; align-items: center; height: 100vh;'>");
                out.println("<p style='font-family: Arial, sans-serif; text-align: center; padding: 20px; background-color: #f0f0f0; border-radius: 8px;'>User not found. Please log in again.</p>");
                out.println("</div>");
            }

            rsUser.close();
            psUser.close();
            conn.close();

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<div style='display: flex; justify-content: center; align-items: center; height: 100vh;'>");
            out.println("<p style='font-family: Arial, sans-serif; text-align: center; padding: 20px; background-color: #f0f0f0; border-radius: 8px;'>Error processing your request. Please try again later.</p>");
            out.println("</div>");
        }
    } else {
        out.println("<div style='display: flex; justify-content: center; align-items: center; height: 100vh;'>");
        out.println("<p style='font-family: Arial, sans-serif; text-align: center; padding: 20px; background-color: #f0f0f0; border-radius: 8px;'>You must be logged in to request seller permission.</p>");
        out.println("</div>");
    }
%>
