<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Register Page</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="../common/navbar.jsp" %>

<!-- ✅ Success login notification -->
<%
    String loginMsg = (String) session.getAttribute("loginMessage");
    if (loginMsg != null) {
%>
    <div class="alert alert-success text-center mt-3" role="alert">
        <%= loginMsg %>
    </div>
<%
        session.removeAttribute("loginMessage");
    }
%>

<h2 class="text-center mt-5">Welcome, <%= session.getAttribute("username") %>!</h2>

</body>
</html>
