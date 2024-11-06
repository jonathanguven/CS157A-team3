import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;

public class RegisterDao {
    private String dburl = "jdbc:mysql://localhost:3306/userdb";
    private String dbuname = "root";
    private String dbpassword = "mysql";
    private String dbdriver = "com.mysql.cj.jdbc.Driver";

    public void loadDriver(String dbDriver) {
        try {
            Class.forName(dbDriver);
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public Connection getConnection() {
        Connection con = null;
        try {
            con = DriverManager.getConnection(dburl, dbuname, dbpassword);
        } catch (SQLException e) {
            e.printStackTrace();
            System.out.println("Error connecting to the database: " + e.getMessage());
        }
        return con;
    }

    public String insert(User user) {
        loadDriver(dbdriver);
        Connection con = getConnection();
        String result = "Data entered successfully";
        String sql = "INSERT INTO user (username, password, email, role) VALUES (?, ?, ?, ?)";
        ResultSet keys = null;
        try {
            PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getUsername());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getRole());

            int affectedRows = ps.executeUpdate();
            if (affectedRows == 0) {
                throw new SQLException("Creating user failed, no rows affected.");
            }

            keys = ps.getGeneratedKeys();
            if (keys.next()) {
                int userId = keys.getInt(1); // Retrieve the generated user_id
                System.out.println("Generated user_id: " + userId);

                if ("admin".equals(user.getRole())) {
                	
                    System.out.println("admin=admin");
                    
                	String adminSql = "INSERT INTO admin (user_id, email, username) VALUES (?, ?, ?)";
                	PreparedStatement adminPs = con.prepareStatement(adminSql);
                	adminPs.setInt(1, userId);
                	adminPs.setString(2, user.getEmail());
                	adminPs.setString(3, user.getUsername());

                    int adminRows = adminPs.executeUpdate();
                    if (adminRows == 0) {
                        throw new SQLException("Inserting into admin table failed, no rows affected.");
                    }
                    System.out.println("Admin record created for user_id: " + userId);
                }
            } else {
                throw new SQLException("Failed to retrieve generated key for user.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            result = "Data not entered: " + e.getMessage();
        } finally {
            try {
                if (keys != null) keys.close();
                if (con != null) con.close();
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
        return result;
    }
}
