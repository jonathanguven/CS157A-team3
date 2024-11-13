import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/logout")
public class Logout extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Invalidate the session
		request.getSession().invalidate();

		// Remove all cookies effectively
		Cookie[] cookies = request.getCookies();
		if (cookies != null) {
			for (Cookie cookie : cookies) {
				cookie.setValue(""); // Clear the value
				cookie.setPath(request.getContextPath()); // Match the path correctly
				cookie.setMaxAge(0); // Expire the cookie
				response.addCookie(cookie);
			}
		}

		// Redirect to the login page
		response.sendRedirect("login.jsp");
	}

}
