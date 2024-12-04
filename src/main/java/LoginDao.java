import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDao {
    private String dburl = "jdbc:mysql://localhost:3306/GroceryGander";
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

    // Validate the username and password and return the user_id and role
    public int validateAndGetUserId(String username, String password, String[] role) {
        loadDriver(dbdriver);
        Connection con = getConnection();
        String sql = "SELECT user_id, role FROM user WHERE username = ? AND password = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                role[0] = rs.getString("role");  // Set the role to the passed variable (as array)
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
        return -1;  // Return -1 if validation fails
    }

    // Get seller id by user id
    public Integer getSellerIdByUserId(int userId) {
        Connection con = getConnection();
        String sql = "SELECT idseller FROM seller WHERE user_id = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("idseller");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            try {
                if (con != null) {
                    con.close();
                }
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return null;  // Return null if no seller is found
    }
}