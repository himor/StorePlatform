package sp;
/* 	================================================
COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
================================================
 */
import java.sql.*;
import java.text.SimpleDateFormat;

public class Notification extends Model {

	// for customer and seller
	public static final int NEW_MAIL = 10;
	
	// for seller
	public static final int NEW_REVIEW = 21;
	public static final int NEW_ORDER = 22;
	public static final int ITEM_COUNT = 23; // one item left	
	
	// for customer/buyer status update
	public static final int PROCESSING = 30;
	public static final int SHIPPED = 31;
	public static final int CANCELLED = 32;
	
	private int id = 0;
	private int userId  = 0;
	private int status = 0;
	private int pointer = 0; // to some item, or user or whatever
	private boolean read = false;
	private Timestamp created;
	
	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}
	
	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getPointer() {
		return pointer;
	}

	public void setPointer(int pointer) {
		this.pointer = pointer;
	}

	public int getId() {
		return id;
	}

	public boolean isRead() {
		return read;
	}

	public String getCreated() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM h:mm a ");
		return dateFormat.format(created);
	}

	public void createNotif() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("INSERT INTO `notification` (`userId`,`status`,`pointer`) VALUES ( ?, ?, ?)");
		      stmt.setInt(1, this.userId);
		      stmt.setInt(2, this.status);
		      stmt.setInt(3, this.pointer);
		      stmt.executeUpdate();
		   }
		   finally {
			   stmt.close();
			   this.closeConnection(con);
		   }
	}
	
	public int getNumberByUserId(int userId, boolean onlyNew) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = runQuery("SELECT COUNT(*) FROM `notification` WHERE `userId` = '" + userId + "' " + 
						(onlyNew ? " AND `read` = FALSE;":";"));
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	public int getNumberByUserId(int userId) throws SQLException {
		return getNumberByUserId(userId, true);
	}
	
	/**
	 * Returns seconds since UNIX epoch
	 */
	public long getNow() {
		long now = System.currentTimeMillis() / 1000L;
		return now;
	}
	
	public Notification[] getAllForUser(int userId) throws SQLException {
		Notification[] nft = new Notification[getNumberByUserId(userId, false)];
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT * FROM `notification` WHERE `userId` = " + userId +
				" AND (`created` > '"+(getNow() - 7*24*60*60)+"' OR `read` = FALSE) " +
						"ORDER BY `created` DESC;"); // returns either new or notifications for the last week
		if (rs == null) return null;
		int i = 0;
		while (rs.next()) {
			Notification z = new Notification();
			z.id = rs.getInt("id");
			z.created = rs.getTimestamp("created");
			z.read = rs.getBoolean("read");
			z.userId = rs.getInt("userId");
			z.status = rs.getInt("status");
			z.pointer = rs.getInt("pointer");
			nft[i++] = z;
		}
		closeConnection();
		return nft;
	}
	
	public void markReadAll(int userId) throws SQLException {
		openConnection();
		String query = "UPDATE `notification` SET `read` = TRUE WHERE `userId` = " + userId + ";";
		runUpdate(query);		
		closeConnection();
	}
	
}
