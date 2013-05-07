<%--
	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
	Logout with redirect
--%>

<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>

<%@ include file="session.jsp" %>

	<%	sessId = getSessionPrefix(session.getId());
		session.setAttribute("uid"+sessId,"0");
		session.invalidate();
	    response.sendRedirect("index.jsp");
	%>