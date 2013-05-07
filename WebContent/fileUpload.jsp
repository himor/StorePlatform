<%@page import="java.util.logging.Logger"%>
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*, javax.servlet.*" %>
<%@ page import="javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*" %>
<%@ page import="org.apache.commons.fileupload.disk.*" %>
<%@ page import="org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.output.*" %>
<%@ page import="sp.*"%>
<%@ page import="org.apache.jasper.tagplugins.jstl.core.ForEach" %>


<%@ include file="session.jsp" %>

<%
	// check the session;

	sessId = getSessionPrefix(session.getId());

	String sess_uid = (String)session.getAttribute("uid"+sessId);
	if (null == sess_uid) sess_uid = "0";
	if (sess_uid.equals("0")) {
		response.sendRedirect("index.jsp");
		return;		
	}
	
	User myUser = new User();
	myUser.loadById(Integer.parseInt(sess_uid));
	
	if (myUser.getType() != myUser.SELLER) {
		response.sendRedirect("index.jsp");
		return;
	}

	Item it = new Item();
	it.setSellerId(myUser.getId());
	
	File file;
	int maxFileSize = 10000 * 1024;
	int maxMemSize = 10000 * 1024;
	String filePath = "D:\\workspace\\StorePlatform\\WebContent\\upload\\"; // TODO change
	// Verify the content type
	String contentType = request.getContentType();
	if ((contentType.indexOf("multipart/form-data") >= 0)) {
		DiskFileItemFactory factory = new DiskFileItemFactory();
		// maximum size that will be stored in memory
		factory.setSizeThreshold(maxMemSize);
		// Location to save data that is larger than maxMemSize.
		factory.setRepository(new File("c:\\temp"));
		// Create a new file upload handler
		ServletFileUpload upload = new ServletFileUpload(factory);
		// maximum file size to be uploaded.
		upload.setSizeMax(maxFileSize);
		try {
			// Parse the request to get file items.
			List fileItems = upload.parseRequest(request);
			// Process the uploaded file items
			Iterator i = fileItems.iterator();
			while (i.hasNext()) {
				FileItem fi = (FileItem) i.next();
				if (!fi.isFormField()) {
					// Get the uploaded file parameters
					String fieldName = fi.getFieldName(); // "picture"
					String fileName = fi.getName();
					if (null != fileName && fileName.length() > 0) {
						int index = fileName.lastIndexOf(".");
						String ext;
						if (index > 0) {
							ext = fileName.substring(index + 1);
							ext = ext.toLowerCase();
							if (!ext.equals("jpg")) {
								response.sendRedirect("addItem.jsp?error=jpeg");
								return;
							}
							fileName += System.currentTimeMillis() + "."
									+ ext; // make filename more random
						}
						boolean isInMemory = fi.isInMemory();
						long sizeInBytes = fi.getSize();
						// Write the file
						if (fileName.lastIndexOf("\\") >= 0) {
							file = new File(filePath
									+ fileName.substring(fileName
											.lastIndexOf("\\")));
						} else {
							file = new File(filePath
									+ fileName.substring(fileName
											.lastIndexOf("\\") + 1));
						}
						fi.write(file);
						it.setPicture("upload/" + fileName);
					} // if null != filename
				} else {
					// process the form field 
					String name = fi.getFieldName();
					String value = fi.getString();
					//System.out.println(name+" : "+value);
					if (name.equals("name")) it.setName(value);
					if (name.equals("type")) it.setType(value);
					if (name.equals("price")) it.setPrice(Float.parseFloat(value));
					if (name.equals("qty")) it.setCount(Integer.parseInt(value));
					if (name.equals("description")) it.setDescription(value);

				}
			}
		} catch (Exception ex) {
			response.sendRedirect("addItem.jsp?error="+ex.toString());
			return;
		}
	}
	it.createItem();
	response.sendRedirect("items.jsp");
	return;
%>