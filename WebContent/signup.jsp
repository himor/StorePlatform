<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	SignUp Module
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%! String header = "UAlbany Market - SignUp"; %>
<%! boolean showButtons = false; %>
<%@ include file="header.jsp" %>
<div id="content">

<%
	String error = null;
	String type = request.getParameter("type");
	String process = request.getParameter("process");

	if (process != null && process.equals("1")) {
		User u = new User();
		u.setType(type.equals("buy")?u.CUSTOMER:u.SELLER);
		u.setName(request.getParameter("name"));
		u.setFname(request.getParameter("fname"));
		u.setLname(request.getParameter("lname"));
		u.setEmail(request.getParameter("email"));
		u.setUsername(request.getParameter("username"));
		u.setPassword(request.getParameter("password"));
		if (!u.checkUnique()) {
			error = "User with this username or email already exists.";
		} else {
			u.createUser();
			// everythings allright
			// set up the session
			sessId = getSessionPrefix(session.getId());
			session.setAttribute("uid" + sessId, ("" + u.getId()));
			// and redirect
			response.sendRedirect("index.jsp");
			return;
		}
	}

	if (type == null || (!type.equals("sell") && !type.equals("buy"))) {
%>
		<p class="heads" style="font-size:1.3em;margin:30px 0px;text-transform: uppercase;">Please choose the account type:</p>
		<div id="acctOpenChoice" class="heads">
		<a href="?type=buy">I'm going to buy</a>
		<a href="?type=sell">I'm going to open a store</a>
		</div>
		<%
	}

	if (error != null) {
		out.print("<div class=\"error\">");
		out.print(error);
		out.print("</div>");
	}
	
	if (type != null && (type.equals("sell"))){
		%>
		<p style="margin-bottom:30px;margin-left:200px;font-size:1.3em; text-transform: uppercase;" class="heads">Please fill out the form:</p>
		<form class="loginform texts" method="post" action="signup.jsp?type=sell">
		<input type="hidden" name="process" value="1">
		<label>Store Name: </label>
		<input type="text" placeholder="Name of the store" name="name" /><br /><br />
		<label>First Name: </label>
		<input type="text" placeholder="Your first name" name="fname" /><br />
		<label>Last Name: </label>
		<input type="text" placeholder="Your last name" name="lname" /><br />
		<label>Username: </label>
		<input type="text" placeholder="Username" name="username"/><br />
		<label>E-mail: </label>
		<input type="email" placeholder="user@domain.abc" name="email" /><br />
		<label>Password: </label>
		<input type="password" placeholder="Password" name="password" /><br />
		<label></label>
		<button class="btn" type="submit">Create the account</button>
		<%
	}

	if (type != null && (type.equals("buy"))){
		%>
		<p style="margin-bottom:30px;margin-left:200px;font-size:1.3em;text-transform: uppercase;" class="heads">Please fill out the form:</p>
		<form class="loginform texts" method="post" action="signup.jsp?type=buy">
		<input type="hidden" name="process" value="1">
		<label>First Name: </label>
		<input type="text" placeholder="Your first name" name="fname" /><br />
		<label>Last Name: </label>
		<input type="text" placeholder="Your last name" name="lname" /><br />
		<label>Username: </label>
		<input type="text" placeholder="Username" name="username"/><br />
		<label>E-mail: </label>
		<input type="email" placeholder="user@domain.abc" name="email" /><br />
		<label>Password: </label>
		<input type="password" placeholder="Password" name="password" /><br />
		<label></label>
		<button class="btn" type="submit">Create the account</button>
		<%
	}
%>
</form>

</div>			
<%@ include file="footer.jsp" %>