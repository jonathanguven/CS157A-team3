import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/SubmitReportServlet")
public class SubmitReportServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/GroceryGander";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportReason = request.getParameter("report_reason");
        String listingIdParam = request.getParameter("listing_id");

        if (listingIdParam == null || reportReason == null || reportReason.trim().isEmpty()) {
            response.getWriter().println("Invalid input. Please provide a valid listing ID and report reason.");
            return;
        }

        int listingId = Integer.parseInt(listingIdParam);

        String sql = "INSERT INTO Report (listing_id, report_reason, status) VALUES (?, ?, 'Pending')";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, listingId);
            stmt.setString(2, reportReason);

            int rowsInserted = stmt.executeUpdate();
            if (rowsInserted > 0) {
                response.getWriter().println("Report submitted successfully.");
            } else {
                response.getWriter().println("Failed to submit the report.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}


