<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Index Module
--%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>    
<%@ page import="sp.*" %>
<%! String header = "UAlbany Market"; %>
<%! boolean showButtons = true; %>
<%@ include file="header.jsp" %>
<%! int showCat = 1; %>
<%@ include file="sidebar.jsp" %>
<div id="content">

<%
	
	Item it = new Item();
	Item[] j = it.getRandom(0);
	Viewer vi = new Viewer();
	if (j != null) {
		for (int i = 0; i < j.length; i++) {
			out.print(vi.getOneOfManyItems(j[i]));
		}
	}
	
%>

</div>			
<%@ include file="footer.jsp" %>