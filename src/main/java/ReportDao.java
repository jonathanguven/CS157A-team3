import java.sql.*;

public class ReportDao {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/GroceryGander";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";

    // Submit a new report
    public void submitReport(int listingId, String reportReason) {
        String sql = "INSERT INTO Report (listing_id, report_reason, status) VALUES (?, ?, 'Pending')";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, listingId);
            stmt.setString(2, reportReason);
            stmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


    // Get all unresolved reports for the admin dashboard
    public ResultSet getReports() {
        String sql = "SELECT r.report_id, r.listing_id, l.product_name, r.report_reason, r.status " +
                     "FROM Report r " +
                     "JOIN Listing l ON r.listing_id = l.listing_id " +
                     "WHERE r.status != 'Resolved'";

        try {
            Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
            PreparedStatement stmt = conn.prepareStatement(sql);
            return stmt.executeQuery();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update report status
    public void updateReportStatus(int reportId, String status) {
        String updateReportSQL = "UPDATE Report SET status = ? WHERE report_id = ?";
        String checkPendingReportsSQL = "SELECT COUNT(*) FROM Report WHERE listing_id = " +
                                        "(SELECT listing_id FROM Report WHERE report_id = ?) AND status = 'Pending'";
        String resetListingSQL = "UPDATE Listing SET is_reported = 0 WHERE listing_id = " +
                                 "(SELECT listing_id FROM Report WHERE report_id = ?)";

        try (Connection conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD)) {
            // Update the report status
            try (PreparedStatement updateStmt = conn.prepareStatement(updateReportSQL)) {
                updateStmt.setString(1, status);
                updateStmt.setInt(2, reportId);
                updateStmt.executeUpdate();
            }

            // Check if there are remaining pending reports for the same listing
            try (PreparedStatement checkStmt = conn.prepareStatement(checkPendingReportsSQL)) {
                checkStmt.setInt(1, reportId);
                ResultSet rs = checkStmt.executeQuery();
                if (rs.next() && rs.getInt(1) == 0) {
                    // If no pending reports, reset the is_reported flag
                    try (PreparedStatement resetStmt = conn.prepareStatement(resetListingSQL)) {
                        resetStmt.setInt(1, reportId);
                        resetStmt.executeUpdate();
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}


