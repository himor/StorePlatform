package test;

import static org.junit.Assert.*;

import java.sql.SQLException;

import org.junit.Test;
import sp.*;

public class ItemTest {
	
	public static int SELLER = 2; // seller ID for testing. must contain items
	public static int ORDER  = 1; // order ID
	public static int NUMBER = 5;
	public static float FLOATNUMBER = (float) 2.59;

	/*
	 * This unit tests the construction of the element
	 */
	@Test
	public void initTest() {
		Item item = new Item();
		assertNotNull(item);
		Item[] items = new Item[NUMBER];
		assertEquals(items.length, NUMBER);		
	}
	
	/*
	 * This unit tests the getters and setters
	 */
	@Test
	public void gettersSettersTest() {
		Item item = new Item();
		item.setCount(NUMBER);
		assertEquals(item.getCount(), NUMBER);
		item.setDescription("word");
		assertEquals(item.getDescription(), "word");
		item.setId(NUMBER);
		assertEquals(item.getId(), NUMBER);
		item.setName("word");
		assertEquals(item.getName(), "word");
		item.setPicture("picture");
		assertEquals(item.getPicture(), "picture");
		item.setPrice(FLOATNUMBER);
		assertEquals(item.getPrice(), FLOATNUMBER, 0);
		item.setType("word");
		assertEquals(item.getType(), "word");
		item.setSellerId(NUMBER);
		assertEquals(item.getSellerId(), NUMBER);
		item.setDeleted(false);
		assertEquals(item.isDeleted(), false);
		item.setDeleted(true);
		assertEquals(item.isDeleted(), true);		
	}
	
	/*
	 * This unit tests item loader 
	 */
	@Test
	public void loaderTest() {
		Item item = new Item();
		assertNotSame(item.getId(), 1);
		try {
			item.loadById(1);
			assertEquals(item.getId(), 1);
		} catch (Exception e) {
			fail("Failed to load item id 1: Exception");
			//e.printStackTrace();
		}
	}
	
	/*
	 * This unit tests item retrieval
	 */
	@Test
	public void itemRetTest() {
		Item item = new Item();
		try {
			int k = 0;
			k = item.getNumberOfItems(SELLER);
			assertNotSame(k, 0);
			Item tempSet[] = item.getAllForUser(SELLER);
			assertEquals(tempSet.length, k);			// Retrieves correct number of items
		} catch (SQLException e) {
			fail("Failed to get number of items for seller id " + SELLER + ": SQLException");
			//e.printStackTrace();
		}
		
		try {
			int k = 0;
			k = item.getNumberOfItemsInOrder(ORDER);
			assertNotSame(k, 0);
			Item tempSet[] = item.getAllByOrder(ORDER);
			assertEquals(tempSet.length, k);			// Retrieves correct number of items
		} catch (SQLException e) {
			fail("Failed to get number of items for order id " + ORDER + ": SQLException");
			//e.printStackTrace();
		}
		
		try {
			Item tempSet[] = item.getAllByOrder(ORDER);
			for (int i = 0; i < tempSet.length; i++) {
				assertNotNull(tempSet[i]);
				assertNotNull(tempSet[i].getId());
				assertNotSame(tempSet[i].getId(), 0);
			}
		} catch (SQLException e) {
			fail("Failed to load items for order id " + ORDER + ": SQLException");
			//e.printStackTrace();
		}
	}
	
	/*
	 * This unit tests item livecycle: creation, update and deletion
	 */
	@Test
	public void itemLiveTest() {
		Item item = new Item();
		item.setDescription("word");
		item.setType("type");
		item.setName("name");
		item.setSellerId(SELLER);
		item.setCount(NUMBER);
		item.setPrice(FLOATNUMBER);
		item.setPicture("picture");
		try {
			item.createItem();
		} catch (SQLException e) {
			fail("Failed to create new item: SQLException");
		}
		
		// load newly created item
		Item itemNew = new Item();		
		assertNotSame(itemNew.getId(), item.getId());
		try {
			itemNew.loadById(item.getId());
			assertEquals(itemNew.getId(), item.getId()); // item actually loaded
		} catch (SQLException e) {
			fail("Failed to load item id "+item.getId()+": SQLException");
		}
		
		itemNew.setName("another name");
		try {
			itemNew.updateItem();
		} catch (SQLException e) {
			fail("Failed to update item id "+itemNew.getId()+": SQLException");
		}
		
		// load updated item
		item = new Item();		
		try {
			item.loadById(itemNew.getId());
			assertEquals(item.getId(), itemNew.getId()); // item actually loaded
			assertEquals(itemNew.getName(), "another name"); // update has been saved			
		} catch (SQLException e) {
			fail("Failed to load updated item id "+itemNew.getId()+": SQLException");
		}
		
		try {
			item.deleteItem(true);
		} catch (SQLException e) {
			fail("Failed to delete item id "+item.getId()+": SQLException");
		}		
	}
	
	/*
	 * This unit tests search functions
	 */
	@Test
	public void searchTest() {
		Item item = new Item();
		// first, search by name
		int k = 0;
		try {
			k = item.searchCount("a", null);
			assertNotSame(k, 0);
		} catch (SQLException e) {
			fail("Failed to execute searchCount by Name: SQLException");
		}
		
		if (k > Item.ITEMS_PER_PAGE) k = Item.ITEMS_PER_PAGE;
		assertNotSame(k, 0);
		
		try {
			Item tempSet[] = item.search("a", null);
			assertSame(tempSet.length, k);
		} catch (SQLException e) {
			fail("Failed to execute search by name: SQLException");
		}
		
		// check if search returns actual items
		try {
			Item tempSet[] = item.search("a", null);
			for (int i = 0; i < tempSet.length; i++) {
				assertNotNull(tempSet[i]);
				assertNotNull(tempSet[i].getId());
				assertNotSame(tempSet[i].getId(), 0);
			}
		} catch (SQLException e) {
			fail("Failed to load items for search by name: SQLException");
		}
		
		// then search by type (category)
		k = 0;
		try {
			k = item.searchCount(null, "a");
			assertNotSame(k, 0);
		} catch (SQLException e) {
			fail("Failed to execute searchCount by Type: SQLException");
		}
		
		if (k > Item.ITEMS_PER_PAGE) k = Item.ITEMS_PER_PAGE;
		assertNotSame(k, 0);
		
		try {
			Item tempSet[] = item.search(null, "a");
			assertSame(tempSet.length, k);
		} catch (SQLException e) {
			fail("Failed to execute search by type: SQLException");
		}
		
		// now search by store name
		k = 0;
		try {
			k = item.searchCountS("a");
			assertNotSame(k, 0);
		} catch (SQLException e) {
			fail("Failed to execute searchCount by Store Name: SQLException");
		}
		
		if (k > Item.ITEMS_PER_PAGE) k = Item.ITEMS_PER_PAGE;
		assertNotSame(k, 0);
		
		try {
			Item tempSet[] = item.searchS("a", 0);
			assertSame(tempSet.length, k);
		} catch (SQLException e) {
			fail("Failed to execute search by Store Name: SQLException");
		}
	}
	
	/*
	 * This unit tests random search functions
	 */
	@Test
	public void randomTest() {
		Item item = new Item();
		try {
			Item tempSet[] = item.getRandom(0);
			assertNotSame(tempSet.length, 0);
		} catch (SQLException e) {
			fail("Failed to execute search of random items: SQLException");
		}
	}
	
	/*
	 * This unit tests the retrieval of the list of categories
	 */
	@Test
	public void catTest() {
		Item item = new Item();
		try {
			String tempSet[] = item.getCats();
			assertNotSame(tempSet.length, 0);
			for (int i = 0; i < tempSet.length; i++) { // check if categories are empty
				assertNotNull(tempSet[i]);
				assertNotSame(tempSet[i], "");
			}
		} catch (SQLException e) {
			fail("Failed to execute the retrieval of the list of categories: SQLException");
		}
		
	}
}
