package sp;
/* 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	*/
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;
import java.text.SimpleDateFormat;

public class User extends Model {

	public static final int CUSTOMER = 1;
	public static final int SELLER = 2;
	
	private int id = 0;
	private String fname = "";
	private String lname = "";
	private String name = "";
	private String email;
	private String password;
	private String username = "";
	private int type;
	private boolean isDeleted = false;
	private Timestamp registered;

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getFname() {
		return fname;
	}

	public void setFname(String fname) {
		this.fname = fname;
	}

	public String getLname() {
		return lname;
	}

	public void setLname(String lname) {
		this.lname = lname;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username.toUpperCase();
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	/**
	 * password will be instantly encoded using MD5
	 * @param password
	 * @throws NoSuchAlgorithmException
	 */
	public void setPassword(String password) throws NoSuchAlgorithmException {
		this.password = hash(password);
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public boolean isDeleted() {
		return isDeleted;
	}

	public void setDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}

	public String getRegistered() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM YYYY h:mm a ");
		return dateFormat.format(registered);
	}
	
	public void loadById(int id) throws SQLException {
		ResultSet rs = null;
		this.openConnection();
		rs = this.runQuery("SELECT * FROM `user` WHERE `id` = " + id);
		if (rs == null) return;
		if (rs.next()) {
			this.id = rs.getInt("id");
			this.fname = rs.getString("fname");
			this.lname = rs.getString("lname");
			this.name = rs.getString("name");
			this.username = rs.getString("username").toUpperCase();
			this.type = rs.getInt("type");
			this.isDeleted = rs.getBoolean("isDeleted");
			this.registered = rs.getTimestamp("registered");
			this.email = rs.getString("email");
			this.password = rs.getString("password");
		}
		this.closeConnection();
	}

	public void loadByEmail(String email) throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		con = this.getDbConnection();
		stmt = con.prepareStatement("SELECT * FROM `user` WHERE `email` =  ?;");
		stmt.setString(1, email);
		rs = stmt.executeQuery();
		if (rs.next()) {
			this.id = rs.getInt("id");
			this.fname = rs.getString("fname");
			this.lname = rs.getString("lname");
			this.name = rs.getString("name");
			this.username = rs.getString("username").toUpperCase();
			this.type = rs.getInt("type");
			this.isDeleted = rs.getBoolean("isDeleted");
			this.registered = rs.getTimestamp("registered");
			this.email = rs.getString("email");
			this.password = rs.getString("password");
		}
		stmt.close();
		closeConnection(con);
	}
	
	public void loadByUsername(String username) throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rs = null;
		con = this.getDbConnection();
		stmt = con.prepareStatement("SELECT * FROM `user` WHERE `username` =  ?;");
		stmt.setString(1, username.toUpperCase());
		rs = stmt.executeQuery();
		if (rs.next()) {
			this.id = rs.getInt("id");
			this.fname = rs.getString("fname");
			this.lname = rs.getString("lname");
			this.name = rs.getString("name");
			this.username = rs.getString("username").toUpperCase();
			this.type = rs.getInt("type");
			this.isDeleted = rs.getBoolean("isDeleted");
			this.registered = rs.getTimestamp("registered");
			this.email = rs.getString("email");
			this.password = rs.getString("password");
		}
		stmt.close();
		closeConnection(con);
	}

	public void updateUser() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("UPDATE `user` SET `fname` = ?,`lname` = ?,`name` = ?,`type` = ?,`username` = ?,`email` = ?,`password` = ?, `isDeleted` = ? WHERE `id` = ? ;");
		      stmt.setString(1, this.fname);
		      stmt.setString(2, this.lname);
		      stmt.setString(3, this.name);
		      stmt.setInt(4, this.type);
		      stmt.setString(5, this.username);
		      stmt.setString(6, this.email);
		      stmt.setString(7, this.password);
		      stmt.setBoolean(8, this.isDeleted);
		      stmt.setInt(9, this.id);
		      stmt.executeUpdate();
		   }
		   finally {
			   this.closeConnection(con);
		   }
	}
	
	public void deleteUser() throws SQLException {
		this.setDeleted(true);
		this.updateUser();
	}
	
	public void undeleteUser() throws SQLException {
		this.setDeleted(false);
		this.updateUser();
	}

	public void createUser() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("INSERT INTO `user` (`fname`,`lname`,`name`,`type`,`username`,`email`,`password`) VALUES (?, ?, ?, ?, ?, ?, ?)");
		      stmt.setString(1, this.fname);
		      stmt.setString(2, this.lname);
		      stmt.setString(3, this.name);
		      stmt.setInt(4, this.type);
		      stmt.setString(5, this.username);
		      stmt.setString(6, this.email);
		      stmt.setString(7, this.password);
		      stmt.executeUpdate();
		   }
		   finally {
			   this.closeConnection(con);
		   }
		loadByEmail(this.email); // this allows us to get the user id
	}
	
	public boolean checkUnique() throws SQLException {
		ResultSet rs = null;
		openConnection();
		rs = runQuery("SELECT * FROM `user` WHERE `username` = '" + username.toUpperCase() + "' OR `email` = '" + email + "';");
		if (rs.next()) {
			return false;
		}
		return true;
	}
	
	/*
	 * checks if user is loaded
	 */
	public boolean loaded() {
		return (this.id > 0);
	}
	
	public boolean checkPassword(String password) throws NoSuchAlgorithmException {
		return (this.password.equals(hash(password)));
	}
	
	/**
	 * method created MD5
	 * @param plaintext
	 * @return
	 * @throws NoSuchAlgorithmException
	 */
	public String hash(String plaintext) throws NoSuchAlgorithmException {
		MessageDigest m = MessageDigest.getInstance("MD5");
		m.reset();
		m.update(plaintext.getBytes());
		byte[] digest = m.digest();
		BigInteger bigInt = new BigInteger(1,digest);
		String hashtext = bigInt.toString(16);
		while(hashtext.length() < 32 ){
		  hashtext = "0"+hashtext;
		}
		return hashtext.trim();
	}
	
	/**
	 * Admin operation: get list
	 * @throws SQLException 
	 */
	public User[] getList() throws SQLException {
		int size = 0;
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `user` WHERE true; ");
		if (rs != null) {
			if (rs.next())
				size = rs.getInt(1);
			closeConnection();
		} else return null;
		User[] usr = new User[size];
		openConnection();
		rs = this.runQuery("SELECT * FROM `user` WHERE true;");
		if (rs == null) return null;
		int i = 0;
		while (rs.next()) {
			User z = new User();
			z.id = rs.getInt("id");
			z.fname = rs.getString("fname");
			z.lname = rs.getString("lname");
			z.name = rs.getString("name");
			z.username = rs.getString("username").toUpperCase();
			z.type = rs.getInt("type");
			z.isDeleted = rs.getBoolean("isDeleted");
			z.registered = rs.getTimestamp("registered");
			z.email = rs.getString("email");
			z.password = rs.getString("password");
			usr[i++] = z;
		}
		closeConnection();
		return usr;	
	}
}
