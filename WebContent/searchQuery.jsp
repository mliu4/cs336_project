<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Search Results</title>
<link rel="stylesheet" type="text/css" href="style.css" />
</head>

<body>
<!-- Welcome Banner code -->
<div align = center class = "banner">
<h1>Candle Feet - Shoe Auction House</h1>
</div>
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

<div>

<!-- Search Engine Query Code -->
	<%
	
		try{
			
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
	
			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			String query = "SELECT * FROM Auctions a, Item i, Bid b WHERE a.auctionItemID = i.itemID AND (a.winningBidID = b.bidID OR a.winningBidID IS NULL) AND ";
			
			//Get commands from searchBrowse.jsp search bar
			String searchType = request.getParameter("searchType");
			String searchInput = request.getParameter("searchBar");
			
			//Switch statement to query properly
			if (searchType.equals("details")){
				query+= "i.details LIKE" + "\"" + "%" + searchInput + "%" + "\"";
			}
			else if (searchType.equals("searchColor")){
				query+= "i.color LIKE" + "\"" + "%" + searchInput + "%" + "\"";
			}
			else if (searchType.equals("searchSize")){
				query+= "i.size LIKE" + "\"" + "%" + searchInput + "%" + "\"";
			}
			else if (searchType.equals("searchStyle")){
				query+= "i.style LIKE" + "\"" + "%" + searchInput + "%" + "\"";
			}
			else{
				response.sendRedirect("searchBrowse.jsp");
			}
			
			query+=" GROUP BY a.auctionID HAVING max(b.bidAmount)";
			
			ResultSet result = stmt.executeQuery(query);
			
			out.print("<h3>Search Results</h3>");
			
			//Print out result table.
			//Create table headers
			out.print("<table>");
			
			out.print("<tr>");
			//auctionID
			out.print("<th>");
			out.print("Auction ID");
			out.print("</th>");
			
			//winning Bid Value
			out.print("<th>");
			out.print("Winning Bid");
			out.print("</th>");
			
			//TimeLeft
			out.print("<th>");
			out.print("Time Left");
			out.print("</th>");
			
			//itemID
			out.print("<th>");
			out.print("Shoe #");
			out.print("</th>");
			
			//itemDescription
			out.print("<th>");
			out.print("Description");
			out.print("</th>");
			
			//Color
			out.print("<th>");
			out.print("Color");
			out.print("</th>");
			
			//size
			out.print("<th>");
			out.print("Size");
			out.print("</th>");
			
			//style
			out.print("<th>");
			out.print("Style");
			out.print("</th>");
			
			out.print("</tr>");
			out.print("<br>");
			
			//Fill Table with the above attributes
			
			while(result.next()){
				
				//Make row
				out.print("<tr>");

				//Make column and fill with correct attribute
				//auctionID
				out.print("<td>");
				%><form method = post action = "viewAuction.jsp"> <button type = "submit" name = "auctionID" value = <%out.print(result.getString("auctionID"));%> ><% out.print(result.getString("auctionID")); %></button></form> <%
				out.print("</td>");
				
				//Winning Bid
				out.print("<td>");
				if(result.getString("winningBidID")!=null){
					out.print("$" + result.getInt("bidAmount"));	
				}
				else{
					out.print("No bids");
				}
				out.print("</td>");
				
				//TimeLeft
				out.print("<td>");
				out.print(result.getInt("timeLeft"));
				out.print("</td>");
				
				//itemID
				out.print("<td>");
				out.print(result.getInt("itemID"));
				out.print("</td>");
				
				//Item Details
				out.print("<td>");
				if(result.getString("details")!=null){
					out.print(result.getString("details"));
				}
				else{
					out.print("User has not provided description");
				}
				out.print("</td>");
				
				//Color
				out.print("<td>");
<<<<<<< HEAD
				if(result.getString("color")!=null){
					out.print(result.getString("color"));
				}
				else{
					out.print("-");
				}
				out.print("</td>");

				//size
				out.print("<td>");
				if(result.getString("size")!=null){
					out.print(result.getString("size"));
				}
				else{
					out.print("-");
				}
=======
				out.print(result.getString("finishDateTime"));
>>>>>>> david
				out.print("</td>");
				
				//Style
				out.print("<td>");
<<<<<<< HEAD
				if(result.getString("style")!=null){
					out.print(result.getString("style"));
				}
				else{
					out.print("-");
				}
=======
				out.print(result.getString("auctioneerUsername"));
>>>>>>> david
				out.print("</td>");
				
				out.print("</tr>");
				out.print("<br>");
				
			}
			
			out.print("</table>");
			
			//close connection
			con.close();
			
		}catch(Exception e){
			out.print("e");
		}
	
	
	%>

</div>


</body>

</html>