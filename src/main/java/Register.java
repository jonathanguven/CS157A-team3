import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class Register
 */
@WebServlet("/Register")
public class Register extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public Register() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String role = request.getParameter("role");
        String adminCode = request.getParameter("adminCode"); // Add adminCode field
        
        // Admin code validation (server-side)
        if ("admin".equals(role)) {
            String correctAdminCode = "groceryganderiscool"; // The correct admin code
            if (!correctAdminCode.equals(adminCode)) {
                // Admin code is incorrect, show error message
                request.setAttribute("errorMessage", "Invalid admin code. Please try again.");
                request.getRequestDispatcher("register.jsp").forward(request, response);
                return; // Stop further execution
            }
        }

        // Proceed with registration if admin code is valid or if role is "user"
        User user = new User(username, password, email, role);
        RegisterDao rDao = new RegisterDao();
        String result = rDao.insert(user);

        if (result.equals("Data entered successfully")) {
            // Redirect to login page after successful registration
            response.sendRedirect("login.jsp");
        } else {
            // Handle the case where registration fails
        	System.out.println("Role: " + role);
        	System.out.println("Registration result: " + result);
            request.setAttribute("errorMessage", "Registration failed. Please try again.");
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
