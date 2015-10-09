<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<body>
<h1>Message : ${message}</h1>

<c:choose>
  <c:when test="${not empty pageContext.request.userPrincipal}">    
    User: <c:out value="${pageContext.request.userPrincipal.name}" />
    <a href="<c:url value='/logout' />" > Logout</a> | <a href="changePassword.jsp"> Change Password</a><br>
  </c:when>
  <c:otherwise>
    <div>
    <a href="../login/login.htm">Sign In</a> | <a href="../login/createAccount.jsp">Sign Up</a>
    </div>
  </c:otherwise>
</c:choose>


</body>
</html>