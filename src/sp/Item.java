package sp;
/* 	================================================
COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
================================================
*/
import java.sql.*; 
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Random;

public class Item extends Model {
	
	private int id = 0;
	private String name = "";
	private String type = "";
	private String description = "";
	private int sellerId = 0;
	private float price = 0;
	private String picture = "";
	private boolean isDeleted = false;
	private int count = 0;
	private Timestamp created;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public int getSellerId() {
		return sellerId;
	}
	
	public User getSeller() throws SQLException {
		User seller = new User();
		seller.loadById(sellerId);
		return seller;
	}

	public void setSellerId(int sellerId) {
		this.sellerId = sellerId;
	}

	public float getPrice() {
		return price;
	}

	public void setPrice(float price) {
		this.price = price;
	}

	public String getPicture() {
		return picture;
	}

	public void setPicture(String picture) {
		this.picture = picture;
	}

	public boolean isDeleted() {
		return isDeleted;
	}

	public void setDeleted(boolean isDeleted) {
		this.isDeleted = isDeleted;
	}

	public int getCount() {
		return count;
	}

	public void setCount(int count) {
		this.count = count;
	}

	public String getCreated() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("EEE, d MMM YYYY h:mm a ");
		return dateFormat.format(created);
	}

	public void loadById(int id) throws SQLException {
		ResultSet rs = null;
		this.openConnection();
		rs = this.runQuery("SELECT * FROM `item` WHERE `id` = " + id);
		if (rs == null) return;
		if (rs.next()) {
			this.id = rs.getInt("id");
			this.description = rs.getString("description");
			this.type = rs.getString("type");
			this.name = rs.getString("name");
			this.sellerId = rs.getInt("sellerId");
			this.count = rs.getInt("count");
			this.price = rs.getFloat("price");
			this.isDeleted = rs.getBoolean("isDeleted");
			this.created = rs.getTimestamp("created");
			this.picture = rs.getString("picture");
		}
		this.closeConnection();
	}
	
	public int getNumberOfItems(int userId) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `item` WHERE `sellerId` = '" + userId + "'; ");
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	/**
	 * returns array of items by sellerId
	 * @throws SQLException 
	 */
	public Item[] getAllForUser(int userId) throws SQLException {
		Item[] itm = new Item[getNumberOfItems(userId)];
		ResultSet rs = null;
		openConnection();
		rs = this.runQuery("SELECT * FROM `item` WHERE `sellerId` = " + userId);
		if (rs == null) return null;
		int i = 0;
		while (rs.next()) {
			Item z = new Item();
			z.id = rs.getInt("id");
			z.description = rs.getString("description");
			z.type = rs.getString("type");
			z.name = rs.getString("name");
			z.sellerId = rs.getInt("sellerId");
			z.count = rs.getInt("count");
			z.price = rs.getFloat("price");
			z.isDeleted = rs.getBoolean("isDeleted");
			z.created = rs.getTimestamp("created");
			z.picture = rs.getString("picture");
			itm[i++] = z;
		}
		closeConnection();
		return itm;		
	}
	
	public int getNumberOfItemsInOrder(int orderId) throws SQLException {
		openConnection();
		ResultSet rs = null;
		rs = this.runQuery("SELECT COUNT(*) FROM `orderItem` WHERE `orderId` = '" + orderId + "'; ");
		if (rs == null) return 0;
		int k = 0;
		if (rs.next())
			k = rs.getInt(1);
		closeConnection();
		return k;
	}
	
	/**
	 * returns array of items by the order id
	 * @throws SQLException 
	 */
	public Item[] getAllByOrder(int orderId) throws SQLException {
		Item[] itm = new Item[getNumberOfItemsInOrder(orderId)];
		HashMap<Integer, Integer> counts = new HashMap<Integer, Integer>();
		ResultSet rs = null;
		ResultSet rs2 = null;
		openConnection();
		rs2 = this.runQuery("SELECT `itemId`, `count` FROM `orderItem` WHERE `orderId` = " + orderId + ";");
		while (rs2.next()) {
			counts.put(rs2.getInt("itemId"), rs2.getInt("count"));
		}
		rs = this.runQuery("SELECT * FROM `item` WHERE `id` IN (" +
				"SELECT itemId FROM `orderItem` WHERE `orderId` = " + orderId + ");");
		if (rs == null) return null;
		int i = 0;
		while (rs.next()) {
			Item z = new Item();
			z.id = rs.getInt("id");
			z.description = rs.getString("description");
			z.type = rs.getString("type");
			z.name = rs.getString("name");
			z.sellerId = rs.getInt("sellerId");
			z.count = counts.get(z.id);
			z.price = rs.getFloat("price");
			z.isDeleted = rs.getBoolean("isDeleted");
			z.created = rs.getTimestamp("created");
			z.picture = rs.getString("picture");
			itm[i++] = z;
		}
		closeConnection();
		return itm;		
	}
	
	public void updateItem() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		con = this.getDbConnection();
		try {
		      stmt = con.prepareStatement("UPDATE `item` SET `name` = ?,`type` = ?,`description` = ?,`sellerId` = ?,`price` = ?,`count` = ?,`picture` = ?, `isDeleted` = ? WHERE `id` = ? ;");
		      stmt.setString(1, this.name);
		      stmt.setString(2, this.type);
		      stmt.setString(3, this.description);
		      stmt.setInt(4, this.sellerId);
		      stmt.setFloat(5, this.price);
		      stmt.setInt(6, this.count);
		      stmt.setString(7, this.picture);
		      stmt.setBoolean(8, this.isDeleted);
		      stmt.setInt(9, this.id);
		      stmt.executeUpdate();
		      stmt.close();
		   }
		   finally {
			   this.closeConnection(con);
		   }
	}
	
	public void deleteItemsByUser(int userId) throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		con = this.getDbConnection();
		try {
		      stmt = con.prepareStatement("UPDATE `item` SET `isDeleted` = ? WHERE `sellerId` = ? ;");
		      stmt.setBoolean(1, true);
		      stmt.setInt(2, userId);
		      stmt.executeUpdate();
		      stmt.close();
		   }
		   finally {
			   this.closeConnection(con);
		   }
	}
	
	public void deleteItem(boolean sure) throws SQLException {
		this.setDeleted(sure);
		this.updateItem();
	}
	
	public void lowerCount() throws SQLException {
		this.setCount(count-1);
		this.updateItem();
	}
	
	public void lowerCount(int n) throws SQLException {
		this.setCount(count-n);
		this.updateItem();
	}
	
	/**
	 * in case order was cancelled
	 */
	public void upperCount() throws SQLException {
		this.setCount(count+1);
		this.updateItem();
	}
	
	public void upperCount(int n) throws SQLException {
		this.setCount(count+n);
		this.updateItem();
	}
	
	public void createItem() throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		con = this.getDbConnection();
		try {
		      stmt = con.prepareStatement("INSERT INTO `item` ( `name`,`type`,`description`,`sellerId`,`price`,`count`,`picture`) VALUES (?,?,?,?,?,?,?);");
		      stmt.setString(1, this.name);
		      stmt.setString(2, this.type);
		      stmt.setString(3, this.description);
		      stmt.setInt(4, this.sellerId);
		      stmt.setFloat(5, this.price);
		      stmt.setInt(6, this.count);
		      stmt.setString(7, this.picture);
		      stmt.executeUpdate();
		      stmt.close();
		   }
		   finally {
			   this.closeConnection(con);
		   }
		// find last item for this seller
		openConnection();
		String query = "SELECT MAX(id) FROM `item` WHERE `sellerId` = '"+this.sellerId+"' AND `name` = '"+this.name+"';";
		ResultSet rs = runQuery(query);
		if (rs.next())
			this.id = rs.getInt(1);
		closeConnection();
	}

	/**
	 * returns the total number of items for these search criteria
	 */
	public int searchCount(String name, String type) throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rsc = null;
		int k = 0;
		con = this.getDbConnection();
		try {
			  if (name != null && name.length() > 0) {
					stmt = con.prepareStatement("SELECT COUNT(*) FROM `item` WHERE (`name` LIKE ? OR `description` LIKE ?) AND isDeleted = FALSE ; ");
					stmt.setString(1, "%"+name+"%");
					stmt.setString(2, "%"+name+"%");
				} else if(type != null && type.length() > 0) {
					stmt = con.prepareStatement("SELECT COUNT(*) FROM `item` WHERE `type` LIKE ? AND isDeleted = FALSE; ");
					stmt.setString(1, "%"+type+"%");
				}
			  rsc = stmt.executeQuery();
			  if (rsc.next())
					k = rsc.getInt(1);
			  stmt.close();
		   }
		   finally {
			   this.closeConnection(con);
		   }
		return k;
	}
	
	/**
	 * returns the total number of items for the search criteria Store Name
	 */
	public int searchCountS(String name) throws SQLException {
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rsc = null;
		int k = 0;
		con = this.getDbConnection();
		try {
			  stmt = con.prepareStatement("SELECT COUNT(`item`.`id`) FROM `item`, `user`" +
			  		" WHERE `item`.`sellerId` = `user`.`id` AND `user`.`name` LIKE ? AND item.isDeleted = FALSE; ");
			  stmt.setString(1, "%"+name+"%");
			  rsc = stmt.executeQuery();
			  if (rsc.next())
					k = rsc.getInt(1);
			  stmt.close();
		   }
		   finally {
			   this.closeConnection(con);
		   }
		return k;
	}
	
	/**
	 * Returns set of items as a result of searching by name or type
	 */
	public Item[] search(String name, String type, int page) throws SQLException {
		// count such items first
		int shift = page * ITEMS_PER_PAGE;
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rsc = null;
		int k = searchCount(name, type);
		k -= shift; 
		if (k>ITEMS_PER_PAGE) k = ITEMS_PER_PAGE;		
		Item[] itm = new Item[k];
		if (k==0) return itm;
		ResultSet rs = null;
		int i = 0;
		
		con = this.getDbConnection();
		try {
			  if (name != null && name.length() > 0) {
					stmt = con.prepareStatement("SELECT * FROM `item` WHERE (`name` LIKE ? OR `description` LIKE ?) AND isDeleted = FALSE ORDER BY `id` LIMIT " + shift + "," + ITEMS_PER_PAGE + ";  ");
					stmt.setString(1, "%"+name+"%");
					stmt.setString(2, "%"+name+"%");
				} else if(type != null && type.length() > 0) {
					stmt = con.prepareStatement("SELECT * FROM `item` WHERE `type` LIKE ? AND isDeleted = FALSE ORDER BY `id` LIMIT " + shift + "," + ITEMS_PER_PAGE + ";  ");
					stmt.setString(1, "%"+type+"%");
				}
			  rs = stmt.executeQuery();
			  while (rs.next()) {
					Item z = new Item();
					z.id = rs.getInt("id");
					z.description = rs.getString("description");
					z.type = rs.getString("type");
					z.name = rs.getString("name");
					z.sellerId = rs.getInt("sellerId");
					z.count = rs.getInt("count");
					z.price = rs.getFloat("price");
					z.isDeleted = rs.getBoolean("isDeleted");
					z.created = rs.getTimestamp("created");
					z.picture = rs.getString("picture");
					itm[i++] = z;
				}
		   }
		   finally {
			   stmt.close();
			   this.closeConnection(con);
		   }
		return itm;
	}
	
	public Item[] search(String name, String type) throws SQLException {
		return search(name, type, 0);
	}
	
	public Item[] search(String name) throws SQLException {
		return search(name, "", 0);
	}
	
	
	/**
	 * Search by store
	 */
	public Item[] searchS(String name, int page) throws SQLException {
		// count such items first
		int shift = page * ITEMS_PER_PAGE;
		Connection con = null;
		PreparedStatement stmt = null;
		ResultSet rsc = null;
		int k = searchCountS(name);
		k -= shift; 
		if (k>ITEMS_PER_PAGE) k = ITEMS_PER_PAGE;		
		Item[] itm = new Item[k];
		if (k==0) return itm;
		ResultSet rs = null;
		int i = 0;
		
		con = this.getDbConnection();
		try {
			  stmt = con.prepareStatement("SELECT * FROM `item`, `user`" +
		  		" WHERE `item`.`sellerId` = `user`.`id` AND `user`.`name` LIKE ? AND item.isDeleted = FALSE ORDER BY `item`.`id` LIMIT " + shift + "," + ITEMS_PER_PAGE + ";  ");
			  stmt.setString(1, "%"+name+"%");
			  rs = stmt.executeQuery();
			  while (rs.next()) {
					Item z = new Item();
					z.id = rs.getInt("id");
					z.description = rs.getString("description");
					z.type = rs.getString("type");
					z.name = rs.getString("name");
					z.sellerId = rs.getInt("sellerId");
					z.count = rs.getInt("count");
					z.price = rs.getFloat("price");
					z.isDeleted = rs.getBoolean("isDeleted");
					z.created = rs.getTimestamp("created");
					z.picture = rs.getString("picture");
					itm[i++] = z;
				}
		   }
		   finally {
			   stmt.close();
			   this.closeConnection(con);
		   }
		return itm;
	}
	
	
	/**
	 * returns pseudo-random items 
	 */
	public Item[] getRandom(int page) throws SQLException {
		Random rnd = new Random();
	    char nextChar = (char) (rnd.nextInt(26) + 97);
		return search(""+nextChar, "", page);
	}
	
	/**
	 * returns array of all existing categories 
	 * @throws SQLException 
	 */
	public String[] getCats() throws SQLException {
		HashMap<Integer, String> hm = new HashMap<Integer, String>();
		int i = 0;
		openConnection();
		String query = "SELECT DISTINCT `type` FROM `item` WHERE `isDeleted` = FALSE;";
		ResultSet rs = runQuery(query);
		while (rs.next()) {
			hm.put(i++, rs.getString("type"));			
		}		
		closeConnection();		
		String[] result = new String[i];
		for(int j = 0; j<i; j++)
			result[j] = hm.get(j);
		java.util.Arrays.sort(result);
		return result;
	}
	
}
