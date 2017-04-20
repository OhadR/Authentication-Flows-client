<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
 <title>Login Page</title>
</head>
 
<body onload='document.f.j_username.focus();'>
	<h3>Login with Username and Password</h3>
	<c:if test="${not empty SPRING_SECURITY_LAST_EXCEPTION}">
      <font color="red">
        Your login attempt was not successful due to <br/><br/>
        <c:out value="${SPRING_SECURITY_LAST_EXCEPTION.message}"/>.
      </font>
    </c:if>
	<form name='f' action='../j_spring_security_check' method='POST'>
		<table>
			<tr>
				<td>User:</td>
				<td><input type='text' name='username' value=''></td>
			</tr>
			<tr>
				<td>Password:</td>
				<td><input type='password' name='password' /></td>
			</tr>
			<tr>
				<td><input type='checkbox' name='remember_me' /></td>
				<td>Remember me on this computer.</td>
			</tr>
			<tr>
				<td colspan='2'><input name="submit" type="submit"
					value="Login" /></td>
				<td><a href="../login/forgotPassword.htm">Forgot Password?</a></td>
			</tr>
			<tr>
				<td><a href="../login/createAccount.jsp">Register</a></td>
			</tr>
		</table>
	</form>
</body>
</html>