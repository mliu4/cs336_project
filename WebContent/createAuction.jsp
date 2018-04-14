<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Create An Auction</title>
</head>
<body>
<% 
	if (session.getAttribute("user") == null) {
		response.sendRedirect("loginPage.jsp");
	} else {
		out.println("Please create your auction, <b>" + session.getAttribute("user") + "</b><br>");
	}
%>
<form method="post" action="submitAuction.jsp">
<table>
	<tbody>
		<tr>
			<td>Auction Title</td>
			<td><input type="text" name="title"></td>
		<tr>
			<td>Universal Product Code</td>
			<td><input type="text" name="itemID"></td>
		</tr>
		<tr>
			<td>Reserve Amount (in Dollars)</td>
			<td>$<input type="text" name="reserve"></td>
		</tr>
		<tr>
			<td>Auction End Date and Time</td>
			<td><input type="text" name="dateandtime"></td>
		</tr>
		<tr>
			<td>Item Details</td>
			<td><input type="text" name="itemDetails"></td>
		</tr>
		<tr>
			<td>Item Color</td>
			<td><input type="text" name="color"></td>
		</tr>
		<tr>
			<td>Item Size</td>
			<td><input type="text" name="size"></td>
		</tr>
		<tr>
			<td>Item Style</td>
			<td><input type="text" name="style"></td>
		</tr>
	</tbody>
</table>
	<br>
	<input type="submit" value="Create">
</form>
</body>
</html>