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
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

@WebServlet("/addProduct")
@MultipartConfig
public class AddProduct extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/grocery_gander_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";
    private static final String UPLOAD_DIRECTORY = "path/to/upload/directory"; // Update to your upload directory

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieving form data
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

        Part filePart = request.getPart("image");
        String imageFileName = filePart.getSubmittedFileName();

        if (priceStr == null || priceStr.trim().isEmpty() || quantityStr == null || quantityStr.trim().isEmpty() || categoryStr == null || categoryStr.trim().isEmpty()) {
            out.println("<h1>Price, Quantity, and Category are required.</h1>");
            return;
        }

        double price = Double.parseDouble(priceStr.trim());
        int quantity = Integer.parseInt(quantityStr.trim());
        int category = Integer.parseInt(categoryStr.trim());

        if (filePart != null && imageFileName != null && !imageFileName.isEmpty()) {
            File uploadDir = new File(UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            File file = new File(uploadDir, imageFileName);
            try {
                Files.copy(filePart.getInputStream(), file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
                out.println("<h1>Error saving the file.</h1>");
                return;
            }
        }

        // Retrieve seller_id from session
     // Debugging session attributes
        System.out.println("Session ID: " + request.getSession().getId());  // Session ID for tracking
        Integer sellerId = (Integer) request.getSession().getAttribute("seller_id");
        System.out.println("Seller ID: " + sellerId);

        // Debugging: Check if seller_id is present in the session
        System.out.println("Seller ID retrieved from session: " + sellerId);

        if (sellerId == null) {
            out.println("<h1>Error: You must be logged in as a seller to add a product.</h1>");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String approvalCheckQuery = "SELECT is_approved FROM seller WHERE seller_id = ?";
            PreparedStatement stmt = conn.prepareStatement(approvalCheckQuery);
            stmt.setInt(1, sellerId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int isApproved = rs.getInt("is_approved");

                // Debugging: Print out the is_approved status
                System.out.println("Approval status for seller ID " + sellerId + ": " + isApproved);

                if (isApproved == 0) {
                    out.println("<h1>Error: You must be an approved seller to add a product.</h1>");
                    return;
                }
            } else {
                System.out.println("No seller found with seller_id: " + sellerId);
                out.println("<h1>Error: Seller not found.</h1>");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
            return;
        }

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "INSERT INTO Listing (product_name, image, location, price, quantity, description, category_id, seller_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, productName);
            stmt.setString(2, imageFileName);
            stmt.setString(3, location);
            stmt.setDouble(4, price);
            stmt.setInt(5, quantity);
            stmt.setString(6, description);
            stmt.setInt(7, category);
            stmt.setInt(8, sellerId);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
                out.println("<h1>Product Added Successfully</h1>");
            } else {
                out.println("<h1>Error adding product. Please try again.</h1>");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
        }
    }
}
