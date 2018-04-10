<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@page import="java.io.PrintWriter"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>
<%
	try {
		//Create a connection string
		String url = "jdbc:mysql://cs336.crihf3wk4z2b.us-east-2.rds.amazonaws.com/BuySellWebsite";
		//Load JDBC Driver
		Class.forName("com.mysql.jdbc.Driver");
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		Connection con = DriverManager.getConnection(url, "daveyjones94", "doubleK1LL");
		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		//When someone wants to look at an auction, I will need to get this key from that page
		//String auctionID = request.getParameter("auctionID");
		
		//We are just looking to see if this works
		String auctionID = "14";
		
		ResultSet rs1 = stmt.executeQuery("SELECT auctioneerUsername, auctionItemID, finishDateTime, winningBidID FROM Auctions WHERE (auctionID = '" + auctionID + "');");
		rs1.next();
		String username = rs1.getString("auctioneerUsername");
		String itemID = rs1.getString("auctionItemID");
		String finishDateTime = rs1.getString("finishDateTime");
		String winningBidID = rs1.getString("winningBidID");
		
		ResultSet rs2 = stmt.executeQuery("SELECT itemType, details FROM Item WHERE (itemID = '" + itemID + "');");
		rs2.next();
		String itemType = rs2.getString("itemType");
		String details = rs2.getString("details");
		
		out.println("Title placeholder<br>");
		out.println("Item type: " + itemType + "<br>");
		out.println("Item details: " + details + "<br>");
		
		out.println(username + " is selling this item<br>");
		out.println("This auction will end on " + finishDateTime + "<br>");
		
		if (winningBidID == null) {
			out.println("There are no bids on this item yet!<br>");
		} else {
			ResultSet rs3 = stmt.executeQuery("SELECT bidderName, bidAmount FROM Bid WHERE (bidID = '" + winningBidID + "') AND (bidAuction = '" + auctionID + "');");
			rs3.next();
			String bidderName = rs3.getString("bidderName");
			float bidAmount = rs3.getFloat("bidAmount");
			out.println(bidderName + " is currently winning this bid at " + bidAmount + "<br>");
			out.println("Enter " + (bidAmount + .01) + "or more in order to bid!<br>");
		}
	} catch (Exception ex) {
		out.print(ex);
	}
%>
<form method="post" action="submitBid.jsp">
<table>
	<tbody>
		<tr>
			<td>Bid Amount</td>
			<td><input type="text" name="bidAmount"></td>
		</tr>
	</tbody>
</table>
	<br>
	<input type="submit" value="Bid!">
</form>
</body>
</html>