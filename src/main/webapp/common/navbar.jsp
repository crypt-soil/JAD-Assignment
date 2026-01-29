<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    Integer caregiverId = (Integer) session.getAttribute("caregiver_id");
    Integer customerId = (Integer) session.getAttribute("customer_id");
    String role = (String) session.getAttribute("role");
    if (role == null) role = "public";
%>

<%
    String timedOut = request.getParameter("timeout");
%>

<% if ("true".equals(timedOut)) { %>
<div class="alert alert-warning text-center m-0">
    Your session has expired. Please log in again.
</div>
<% } %>

<nav class="navbar navbar-custom d-flex justify-content-between align-items-center sticky-top">
    <div class="fw-semibold">Silver Care</div>

    <div>

        <% if ("admin".equals(role)) { %>

            <a href="<%= request.getContextPath() %>/admin/management" class="btn btn-white">
                Management Overview
            </a>
            <a href="<%= request.getContextPath() %>/adminPage/analyticsDashboard.jsp" class="btn btn-white">
                Analytics Dashboard
            </a>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-purple">
                Logout
            </a>

        <% } else if (caregiverId != null) { %>

            <a href="<%= request.getContextPath() %>/caregiver/home">
                Caregiver Home
            </a>
            <a href="<%= request.getContextPath() %>/caregiver/visits?filter=today" class="btn btn-purple">
                Schedule
            </a>
            <a href="<%= request.getContextPath() %>/CaregiverLogoutServlet" class="btn btn-white">
                Logout
            </a>

        <% } else if (customerId != null && "member".equals(role)) { %>

            <a href="<%= request.getContextPath() %>/categories">Service Category</a>
            <a href="<%= request.getContextPath() %>/caregiverInfoPage/caregiver.jsp">Our Caregivers</a>
            <a href="<%= request.getContextPath() %>/profile" class="btn btn-white">
                Profile
            </a>
            <a href="<%= request.getContextPath() %>/cartPage/cartPage.jsp" class="btn btn-white">
                Cart
            </a>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-purple">
                Logout
            </a>

        <% } else { %>

            <a href="<%= request.getContextPath() %>/categories">Service Category</a>
            <a href="<%= request.getContextPath() %>/caregiverInfoPage/caregiver.jsp">Our Caregivers</a>
            <a href="<%= request.getContextPath() %>/registerPage/registerPage.jsp" class="btn btn-white">
                Sign Up
            </a>
            <a href="<%= request.getContextPath() %>/loginPage/login.jsp" class="btn btn-purple">
                Login
            </a>
        <% } %>

    </div>
</nav>

<style>
.navbar-custom {
    background-color: #c5b2e6;
    padding: 30px 70px;
    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
    z-index: 1030;
}
.navbar-custom a {
    color: #000;
    text-decoration: none;
    margin-right: 25px;
    font-weight: 500;
}
.navbar-custom a:hover {
    text-decoration: underline;
}
.btn-purple {
    background-color: #6d4a8d;
    color: white;
    border: none;
    border-radius: 6px;
    padding: 6px 18px;
    font-weight: 500;
}
.btn-white {
    background-color: white;
    color: #000;
    border: none;
    border-radius: 6px;
    padding: 6px 18px;
    font-weight: 500;
    margin-right: 10px;
}
</style>
