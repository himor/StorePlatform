<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Search Module
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%! String header = "UAlbany Market"; %>
<%! boolean showButtons = true; %>

<%
String stype = request.getParameter("stype");
	
	if (stype != null) {
		sessId = getSessionPrefix(session.getId());
		session.setAttribute("searchCat" + sessId,stype);
	}
	%>

<%@ include file="header.jsp" %>
<%! int showCat = 1; %>
<%@ include file="sidebar.jsp" %>
<div id="content">

<%
	String page_a = request.getParameter("page");
	int pge;
	if (page_a == null) pge = 0;
	else pge = Integer.parseInt(page_a);
	
	Item it = new Item();
	
	String type = request.getParameter("type");
	String value = request.getParameter("value");

	if (value == null || value.length() == 0) {
		response.sendRedirect("index.jsp");
		return;
	}
	
	Item[] j = null;
	int pages = 0;
	int cnt = 0;
	
	if ((type != null && type.equals("cat")) || (stype != null && stype.equals("type"))) {
		j = it.search(null, value, pge);
		cnt = it.searchCount(null, value);
		pages = (int)(Math.ceil(cnt / (double)it.ITEMS_PER_PAGE));
	}
	
	if ((type != null && type.equals("name")) || (stype != null && stype.equals("name"))) {
		j = it.search(value, null, pge);
		cnt = it.searchCount(value, null);
		pages = (int)(Math.ceil(cnt / (double)it.ITEMS_PER_PAGE));
	}
	
	if ((type != null && type.equals("seller")) || (stype != null && stype.equals("seller"))) {
		j = it.searchS(value,pge);
		cnt = it.searchCountS(value);
		pages = (int)(Math.ceil(cnt / (double)it.ITEMS_PER_PAGE));
	}

	Viewer vi = new Viewer();
	if (j != null) {
		for (int i = 0; i < j.length; i++) {
			out.print(vi.getOneOfManyItems(j[i]));
		}
	}
	
	// pagination
	out.print ("<ul id=\"nav-bar\">");
	int p_start = pge - 4;
	int p_end =   pge + 4;
	if (p_end > pages) {
		p_start -= (p_end - pages);
		p_end = pages;
	} 
	if (p_start < 0) {
		p_end += (-p_start);
		p_start = 0;
	}
	if (p_end > pages) {
		p_end = pages;
	}
	
	if (type == null && stype != null) type = stype;
	
	for(int i = p_start; i < p_end; i ++) {
		out.print ("<li><a href=\"search.jsp?type="+type+"&value="+value+"&page="+i+"\" class=\""+((i==pge)?"active":"")+"\">"+(i+1)+"</a></li>");
	}
	
	out.print ("</ul>");
%>

</div>			
<%@ include file="footer.jsp" %>