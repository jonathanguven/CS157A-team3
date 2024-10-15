
public class Member {
	 private String username, password, email, phone, role;

	    //Default constructor
	    public Member() {
	        super();
	    }

	    public Member(String username, String password, String email, String phone, String role) {
	        super();
	        this.username = username;
	        this.password = password;
	        this.email = email;
	        this.phone = phone;
	        this.role = role;
	    }

	    // Getters and setters
	    public String getUsername() {
	        return username;
	    }

	    public void setUsername(String username) {
	        this.username = username;
	    }

	    public String getPassword() {
	        return password;
	    }

	    public void setPassword(String password) {
	        this.password = password;
	    }

	    public String getEmail() {
	        return email;
	    }

	    public void setEmail(String email) {
	        this.email = email;
	    }

	    public String getPhone() {
	        return phone;
	    }

	    public void setPhone(String phone) {
	        this.phone = phone;
	    }

	    public String getRole() {
	        return role;
	    }

	    public void setRole(String role) {
	        this.role = role;
	    }
	}