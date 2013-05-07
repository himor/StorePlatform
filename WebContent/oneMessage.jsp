<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	One Message
--%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%@ page import="java.util.List" %>

<%! String header = "UAlbany Market - Message"; %>
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
	boolean isNew = false;
	int preselected = 0;
	String preselectedName = "";
%>
<div id="content">
<%
	if (request.getParameter("toUser")!= null) {
		preselected = Integer.parseInt(request.getParameter("toUser"));
		User tempuser = new User();
		tempuser.loadById(preselected);
		preselectedName = tempuser.getFname()+" "+tempuser.getLname();
	}

	if (request.getParameter("create")!= null) {
		if (preselected != 0)
			mess.setTo(preselected);
		else
			mess.setTo(Integer.parseInt(request.getParameter("to")));
		mess.setFrom(myUser.getId());
		mess.setSubject(request.getParameter("subject"));
		mess.setText(request.getParameter("text"));
		mess.createMessage();
		Notification ntf = new Notification();
		ntf.setStatus(ntf.NEW_MAIL);
		ntf.setPointer(mess.getId()); //message id
		ntf.setUserId(mess.getTo());		
		ntf.createNotif();
		response.sendRedirect("messages.jsp");
		return;		
	}

	String predefinedText = "";
	
	if (request.getParameter("review")!= null) {
		Review rev = new Review();
		rev.getReviewById(Integer.parseInt(request.getParameter("review")));
		predefinedText = "Response regarding your review:\n\"" + rev.getText() + "\"\n\n";
	}
	
	String fromName = "";
	String toName = "";
	
	if (request.getParameter("id")!= null) {
		out.print("<h2 class=\"heads\" style=\"text-transform: uppercase;\">Message</h2>");
		mess.loadById(Integer.parseInt(request.getParameter("id")));
		if (mess.getTo() == myUser.getId())
			mess.markRead();
		User tempuu = new User();
		tempuu.loadById(mess.getFrom());
		fromName = tempuu.getFname() + " " + tempuu.getLname();
		tempuu.loadById(mess.getTo());
		toName = tempuu.getFname() + " " + tempuu.getLname();
	} else {
		out.print("<h2 class=\"heads\" style=\"text-transform: uppercase;\">New message</h2>");
		isNew = true; 
	}
	List<User> myRecepients = (new Order()).getRecepientsForUser(myUser.getId());;
	
	if (isNew) { // create the form
		%>
		<form class="loginform texts" method="post" action="oneMessage.jsp">
			<input type="hidden" name="create" value="1" />
			<input type="hidden" name="toUser" value="<%out.print(preselected);%>" />
			<label for="select">Recepient:</label>
			
			<% if (preselected > 0) 
				out.print("<input type=\"text\" readonly=\"readonly\" value=\""+preselectedName+"\" />");
			else {%>				
				<select id="select" name="to">
				<% 
					for (User usr : myRecepients) {
						out.print("<option value='"+usr.getId()+"'>"+usr.getFname()+" "+usr.getLname()+"</option>");
					}
				%>			
				</select>
			<% } %> <%-- select --%>
			<br />
			<label>Subject:</label><input type="text" name="subject" /><br />
			<label for="textarea">Message:</label><textarea id="textarea" style="width:450px;height:200px;" name="text"><% out.print(predefinedText);%>
			</textarea><br />
			<label></label>
			<button class="btn" type="submit">Submit</button>
		</form>
	<%	
	} else {
		if (mess.getFrom() != myUser.getId()) {
	%>
	<form method="post" action="oneMessage.jsp">
		<input type="hidden" name="toUser" value="<%out.print(mess.getFrom());%>">
		<button class="btn" type="submit">Reply</button>
	</form>
	<% } %>
	
	<div>
		<p><span class="heads fixed100">From: </span>
		<span class="texts"><% out.print(fromName);%></span>
		</p>
		
		<p><span class="heads fixed100">To: </span>
		<span class="texts"><% out.print(toName);%></span>
		</p>
		
		<br />
		
		<p><span class="heads fixed100">Subject: </span>
		<span class="texts"><% out.print(mess.getSubject());%></span>
		</p>
		
		<p><span class="heads fixed100"></span>
		<span class="texts"><% out.print(mess.getText());%></span>
		</p>
		
	</div>

<% } %>
	
</div>
<%@ include file="footer.jsp" %>