import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDao {
	private String dburl = "jdbc:mysql://localhost:3306/userdb";
	private String dbuname = "root";
	private String dbpassword = "mysql";
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
        
        System.out.println("Executing query: " + sql);
        System.out.println("Username: " + username);
        System.out.println("Password: " + password); // If passwords are hashed, print the hashed version

        
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
    
    public int validateAndGetUserId(String username, String password) {
        loadDriver(dbdriver);
        Connection con = getConnection();
        String sql = "SELECT user_id FROM user WHERE username = ? AND password = ?"; // Ensure your table and column names match

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("user_id");  // Successfully validated and return the user_id
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
        return -1;  // Return -1 or any other appropriate error code if validation fails
    }
}
