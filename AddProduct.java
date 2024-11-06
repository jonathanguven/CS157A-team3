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

    // Database connection parameters
    private static final String DB_URL = "jdbc:mysql://localhost:3306/grocery_gander_db";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";
    private static final String UPLOAD_DIRECTORY = "path/to/upload/directory"; // Change this to your upload directory

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Retrieving the form data
        String productName = request.getParameter("productName");
        String location = request.getParameter("location");
        String priceStr = request.getParameter("price");
        String quantityStr = request.getParameter("quantity");
        String description = request.getParameter("description");
        String categoryStr = request.getParameter("category");

        // Validate required fields
        if (productName == null || productName.trim().isEmpty()) {
            out.println("<h1>Product name is required.</h1>");
            return;
        }

        // Get the file part (optional)
        Part filePart = request.getPart("image"); // Retrieve the file part
        String imageFileName = filePart.getSubmittedFileName(); // Get the file name

        // Validate price and quantity
        if (priceStr == null || priceStr.trim().isEmpty() || quantityStr == null || quantityStr.trim().isEmpty() || categoryStr == null || categoryStr.trim().isEmpty()) {
            out.println("<h1>Price, Quantity, and Category are required.</h1>");
            return;
        }

        // Parse the price and quantity
        double price = Double.parseDouble(priceStr.trim());
        int quantity = Integer.parseInt(quantityStr.trim());
        int category = Integer.parseInt(categoryStr.trim());

        // Handle file upload
        if (filePart != null && imageFileName != null && !imageFileName.isEmpty()) {
            // Create the upload directory if it doesn't exist
            File uploadDir = new File(UPLOAD_DIRECTORY);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            // Save the file to the upload directory
            File file = new File(uploadDir, imageFileName);
            try {
                Files.copy(filePart.getInputStream(), file.toPath(), StandardCopyOption.REPLACE_EXISTING);
            } catch (IOException e) {
                e.printStackTrace();
                out.println("<h1>Error saving the file.</h1>");
                return;
            }
        }

        // Retrieve the seller_id from the session
        Integer sellerId = (Integer) request.getSession().getAttribute("seller_id");

        // Check if seller_id exists in the session
        if (sellerId == null) {
            out.println("<h1>Error: You must be logged in as a seller to add a product.</h1>");
            return; // Prevent further execution if the seller_id is missing
        }
        
        // Debugging: Print out the seller_id to check if it's correct
        System.out.println("Seller ID from session: " + sellerId);

        // Check if the seller is approved
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String approvalCheckQuery = "SELECT is_approved FROM sellers WHERE seller_id = ?";
            PreparedStatement stmt = conn.prepareStatement(approvalCheckQuery);
            stmt.setInt(1, sellerId);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                int isApproved = rs.getInt("is_approved");

                // Check if the seller is approved
                if (isApproved == 0) {
                    out.println("<h1>Error: You must be an approved seller to add a product.</h1>");
                    return; // Seller is not approved, do not proceed
                }
            } else {
                out.println("<h1>Error: Seller not found.</h1>");
                return;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<h1>Error: " + e.getMessage() + "</h1>");
            return;
        }

        // If seller is approved, proceed with product insertion
        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            String query = "INSERT INTO Listing (product_name, image, location, price, quantity, description, category_id, seller_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            PreparedStatement stmt = conn.prepareStatement(query);
            stmt.setString(1, productName);
            stmt.setString(2, imageFileName); // Save just the filename or the path if needed
            stmt.setString(3, location);
            stmt.setDouble(4, price);
            stmt.setInt(5, quantity);
            stmt.setString(6, description);
            stmt.setInt(7, category);
            stmt.setInt(8, sellerId); // Add the seller_id

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
