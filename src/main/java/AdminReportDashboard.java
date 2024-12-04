import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;


@WebServlet("/AdminReportDashboard")
public class AdminReportDashboard extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/GroceryGander";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "password";

    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reportId = request.getParameter("report_id");

        if (reportId != null) {
            Connection conn = null;
            PreparedStatement ps = null;

            try {
                conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

                // Update the report status to 'Resolved'
                String query = "UPDATE Report SET status = 'Resolved' WHERE report_id = ?";
                ps = conn.prepareStatement(query);
                ps.setInt(1, Integer.parseInt(reportId));
                int rowsAffected = ps.executeUpdate();

                if (rowsAffected > 0) {
                    response.sendRedirect("adminReportDashboard.jsp");
                } else {
                    response.getWriter().println("<p>Error: Unable to resolve the report.</p>");
                }

            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().println("<p>Error resolving the report: " + e.getMessage() + "</p>");
            } finally {
                try {
                    if (ps != null) ps.close();
                    if (conn != null) conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        } else {
            response.getWriter().println("<p>Error: Invalid report ID.</p>");
        }
    }

}
