import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDao {
    private String dburl = "jdbc:mysql://localhost:3306/grocery_gander_db";
    private String dbuname = "root";
    private String dbpassword = "password";
    private String dbdriver = "com.mysql.jdbc.Driver";

    // Load the JDBC Driver
    public void loadDriver(String dbDriver) {
        try {
            Class.forName(dbDriver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    // Get connection to the database
    public Connection getConnection() {
        Connection con = null;
        try {
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return con;
    }

    // Validate the username and password
    public boolean validate(String username, String password) {
        loadDriver(dbdriver);
        Connection con = getConnection();
        boolean status = false;
        String sql = "SELECT * FROM user WHERE username = ? AND password = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            status = rs.next(); // Returns true if a match is found
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return status;
    }

    // Get seller_id for the given username
    public Integer getSellerId(String username) {
        loadDriver(dbdriver);
        Connection con = getConnection();
        Integer sellerId = null;
        String sql = "SELECT s.seller_id FROM user u JOIN seller s ON u.user_id = s.user_id WHERE u.username = ?";
        
        try {
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                sellerId = rs.getInt("seller_id");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return sellerId;
    }
}
