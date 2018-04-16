<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="java.text.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Auction View</title>
</head>
<body>
<!-- Welcome Banner code -->
<div align = center class = "banner">
Welcome to Candle Feet
</div>

<br>

<!-- Navigation Bar code -->
<div align= center class = "navigation">
<a href = "main_index.jsp">HOME</a>
<% 
	if(session.getAttribute("user") == null){
%>
<a href = "registerOrLogin.jsp">Sign up or Sign in</a>
<%} else{
%>
<a href = "logOut.jsp">Log Out</a>
<%}%>
<a href = "searchBrowse.jsp">Search & Browse</a>
<a href = "createAuction.jsp">Create an Auction</a>
</div>

<br>
<%
	Connection con = null;
	try {
		//Create a connection string
		String url = "jdbc:mysql://cs336.crihf3wk4z2b.us-east-2.rds.amazonaws.com/BuySellWebsite";
		//Load JDBC Driver
		Class.forName("com.mysql.jdbc.Driver");
		//Get the database connection
		ApplicationDB db = new ApplicationDB();	
		con = DriverManager.getConnection(url, "daveyjones94", "doubleK1LL");
		//Create a SQL statement
		Statement stmt = con.createStatement();
		
		//When someone wants to look at an auction, I will need to get this key from that page
		String auctionID = request.getParameter("auctionID");
		
		if (auctionID == null) {
			auctionID = (String)session.getAttribute("auctionID");
		}
		
		//We are just looking to see if this works
		//String auctionID = "19";
		
		ResultSet rs1 = stmt.executeQuery("SELECT title, reserve, auctioneerUsername, auctionItemID, finishDateTime, winningBidID, reserveMet FROM Auctions WHERE (auctionID = '" + auctionID + "');");
		rs1.next();
		String title = rs1.getString("title");
		String username = rs1.getString("auctioneerUsername");
		String itemID = rs1.getString("auctionItemID");
		String finishDateTime = rs1.getString("finishDateTime");
		String winningBidID = rs1.getString("winningBidID");
		int reserveMet = rs1.getInt("reserveMet");
		float reserve = rs1.getFloat("reserve");
		
		ResultSet rs2 = stmt.executeQuery("SELECT details, color, size, style FROM Item WHERE (itemID = '" + itemID + "');");
		rs2.next();
		String details = rs2.getString("details");
		String color = rs2.getString("color");
		String size  = rs2.getString("size");
		String itemType = rs2.getString("style");
		
		out.println(title + "<br>");
		out.println("Item style: " + itemType + "<br>");
		out.println("Item color: " + color + "<br>");
		out.println("Item size: " + size + "<br>");
		out.println("Item details: " + details + "<br>");
		
		SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		java.util.Date dNow = new java.util.Date();
		java.util.Date endAuction = formatter.parse(finishDateTime);
		
		if (dNow.before(endAuction)) {
			out.println(username + " is selling this item<br>");
			out.println("This auction will end on " + finishDateTime + "<br>");
		
			float bidAmount = 0;
			
			if (winningBidID == null) {
				out.println("There are no bids on this item yet!<br>");
			} else {
				ResultSet rs3 = stmt.executeQuery("SELECT bidderName, bidAmount FROM Bid WHERE (bidID = '" + winningBidID + "') AND (bidAuction = '" + auctionID + "');");
				rs3.next();
				String bidderName = rs3.getString("bidderName");
				bidAmount = rs3.getFloat("bidAmount");
				out.println(String.format("<b>%s</b> is currently winning the auction with a bid of <b>$%.2f</b><br>", bidderName, bidAmount));
			}
			
			if (!(username.equals((String)session.getAttribute("user")))) {
			out.println(String.format("Enter <b>$%.2f</b> or more in order to bid!", (bidAmount + .01)));%>
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
				<input type="hidden" name="auctionID" value="<%out.println(auctionID);%>">
				<input type="submit" value="Bid!">
			</form>
			<form method="post" action="createAutobidder.jsp">
				<input type="hidden" name="auctionID" value="<%out.println(auctionID);%>">
				<input type="submit" value="Set up Autobidder">
			</form>
		<% }
		} else {
			out.println("<b>" + username + "</b> sold this item<br>");
			out.println("This auction ended on " + finishDateTime + "<br>");
		
			float bidAmount = 0;
			
			if (winningBidID == null) {
				out.println("No one won this item: no one bid on it.<br>");
			} else if (reserveMet == 0 && reserve != 0) {
				out.println("No one won this item: the reserve was not met.<br>");
			} else {
				ResultSet rs3 = stmt.executeQuery("SELECT bidderName, bidAmount FROM Bid WHERE (bidID = '" + winningBidID + "') AND (bidAuction = '" + auctionID + "');");
				rs3.next();
				String bidderName = rs3.getString("bidderName");
				bidAmount = rs3.getFloat("bidAmount");
				out.println(String.format("<b>%s</b> won the auction with a bid of <b>$%.2f</b><br>", bidderName, bidAmount));
			}
		}
		
		out.println(String.format("<br>History of Bids:<br> "));
        out.println(String.format("----------------------- <br>"));

        ResultSet rsSam = stmt.executeQuery("SELECT Bid.bidAmount, Bid.bidderName FROM Bid WHERE (Bid.bidAuction = '" + auctionID + "');");
        while(rsSam.next()!=false){
            String SamAmount = rsSam.getString(1);
            String SamName = rsSam.getString(2);
            out.println("Person: " + SamName +" bid  $" + SamAmount +"   on this auction" + "<br />"+ "<br />");
        }
	} catch (Exception ex) {
		out.print(ex);
	} finally {
		con.close();
	}
%>
</body>
</html>