<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	My Reviews Module
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

<%
	if (myUser.getType() == myUser.CUSTOMER) {
		out.print("<h2 class=\"heads\" style=\"text-transform: uppercase;\">My Reviews</h2>");
		Review rewr = new Review();
		Review reviews[] = rewr.getAllForUser(myUser.getId());
		if (reviews.length == 0) {
			out.print("<p class='texts'>You do not have any reviews</p>");
		} else {
		out.print("<table>");
		for (int i = 0; i< reviews.length; i++) { 
			if (reviews[i].isDeleted()) continue;
			Item forItem = new Item();
			forItem.loadById(reviews[i].getItemId());
			%>
			<tr id="tr_<% out.print(reviews[i].getId());%>"><td style="vertical-align: top;">
			<a href="item.jsp?id=<%out.print(forItem.getId());%>">
			<%
					if (forItem.getPicture().equals("") || forItem.getPicture() == null)
						out.print("<img class='item' src='img/item.png' />");
					else
						out.print("<img class='item' src='" + forItem.getPicture() + "' />");
				%></a>
				<br />
			</td><td style="vertical-align: top;">
			<span class="typeType texts"><% out.print(forItem.getType()); %></span>
			<span class="nameName texts"><% out.print(forItem.getName()); %></span>
			<span class="typeType texts">by <% out.print(forItem.getSeller().getName()); %></span>
			<%
			String avgStarText = "";
			for (int j = 0; j < reviews[i].getStar(); j++)
				avgStarText += "<i class='icon-star'></i>";
			for (int j = 0; j < 5-reviews[i].getStar(); j++)
				avgStarText += "<i class='icon-star icon-white'></i>"; 
			out.print(avgStarText + "<br>");
			out.print("<p class=\"texts bright-round\">" + reviews[i].getText() + "</p><br>");
			out.print("<a class='heads' href='javascript:rDelete("+reviews[i].getId()+");'>Delete</a>");
			%>
			
			</td></tr>
			
		

		<% }
		out.print("</table>");
		}
	} else { //IF SELLER - SHOW REVIEWS FOR SELLER
		out.print("<h2 class=\"heads\" style=\"text-transform: uppercase;\">Review History</h2>");
		Review rewr = new Review();
		Review reviews[] = rewr.getAllForStore(myUser.getId());
		if (reviews.length == 0) {
			out.print("<p class='texts'>You do not have any reviews</p>");
		} else {
		out.print("<table>");
		for (int i = 0; i< reviews.length; i++) { 
			Item forItem = new Item();
			forItem.loadById(reviews[i].getItemId());
			%>
			<tr id="tr_<% out.print(reviews[i].getId());%>"><td style="vertical-align: top;">
			<a href="item.jsp?id=<%out.print(forItem.getId());%>">
			<%
					if (forItem.getPicture().equals("") || forItem.getPicture() == null)
						out.print("<img class='item' src='img/item.png' />");
					else
						out.print("<img class='item' src='" + forItem.getPicture() + "' />");
				%></a>
				<br />
			</td><td style="vertical-align: top;">
			<span class="typeType texts"><% out.print(forItem.getType()); %></span>
			<span class="nameName texts"><% out.print(forItem.getName()); if (reviews[i].isDeleted()) out.print("&nbsp;<span class=\"label label-important\">Deleted</span>");%>   </span>
			<span class="typeType texts">Review by <% out.print(reviews[i].customerName); %></span>
			<%
			String avgStarText = "";
			for (int j = 0; j < reviews[i].getStar(); j++)
				avgStarText += "<i class='icon-star'></i>";
			for (int j = 0; j < 5-reviews[i].getStar(); j++)
				avgStarText += "<i class='icon-star icon-white'></i>"; 
			out.print(avgStarText + "<br>");
			out.print("<p class=\"texts bright-round\">" + reviews[i].getText() + "</p><br>");
			out.print("<a class='heads' href='javascript:rResp("+reviews[i].getId()+", "+reviews[i].getCustomerId()+");'>Contact the customer</a>");
			%>
			
			</td></tr>

		<% }
		}
		out.print("</table>");
	} %>
<script>
function rResp(reviewId, customerId) {
	window.location.href = "oneMessage.jsp?toUser="+customerId+"&review="+reviewId;
}

function rDelete(id) {
	$.post('slave.jsp', {action:2, reviewId:id}, function(data) {
		$('#tr_'+id).remove();
		$("#sidebar").height($("#content").height());
	});	
}
</script>
</div>			
<%@ include file="footer.jsp" %>