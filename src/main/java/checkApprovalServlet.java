import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet("/checkApprovalServlet")
public class checkApprovalServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String userId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("user_id".equals(cookie.getName())) {
                    userId = cookie.getValue();
                    break;
                }
            }
        }

        String status = "not_approved";
        if (userId != null) {
            String sql = "SELECT is_approved FROM seller WHERE user_id = ?";
            try (Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/GroceryGander", "root", "password");
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, userId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        status = rs.getString("is_approved");
                    }
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }

        response.setContentType("text/plain");
        response.getWriter().write(status.equalsIgnoreCase("approved") ? "approved" : "not_approved");
    }
}
