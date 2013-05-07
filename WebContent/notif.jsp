<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Notifications
--%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>

<%! String header = "UAlbany Market - Notifications"; %>
<%! boolean showButtons = true; %>
<%@ include file="header.jsp" %>
<%! int showCat = 2; %>
<%@ include file="sidebar.jsp" %>

<%
	// check the session;
	String sess_uid = (String)session.getAttribute("uid"+sessId);
	if (null == sess_uid) sess_uid = "0";
	if (sess_uid.equals("0")) {
		response.sendRedirect("index.jsp");
		return;		
	}
	Notification noti[] = (new Notification()).getAllForUser(myUser.getId());
%>
<div id="content">
	<h2 class="heads" style="text-transform: uppercase;">Notifications</h2>
	<div>
	<%
		for (int i = 0; i < noti.length; i++) {
		%>
			<p <% if (!noti[i].isRead()) out.print("class='isbright'"); else out.print("class='nonbright'"); %>
			><span class="heads fixed50">
			<%
			if (noti[i].getStatus() == noti[i].NEW_MAIL) 
			  out.print("<i class=\"icon-envelope\"></i>");
			if (noti[i].getStatus() == noti[i].NEW_ORDER) 
				  out.print("<i class=\"icon-shopping-cart\"></i>");
			if (noti[i].getStatus() == noti[i].NEW_REVIEW) 
				  out.print("<i class=\"icon-comment\"></i>");
			if (noti[i].getStatus() == noti[i].ITEM_COUNT) 
				  out.print("<i class=\"icon-bell\"></i>");
			if (noti[i].getStatus() == noti[i].SHIPPED) 
				  out.print("<i class=\"icon-ok\"></i>");
			if (noti[i].getStatus() == noti[i].CANCELLED) 
				  out.print("<i class=\"icon-remove\"></i>");
			if (noti[i].getStatus() == noti[i].PROCESSING) 
				  out.print("<i class=\"icon-tag\"></i>");
			%>
			</span>
			
			<span class="texts"><%
			if (noti[i].getStatus() == noti[i].NEW_MAIL) 
				out.print("You have a <a href='oneMessage.jsp?id="+noti[i].getPointer()+"'>new mail</a>!");
			if (noti[i].getStatus() == noti[i].NEW_ORDER) 
				out.print("<a href='order.jsp?id="+noti[i].getPointer()+"'>New order</a> has been placed!");
			if (noti[i].getStatus() == noti[i].NEW_REVIEW) 
				out.print("You have a new review for <a href='item.jsp?id="+noti[i].getPointer()+"'>one of your items</a>");
			if (noti[i].getStatus() == noti[i].ITEM_COUNT) 
				out.print("There is only one <a href='item.jsp?id="+noti[i].getPointer()+"'>item</a> left in stock!");
			if (noti[i].getStatus() == noti[i].SHIPPED) 
				out.print("<a href='order.jsp?id="+noti[i].getPointer()+"'>Your order</a> has been shipped!");
			if (noti[i].getStatus() == noti[i].CANCELLED) 
				out.print("<a href='order.jsp?id="+noti[i].getPointer()+"'>Your order</a> has been cancelled!");
			if (noti[i].getStatus() == noti[i].PROCESSING) 
				out.print("<a href='order.jsp?id="+noti[i].getPointer()+"'>Your order</a> is being processed!");
			%></span>
			
			<span class="heads fixed150"><%
			out.print(noti[i].getCreated());
			%></span>
			
			</p>
		
		<%	
		}
	%>
	</div>
</div>
<%
	(new Notification()).markReadAll(myUser.getId());
%>

<%@ include file="footer.jsp" %>