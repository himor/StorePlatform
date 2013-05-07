<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Sidebar Module
--%>
<%@ page import="sp.*" %>
<div id="sidebar" class="heads">
<%  //int showCat = 1; - show categories
	//int showCat = 2; - my account
	if (showCat == 2){
		User myUserSidebar = new User();
		myUserSidebar.loadById(Integer.parseInt(sess_uid));
		if (!myUserSidebar.loaded()) {
			response.sendRedirect("logout.jsp");
			return;
		}
		if (myUserSidebar.getType() == myUserSidebar.CUSTOMER) {
			// display menu for the customer
			out.print("<a href='account.jsp'>Account settings</a>");
			out.print("<a href='history.jsp'>Order history</a>");
			out.print("<a href='reviews.jsp'>My reviews</a>");
			out.print("<a href='messages.jsp'>Messages</a>");
			out.print("<a href='notif.jsp'>Notifications</a>");
		}
		
		if (myUserSidebar.getType() == myUserSidebar.SELLER) {
			// display menu for the seller
			out.print("<a href='account.jsp'>Account settings</a>");
			out.print("<a href='history.jsp'>Order history</a>");
			out.print("<a href='reviews.jsp'>Review history</a>");
			out.print("<a href='items.jsp'>Items history</a>");
			out.print("<a href='messages.jsp'>Messages</a>");
			out.print("<a href='notif.jsp'>Notifications</a>");
		}
	}
	
	if (showCat == 1) {
		Item sbit = new Item();
		String[] cats = sbit.getCats();
		for(int i = 0; i<cats.length; i++) {
			out.print("<a href='search.jsp?type=cat&value="+cats[i]+"'>"+cats[i]+"</a>");
		}
	}

%>
			
</div>