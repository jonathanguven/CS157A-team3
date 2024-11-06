import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/Profile")
public class Profile extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Check if the user is logged in by checking the session or cookies
        HttpSession session = request.getSession(false); // Get session without creating a new one

        String username = null;
        String role = null;
        Integer userId = null;

        // Check for session attribute
        if (session != null) {
            username = (String) session.getAttribute("username");
            role = (String) session.getAttribute("role");
            userId = (Integer) session.getAttribute("user_id"); // assuming user_id is stored as Integer
        }

        // Check for the username in cookies (if you're using cookies)
        if (username == null) {
            Cookie[] cookies = request.getCookies();
            if (cookies != null) {
                for (Cookie cookie : cookies) {
                    if (cookie.getName().equals("username")) {
                        username = cookie.getValue();
                        break;
                    }
                }
            }
        }

        // If the user is not logged in, redirect to the login page
        if (username == null) {
            response.sendRedirect("login.jsp");
        } else {
            // Print user_id and role to console
            System.out.println("User ID: " + userId);
            System.out.println("Role: " + role);

            // Proceed to profile.jsp if the user is logged in
            request.getRequestDispatcher("profile.jsp").forward(request, response);
        }
    }
}
