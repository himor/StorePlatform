<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Single Item
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%
	Item it = new Item();
	String itemId = request.getParameter("id");
	if (itemId == null) {
		response.sendRedirect("index.jsp");
		return;
	}
	int id = Integer.parseInt(itemId);
	it.loadById(id);
%>

<% String header = "UAlbany Market - " + it.getName(); %>
<%!boolean showButtons = true;%>
<%@ include file="header.jsp"%>
<%!int showCat = 1;%>
<%@ include file="sidebar.jsp"%>
<div id="content">
	<%
		Viewer vie = new Viewer();
		User seller = new User();
		seller.loadById(it.getSellerId());
		Review revForItem = new Review();
		Review[] revs = revForItem.getAllForItem(it.getId());
	%>
	<div style="min-height:380px;">
		<div class="leftItemContainer">
			<%
				if (it.getPicture().equals("") || it.getPicture() == null)
					out.print("<img src='img/item.png' />");
				else
					out.print("<img src='" + it.getPicture() + "' />");
			%>
			<br />
			<span class="price heads">$<% out.print(it.getPrice()); %></span>
			<br /><br />
			<button type="button" id="buynow" class="btn btn-primary"><i class="icon-shopping-cart icon-white"></i> Buy now</button>
		</div>
		
		<div class="rightItemContainer">
		<span class="type texts"><% out.print(it.getType()); %></span>
		<span class="name texts"><% out.print(it.getName()); %></span>
		<span class="type texts">by <% out.print(seller.getName()); %></span>
		<p class="texts bright"><% out.print(it.getDescription()); %></p>
		
		<%-- reviews --%>
		<% if (revs.length > 0) {
			int avgStar = 0;
			int length = 0;
			for (int i = 0; i < revs.length; i++)
				if (!revs[i].isDeleted()) {
					avgStar += revs[i].getStar();
					length ++;
				}
			avgStar /= length;
			String avgStarText = "";
			for (int i = 0; i < avgStar; i++)
				avgStarText += "<i class='icon-star'></i>";
			for (int i = 0; i < 5-avgStar; i++)
				avgStarText += "<i class='icon-star icon-white'></i>";
			out.print("<h3 class=\"heads\">Customer Reviews "+avgStarText+"</h2>");
			int maxReviews = revs.length > 3 ? 3 : revs.length;
			if (request.getParameter("maxReviews") != null) maxReviews = revs.length;
			for (int i = 0; i < maxReviews; i++) {
				if (!revs[i].isDeleted())
					out.print(vie.getOneOfManyReviews(revs[i]));
			}
			if (maxReviews < revs.length )
				out.print("<a class=\"texts\" href='item.jsp?id="+it.getId()+"&maxReviews'><i class='icon-comment'></i> Display all " + length + " reviews</a>");
		}
		%>
		
		</div>
	</div>
	
	<div class="bottomItemContainer">
		<h2 class="heads" style="text-transform: uppercase;"><i class="icon-bookmark"></i> You may also be interested</h2>
		<%
		Item[] j = it.getRandom(0);
		Viewer vi = new Viewer();
		if (j != null) {
			int mxx = j.length > 4 ? 4 : j.length;
			for (int i = 0; i < mxx; i++) {
				out.print(vi.getOneOfManyItems(j[i]));
			}
		}
		%>
	</div>

</div>

<script>
$(document).ready(function(){
	$("#buynow").click(function(){
		window.location = "buy.jsp?id=<%out.print(it.getId());%>";
	});
});
</script>


<%@ include file="footer.jsp" %>