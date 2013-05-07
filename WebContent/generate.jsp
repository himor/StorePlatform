<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>

	<%@ page import="sp.*"%>
	<%@ page import="java.util.Random"%>

	<%
		Viewer v = new Viewer();
		User u = new User();
		u.loadById(50);
		if (!u.loaded()) {
			// generate 100 users
			for (int i = 0; i < 50; i++) {
				u.setType(u.SELLER);
				u.setFname(v.getRandomString(10));
				u.setLname(v.getRandomString(8));
				u.setName(v.getRandomString(8) + " " + v.getRandomString(12));
				u.setUsername(v.getRandomString(8));
				u.setPassword("querty");
				u.createUser();
			}
			for (int i = 0; i < 50; i++) {
				u.setType(u.CUSTOMER);
				u.setFname(v.getRandomString(10));
				u.setLname(v.getRandomString(8));
				u.setName(v.getRandomString(8) + " " + v.getRandomString(12));
				u.setUsername(v.getRandomString(8));
				u.setPassword("querty");
				u.createUser();
			}
		}
		
		Item it = new Item();
		Random rnd = new Random();
		for (int i = 0; i < 500; i++) {
			it.setCount(10);
			it.setDescription(v.getRandomString(10) + " " + v.getRandomString(3) + " " + v.getRandomString(6));
			it.setName(v.getRandomString(10) + " " + v.getRandomString(3));
			it.setName("Item " + i);
			it.setPrice(Float.parseFloat("29.99"));
			it.setType("Stuff");
			it.setSellerId(rnd.nextInt(40)+3);
			it.createItem();
		}


	%>

	Done.






</body>
</html>