<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Helper Module - returns JSON content
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ page import="sp.*" %>
<%@ include file="session.jsp"%>
<%
	// check the session;

		sessId = getSessionPrefix(session.getId());
		String sess_uid = (String)session.getAttribute("uid"+sessId);
	if (null == request.getParameter("admin")) { 
		if (null == sess_uid) sess_uid = "0";
		if (sess_uid.equals("0")) {
			return;		
		}
	}
	
	String action = request.getParameter("action");
	if (action == null) {
		return;
	}
	
	if (action.equals("1")) {%>
		<%
			Notification notif = new Notification();
			int k = notif.getNumberByUserId(Integer.parseInt(sess_uid));
			if (k > 0) {
				out.print("You have <span class='bright'>");
				out.print(k);
				out.print("</span>");
			} else
				out.print(" View ");
		%>
		notifications
<%
	} 
		
	if (action.equals("2")) {
		String revId = request.getParameter("reviewId");
		if (null != revId) {
	Review rev = new Review();
	rev.getReviewById(Integer.parseInt(revId));
	if (rev.getCustomerId() == Integer.parseInt(sess_uid))
		rev.deleteReview();		
		}
		out.print("ok");
		} 
		
	if (action.equals("3")) {
		String messId = request.getParameter("messageId");
	if (null != messId) {
		Message mess = new Message();
		mess.loadById(Integer.parseInt(messId));
		mess.hideMessage(Integer.parseInt(sess_uid));
	}
		out.print("ok");
		}
		
	if (action.equals("adminDeleteUser")) {
		String userId = request.getParameter("userId");
		if (null != userId) {
	User user = new User();
	user.loadById(Integer.parseInt(userId));
	user.deleteUser();
	(new Item()).deleteItemsByUser(Integer.parseInt(userId));
		}
		out.print("ok");
		} 
	
	if (action.equals("adminUnDeleteUser")) {
		String userId = request.getParameter("userId");
		if (null != userId) {
	User user = new User();
	user.loadById(Integer.parseInt(userId));
	user.undeleteUser();		
		}
		out.print("ok");
		} 
	
	if (action.equals("deleteItem")) {
		String itemId = request.getParameter("itemId");
	if (null != itemId) {
		Item item = new Item();
		item.loadById(Integer.parseInt(itemId));
		if (item.getSellerId() == Integer.parseInt(sess_uid))
			item.deleteItem(true);
	}
		out.print("ok");
		}
	
	if (action.equals("undeleteItem")) {
		String itemId = request.getParameter("itemId");
	if (null != itemId) {
		Item item = new Item();
		item.loadById(Integer.parseInt(itemId));
		if (item.getSellerId() == Integer.parseInt(sess_uid))
			item.deleteItem(false);
	}
		out.print("ok");
		}
	
	if (action.equals("updateCounter")) {
		String itemId = request.getParameter("itemId");
		if (null != itemId) {
			Item item = new Item();
			item.loadById(Integer.parseInt(itemId));
			if (item.getSellerId() == Integer.parseInt(sess_uid)) {
				if (1 == Integer.parseInt(request.getParameter("op"))) {
					item.upperCount(Integer.parseInt(request
							.getParameter("value")));
				} else {
					item.lowerCount(Integer.parseInt(request
							.getParameter("value")));
				}
				out.print(item.getCount());
				return;
			}
		}
		out.print("error");
	}

	if (action.equals("updateItemInfo")) {
		String itemId = request.getParameter("itemId");
		if (null != itemId) {
			Item item = new Item();
			item.loadById(Integer.parseInt(itemId));
			if (item.getSellerId() == Integer.parseInt(sess_uid)) {
				// update the item
				String name = request.getParameter("name");
				String price = request.getParameter("price");
				String type = request.getParameter("type");
				String description = request.getParameter("description");
				item.setPrice(Float.parseFloat(price));
				item.setName(name);
				item.setType(type);
				item.setDescription(description);
				item.updateItem();				
			}		
		}
		response.sendRedirect("items.jsp");
		return;
	}
%>
