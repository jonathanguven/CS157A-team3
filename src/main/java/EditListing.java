import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/EditListing")
@MultipartConfig
public class EditListing extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/userdb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "mysql";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieve parameters from the form
        String listingIdStr = request.getParameter("listing_id");
        String productName = request.getParameter("product_name");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String location = request.getParameter("location");
        String description = request.getParameter("description");
        String categoryStr = request.getParameter("category_id");

        // Validate required fields
        if (listingIdStr == null || listingIdStr.trim().isEmpty() ||
            productName == null || productName.trim().isEmpty() ||
            priceStr == null || priceStr.trim().isEmpty() ||
            quantityStr == null || quantityStr.trim().isEmpty() ||
            categoryStr == null || categoryStr.trim().isEmpty()) {
            out.println("<h1>Error: Listing ID, product name, price, quantity, and category are required.</h1>");
            return;
        }

        int listingId = Integer.parseInt(listingIdStr.trim());
        double price = Double.parseDouble(priceStr.trim());
        int quantity = Integer.parseInt(quantityStr.trim());
        int category = Integer.parseInt(categoryStr.trim());

        // Handle optional image
        Part filePart = request.getPart("image");
        byte[] imageBytes = null;
        if (filePart != null && filePart.getSize() > 0) {
            imageBytes = filePart.getInputStream().readAllBytes(); // Read the new image if provided
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Retrieve the current image from the Description table if no new image is uploaded
            if (imageBytes == null) {
                String selectImageQuery = "SELECT image FROM Description WHERE listing_id = ?";
                PreparedStatement selectStmt = conn.prepareStatement(selectImageQuery);
                selectStmt.setInt(1, listingId);
                ResultSet rs = selectStmt.executeQuery();
                if (rs.next()) {
                    imageBytes = rs.getBytes("image");  // Retrieve the existing image
                }
            }

            // Update Listing table
            String updateListingQuery = "UPDATE Listing SET product_name = ?, price = ?, category_id = ? WHERE listing_id = ?";
            PreparedStatement listingStmt = conn.prepareStatement(updateListingQuery);
            listingStmt.setString(1, productName);
            listingStmt.setDouble(2, price);
            listingStmt.setInt(3, category);
            listingStmt.setInt(4, listingId);
            listingStmt.executeUpdate();

            // Update Description table
            StringBuilder updateDescriptionQuery = new StringBuilder(
                "UPDATE Description SET quantity = ?, location = ?, description = ?");
            if (imageBytes != null) {
                updateDescriptionQuery.append(", image = ?");
            }
            updateDescriptionQuery.append(" WHERE listing_id = ?");

            PreparedStatement descriptionStmt = conn.prepareStatement(updateDescriptionQuery.toString());
            descriptionStmt.setInt(1, quantity);
            descriptionStmt.setString(2, (location != null && !location.trim().isEmpty()) ? location : null);
            descriptionStmt.setString(3, (description != null && !description.trim().isEmpty()) ? description : null);
            if (imageBytes != null) {
                descriptionStmt.setBytes(4, imageBytes); // Update image if provided
                descriptionStmt.setInt(5, listingId);
            } else {
                descriptionStmt.setInt(4, listingId);  // Just update the other fields if no image is provided
            }
            descriptionStmt.executeUpdate();

            // Redirect to manageListings.jsp after the update
            response.sendRedirect("manageListings.jsp");

        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
        }
    }
}


