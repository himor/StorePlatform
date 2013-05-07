package sp;
/* 	================================================
COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
================================================
*/
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;

public class Cart {

	private int size;
	private HashMap<Integer, Item> items;
	
	public Cart() {
		this.size = 0;
		this.items = new HashMap<Integer, Item>();		
	}
	
	public int getSize() {
		return size;
	}
	
	public void setSize(int size) {
		this.size = size;
	}
	
	public void addItem(Item item) {
		items.put(item.getId(), item);
		size += 1;
	}
	
	public Item[] getItems() {
		Item[] itms = new Item[size];
		int k = 0;
		for (Iterator it = items.keySet().iterator(); it.hasNext();) {
			itms[k++] = (Item) items.get(it.next());			
		} 
		return itms;
	}
	
	public Item[] getItems(int sellerId) {
		int itemsWithSeller = 0;
		for (Iterator it = items.keySet().iterator(); it.hasNext();) {
			Item temp = (Item) items.get(it.next());
			if (temp.getSellerId() == sellerId) itemsWithSeller++;
		}		
		Item[] itms = new Item[itemsWithSeller];
		int k = 0;
		for (Iterator it = items.keySet().iterator(); it.hasNext();) {
			Item temp = (Item) items.get(it.next());
			if (temp.getSellerId() == sellerId)
				itms[k++] = temp;			
		} 
		return itms;
	}	
	
	public void updateItem(Item item) {
		if (items.containsKey(item.getId())) {
				if (item.getCount() > 0)
				items.get(item.getId()).setCount(item.getCount());
				else { items.remove(item.getId()); size--;}
			} else {
				addItem(item);
			}
		}
	
	public int[] getSellers(){
		HashSet<Integer> sellers = new HashSet<Integer>();
		for (Iterator<Integer> it = items.keySet().iterator(); it.hasNext();) {
			Item myItem = (Item) items.get(it.next());
			if (!sellers.contains(myItem.getSellerId()))
				sellers.add(myItem.getSellerId());			
		}
		int[] hs = new int[sellers.size()];
		int k = 0;
		for (Iterator it = sellers.iterator(); it.hasNext();) {
			Integer i = (Integer) it.next();
			hs[k++] = i;
		}
		return hs;
	}
}
