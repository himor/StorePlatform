<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Order History Module
--%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>

<%! String header = "UAlbany Market - History"; %>
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
%>
<div id="content">
<h2 class="heads" style="text-transform: uppercase;">Order History</h2>
<%
	if (myUser.getType() == myUser.CUSTOMER) {
		if (request.getParameter("placed")!= null) {
			out.print("<div class=\"success texts\">");
			out.print("Your order has been received!");
			out.print("</div>");
		}
		Order ordr = new Order();
		Order orders[] = ordr.getOrdersForUser(myUser.getId());
		if (orders.length == 0) {
			out.print("<p class='texts'>You do not have any orders</p>");
		} else {
%>
	<table class="table table-bordered" style="background-color: #eee;">
	<tr class="heads">
		<th width="10%">Order ID</th>
		<th style="text-align:left;width:30%">Description</th>
		<th style="text-align:center;width:20%">Date</th>
		<th style="text-align:right;width:10%">Total</th>
		<th style="text-align:center;width:10%">Status</th>
	</tr>
	<% 
		for (int i = 0; i< orders.length; i++) { 
		Status tmpStat = orders[i].getStatuses()[0];
		%>
		<tr>
	    <td class="texts" style="text-align:center; vertical-align: middle;"><% out.print(orders[i].getId()); %></td>
	    <td class="texts" style="text-align:left; vertical-align: middle;">
	    <a href="order.jsp?id=<% out.print(orders[i].getId()); %>"><% out.print(orders[i].getItems()[0].getName()); %></a></td>
	    <td class="texts" style="text-align:center; vertical-align: middle;"><% out.print(orders[i].getCreated()); %></td>
	    <td class="heads" style="text-align:right; vertical-align: middle;">$<% out.print(orders[i].getTotal()); %></td>
	    <td class="texts" style="text-align:center; vertical-align: middle;"><% 
	    if (tmpStat.getType() == tmpStat.PENDING) out.print("<span class=\"label\">Pending");	    
	    if (tmpStat.getType() == tmpStat.PROCESSING) out.print("<span class=\"label label-info\">Processing");
	    if (tmpStat.getType() == tmpStat.SHIPPED) out.print("<span class=\"label label-success\">Shipped");
	    if (tmpStat.getType() == tmpStat.CANCELLED) out.print("<span class=\"label label-important\">Cancelled");
	    out.print("</span>"); %></td>
	    </tr>
	<% } %>
	</table>
<% }
	} else { //IF SELLER - SHOW SELLER'S HISTORY
		
		if (request.getParameter("placed")!= null) {
			out.print("<div class=\"success texts\">");
			out.print("Your order has been received!");
			out.print("</div>");
		}
		Order ordr = new Order();
		Order orders[] = ordr.getOrdersFromStore(myUser.getId());
		if (orders.length == 0) {
			out.print("<p class='texts'>You do not have any orders</p>");
		} else {
%>
	<table class="table table-bordered" style="background-color: #eee;">
	<tr class="heads">
		<th width="10%">Order ID</th>
		<th style="text-align:left;width:30%">Description</th>
		<th style="text-align:center;width:20%">Date</th>
		<th style="text-align:right;width:10%">Total</th>
		<th style="text-align:center;width:10%">Status</th>
	</tr>
	<% 
		for (int i = 0; i< orders.length; i++) { 
		Status tmpStat = orders[i].getStatuses()[0];
		%>
		<tr>
	    <td class="texts" style="text-align:center; vertical-align: middle;"><% out.print(orders[i].getId()); %></td>
	    <td class="texts" style="text-align:left; vertical-align: middle;">
	    <a href="order.jsp?id=<% out.print(orders[i].getId()); %>"><% out.print(orders[i].getItems()[0].getName()); %></a></td>
	    <td class="texts" style="text-align:center; vertical-align: middle;"><% out.print(orders[i].getCreated()); %></td>
	    <td class="heads" style="text-align:right; vertical-align: middle;">$<% out.print(orders[i].getTotal()); %></td>
	    <td class="texts" style="text-align:center; vertical-align: middle;"><% 
	    if (tmpStat.getType() == tmpStat.PENDING) out.print("<span class=\"label\">Pending");	    
	    if (tmpStat.getType() == tmpStat.PROCESSING) out.print("<span class=\"label label-info\">Processing");
	    if (tmpStat.getType() == tmpStat.SHIPPED) out.print("<span class=\"label label-success\">Shipped");
	    if (tmpStat.getType() == tmpStat.CANCELLED) out.print("<span class=\"label label-important\">Cancelled");
	    out.print("</span>"); %></td>
	    </tr>
	<% } %>
	</table>

<% }
		} %>

</div>			
<%@ include file="footer.jsp" %>