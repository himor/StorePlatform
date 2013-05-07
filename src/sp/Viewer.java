package sp;

import java.util.Random;

public class Viewer extends Model {
	
	
	public String getOneOfManyItems(Item it) {
		String str = "";
		str += "<div class='item texts'>";
		str += "<a href='item.jsp?id=" + it.getId() + "'>";
		str += "<span class='name'>" + it.getName() + "</span>";
		if (it.getPicture().equals("") || it.getPicture() == null) {
			str += "<img src='img/item.png' />";
		} else 
		str += "<img src='" + it.getPicture() + "' />";
		str += "<span class='price'>$" + it.getPrice() + "</span>";
		str += "</a>";
		str += "</div>";
		return str;
	}
	
	public String getOneOfManyReviews(Review re) {
		String str = "";
		str += "<div class=\"review\">";
		str += "<p class=\"heads\">";
		String avgStarText = "";
		for (int j = 0; j < re.getStar(); j++)
			avgStarText += "<i class='icon-star'></i>";
		for (int j = 0; j < 5 - re.getStar(); j++)
			avgStarText += "<i class='icon-star icon-white'></i>";
		str += avgStarText+"</p>";
		str += "<span class=\"type texts\">by "+re.customerName+"</span>";
		str += "<p class=\"texts bright-round\"> "+re.getText()+"</p></div>";
		return str;
	}

	public String getRandomString(int length) {
		String r = "";
		Random rnd = new Random();
		for (int i = 0; i < length; i++) {
			char nextChar = (char) (rnd.nextInt(26) + 97);
			r += nextChar;
			if (r.length() == 1) r = r.toUpperCase();
		}
		return r;
	}

}
