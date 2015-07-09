<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<body>
<a href="<c:url value='/logout' />" > Logout</a><br>
<h1>Message : ${message}</h1>
User:
<c:if test="${not empty pageContext.request.userPrincipal}">
    <c:out value="${pageContext.request.userPrincipal.name}" />
</c:if>

</body>
</html>