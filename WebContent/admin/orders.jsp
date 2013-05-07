<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="sp.*"%>

<%
	Order orders[] = (new Order()).getList();
	if (orders.length > 0) {
		%>
<table width="100%">
<tr>
	<th style="width:3%;">Id</th>
	<th style="width:20%;">Store [id]</th>
	<th style="width:20%;">Buyer [id]</th>
	<th style="width:20%;">Date</th>
	<th style="width:15%;">Status</th>
	<th style="width:15%;">Price</th>
	<th style="width:7%;"># items</th>
</tr>
	<%
	String classes="";
	for (int i = 0; i < orders.length; i++) {
		if (orders[i].getStatuses()[0].getType() == 1) classes = "";
		if (orders[i].getStatuses()[0].getType() == 2) classes = "processing";
		if (orders[i].getStatuses()[0].getType() == 3) classes = "shipped";
		if (orders[i].getStatuses()[0].getType() == 4) classes = "cancelled";
		
		out.print("<tr class=\"" + classes + "\">");
		out.print("<td>" + orders[i].getId() + "</td>");
		out.print("<td>" + orders[i].sellerName + " [" + orders[i].getSellerId() + "]</td>");
		out.print("<td>" + orders[i].buyerName + " [" + orders[i].getCustomerId() + "]</td>");
		out.print("<td>" + orders[i].getCreated() + "</td>");
		out.print("<td>" + orders[i].getStatuses()[0].getTypeName() + "</td>");
		out.print("<td>$" + orders[i].getTotal() + "</td>");
		out.print("<td>" + orders[i].getItems().length + "</td>");	
		out.print("</tr>\n");
	}
%>



</table>
<%
	}	
%>

<script type="text/javascript">


</script>