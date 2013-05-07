<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Header Module
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%@ include file="session.jsp" %>
<%!		
	String sess_uid = "0";
%>
<%
	out.print("<!-- Session ID: "+sessId+"-->");
	sessId = getSessionPrefix(session.getId());
	sess_uid = (String)session.getAttribute("uid"+sessId);
	if (null == sess_uid) sess_uid = "0";
	%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<link rel="stylesheet" type="text/css" href="css/bootstrap.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/frame.css" media="all">
	<link rel="stylesheet" type="text/css" href="css/sp.css" media="all">
	
	<script type="text/javascript" src="//use.typekit.net/wnw1kmq.js"></script>
	<script type="text/javascript">try{Typekit.load();}catch(e){}</script>
	
	<script type="text/javascript" src="js/bootstrap.js"></script>
	<script type="text/javascript" src="js/jquery.min.js"></script>
	<title><%
		out.println(header);
		%></title>
	<script>
	function signup() {
		window.location = "signup.jsp";
	}
	function login() {
		window.location = "login.jsp";
	}
	</script>
</head>
<body>

	<%
		// shopping cart implementation
		Cart myCart = (Cart) session.getAttribute("cart" + sessId);
		if (null == myCart)
			myCart = new Cart();
	%>

	<div id="container">
	<!-- header -->
		<div id="header1">
			<div id="top-content" class="texts">
				<div id="logo-holder"><a href="index.jsp"><img src="img/mainLogo.png" /></a></div>
				<div id="info-holder">
					<a href="signup.jsp?type=sell" id="sell-link"></a>
					<div style="margin-top:30px;">
						<% /* the content depends on session variable */ 
						User myUser = new User();
						if (!sess_uid.equals("0")) {
							//load user
							myUser.loadById(Integer.parseInt(sess_uid));
							if (!myUser.loaded()) {
								response.sendRedirect("logout.jsp");
								return;
							} else {
							%>
							<div id="uInfoHolder">
								<p>Welcome <% out.print(myUser.getFname() + " " + myUser.getLname()); %>!<br>
								<a href="notif.jsp"><span id="notif"></span></a></p>
							</div>
							<div id="theBar">
							<% if (myCart.getSize() > 0)
								out.print("<a href=\"buy.jsp\"><i class='icon-shopping-cart'></i> <strong>Cart</strong></a> | ");%>
							<a href="index.jsp">Home</a> | <a href="account.jsp">My Account</a> | <a href="logout.jsp">Logout</a></div>
							<%	
							}							
						} else if (showButtons) {						
						%>
						
						<a href="javascript:signup();" id="signup-link"></a>
						<a href="javascript:login();" id="login-link"></a>
						<% } %>						
					</div>
				</div>
				<% String value_t = request.getParameter("value"); %>
				<div id="search-holder"><input type="text" name="value" id="search-text" placeholder="Search something..." value="<% out.print(value_t == null ? "" : value_t);%>"/>
				<%
				String searchCat = (String)session.getAttribute("searchCat"+sessId);
				%>
				<input name="stype" type="radio" value="name" <% if (searchCat == null || searchCat.equals("name")) out.print("checked='checked'"); %>/> By description
				<input name="stype" type="radio" value="type" <% if (searchCat != null && searchCat.equals("type")) out.print("checked='checked'"); %>/> By category
				<input name="stype" type="radio" value="seller" <% if (searchCat != null && searchCat.equals("seller")) out.print("checked='checked'"); %>/> By store name 
				</div>
			</div>
		</div>
		<div id="header-line"></div>
	<!-- main -->
	<div id="mid-content-holder">
		<div id="mid-content">
		