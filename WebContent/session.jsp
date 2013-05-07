<%--
 	================================================
	COPYRIGHT (C) 2013 MIKHAIL GORDO mgordo@live.com
	================================================
	
	DESCRIPTION:
		This module generates the Session Checksum used as a part 
		of session variables used throughout the application
--%>

<%!
	public String getSessionPrefix(String s) {
		String result = "";
		int a = 0;
		for (int i=0;i<s.length()-1;i++) {
			a += (int)s.charAt(i)*(int)s.charAt(i+1);
		}
		result = "-"+a;
		return result;
	}
	String sessId = "";	
%>