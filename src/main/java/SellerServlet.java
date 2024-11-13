import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import com.grocerygander.model.Seller;

import jakarta.servlet.annotation.WebServlet;

@WebServlet("/sellers")
public class SellerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SellerDao sellerDao;

    public void init() {
        sellerDao = new SellerDao();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Seller> listSeller = sellerDao.listAllSellers();
        System.out.println("Fetched " + listSeller.size() + " sellers.");  // Add logging to check list size

        // Adding logging to check each Seller's class type
        if (listSeller != null) {
            for (Seller seller : listSeller) {
                System.out.println("Seller class used: " + seller.getClass().getName());
            }
        }

        request.setAttribute("listSeller", listSeller);
        RequestDispatcher dispatcher = request.getRequestDispatcher("sellersRequest.jsp");
        dispatcher.forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Seller> listSeller = sellerDao.listAllSellers();
        for (Seller seller : listSeller) {
            String newStatus = request.getParameter("status_" + seller.getIdseller());
            if (newStatus != null && !newStatus.equals(seller.getIsApproved())) {
                sellerDao.updateSellerStatus(seller.getIdseller(), newStatus);
            }
        }
        doGet(request, response);
    }

}
