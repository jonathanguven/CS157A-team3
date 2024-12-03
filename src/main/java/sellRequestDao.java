import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class sellRequestDao {
	private String dburl = "jdbc:mysql://localhost:3306/GroceryGander";
	private String dbuname = "root";
	private String dbpassword = "password";
	private String dbdriver = "com.mysql.jdbc.Driver";
	
	
	   
	   

    public void loadDriver(String dbDriver) {
        try {
            Class.forName(dbDriver);
            System.out.println("sellRequestDao: JDBC driver loaded successfully.");
        } catch (ClassNotFoundException e) {
            System.out.println("sellRequestDao: Error loading JDBC driver!");
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        Connection con = null;
        try {
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);
            System.out.println("sellRequestDao: Database connection established.");
        } catch (SQLException e) {
            System.out.println("sellRequestDao: Error establishing connection to the database!");
            e.printStackTrace();
        }
        return con;
    }

    public String insertSellerRequest(int userId, String status) {
        loadDriver(dbdriver);
        try (Connection con = getConnection();
             PreparedStatement ps = con.prepareStatement("INSERT INTO seller (user_id, is_approved) VALUES (?, ?)")) {
            ps.setInt(1, userId);
            ps.setString(2, status);
            ps.executeUpdate();
            System.out.println("sellRequestDao: Insert operation successful.");
            return "Data entered successfully";
        } catch (SQLException e) {
            System.out.println("sellRequestDao: Error executing insert operation.");
            e.printStackTrace();
            return "Data not entered";
        }
    }
}
