<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Adding new item
--%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="sp.*"%>
<%@ page import="java.util.List"%>

<%! String header = "UAlbany Market - Message"; %>
<%! boolean showButtons = true; %>
<%@ include file="header.jsp"%>
<%! int showCat = 2; %>
<%@ include file="sidebar.jsp"%>

<%
	// check the session;
	String sess_uid = (String)session.getAttribute("uid"+sessId);
	if (null == sess_uid) sess_uid = "0";
	if (sess_uid.equals("0")) {
		response.sendRedirect("index.jsp");
		return;		
	}
	
	if (myUser.getType() != myUser.SELLER) {
		response.sendRedirect("index.jsp");
		return;
	}
	
%>
<div id="content">
	<h2 class="heads" style="text-transform: uppercase;" id="theTitle">New Item</h2>
	
	<% 	String error = request.getParameter("error");
		if (error != null && error.equals("jpeg")) error = "Only JPEG pictures are allowed!";
		if (error != null && error.equals("exception")) error = "Unknown error detected! Please check your input.";
		if (error != null) {
			out.print("<div class=\"error texts\">");
			out.print(error);
			out.print("</div>");
		}
	%>
	
	<form method="post" action="fileUpload.jsp" enctype="multipart/form-data" class="addItem">
		<input type="hidden" name="update" value="1" />
		
		<div class="form-inline texts">
			<label>Name:</label> <input type="text" name="name" required="required" />
		</div>

		<div class="form-inline texts">
			<label>Price:</label> <input type="text" class="input-medium" name="price" required="required" placeholder="e.g. 21.95" />
			<label style="margin-left:20px;">Quantity:</label> <input type="text" class="input-small" name="qty" required="required" placeholder="e.g. 10" />
		</div>

		<div class="form-inline texts">
			<label>Category:</label> <input type="text" class="input-medium" name="type" required="required" placeholder="e.g. shoes"
				value="" />
		</div>

		<label class="texts">Description:</label>
		<textarea style="width:400px;height:150px;" name="description"></textarea><br />

		<label class="texts">Picture:</label>
		<input type="file" name="picture" /><br/>

		<label></label>
		<button type="submit" class="btn btn-primary">Submit</button>

	</form>
</div>

<%@ include file="footer.jsp"%>