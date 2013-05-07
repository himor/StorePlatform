<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" type="text/css" href="css/admin.css" media="all">
	<script type="text/javascript" src="js/jquery.min.js"></script>
<title>UAlbanyMarket Admin</title>
</head>
<body>
<% 
	String pg = request.getParameter("page");
	if (null == pg) pg = "users";
	
	String admin_uid = (String)session.getAttribute("adminUid");
	
	%>
	<div id="wrap">
		<div id="holder">
			<div id="content">
				<% if (admin_uid == null) {%>
					<%@ include file="admin/login.jsp" %>
				<% } else { %>
					<% if (pg.equals("users")) { %>
						<%@ include file="admin/users.jsp" %>
					<% } %>
					<% if (pg.equals("items")) { %>
						<%@ include file="admin/items.jsp" %>
					<% } %>
					<% if (pg.equals("mesages")) { %>
						<%@ include file="admin/messages.jsp" %>
					<% } %>
					<% if (pg.equals("orders")) { %>
						<%@ include file="admin/orders.jsp" %>
					<% }
					}%>					
			</div>			
			<div id="menu" class="heads">
				<ul>
					<li><a href="?page=users">USERS</a></li>
					<!-- <li><a href="?page=items">ITEMS</a></li>
					<li><a href="?page=messages">MESSAGES</a></li>  -->
					<li><a href="?page=orders">ORDERS</a></li>
					<li><a href="admin/login.jsp?login=logout">LOGOUT</a></li>  
					<!-- <li style="padding-left:10px; padding-right: 10px;"><input type="text" placeholder="Search..." name="search" id="search" style="margin:0px;padding:0px;width:200px;" /></li>-->
				</ul>
			</div>
		</div>
	</div>
<script>
	$(window).load(function(){
		$('#content').height($(window).height() - $('#menu').height() - 40);
	});
	
	$(document).ready(function(){
		$("#search").bind("keypress", function(e) {
	        if (e.keyCode == 13) {
				// do search here
	            return false;
	        }
	    });
		
	});
	
</script>
</body>
</html>