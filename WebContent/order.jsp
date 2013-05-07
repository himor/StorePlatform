<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Single Order Module
--%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>

<%! String header = "UAlbany Market - Order"; %>
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
%>
<div id="content">
<%
	Order ordr = new Order();
	String ordId = request.getParameter("id");
	String forItem_t = request.getParameter("forItem");
	int forItem = -1;
	if (forItem_t != null) forItem = Integer.parseInt(forItem_t);
	if (ordId == null) {
		response.sendRedirect("history.jsp");
		return;		
	}
	ordr.getOrderById(Integer.parseInt(ordId));
	Status[] statuses = ordr.getStatuses();
	Item[] items = ordr.getItems();
	if (forItem == -1) forItem = items[0].getId();

	Item it = new Item();
	it.loadById(forItem);
	
	// add new review
	
	if (request.getParameter("updateReview") != null) {
		Review newReview = new Review();
		newReview.setSellerId(ordr.getSellerId());
		newReview.setCustomerId(ordr.getCustomerId());
		String star_t = request.getParameter("star");
		int star = 1;
		if (star_t != null) star = (Integer.parseInt(star_t)>0 && Integer.parseInt(star_t)< 6)? Integer.parseInt(star_t) : 1;
		String text = request.getParameter("text");
		if (ordr.getCustomerId() != myUser.getId() || text.equals("")) { // fake review!
			response.sendRedirect("history.jsp");
			return;		
		}
		newReview.setItemId(forItem);
		newReview.setText(text);
		newReview.setStar(star);
		newReview.createReview();
		Notification ntf = new Notification();
		ntf.setStatus(ntf.NEW_REVIEW);
		ntf.setPointer(it.getId());
		ntf.setUserId(ordr.getSellerId());		
		ntf.createNotif();
	} // updateReview
	
	if (request.getParameter("updateStatus") != null) {
		Status newStatus = new Status();
		newStatus.setOrderId(ordr.getId());
		// check last status if 3 or 4 - abort
		if (statuses[0].getType() != statuses[0].SHIPPED && statuses[0].getType() != statuses[0].CANCELLED) {
			newStatus.setType(Integer.parseInt(request.getParameter("type")));
			newStatus.setDescription(request.getParameter("description"));
			newStatus.statusUpdate();
			
			// do the actual SHIPPING (decrement item counter)
			if (newStatus.getType() == newStatus.SHIPPED) {
				Item it_z = new Item();
				for (int i = 0;	i< items.length; i++) {
					it_z.loadById(items[i].getId());
					it_z.lowerCount(items[i].getCount());
					if (it_z.getCount() < 2) {
						Notification itntf = new Notification();
						itntf.setStatus(itntf.ITEM_COUNT); // last item
						itntf.setPointer(it_z.getId());
						itntf.setUserId(ordr.getSellerId());		
						itntf.createNotif(); 
					}
				}
			}
			
			Notification ntf = new Notification();
			if (newStatus.getType() == newStatus.SHIPPED)
				ntf.setStatus(ntf.SHIPPED);
			if (newStatus.getType() == newStatus.CANCELLED)
				ntf.setStatus(ntf.CANCELLED);
			if (newStatus.getType() == newStatus.PROCESSING)
				ntf.setStatus(ntf.PROCESSING);
			ntf.setPointer(ordr.getId());
			ntf.setUserId(ordr.getCustomerId());		
			ntf.createNotif(); 
			response.sendRedirect("order.jsp?id="+ordr.getId()+"&forItem="+forItem);
			return;
		}
	} // updateStatus
	
	
	%>
	<div class="leftItemContainer">
	<h2 class="heads" style="text-transform: uppercase; text-align: left;">Order Content</h2>
	<table class="table table-bordered" style="background-color: #eee;">
	<tr class="heads">
		<th width="20%"></th>
		<th style="text-align:left;width:60%">Item</th>
		<th style="text-align:center;width:30%">Qty</th>
	</tr>
	<%
		for(int i = 0; i < items.length; i++) {
			out.print("<tr"+(forItem == items[i].getId() ? " class='info'":"")+"><td class='heads'>" + (i+1) + "</td>");
			out.print("<td class='texts'><a href='javascript:selectItem(\""+items[i].getId()+"\");'>"+items[i].getName()+"</a></td>");
			out.print("<td class='heads'>"+items[i].getCount()+"</td>");
		}
	%>
	</table>
	
	<p><span class="heads">TOTAL: </span> <span class="texts">$<% out.print(ordr.getTotal()); %></span></p>
	
	<p style="text-align: left;"><span class="heads">Billing address: </span><br><span class="texts"><% out.print(ordr.getAddressB()); %></span></p>
	<p style="text-align: left;"><span class="heads">Shipping address: </span><br><span class="texts"><% out.print(ordr.getAddressD()); %></span></p>
	
	</div>
	<%
	if (myUser.getType() == myUser.CUSTOMER && ordr.getCustomerId() == myUser.getId()) {
%>
	<div class="rightItemContainer">
	<h2 class="heads" style="text-transform: uppercase;">Order status</h2>
	<table class="table table-bordered" style="background-color: #eee;">
	<tr class="heads">
		<th width="30%">Date</th>
		<th style="text-align:left;width:50%">Description</th>
		<th style="text-align:center;width:30%">Status</th>
	</tr>
	<%
		for(int i = 0; i < statuses.length; i++) {
			out.print("<tr><td class='texts'>" + statuses[i].getCreated() + "</td>");
			out.print("<td class='texts'>"+statuses[i].getDescription()+"</td>");
			out.print("<td>");
			if (statuses[i].getType() == statuses[i].PENDING) out.print("<span class=\"label\">Pending");	    
		    if (statuses[i].getType() == statuses[i].PROCESSING) out.print("<span class=\"label label-info\">Processing");
		    if (statuses[i].getType() == statuses[i].SHIPPED) out.print("<span class=\"label label-success\">Shipped");
		    if (statuses[i].getType() == statuses[i].CANCELLED) out.print("<span class=\"label label-important\">Cancelled");
		    out.print("</span></td>");
		}
	%>
	</table>
	<%
	Review revv = new Review();
	Review[] revs = revv.getAllForItem(forItem);
	
	String avgStarText = " ";
	int avgStar = 0;
	for (int i = 0; i < revs.length; i++)
		avgStar += revs[i].getStar();
	avgStar /= revs.length > 0 ? revs.length : 1;
	for (int i = 0; i < avgStar; i++)
		avgStarText += "<i class='icon-star'></i>";
	for (int i = 0; i < 5-avgStar; i++)
		avgStarText += "<i class='icon-star icon-white'></i>";
	%>
	<h2 class="heads"><span style="text-transform: uppercase;"><% out.print(it.getName() + avgStarText); %></span></h2>
	<h3 class="heads"><span style="text-transform: uppercase;">Reviews </span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<a href="javascript:writeReview();"><i style="top:4px;position:relative;" class="icon-plus"></i> add new</a></h3>
	<div class="composeReview">
		<form method="post" class="texts" action="order.jsp?id=<% out.print(ordr.getId());%>&forItem=<% out.print(forItem);%>">
		<textarea type="text" name="text" placeholder="Write a review"></textarea>
		<input type="hidden" name="updateReview" value="1" />
		<input type="hidden" name="star" id="starId" value="1" />
		<br />
		<i id="star1" class="icon-star" style="cursor: pointer;"></i>
		<i id="star2" class="icon-star icon-white" style="cursor: pointer;"></i>
		<i id="star3" class="icon-star icon-white" style="cursor: pointer;"></i>
		<i id="star4" class="icon-star icon-white" style="cursor: pointer;"></i>
		<i id="star5" class="icon-star icon-white" style="cursor: pointer;"></i> 
		<span id="starNumber" class="heads">1 star</span>
		<button type="submit" class="btn btn-primary" style="float:right;">Submit</button><br>
		</form>
	</div>
	<%
		Viewer vie = new Viewer();
		if (revs.length == 0) {
			out.print("<p class='texts' id='writeFirst'>Write the first review for this item!</p>");
		} else
		for(int i = 0; i < revs.length; i++) {
			out.print(vie.getOneOfManyReviews(revs[i]));
		}
	%>
	</div>
<% 
	} else if (myUser.getType() == myUser.SELLER && ordr.getSellerId() == myUser.getId()) { %> <%-- IF SELLER - SHOW SELLER'S HISTORY --%>

<div class="rightItemContainer">
	<h2 class="heads" style="text-transform: uppercase;">Order status</h2>
	<table class="table table-bordered" style="background-color: #eee;">
	<tr class="heads">
		<th width="30%">Date</th>
		<th style="text-align:left;width:50%">Description</th>
		<th style="text-align:center;width:30%">Status</th>
	</tr>
	<%
	for(int i = 0; i < statuses.length; i++) {
		out.print("<tr><td class='texts'>" + statuses[i].getCreated() + "</td>");
		out.print("<td class='texts'>"+statuses[i].getDescription()+"</td>");
		out.print("<td>");
		if (statuses[i].getType() == statuses[i].PENDING) out.print("<span class=\"label\">Pending");	    
	    if (statuses[i].getType() == statuses[i].PROCESSING) out.print("<span class=\"label label-info\">Processing");
	    if (statuses[i].getType() == statuses[i].SHIPPED) out.print("<span class=\"label label-success\">Shipped");
	    if (statuses[i].getType() == statuses[i].CANCELLED) out.print("<span class=\"label label-important\">Cancelled");
	    out.print("</span></td>");
	}
	%>
	</table>	
	<h3 class="heads"><a href="javascript:writeReview();"><i style="top:4px;position:relative;" class="icon-plus"></i> update status</a></h3>
	
	<div class="composeReview">
		<form method="post" class="texts" action="order.jsp?id=<% out.print(ordr.getId());%>&forItem=<% out.print(forItem);%>">
		<input type="text" style="width: 97%;" name="description" placeholder="Write a description" />
		<input type="hidden" name="updateStatus" value="1" />
		<br />
		<span class="heads">Order status:</span>
		<select name="type">
			<option value="1">Pending</option>		
			<option value="2">Processing</option>		
			<option value="3">Shipped</option>		
			<option value="4">Cancelled</option>		
		</select>
		<button type="submit" class="btn btn-primary" style="float:right;">Submit</button>
		</form>
	</div>
	
	
	<%
	Review revv = new Review();
	Review[] revs = revv.getAllForItem(forItem);
	
	String avgStarText = " ";
	int avgStar = 0;
	for (int i = 0; i < revs.length; i++)
		avgStar += revs[i].getStar();
	avgStar /= revs.length > 0 ? revs.length : 1;
	for (int i = 0; i < avgStar; i++)
		avgStarText += "<i class='icon-star'></i>";
	for (int i = 0; i < 5-avgStar; i++)
		avgStarText += "<i class='icon-star icon-white'></i>";
	%>
	<h2 class="heads"><span style="text-transform: uppercase;"><% out.print(it.getName() + avgStarText); %></span></h2>
	<h3 class="heads"><span style="text-transform: uppercase;">Reviews </span></h3>
	<%
		Viewer vie = new Viewer();
		if (revs.length == 0) {
			out.print("<p class='texts' id='writeFirst'>There are no reviews for this item!</p>");
		} else
		for(int i = 0; i < revs.length; i++) {
			out.print(vie.getOneOfManyReviews(revs[i]));
		}
	%>
	
	</div>
<% } %>
<script>

$(document).ready(function(){
	$('#star1').click(function() {
		$('#starId').val(1);
		$('#starNumber').text("1 star");
		$('#star1').removeClass('icon-white');
		$('#star2, #star3, #star4, #star5').addClass('icon-white');
	});
	$('#star2').click(function() {
		$('#starId').val(2);
		$('#starNumber').text("2 stars");
		$('#star1, #star2').removeClass('icon-white');
		$('#star3, #star4, #star5').addClass('icon-white');
	});
	$('#star3').click(function() {
		$('#starId').val(3);
		$('#starNumber').text("3 stars");
		$('#star1, #star2, #star3').removeClass('icon-white');
		$('#star4, #star5').addClass('icon-white');
	});
	$('#star4').click(function() {
		$('#starId').val(4);
		$('#starNumber').text("4 stars");
		$('#star1, #star2, #star3, #star4').removeClass('icon-white');
		$('#star5').addClass('icon-white');
	});
	$('#star5').click(function() {
		$('#starId').val(5);
		$('#starNumber').text("5 stars");
		$('#star1, #star2, #star3, #star4, #star5').removeClass('icon-white');
	});
});

function selectItem(id) {
	var url = "order.jsp?id=<% out.print(ordr.getId());%>&forItem="+id;
	window.location = url;
}

function writeReview() {
	$('.composeReview').fadeIn(200);
	$('#writeFirst').hide();
	$("#sidebar").height($("#content").height());
}

</script>
</div>			
<%@ include file="footer.jsp" %>