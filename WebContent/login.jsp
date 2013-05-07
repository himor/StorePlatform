<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	LogIn Module
--%>

<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%! String header = "UAlbany Market - Login"; %>
<%! boolean showButtons = false; %>
<%@ include file="header.jsp" %>
<div id="content">
<%

String redirect = request.getParameter("redirect");
String redirectId = request.getParameter("redid");

String username = request.getParameter("username");
String password = request.getParameter("password");
String error = request.getParameter("error");
if (error != null && error.equals("errSeller")) error = "Sellers cannot purchase items!";
if (username != null && password != null && username.length() > 0 && password.length() > 0) {
	User u = new User();
	u.loadByUsername(username);
	if (!u.loaded())
		u.loadByEmail(username); // maybe user decided to use email
	if (!u.loaded()) {
		error = "Username or password is incorrect!";
	} else {
		if (u.checkPassword(password)) {
			// everythings allright
			// set up the session
			sessId = getSessionPrefix(session.getId());
			session.setAttribute("uid" + sessId,(""+u.getId()));
			// and redirect
			if (redirect == null)
		    	response.sendRedirect("index.jsp");
			else if (redirect.equals("buy"))
					response.sendRedirect("buy.jsp?id=" + redirectId);
			return;
		} else {
			error = "Username or password is incorrect!";
		}
	}
}
%>

<form class="loginform texts" method="post" action="login.jsp<%
	if (redirect != null)
		out.print("?redirect="+redirect+"&redid="+redirectId);
%>">
<p style="margin-bottom:30px;font-size:1.3em;text-transform: uppercase;" class="heads">Please enter your username/email and password:</p>

<%
	if (error != null) {
		out.print("<div class=\"error texts\">");
		out.print(error);
		out.print("</div>");
	}
%>


<label>Username: </label>
<input type="text" placeholder="Username" name="username"/><br />
<label >Password: </label>
<input type="password" placeholder="Password" name="password" /><br />
<label></label>
<button class="btn" type="submit">Login</button>
</form>



</div>			
<%@ include file="footer.jsp" %>