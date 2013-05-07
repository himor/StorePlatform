package sp;

import java.sql.*;

/* 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
 * Responsible for all operations with database
 */
public class Model {

	private String 	mysql_server = 	"localhost";
	private int 	mysql_port = 	3306;
	private String 	mysql_dbname = 	"uamarket";
	private String 	mysql_user = 	"root";
	private String 	mysql_password ="root";	
	private Statement stmt = null;
	private Connection db = null;
	public static final int ITEMS_PER_PAGE = 20; 

	public void openConnection() throws SQLException {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		db = DriverManager.getConnection("jdbc:mysql://"+this.mysql_server+":"+this.mysql_port+"/"+this.mysql_dbname, this.mysql_user, this.mysql_password);
		stmt = db.createStatement();
	}
	
	public void closeConnection() throws SQLException {
		this.db.close();
		this.stmt.close();
	}
	
	public void closeConnection(Connection db) throws SQLException {
		db.close();
	}
	
	public ResultSet runQuery(String sql) throws SQLException {
		if (null == stmt) return null;
		ResultSet rs = stmt.executeQuery(sql);
		return rs;
	}
	
	public int runUpdate(String sql) throws SQLException {
		int r = stmt.executeUpdate(sql);
		return r;		
	}
	
	public Connection getDbConnection() throws SQLException {
		try {
			Class.forName("com.mysql.jdbc.Driver");
		} catch (ClassNotFoundException e) {
			e.printStackTrace();
		} 
		db = DriverManager.getConnection("jdbc:mysql://"+this.mysql_server+":"+this.mysql_port+"/"+this.mysql_dbname, this.mysql_user, this.mysql_password);
		return db;
	}
	
}