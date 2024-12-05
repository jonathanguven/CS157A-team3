import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import com.grocerygander.model.Seller;

public class SellerDao {
	private String dburl = "jdbc:mysql://localhost:3306/GroceryGander";
	private String dbuname = "root";
	private String dbpassword = "password";
	private String dbdriver = "com.mysql.jdbc.Driver";
	
	
	   
	   

    public SellerDao() {
        loadDriver(dbdriver);
    }

    // Load the JDBC Driver
    private void loadDriver(String dbDriver) {
        try {
            Class.forName(dbDriver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    // Get connection to the database
    private Connection getConnection() {
        Connection con = null;
        try {
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    // Fetch all sellers
    public List<Seller> listAllSellers() {
        List<Seller> listSeller = new ArrayList<>();
        String sql = "SELECT seller.*, user.email FROM seller JOIN user ON seller.user_id = user.user_id";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                int id = rs.getInt("idseller");
                int userId = rs.getInt("user_id");  // Make sure your data types align with the database schema
                String email = rs.getString("email");
                String isApproved = rs.getString("is_approved");
                Seller seller = new Seller(id, userId, email, isApproved);
                listSeller.add(seller);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            // Consider logging this error and potentially returning an empty list or a custom error response
            System.out.print("NOTTTTTTTTTT WORKINNNNNNNNNNGGGG");
        }
        return listSeller;
    }
    
    public void updateSellerStatus(int sellerId, String status) {
        String sql = "UPDATE seller SET is_approved = ? WHERE idseller = ?";
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, sellerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    
}



