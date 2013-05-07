<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="sp.*"%>

<%
	User users[] = (new User()).getList();
	if (users.length > 0) {
		%>
<table width="100%">
<tr>
	<th style="width:3%;">Id</th>
	<th style="width:7%;">Type</th>
	<th style="width:10%;">Username</th>
	<th style="width:15%;">Name</th>
	<th style="width:15%;">Store</th>
	<th style="width:15%;">Email</th>
	<th style="width:15%;">Registered</th>
	<th style="width:7%;">Deleted</th>
	<th style="width:13%;"></th>
</tr>
	<%
	String classes="";
	for (int i = 0; i < users.length; i++) {
		if (users[i].isDeleted()) classes = "deleted";
		else classes = "";
		if (users[i].getType() == users[i].CUSTOMER) classes += " customer";
		else classes += " seller";
		
		out.print("<tr class=\"" + classes + "\">");
		out.print("<td>" + users[i].getId() + "</td>");
		out.print("<td><small>" + (users[i].getType() == users[i].CUSTOMER ? "BUYER" : "SELLER") + "</small></td>");
		out.print("<td>" + users[i].getUsername() + "</td>");
		out.print("<td>" + users[i].getFname() + " " + users[i].getLname() + "</td>");
		out.print("<td>" + users[i].getName() + "</td>");
		out.print("<td>" + users[i].getEmail() + "</td>");
		out.print("<td>" + users[i].getRegistered() + "</td>");
		out.print("<td><small>" + (users[i].isDeleted() ? "DELETED" : "") + "</small></td>");
		
		if (users[i].isDeleted())
			out.print("<td><a href='javascript:undeleteUser("+users[i].getId()+");'> Un-Delete </a>");
		else out.print("<td><a href='javascript:deleteUser("+users[i].getId()+");'> Delete </a>");
		out.print(" &nbsp;&nbsp;&nbsp;&middot;&nbsp;&nbsp;&nbsp;<a href='javascript:messageUser("+users[i].getId()+");'> Message </a></td>");
		
		out.print("</tr>\n");
	}
%>



</table>
<%
	}	
%>

<script type="text/javascript">


function deleteUser(id) {
	$.post('slave.jsp', {admin:"z", action:"adminDeleteUser", userId:id}, function(data) {
		window.location.reload();
	});	
}

function undeleteUser(id) {
	$.post('slave.jsp', {admin:"z", action:"adminUnDeleteUser", userId:id}, function(data) {
		window.location.reload();
	});	
}

</script>