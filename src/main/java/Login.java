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
        // Pre-check for existing login
        Cookie[] cookies = request.getCookies();
        String username = null;
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName()) && cookie.getValue() != null && !cookie.getValue().isEmpty()) {
                    username = cookie.getValue();
                    response.sendRedirect("profile.jsp");
                    return;  // Stop further processing, user is already logged in
                }
            }
        }

        // Continue with login process if no valid login cookie found
        username = request.getParameter("username");
        String password = request.getParameter("password");

        LoginDao loginDao = new LoginDao();
        int userId = loginDao.validateAndGetUserId(username, password);

        if (userId != -1) {
            // Create cookies for username and user_id
            Cookie loginCookie = new Cookie("username", username);
            loginCookie.setMaxAge(60 * 60 * 24); // Cookie lasts 1 day
            response.addCookie(loginCookie);

            Cookie userIdCookie = new Cookie("user_id", String.valueOf(userId));
            userIdCookie.setMaxAge(60 * 60 * 24);
            response.addCookie(userIdCookie);

            // Fetch idseller and set cookie if present
            Integer idseller = loginDao.getSellerIdByUserId(userId);
            if (idseller != null) {
                Cookie sellerIdCookie = new Cookie("idseller", String.valueOf(idseller));
                sellerIdCookie.setMaxAge(60 * 60 * 24);
                response.addCookie(sellerIdCookie);
            }

            response.sendRedirect("profile.jsp");
        } else {
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
