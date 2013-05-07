<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Place the order
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%@ page import="java.text.NumberFormat" %>
<%

	Item it = new Item();
	String itemId = request.getParameter("id");
	int id  = 0;
	if (itemId != null) {
		id = Integer.parseInt(itemId);
		it.loadById(id);
	}
	
%>

<% String header = "UAlbany Market - " + it.getName(); %>
<%!boolean showButtons = true;%>
<%@ include file="header.jsp"%>
	<%
	if (sess_uid.equals("0")) { // send user to the login page
		response.sendRedirect("login.jsp?redirect=buy&redid="+id);
		return;
	} else { 
		if (myUser.getType() == myUser.SELLER) { // send user to the login page
			response.sendRedirect("login.jsp?redirect=buy&redid="+id+"&error=errSeller");
			return;
		}
	}
	
	String qty = request.getParameter("qty");
	if (qty == null) qty = "1";
	
	if (id>0) {
		it.setCount(Integer.parseInt(qty));
		myCart.updateItem(it);
		session.setAttribute("cart" + sessId, myCart);
		}

	if (myCart.getSize() == 0) {
		response.sendRedirect("index.jsp");
		return;
	}
	
	int[] sellers = myCart.getSellers();
	Item[] its = myCart.getItems(); 
	
	if (request.getParameter("place") != null) {
		// creating the actual orders - by the number of sellers
		for (int i = 0; i < sellers.length; i++) {
			Order order = new Order();
			order.setSellerId(sellers[i]);
			order.setCustomerId(myUser.getId());
			String addr = request.getParameter("b-fname");
			addr += " " + request.getParameter("b-lname") + "\n";
			addr += request.getParameter("b-street") + "\n";
			addr += request.getParameter("b-city") + " " + request.getParameter("b-zip");
			order.setAddressB(addr);
			addr = request.getParameter("s-fname");
			addr += " " + request.getParameter("s-lname") + "\n";
			addr += request.getParameter("s-street") + "\n";
			addr += request.getParameter("s-city") + " " + request.getParameter("s-zip");
			order.setAddressD(addr);
			Item[] thisItems = myCart.getItems(sellers[i]);
			//out.print(thisItems[1].getCount());
			//if (true) return;
			float total = 0;
			for (int j = 0; j < thisItems.length; j++) {
				total += thisItems[j].getCount() * thisItems[j].getPrice();
			}
			order.setTotal(total);
			order.createOrder();
			for (int j = 0; j < thisItems.length; j++) {
				order.addItemToOrder(thisItems[j].getId(), thisItems[j].getCount());
			}
			
			Notification ntf = new Notification();
			ntf.setStatus(ntf.NEW_ORDER);
			ntf.setPointer(order.getId());
			ntf.setUserId(sellers[i]);		
			ntf.createNotif();
		}
		
		session.setAttribute("cart" + sessId, new Cart()); // destroy the cart
		
		response.sendRedirect("history.jsp?placed");
		return;		
	}
%>

<%!int showCat = 2;%>
<%@ include file="sidebar.jsp"%>
<div id="content">
		<div class="rightItemContainer lonely">
		<h2 class="heads" style="text-transform: uppercase;">New order</h2>
		<table class="table table-bordered" style="background-color: #eee;">
		
		<%
		double grandTotal = 0;
		for(int i = 0; i<its.length; i++) { %>
		
			<tr>
		    <td class="texts" style="text-align:center; vertical-align: middle;"><%
					if (its[i].getPicture().equals("") || its[i].getPicture() == null)
						out.print("<img height='80px' src='img/item.png' />");
					else
						out.print("<img height='80px' src='" + its[i].getPicture() + "' />");
				%></td>
		    <td class="texts" style="vertical-align: middle; ">
			<% out.print(its[i].getName()); %><br>
			Sold by: <% out.print(its[i].getSeller().getName()); %><br>
			<small><% out.print(its[i].getDescription()); %></small>
			</td>
		    <td class="heads" style="vertical-align: middle; ">$<% out.print(its[i].getPrice()); %></td>
		    <td class="texts" style="vertical-align: middle; padding-top:30px; ">
			    <form class="form-inline" method="post" action="buy.jsp?id=<% out.print(its[i].getId()); %>">Qty:
			    <input type="number" name="qty" class="input-small" value="<% out.print(its[i].getCount()); %>"/>
			    <button class="btn btn-info">Update</button>
			    </form>
		    </td>
		    <td class="heads" style="vertical-align: middle; ">Total: $<%
		    	out.print(its[i].getPrice()* its[i].getCount());
		    	grandTotal += its[i].getPrice()* its[i].getCount();
		    %>
		    </td>
		  	</tr>
	  	
	  	<%} %>
	  	
		</table>
		
		<form class="bill" method="post" action="buy.jsp">
		<table class="table table-bordered texts" style="background-color: #eee;">
		<tr>
		<td style="width:50%;"><h3 class="heads" style="text-transform: uppercase;">Billing address</h3>
		<div class="texts">
			<label>First name:</label>
			<input required="required" type="text" value="<% out.print(myUser.getFname()); %>" name="b-fname"/><br />
			<label>Last name:</label>
			<input required="required" type="text" value="<% out.print(myUser.getLname()); %>" name="b-lname"/><br />
			<label>Street address:</label>
			<input required="required" type="text" name="b-street"/><br />
			<label>City:</label>
			<input required="required" type="text" name="b-city"/><br />
			<label>Zip:</label>
			<input required="required" type="text" name="b-zip"/><br />
			
			<input type="checkbox" id="sameAsBilling"><label style="width:230px; test-align:left;">Use as a shipping address</label><br />
		</div>
		</td><td><h3 class="heads" style="text-transform: uppercase;">Shipping address</h3>
		<div class="texts">
			
			<label>First name:</label>
			<input required="required" type="text" value="" name="s-fname"/><br />
			<label>Last name:</label>
			<input required="required" type="text" value="" name="s-lname"/><br />
			<label>Street address:</label>
			<input required="required" type="text" name="s-street"/><br />
			<label>City:</label>
			<input required="required" type="text" name="s-city"/><br />
			<label>Zip:</label>
			<input required="required" type="text" name="s-zip"/><br />
		</div>
		</td>
		</tr>
		</table>
		
		<table class="table table-bordered texts" style="background-color: #eee;">
		<tr>
		<td><h3 class="heads" style="text-transform: uppercase;">Billing information</h3>
		<div class="texts">
		
			Total: $<% 
			NumberFormat nf = NumberFormat.getInstance();
		    nf.setMaximumFractionDigits(2);
		    nf.setMinimumFractionDigits(2);
			out.print(nf.format(grandTotal)); %><br/><br/>
			
			<a href="https://www.paypal.com/webapps/mpp/paypal-popup" title="How PayPal Works" onclick="javascript:window.open('https://www.paypal.com/webapps/mpp/paypal-popup','WIPaypal','toolbar=no, location=no, directories=no, status=no, menubar=no, scrollbars=yes, resizable=yes, width=1060, height=700'); return false;"><img src="https://www.paypalobjects.com/webstatic/mktg/logo/bdg_payments_by_pp_2line.png" border="0" alt="Payments by PayPal"></a>
			
			<br><br>
			<input type="hidden" name="place" value="1" />
			<button class="btn btn-primary" type="submit"><i class="icon-shopping-cart icon-white"></i> Place the order</button>
			
		</div>
		</td>
		</tr>
		</table>
		
		
		
		</form>
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
	
	$("form").submit(function() {
		$('input[name=s-fname], input[name=s-lname], input[name=s-city], input[name=s-zip], input[name=s-street]').removeAttr("disabled");
	});
	
	$("#sameAsBilling").click(function(){
		if ($(this).is(':checked')) {
			$('input[name=s-fname]').val($('input[name=b-fname]').val());
			$('input[name=s-lname]').val($('input[name=b-lname]').val());
			$('input[name=s-street]').val($('input[name=b-street]').val());
			$('input[name=s-city]').val($('input[name=b-city]').val());
			$('input[name=s-zip]').val($('input[name=b-zip]').val());
			
		    $('input[name=s-fname], input[name=s-lname], input[name=s-city], input[name=s-zip], input[name=s-street]').attr("disabled", "disabled");
		} else {
			$('input[name=s-fname], input[name=s-lname], input[name=s-city], input[name=s-zip], input[name=s-street]').removeAttr("disabled");
		} 
	});
});
</script>


<%@ include file="footer.jsp" %>