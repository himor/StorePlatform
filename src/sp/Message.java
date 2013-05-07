package sp;
/* 	================================================
COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
================================================
*/
import java.sql.*;
import java.text.SimpleDateFormat;

public class Message extends Model {

	private int id = 0;
	private int from = 0;
	private int to = 0;
	private String text = "";
	private String subject = "";
	private boolean read = false;
	private boolean isDeleted = false;
	private Timestamp created;
	private boolean showToRec = true;
	private boolean showToSen = true;
	
	public String toName = "";
	public String fromName = "";
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getFrom() {
		return from;
	}
	public void setFrom(int from) {
		this.from = from;
	}
	public int getTo() {
		return to;
	}
	public void setTo(int to) {
		this.to = to;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public String getSubject() {
		return subject;
	}
	public void setSubject(String subject) {
		this.subject = subject;
	}
	public boolean isRead() {
		return read;
	}
	public void setRead(boolean read) {
		this.read = read;
	}
	public boolean isDeleted() {
		return isDeleted;
	}
	public void setDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}
	public String getCreated() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM h:mm a ");
		return dateFormat.format(created);
	}
	public boolean isShowToRec() {
		return showToRec;
	}
	public void setShowToRec(boolean showToRec) {
		this.showToRec = showToRec;
	}
	public boolean isShowToSen() {
		return showToSen;
	}
	public void setShowToSen(boolean showToSen) {
		this.showToSen = showToSen;
	}
	
	public void loadById(int id) throws SQLException {
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT * FROM `message` WHERE `id` = " + id);
		if (rs == null) return;
		if (rs.next()) {
			this.id = rs.getInt("id");
			this.from = rs.getInt("from");
			this.to = rs.getInt("to");
			this.text = rs.getString("text");
			this.subject = rs.getString("subject");
			this.isDeleted = rs.getBoolean("isDeleted");
			this.created = rs.getTimestamp("created");
			this.read = rs.getBoolean("read");
			this.showToRec = rs.getBoolean("showToRec");
			this.showToSen = rs.getBoolean("showToSen");
		}
		closeConnection();
	}
	
	/**
	 * function adds read market to this message 
	 */
	public void markRead() throws SQLException {
		openConnection();
		setRead(true);
		runUpdate("UPDATE `message` SET `read` = "+this.read+" "+
				"WHERE `id` = " + this.id);
		closeConnection();
	}
	
	/**
	 * function deletes this message 
	 */
	public void deleteMessage() throws SQLException {
		openConnection();
		setDeleted(true);
		runUpdate("UPDATE `message` SET `isDeleted`='"+this.isDeleted+"' "+
				"WHERE `id` = " + this.id);
		closeConnection();
	}
	
	public void hideMessage(int userId) throws SQLException {
		User user = new User();
		user.loadById(userId);
		if (user.getId() == this.from)
			setShowToSen(false);
		if (user.getId() == this.to)
			setShowToRec(false);
		openConnection();
		runUpdate("UPDATE `message` SET `showToRec`="+this.showToRec+", `showToSen`="+this.showToSen+
				" WHERE `id` = " + this.id);
		closeConnection();
	}
	
	private int getNumberOfMessages(int userId) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `message` WHERE `to` = '" + userId + "' OR `from` = '"+userId+"'; ");
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	/**
	 * returns number of fresh messages 
	 */
	public int getNumberOfNewMessages(int userId) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `message` WHERE `to` = '" + userId + "' AND `read` = FALSE; ");
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	/**
	 * returns array of messages sent to and from this user
	 * @throws SQLException 
	 */
	public Message[] getAllForUser(int userId) throws SQLException {
		Message[] msg = new Message[getNumberOfMessages(userId)];
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT message.*, " +
				"(SELECT CONCAT(user.fname, ' ', user.lname) FROM `user` WHERE message.from = user.id) AS fromName," +
				"(SELECT CONCAT(user.fname, ' ', user.lname) FROM `user` WHERE message.to = user.id) AS toName " +
				" FROM `message` WHERE `to` = '" + userId+ "' OR `from` = '"+userId+"' ORDER BY `created` DESC; ");
		if (rs == null) return null;
		int i = 0;
		while (rs.next()) {
			Message z = new Message();
			z.id = rs.getInt("id");
			z.from = rs.getInt("from");
			z.to = rs.getInt("to");
			z.text = rs.getString("text");
			z.subject = rs.getString("subject");
			z.isDeleted = rs.getBoolean("isDeleted");
			z.created = rs.getTimestamp("created");
			z.read = rs.getBoolean("read");
			z.showToRec = rs.getBoolean("showToRec");
			z.showToSen = rs.getBoolean("showToSen");
			z.fromName = rs.getString("fromName");
			z.toName = rs.getString("toName");
			msg[i++] = z;
		}
		closeConnection();
		return msg;
	}
	
	/**
	 * returns array of messages sent by this user
	 * @throws SQLException 
	 */
//	public Message[] getAllFromUser(int userId) throws SQLException {
//		Message[] msg = new Message[getNumberOfMessages(userId)];
//		ResultSet rs = null;
//		openConnection();
//		rs = this.runQuery("SELECT * FROM `message` WHERE `from` = " + userId);
//		if (rs == null) return null;
//		int i = 0;
//		while (rs.next()) {
//			Message z = new Message();
//			z.id = rs.getInt("id");
//			z.from = rs.getInt("from");
//			z.to = rs.getInt("to");
//			z.text = rs.getString("text");
//			z.subject = rs.getString("subject");
//			z.isDeleted = rs.getBoolean("isDeleted");
//			z.created = rs.getTimestamp("created");
//			z.read = rs.getBoolean("read");
//			z.showToRec = rs.getBoolean("showToRec");
//			z.showToSen = rs.getBoolean("showToSen");
//			msg[i++] = z;
//		}
//		closeConnection();
//		return msg;		
//	}
	
	public void createMessage() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("INSERT INTO `message` (`from`,`to`,`text`,`subject`) VALUES (?, ?, ?, ?)");
		      stmt.setInt(1, this.from);
		      stmt.setInt(2, this.to);
		      stmt.setString(3, this.text);
		      stmt.setString(4, this.subject);
		      stmt.executeUpdate();
		   }
		   finally {
			   this.closeConnection(con);
		   }
		// load this message id
		openConnection();
		String query = "SELECT MAX(id) FROM `message` WHERE `from` = '"+this.from+"' AND `to` = '"+this.to+"';";
		ResultSet rs = runQuery(query);
		if (rs.next())
			this.id = rs.getInt(1);
		closeConnection();
	}
}
