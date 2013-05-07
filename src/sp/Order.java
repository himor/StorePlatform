package sp;
/* 	================================================
COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
================================================
*/
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

public class Order extends Model {

	private int id = 0;
	private int sellerId = 0;
	private int customerId = 0;
	private String addressD = "";
	private String addressB = "";
	private Timestamp created;
	private float total = 0;
	
	private Status[] statuses;
	private Item[] items;
	
	public String sellerName;
	public String buyerName;
	

	public float getTotal() {
		return total;
	}
	
	public void setTotal(float total) {
		this.total = total;
	}
	
	public Status[] getStatuses() {
		return statuses;
	}
	
	public Item[] getItems() {
		return items;
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getSellerId() {
		return sellerId;
	}
	
	public User getSeller() throws SQLException {
		User user = new User();
		user.loadById(sellerId);
		return user;
	}

	public User getCustomer() throws SQLException {
		User user = new User();
		user.loadById(customerId);
		return user;
	}

	public void setSellerId(int sellerId) {
		this.sellerId = sellerId;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}

	public String getAddressD() {
		return addressD;
	}

	public void setAddressD(String addressD) {
		this.addressD = addressD;
	}

	public String getAddressB() {
		return addressB;
	}

	public void setAddressB(String addressB) {
		this.addressB = addressB;
	}

	public String getCreated() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM h:mm a ");
		return dateFormat.format(created);
	}

	/**
	 * Creates new order with status PENDING
	 * @throws SQLException 
	 */
	public void createOrder() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		try {
			  con = this.getDbConnection();
		      stmt = con.prepareStatement("INSERT INTO `order` (`sellerId`,`customerId`, `addressD`,`addressB`,`total`) VALUES (?, ?, ?, ?, ?)");
		      stmt.setInt(1, this.sellerId);
		      stmt.setInt(2, this.customerId);
		      stmt.setString(3, this.addressD);
		      stmt.setString(4, this.addressB);
		      stmt.setFloat(5, this.total);
		      stmt.executeUpdate();
		   }
		   finally {
			   this.closeConnection(con);
		   }
		// find last order for this customer+seller
		openConnection();
		String query = "SELECT MAX(id) FROM `order` WHERE `sellerId` = '"+this.sellerId+"' AND `customerId` = '"+this.customerId+"';";
		ResultSet rs = runQuery(query);
		if (rs.next())
			this.id = rs.getInt(1);
		closeConnection();
		Status s = new Status();
		s.setType(s.PENDING);
		s.setOrderId(this.id);
		s.setDescription("Order received");
		s.statusUpdate();
	}
	
	/**
	 * after order is created we should add all items to this order
	 */
	public void addItemToOrder(int itemId, int count) throws SQLException {
		String query = "INSERT INTO `orderItem` (`orderId`, `itemId`, `count`) VALUES ('" +
				id + "','" + itemId + "','" + count + "');";
		openConnection();
		runUpdate(query);
		closeConnection();
	}
	
	/**
	 * loads order by id with statuses and items
	 */	
	public void getOrderById(int id) throws SQLException {
		ResultSet rs = null;
		this.openConnection();
		rs = this.runQuery("SELECT * FROM `order` WHERE `id` = " + id);
		if (rs == null) return;
		if (rs.next()) {
			this.id = rs.getInt("id");
			this.addressD = rs.getString("addressD");
			this.addressB = rs.getString("addressB");
			this.created = rs.getTimestamp("created");
			this.sellerId = rs.getInt("sellerId");
			this.customerId = rs.getInt("customerId");
			this.total = rs.getFloat("total");
		}
		this.closeConnection();
		Status s = new Status();
		Item i = new Item();
		this.statuses = s.getStatusesByOrderId(id);
		this.items = i.getAllByOrder(id);
	}
	
	private int getNumberOfOrdersForUser(int userId) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `order` WHERE `customerId` = '" + userId + "';");
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	private int getNumberOfOrdersForStore(int userId) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `order` WHERE `sellerId` = '" + userId + "';");
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	/**
	 * Returns set of orders for the particular user id and statuses (in fact we need only last one)
	 * @throws SQLException 
	 */
	public Order[] getOrdersForUser(int userId) throws SQLException {
		Order[] ord = new Order[getNumberOfOrdersForUser(userId)];
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT * FROM `order` WHERE `customerId` = " + userId + " ORDER BY `created` DESC;");
		if (rs == null) return null;
		int i = 0;
		Item it = new Item();
		Status st = new Status();
		while (rs.next()) {
			Order z = new Order();
			z.id = rs.getInt("id");
			z.addressD = rs.getString("addressD");
			z.addressB = rs.getString("addressB");
			z.sellerId = rs.getInt("sellerId");
			z.customerId = rs.getInt("customerId");
			z.total = rs.getFloat("total");
			z.created = rs.getTimestamp("created");
			z.items = it.getAllByOrder(z.id);
			z.statuses = st.getStatusesByOrderId(z.id);
			ord[i++] = z;
		}
		closeConnection();
		return ord;
	}
	
	/**
	 * Returns set of orders for the particular seller id and statuses (in fact we need only last one)
	 * @throws SQLException 
	 */
	public Order[] getOrdersFromStore(int userId) throws SQLException {
		Order[] ord = new Order[getNumberOfOrdersForStore(userId)];
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT * FROM `order` WHERE `sellerId` = " + userId + " ORDER BY `created` DESC;");
		if (rs == null) return null;
		int i = 0;
		Item it = new Item();
		Status st = new Status();
		while (rs.next()) {
			Order z = new Order();
			z.id = rs.getInt("id");
			z.addressD = rs.getString("addressD");
			z.addressB = rs.getString("addressB");
			z.sellerId = rs.getInt("sellerId");
			z.customerId = rs.getInt("customerId");
			z.created = rs.getTimestamp("created");
			z.total = rs.getFloat("total");
			z.items = it.getAllByOrder(z.id);
			z.statuses = st.getStatusesByOrderId(z.id);
			ord[i++] = z;
		}
		closeConnection();
		return ord;
	}
	
	/**
	 * Returns list of recepients
	 */
	public List<User> getRecepientsForUser(int userId) throws SQLException {
		List<User> recs = new ArrayList<User>();
		User usr = new User();
		Order myOrders[] = null;
		List ids = new ArrayList();;
		usr.loadById(userId);
		if (usr.getType() == usr.CUSTOMER) {
			myOrders = (new Order()).getOrdersForUser(userId);
		} else {
			myOrders = (new Order()).getOrdersFromStore(userId);
		}
		for(int i=0; i < myOrders.length; i++) {
			User tmpusr = null;
			if (usr.getType() == usr.CUSTOMER) {
				tmpusr = myOrders[i].getSeller();
				if (!ids.contains(tmpusr.getId())) recs.add(tmpusr);
				ids.add(tmpusr.getId());
			} else {
				tmpusr = myOrders[i].getCustomer();
				if (!ids.contains(tmpusr.getId())) recs.add(tmpusr);
				ids.add(tmpusr.getId());
			}
		}
		return recs;	
	}
	
	
	/**
	 * get all orders
	 */
	public Order[] getList() throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `order` WHERE true;");
		if (rs == null) return null;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		Order[] ord = new Order[k];
		rs = this.runQuery("SELECT `order`.*, `user`.`name` as sellerName, " +
				"CONCAT(`usr`.`fname`, ' ', `usr`.`lname`) as buyerName FROM `order`, `user`, `user` AS `usr` WHERE " +
				"`usr`.`id` = `customerId` AND `user`.`id` = `sellerId`;");
		if (rs == null) return null;
		int i = 0;
		Item it = new Item();
		Status st = new Status();
		while (rs.next()) {
			Order z = new Order();
			z.id = rs.getInt("id");
			z.addressD = rs.getString("addressD");
			z.addressB = rs.getString("addressB");
			z.sellerId = rs.getInt("sellerId");
			z.customerId = rs.getInt("customerId");
			z.created = rs.getTimestamp("created");
			z.total = rs.getFloat("total");
			z.items = it.getAllByOrder(z.id);
			z.statuses = st.getStatusesByOrderId(z.id);
			z.sellerName = rs.getString("sellerName");
			z.buyerName = rs.getString("buyerName");
			ord[i++] = z;
		}
		closeConnection();
		return ord;
	}
	
}
