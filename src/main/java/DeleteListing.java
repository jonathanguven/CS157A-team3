import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.*;
import java.sql.*;

@WebServlet("/DeleteListing")
public class DeleteListing extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String listingIdStr = request.getParameter("listing_id");

        if (listingIdStr != null) {
            int listingId = Integer.parseInt(listingIdStr);

            Connection conn = null;
            PreparedStatement psDeleteReport = null;
            PreparedStatement psDeleteDescription = null;
            PreparedStatement psDeleteListing = null;

            try {
                // Load MySQL JDBC Driver (optional for JDBC 4.0+)
                Class.forName("com.mysql.cj.jdbc.Driver");

                // Set up the database connection
                conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");

                // Begin a transaction
                conn.setAutoCommit(false);

                // SQL query to delete from the report table
                String deleteReportQuery = "DELETE FROM report WHERE listing_id = ?";
                psDeleteReport = conn.prepareStatement(deleteReportQuery);
                psDeleteReport.setInt(1, listingId);
                psDeleteReport.executeUpdate();

                // SQL query to delete from the description table
                String deleteDescriptionQuery = "DELETE FROM description WHERE listing_id = ?";
                psDeleteDescription = conn.prepareStatement(deleteDescriptionQuery);
                psDeleteDescription.setInt(1, listingId);
                psDeleteDescription.executeUpdate();

                // SQL query to delete from the listing table
                String deleteListingQuery = "DELETE FROM listing WHERE listing_id = ?";
                psDeleteListing = conn.prepareStatement(deleteListingQuery);
                psDeleteListing.setInt(1, listingId);
                psDeleteListing.executeUpdate();

                // Commit the transaction
                conn.commit();

                // Redirect to the listings management page after successful deletion
                response.sendRedirect("manageListings.jsp");
            } catch (ClassNotFoundException e) {
                response.getWriter().println("Error loading database driver: " + e.getMessage());
            } catch (SQLException e) {
                try {
                    // If there is an error, rollback the transaction
                    if (conn != null) {
                        conn.rollback();
                    }
                } catch (SQLException rollbackEx) {
                    e.printStackTrace();
                }
                response.getWriter().println("Error deleting listing: " + e.getMessage());
            } finally {
                try {
                    if (psDeleteReport != null) psDeleteReport.close();
                    if (psDeleteDescription != null) psDeleteDescription.close();
                    if (psDeleteListing != null) psDeleteListing.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    response.getWriter().println("Error closing database resources: " + e.getMessage());
                }
            }
        } else {
            response.getWriter().println("Error: Invalid listing ID.");
        }
    }
}
