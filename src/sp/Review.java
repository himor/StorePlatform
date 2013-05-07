package sp;
/* 	================================================
COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
================================================
*/

import java.sql.*;
import java.text.SimpleDateFormat;

public class Review extends Model {

	private int id = 0;
	private int customerId = 0;
	private int sellerId = 0;
	private int itemId = 0;
	private String text = "";
	private int star = 0;
	private boolean isDeleted = false;
	private Timestamp created;
	
	public String customerName;
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public int getCustomerId() {
		return customerId;
	}
	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}
	public int getSellerId() {
		return sellerId;
	}
	public void setSellerId(int sellerId) {
		this.sellerId = sellerId;
	}
	public int getItemId() {
		return itemId;
	}
	public void setItemId(int itemId) {
		this.itemId = itemId;
	}
	public String getText() {
		return text;
	}
	public void setText(String text) {
		this.text = text;
	}
	public int getStar() {
		return star;
	}
	public void setStar(int star) {
		this.star = star;
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
	
	public void getReviewById(int id) throws SQLException {
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT * FROM `review` WHERE `id` = " + id);
		if (rs == null) return;
		if (rs.next()) {
			this.id = rs.getInt("id");
			this.sellerId = rs.getInt("sellerId");
			this.customerId = rs.getInt("customerId");
			this.itemId = rs.getInt("itemId");
			this.text = rs.getString("text");
			this.isDeleted = rs.getBoolean("isDeleted");
			this.created = rs.getTimestamp("created");
			this.star = rs.getInt("star");
		}
		closeConnection();
	}
	
	public void createReview() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("INSERT INTO `review` (`sellerId`,`customerId`,`itemId`,`text`,`star`) VALUES (?, ?, ?, ?, ?)");
		      stmt.setInt(1, this.sellerId);
		      stmt.setInt(2, this.customerId);
		      stmt.setInt(3, this.itemId);
		      stmt.setString(4, this.text);
		      stmt.setInt(5, this.star);
		      stmt.executeUpdate();
		   }
		   finally {
			   this.closeConnection(con);
		   }
	}
	
	public void updateReview() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("UPDATE `review` SET `sellerId` = ?,`customerId` = ?,`itemId` = ?,`text` = ?,`star` = ?, `isDeleted` = ? WHERE `id` = ?;");
		      stmt.setInt(1, this.sellerId);
		      stmt.setInt(2, this.customerId);
		      stmt.setInt(3, this.itemId);
		      stmt.setString(4, this.text);
		      stmt.setInt(5, this.star);
		      stmt.setBoolean(6,  this.isDeleted);
		      stmt.setInt(7, this.id);
		      stmt.executeUpdate();
		   }
		   finally {
			   this.closeConnection(con);
		   }
	}
	
	public void deleteReview() throws SQLException {
		this.setDeleted(true);
		updateReview();
	}
	
	private Review[] getAll(int itemId, String param) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `review` WHERE `"+param+"` = '" + itemId + "' ; ");
		if (rs == null) return null;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		Review[] rev = new Review[k];
		rs = null;
		rs = this.runQuery("SELECT review.*, user.fname FROM `review`, `user` WHERE `"+param+"` = " + itemId + " AND user.id = review.customerId ORDER BY `created` DESC");
		if (rs == null) return null;
		int i = 0;
		while (rs.next()) {
			Review z = new Review();
			z.id = rs.getInt("id");
			z.sellerId = rs.getInt("sellerId");
			z.customerId = rs.getInt("customerId");
			z.itemId = rs.getInt("itemId");
			z.isDeleted = rs.getBoolean("isDeleted");
			z.created = rs.getTimestamp("created");
			z.star = rs.getInt("star");
			z.text = rs.getString("text");
			z.customerName = rs.getString("fname");
			rev[i++] = z;
		}
		closeConnection();
		return rev;		
	}
	
	public Review[] getAllForItem(int itemId) throws SQLException {
		return getAll(itemId, "itemId");
	}
	
	public Review[] getAllForUser(int userId) throws SQLException {
		return getAll(userId, "customerId");
	}

	public Review[] getAllForStore(int userId) throws SQLException {
		return getAll(userId, "sellerId");
	}
}
