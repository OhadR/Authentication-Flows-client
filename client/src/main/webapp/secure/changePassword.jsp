<html>
<head>
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.4.2.js"></script>
	<script type="text/javascript" src="./javascript/oauth.js"></script>
	<title>Set New Password Page</title>
</head>

<!-- onload='document.f.password.focus();InitCreateAccount();setEnc()'  -->
<body >
	<h3>Change Password</h3>

	<%   
	    if ( null != request.getParameter("err_msg") ) {
	%>	
	<div style="margin-top:  25px ;position: relative; color: red; font:15px">
		<span style="font-weight:bold"><%= request.getParameter("err_msg") %></span>
	</div>
	<%   } %>

	<form name='f' id='f' 
		action='../changePassword'
		method='POST'>
		<table>
			<tr>
				<td><input type='hidden' name='enc' /></td>
			</tr>
			<tr>
				<td>Current password:</td>
				<td><input type='password' name='currentPassword' /></td>
			</tr>
			<tr>
				<td>New Password:</td>
				<td><input type='password' name='newPassword' /></td>
			</tr>
			<tr>
				<td>Confirm Password:</td>
				<td><input type='password' name='confirm_password' /></td>
			</tr>
			<tr>
				<td colspan='2'><input name="submit" type="submit"
					value='Set New Password' /></td>
			</tr>
		</table>
	</form>
</body>
</html>