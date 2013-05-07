<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%

	String update = request.getParameter("login");
	if (update != null && !update.equals("logout")) {
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		if (username.equals("admin") && password.equals("admin"))
			session.setAttribute("adminUid", "admin");
		response.sendRedirect("../admin.jsp");
		return;
	}
	if (update != null && update.equals("logout")) {
		session.invalidate();
		response.sendRedirect("../admin.jsp");
		return;
	}

%>



<style type="text/css">
label {
	display:inline-block;
	margin:5px;
	min-width:100px;	
}
</style>

<div style="padding: 20px 40px;">
	<h3>Please log in:</h3>
	<form method="post" action="admin/login.jsp">
		<input type="hidden" name="login" value="1">
		<label>Username: </label>
		<input type="text" name="username" /><br />
		<label>Password: </label>
		<input type="password" name="password" />
		<br /><label></label>
		<button type="submit" class="btn">Login</button>
	</form>
</div>
<script type="text/javascript">


</script>