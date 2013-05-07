package sp;
/* 	================================================
COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
================================================
*/
import java.sql.*;
import java.text.SimpleDateFormat;

public class Status extends Model {
	
	public static final int PENDING = 1;
	public static final int PROCESSING = 2;
	public static final int SHIPPED = 3;
	public static final int CANCELLED = 4;
	
	private int id = 0;
	private int orderId = 0;
	private int type = 0;
	private String description = "";
	private Timestamp created;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getOrderId() {
		return orderId;
	}

	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getType() {
		return type;
	}

	public void setType(int type) {
		this.type = type;
	}
	
	public String getTypeName() {
		if (this.type == this.CANCELLED) return "Cancelled";
		if (this.type == this.PROCESSING) return "Processing";
		if (this.type == this.SHIPPED) return "Shipped";
		return "Pending";
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCreated() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM h:mm a ");
		return dateFormat.format(created);
	}

	public void statusUpdate() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("INSERT INTO `status` (`orderId`,`type`,`description`) VALUES (?, ?, ?)");
		      stmt.setInt(1, this.orderId);
		      stmt.setInt(2, this.type);
		      stmt.setString(3, this.description);
		      stmt.executeUpdate();
		   }
		   finally {
			   this.closeConnection(con);
		   }
	}
	
	public void deleteStatus() throws SQLException {
		String query = "DELETE FROM `status` WHERE `id` = " + id + ";";
		openConnection();
		runUpdate(query);
		closeConnection();
	}
	
	private int getNumberOfStatuses(int orderId) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `status` WHERE `orderId` = '" + orderId + "'; ");
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	public Status[] getStatusesByOrderId(int orderId) throws SQLException {
		Status[] ord = new Status[getNumberOfStatuses(orderId)];
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT * FROM `status` WHERE `orderId` = " + orderId + " ORDER BY `created` DESC;");
		if (rs == null) return null;
		int i = 0;
		while (rs.next()) {
			Status z = new Status();
			z.id = rs.getInt("id");
			z.orderId = rs.getInt("orderId");
			z.type = rs.getInt("type");
			z.description = rs.getString("description");
			z.created = rs.getTimestamp("created");
			ord[i++] = z;
		}
		closeConnection();
		return ord;		
	}

}
