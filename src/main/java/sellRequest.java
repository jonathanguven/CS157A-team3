import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Cookie;
import java.io.IOException;

@WebServlet("/SellRequest")
public class sellRequest extends HttpServlet {
    
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("SellRequest Servlet: Handling POST request.");
        String userId = null;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("user_id".equals(cookie.getName())) {
                    userId = cookie.getValue();
                    System.out.println("SellRequest Servlet: Found user_id cookie with value - " + userId);
                    break;
                }
            }
        }

        if (userId != null) {
            sellRequestDao sellRequestDao = new sellRequestDao();
            String result = sellRequestDao.insertSellerRequest(Integer.parseInt(userId), "pending");
            System.out.println("SellRequest Servlet: Database operation result - " + result);
            response.getWriter().print(result);
        } else {
            System.out.println("SellRequest Servlet: User ID not found in cookies.");
            response.getWriter().print("User ID not found in cookies.");
        }
    }
}
