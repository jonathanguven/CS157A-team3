import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDao {
	private String dburl = "jdbc:mysql://localhost:3306/userdb";			//change to ur stuff
	private String dbuname = "root";										//change to ur stuff
	private String dbpassword = "mysql";									//change to ur stuff
	private String dbdriver = "com.mysql.jdbc.Driver";

	// Load the MySQL driver
	public void loadDriver(String dbDriver) {
		try {
			Class.forName(dbDriver);
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		}
	}

	// Establish connection with the database
	public Connection getConnection() {
		Connection con = null;
		try {
			con = DriverManager.getConnection(dburl, dbuname, dbpassword);
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return con;
	}

	// Validate the login credentials
	public boolean validate(String email, String password) {
		loadDriver(dbdriver);
		Connection con = getConnection();
		boolean status = false;
		String sql = "SELECT * FROM member WHERE email = ? AND password = ?";
		try {
			PreparedStatement ps = con.prepareStatement(sql);
			ps.setString(1, email);
			ps.setString(2, password);
			ResultSet rs = ps.executeQuery();
			status = rs.next();  // If there is a result, it means credentials are correct
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return status;
	}
}
