import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

public class RegisterDao {
	private String dburl = "jdbc:mysql://localhost:3306/grocery_gander_db";
	private String dbuname = "root";
	private String dbpassword = "password";
	private String dbdriver = "com.mysql.jdbc.Driver";

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
		    try {
		        PreparedStatement ps = con.prepareStatement(sql);
		        ps.setString(1, user.getUsername());  // Placeholder 1 for username
		        ps.setString(2, user.getPassword());  // Placeholder 2 for password
		        ps.setString(3, user.getEmail());     // Placeholder 3 for email
		        ps.setString(4, user.getRole());      // Placeholder 4 for role
		        
		        System.out.println("SQL Query: " + ps.toString());


		        ps.executeUpdate();
		    } catch (SQLException e) {
		        e.printStackTrace();
		        result = "Data not entered: " + e.getMessage();  // Pass the error message
		    }
		    return result;
		}


	}