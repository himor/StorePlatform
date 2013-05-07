<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Messages
--%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>

<%! String header = "UAlbany Market - Messages"; %>
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
	Message mess = new Message();
%>
<div id="content">

<h2 class="heads" style="text-transform: uppercase;">Messages <% int n = mess.getNumberOfNewMessages(myUser.getId()); 
if (n>0) out.print ("<small>("+n+" new)</small>"); %></h2>
<a href="oneMessage.jsp"><button class="btn" type="button">Compose</button></a><br /><br />
<%
Message msg[] = mess.getAllForUser(myUser.getId());
if (msg.length == 0) {
	out.print("<p class='texts'>You do not have any messages</p>");
} else {
%>
	<table class="table table-bordered texts" style="background-color: #eee;">
<% 
	for (int i = 0; i< msg.length; i++) {
		boolean read = msg[i].isRead();
		if (msg[i].getFrom() == myUser.getId() && !msg[i].isShowToSen()) continue; 
		if (msg[i].getTo() == myUser.getId() && !msg[i].isShowToRec()) continue;
	%>
		<tr id="tr_<%out.print(msg[i].getId());%>">
			<td style="width:5%;"><% if (msg[i].getFrom() == myUser.getId()) 
				out.print("<i class=\"icon-arrow-right\"></i>"); 
			else out.print("<i class=\"icon-arrow-left\"></i>");
			%></td>
			<td><% if (!read) out.print("<strong>");
			out.print("<a href=\"oneMessage.jsp?id="+msg[i].getId()+"\">");
			if (msg[i].getFrom() == myUser.getId()) 
				out.print("Me to "+msg[i].toName); 
			else out.print(msg[i].fromName+" to Me");
			out.print("</a>");
			if (!read) out.print("</strong>");
			%></td>
			<td><% if (!read) out.print("<strong>");
			out.print("<a href=\"oneMessage.jsp?id="+msg[i].getId()+"\">");
			out.print(msg[i].getSubject());
			out.print("</a>");
			if (!read) out.print("</strong>");
			%></td>
			<td style="width:20%;"><% if (!read) out.print("<strong>");
			out.print(msg[i].getCreated());
			if (!read) out.print("</strong>");
			%></td>
			<td style="width:5%;"><a href="javascript:deleteMessage(<%out.print(msg[i].getId());%>);"><i class="icon-remove"></i></a></td>
		</tr>
	<%
	}
	out.print("</table>");
}
%>
	
</div>

<script>
function deleteMessage(id) {
	$.post('slave.jsp', {action:3, messageId:id}, function(data) {
		$('#tr_'+id).remove();
		$("#sidebar").height($("#content").height());
	});	
}
</script>

<%@ include file="footer.jsp" %>