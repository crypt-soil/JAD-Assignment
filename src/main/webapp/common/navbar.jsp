<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null) role = "public";

    String username = (String) session.getAttribute("username");
%>

<!-- Sticky Purple Navbar -->
<nav class="navbar navbar-custom d-flex justify-content-between align-items-center sticky-top">
    <div class="fw-semibold">Silver Care</div>

    <div>

        <a href="<%= request.getContextPath() %>/categories">Service Category</a>

        <%-- ===========================
             PUBLIC (not logged in)
        ============================ --%>
        <%
            if (role.equals("public")) {
        %>
            <a href="<%= request.getContextPath() %>/registerPage/registerPage.jsp" class="btn btn-signup">Sign Up</a>
            <a href="<%= request.getContextPath() %>/loginPage/login.jsp" class="btn btn-login">Login</a>

        <%-- ===========================
             MEMBER
        ============================ --%>
        <%
            } else if (role.equals("member")) {
        %>
            <a href="../profilePage/profile.jsp" class="btn btn-signup">
                Profile
            </a>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-login">Logout</a>

        <%-- ===========================
             ADMIN
        ============================ --%>
        <%
            } else if (role.equals("admin")) {
        %>
            <a href="<%= request.getContextPath() %>/adminPage/managementOverview.jsp" class="btn btn-signup">
                Management Overview
            </a>
            <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-login">Logout</a>
        <%
            }
        %>

    </div>
</nav>

<style>
    .navbar-custom {
        background-color: #c5b2e6;
        padding: 30px 70px 30px 70px;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
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

    .btn-login {
        background-color: #6d4a8d;
        color: white;
        border: none;
        border-radius: 6px;
        padding: 6px 18px;
        font-weight: 500;
        transition: all 0.2s ease-in-out;
    }

    .btn-login:hover {
        background-color: #5c3c7a;
        transform: translateY(-1px);
    }

    .btn-signup {
        background-color: white;
        color: #000;
        border: none;
        border-radius: 6px;
        padding: 6px 18px;
        font-weight: 500;
        margin-right: 10px;
        transition: all 0.2s ease-in-out;
    }

    .btn-signup:hover {
        background-color: #f5f5f5;
        transform: translateY(-1px);
    }
</style>
