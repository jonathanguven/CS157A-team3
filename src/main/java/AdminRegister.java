import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class AdminRegister
 */
@WebServlet("/AdminRegister")
public class AdminRegister extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public AdminRegister() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = "admin"; // Default role for admins

        Member admin = new Member(username, password, email, phone, role);
        RegisterDao rDao = new RegisterDao();
        String result = rDao.insert(admin);
        response.getWriter().print(result);
    }
}
