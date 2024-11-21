import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/addProduct")
@MultipartConfig
public class AddProduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/userdb";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "mysql";

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        String productName = request.getParameter("productName");
        String location = request.getParameter("location");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String description = request.getParameter("description");
        String categoryStr = request.getParameter("category");

        if (productName == null || productName.trim().isEmpty()) {
            out.println("<h1>Product name is required.</h1>");
            return;
        }

        // Handling the image file
        Part filePart = request.getPart("image");
        byte[] imageBytes = null;
        if (filePart != null && filePart.getSize() > 0) {
            imageBytes = filePart.getInputStream().readAllBytes(); // Read the image file as a byte array
        }

        if (priceStr == null || priceStr.trim().isEmpty() || quantityStr == null || quantityStr.trim().isEmpty() || categoryStr == null || categoryStr.trim().isEmpty()) {
            out.println("<h1>Price, Quantity, and Category are required.</h1>");
            return;
        }

        double price = Double.parseDouble(priceStr.trim());
        int quantity = Integer.parseInt(quantityStr.trim());
        int category = Integer.parseInt(categoryStr.trim());

        Integer sellerId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("idseller".equals(cookie.getName())) {
                    sellerId = Integer.parseInt(cookie.getValue());
                    break;
                }
            }
        }

        if (sellerId == null) {
            out.println("<h1>Error: You must be logged in as a seller to add a product.</h1>");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String approvalCheckQuery = "SELECT is_approved FROM seller WHERE idseller = ?";
            PreparedStatement stmt = conn.prepareStatement(approvalCheckQuery);
            stmt.setInt(1, sellerId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                String approvalStatus = rs.getString("is_approved");

                if ("approved".equals(approvalStatus)) {
                    // Insert into Listing table
                    String listingQuery = "INSERT INTO Listing (product_name, price, category_id, idseller) VALUES (?, ?, ?, ?)";
                    PreparedStatement listingStmt = conn.prepareStatement(listingQuery, PreparedStatement.RETURN_GENERATED_KEYS);
                    listingStmt.setString(1, productName);
                    listingStmt.setDouble(2, price);
                    listingStmt.setInt(3, category);
                    listingStmt.setInt(4, sellerId);

                    int rowsAffected = listingStmt.executeUpdate();
                    ResultSet generatedKeys = listingStmt.getGeneratedKeys();
                    int listingId = 0;

                    if (generatedKeys.next()) {
                        listingId = generatedKeys.getInt(1);
                    } else {
                        out.println("<h1>Error: Could not retrieve listing ID.</h1>");
                        return;
                    }

                    if (rowsAffected > 0 && listingId > 0) {
                        // Insert into Description table with 'description' and 'location' and store the image as a BLOB
                        String descriptionQuery = "INSERT INTO Description (listing_id, image, quantity, location, description) VALUES (?, ?, ?, ?, ?)";
                        PreparedStatement descriptionStmt = conn.prepareStatement(descriptionQuery);
                        descriptionStmt.setInt(1, listingId);
                        if (imageBytes != null) {
                            descriptionStmt.setBytes(2, imageBytes); // Store image as a BLOB
                        } else {
                            descriptionStmt.setNull(2, java.sql.Types.BLOB); // If no image, set NULL
                        }
                        descriptionStmt.setInt(3, quantity);
                        descriptionStmt.setString(4, location);
                        descriptionStmt.setString(5, description); // Set the description

                        int descRowsAffected = descriptionStmt.executeUpdate();

                        if (descRowsAffected > 0) {
                            // Redirect to profile.jsp after successfully adding the product
                            response.sendRedirect("profile.jsp");
                        } else {
                            out.println("<h1>Error adding product description. Please try again.</h1>");
                        }
                    } else {
                        out.println("<h1>Error adding product. Please try again.</h1>");
                    }
                } else {
                    out.println("<h1>Error: You must be an approved seller to add a product.</h1>");
                }
            } else {
                out.println("<h1>Error: Seller not found.</h1>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
        }
    }
}
