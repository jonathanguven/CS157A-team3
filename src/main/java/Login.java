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

        // Call the DAO to validate credentials
        LoginDao loginDao = new LoginDao();
        
        System.out.println("Username: " + username);
        System.out.println("Password: " + password);

        
        if (loginDao.validate(username, password)) {
            // If valid, create a session and set cookies
            Cookie loginCookie = new Cookie("username", username);
            loginCookie.setMaxAge(60 * 60 * 24); // Cookie will last 1 day
            response.addCookie(loginCookie);

            // Redirect to the profile or home page
            response.sendRedirect("profile.jsp");
        } else {
            // Redirect back to login page with error parameter
            response.sendRedirect("login.jsp?error=1");
        }
    }
}
