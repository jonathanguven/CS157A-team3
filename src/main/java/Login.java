import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/login")
public class Login extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // Assuming LoginDao now returns user ID on successful validation, -1 on failure
        LoginDao loginDao = new LoginDao();
        
        int userId = loginDao.validateAndGetUserId(username, password); // This method needs to be implemented

        if (userId != -1) {
            // If valid, create a session and set cookies for username and user_id
            Cookie loginCookie = new Cookie("username", username);
            loginCookie.setMaxAge(60 * 60 * 24); // Cookie will last 1 day
            response.addCookie(loginCookie);

            // Set user_id cookie
            Cookie userIdCookie = new Cookie("user_id", String.valueOf(userId));
            userIdCookie.setMaxAge(60 * 60 * 24); // Same lifespan
            response.addCookie(userIdCookie);

            // Redirect to the profile or home page
            response.sendRedirect("profile.jsp");
        } else {
            // Redirect back to login page with error parameter
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
