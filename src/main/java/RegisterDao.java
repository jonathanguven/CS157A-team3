import java.sql.Connection;
import java.sql.DriverManager;

import java.sql.PreparedStatement;
import java.sql.SQLException;


public class RegisterDao {
	private String dburl = "jdbc:mysql://localhost:3306/userdb";			//change to ur stuff
	private String dbuname = "root";										//change to ur stuff
	private String dbpassword = "mysql";									//change to ur stuff
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
	        }
	        return con;
	    }

	    public String insert(Member member) {
	        loadDriver(dbdriver);
	        Connection con = getConnection();
	        String result = "Data entered successfully";
	        String sql = "INSERT INTO member (username, password, email, phone, role) VALUES (?, ?, ?, ?, ?)";
	        try {
	            PreparedStatement ps = con.prepareStatement(sql);
	            ps.setString(1, member.getUsername());
	            ps.setString(2, member.getPassword());
	            ps.setString(3, member.getEmail());
	            ps.setString(4, member.getPhone());
	            ps.setString(5, member.getRole());
	            ps.executeUpdate();
	        } catch (SQLException e) {
	            e.printStackTrace();
	            result = "Data not entered";
	        }
	        return result;
	    }
	}
