<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Account Module
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>

<%! String header = "UAlbany Market - My account"; %>
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
	User myAcctUser = new User();
	myAcctUser.loadById(Integer.parseInt(sess_uid));
	
	String fname = request.getParameter("fname");
	if (fname != null) {
		// update is in progress
		myAcctUser.setFname(fname);
		myAcctUser.setLname(request.getParameter("lname"));
		if (request.getParameter("name")!=null)
			myAcctUser.setName(request.getParameter("name"));
		myAcctUser.setUsername(request.getParameter("username"));
		myAcctUser.setEmail(request.getParameter("email"));
		if (request.getParameter("password")!=null && request.getParameter("password").length() > 0)
			myAcctUser.setPassword(request.getParameter("password"));
		myAcctUser.updateUser();
		response.sendRedirect("account.jsp");
	}	
%>

<div id="content">

<form class="uaform texts" action="account.jsp" method="post">
	<label>Registered on: </label><strong><% out.print(myAcctUser.getRegistered()); %></strong><br>
	<label>Account type: </label><strong><% out.print(myAcctUser.getType() == myAcctUser.CUSTOMER ? "Customer" : "Seller"); %></strong><br><br>
	<label>First name: </label>
	<input type="text" name="fname" required="required" value="<%= myAcctUser.getFname() %>" /> <br />
	<label>Last name: </label>
	<input type="text" name="lname" required="required" value="<%= myAcctUser.getLname() %>" /> <br />

	<% if (myAcctUser.getType() == myAcctUser.SELLER) { %>
	<label>Store Name: </label>
	<input type="text" name="name" required="required" value="<%= myAcctUser.getName() %>" /> <br />
	<% } %>

	<label>Username: </label>
	<input type="text" name="username" required="required" value="<%= myAcctUser.getUsername() %>" /> <br />
	<label>Email: </label>
	<input type="email" name="email" required="required" value="<%= myAcctUser.getEmail() %>" /> <br />

	<label>Password: </label>
	<input type="password" id="pasw1" name="password" /><br />
	<label>Re-type Password: </label>
	<input type="password" id="pasw2" /> <span class="label label-important" id="error">Passwords don't match!</span>
	<br><br>
	<label></label>
	<button type="button" onclick="javascript:submitForm();" class="btn">Update</button>

</form>
<script>
	var allowPost = true;
	$(document).ready(function(){
		$("#error").hide();
		$("#pasw1").keyup(function(){
			allowPost = false;
			if ($("#pasw2").val().length > 0 && $("#pasw2").val()!=$("#pasw1").val()) {
				$("#error").fadeIn(200);
			} else {$("#error").hide();}
		});	
		$("#pasw2").keyup(function(){
			allowPost = false;
			if ($("#pasw2").val()!=$("#pasw1").val()) {
				$("#error").fadeIn(200);
				allowPost = false;
			} else {$("#error").hide();allowPost = true;}
		});	
	});
	function submitForm() {
		if (!allowPost) return false;
		else $("form").submit();
	}
</script>
</div>			
<%@ include file="footer.jsp" %>