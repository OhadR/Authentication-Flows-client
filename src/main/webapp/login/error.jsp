<html>
<head>
	<title>Account Creation Failed</title>
</head>

<body>
	<h3><%= request.getParameter("err_header") %></h3>
			<div style="margin-top:  25px ;position: relative; font:15px">
					<%= request.getParameter("err_header") %> for user <span style="font-weight:bold"><%= request.getParameter("email") %></span><br>
					Detailed message:  <span style="font-weight:bold"><%= request.getParameter("err_msg") %></span>
			</div>

</body>
</html>