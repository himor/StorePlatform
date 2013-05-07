<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Items History Module
--%>
<%@page import="org.apache.jasper.tagplugins.jstl.core.ForEach"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>

<%! String header = "UAlbany Market - Items"; %>
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
	if (myUser.getType() != myUser.SELLER) {
		response.sendRedirect("index.jsp");
		return;
	}
	
	Item items[] = (new Item()).getAllForUser(myUser.getId());
%>

<div id="content">
	<h2 class="heads" style="text-transform: uppercase;">Store content</h2>
	
	<%
		if (items.length == 0) {
			out.print("<p class='texts'>There are no items in your store. <a href='addItem.jsp'>Add one</a>.</p>");	
		} else {
			%>
			
			<div class="form-search" style="float:right;background-color:#99b2b7;border-radius:5px;padding:10px;">
			  <input type="text" id="iSearcher" class="input-medium search-query" placeholder="Search items...">
			  <button type="button" id="bSearcher" class="btn">Search</button>
			</div>
			
			
			<%
			out.print("<p class='texts'><a href='addItem.jsp'>Add new item...</a>.</p>");
			out.print("<div>");
			for (int i = 0; i < items.length; i++) {
				
	%>
	<div class="itemsImage">
	<a href="item.jsp?id=<% out.print(items[i].getId()); %>">
				<%
					if (items[i].getPicture().equals("") || items[i].getPicture() == null)
						out.print("<img class='item' src='img/item.png' />");
					else
						out.print("<img class='item' src='" + items[i].getPicture() + "' />");
				%>
	</a>
	</div>
	<div class="itemsInfo">
		<span class="itemsName heads searchable" style="font-size:1.2em;text-transform: uppercase;"><% out.print(items[i].getName()); 
		if (items[i].isDeleted()) out.print (" &middot; <span class=\"badge badge-important\">DELETED</span>");
		%></span><br/>
		
		<span class="itemsName heads">Price:</span>
		<span class="itemsStuff texts">$<% out.print(items[i].getPrice()); %></span><br />
		
		<span class="itemsName heads">Category:</span>
		<span class="itemsStuff texts"><% out.print(items[i].getType()); %></span><br />
		
		<span class="itemsName heads">In stock:</span>
		<span class="itemsStuff texts" id="countHolder_<% out.print(items[i].getId());%>"><%
		if (items[i].getCount() > 5) out.print ("<span class=\"badge badge-success\">"+items[i].getCount()+"</span>");
		if (items[i].getCount() > 1 && items[i].getCount() <= 5) out.print ("<span class=\"badge badge-warning\">"+items[i].getCount()+"</span>");
		if (items[i].getCount() == 1) out.print ("<span class=\"badge badge-important\">"+items[i].getCount()+"</span>");
		if (items[i].getCount() == 0) out.print ("<span class=\"badge\">"+items[i].getCount()+"</span>");
		 %></span><br />
		
		<span class="itemsName heads">In stock since:</span>
		<span class="itemsStuff texts"><% out.print(items[i].getCreated()); %></span><br />
	
		<span class="itemsName heads">Description:</span>
		<span class="itemsStuff texts searchable"><% out.print(items[i].getDescription()); %></span><br />
	
		<span class="texts">
			<br />
			<%-- operations --%>
			<% if (items[i].isDeleted()) {%>
			<a href="javascript:undelete(<% out.print(items[i].getId());%>);">Undelete</a>
			<% } else { %>
			<a href="javascript:deletei(<% out.print(items[i].getId());%>);">Delete</a> &middot;
			<a href="javascript:upcount(<% out.print(items[i].getId());%>);">Update count</a> &middot;
			<a href="javascript:upinfo(<% out.print(items[i].getId());%>);">Update intormation</a>
			<% } %>
		</span>
		
		<div class="composeReview" style="width:300px;margin:20px;" id="editItemCount_<% out.print(items[i].getId());%>">
			<div class="form-inline"><select class="operation input-small">
				<option value="1">Add</option>		
				<option value="2">Subtract</option>	
			</select>
			<input type="number" class="number input-small" />	
			<button type="button" onclick="javascript:countUpdate(<% out.print(items[i].getId());%>);" class="btn btn-primary">Submit</button>
			</div>
		</div>
	
		<div class="composeReview" style="width:400px;margin:20px;" id="editItemInfo_<% out.print(items[i].getId());%>">
			<form method="post" action="slave.jsp">
				<input type="hidden" name="action" value="updateItemInfo" />
				<input type="hidden" name="itemId" value="<% out.print(items[i].getId());%>" />
				
				<div class="form-inline texts">
				<label>Name:</label>
				<input type="text" name="name" value="<% out.print(items[i].getName()); %>" /></div>
				
				<div class="form-inline texts">
				<label>Price:</label>
				<input type="text" name="price" value="<% out.print(items[i].getPrice()); %>" /></div>
				
				<div class="form-inline texts">
				<label>Category:</label>
				<input type="text" name="type" value="<% out.print(items[i].getType()); %>" /></div>
				
				<label class="texts">Description:</label>
				<textarea style="" name="description" ><% out.print(items[i].getDescription()); %></textarea>
			
				<button type="submit" class="btn btn-primary">Submit</button>
			</form>
		</div>
		<br />
		<br />
		
	</div>
	
	<% } %>
	
	</div>
	
	
	<%	} %>
</div>

<script>
function deletei(id) {
	$.post('slave.jsp', {action:"deleteItem", itemId:id}, function(data) {
		window.location.reload();
	});	
}

function undelete(id) {
	$.post('slave.jsp', {action:"undeleteItem", itemId:id}, function(data) {
		window.location.reload();
	});	
}

function countUpdate(id) {
	var op = $('#editItemCount_'+id+' .operation').val();
	var value = $('#editItemCount_'+id+' .number').val();
	$.post('slave.jsp', {action:"updateCounter", itemId:id, op:op, value:value}, function(data) {
		$('#editItemCount_'+id).hide();
		$("#sidebar").height($("#content").height());
		$('#countHolder_'+id+' .badge').text(data.trim());
	});
}

function upcount(id) {
	$('.composeReview').hide();
	$('#editItemCount_'+id).fadeIn(200);
	$("#sidebar").height($("#content").height());
}

function upinfo(id) {
	$('.composeReview').hide();
	$('#editItemInfo_'+id).fadeIn(200);
	$("#sidebar").height($("#content").height());
}

// context search
(function(){
	$('#bSearcher').on('click', function(){
		var text = $('#iSearcher').val().toUpperCase(),
			done = false;
		if (text.length > 0) {
			$('.searchable').each(function(){
				var $this = $(this);
				if ($this.text().toUpperCase().indexOf(text) > -1){
					// scroll there
					if (done) return;
					$('html, body').animate({
				         scrollTop: $this.offset().top
				     }, 500);
					done = true;
				}
			});
		};
	});
})();

</script>


<%@ include file="footer.jsp" %>