<html>
<head>
	<title>Account Creation Failed</title>
</head>

<body>
	<h3>Account Creation Failed</h3>
			<div style="margin-top:  25px ;position: relative; font:15px">
					Account Creation Failed for user <span style="font-weight:bold"><%= request.getParameter("email") %></span><br>
					Detailed message:  <span style="font-weight:bold"><%= request.getParameter("err_msg") %></span>
			</div>

</body>
</html>