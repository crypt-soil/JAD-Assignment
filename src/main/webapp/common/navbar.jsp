<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Sticky Purple Navbar -->
<nav class="navbar navbar-custom d-flex justify-content-between align-items-center sticky-top">
    <div class="fw-semibold">Silver Care</div>
    <div>
        <a href="#">Service Category</a>
        <a href="../registerPage/registerPage.jsp" class="btn btn-signup">Sign Up</a>
        <a href="../loginPage/login.jsp" class="btn btn-login">Login</a>
    </div>
</nav>

<style>
    .navbar-custom {
        background-color: #c5b2e6;
        padding: 30px 70px 30px 70px; /* extra bottom padding */
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
        z-index: 1030; /* ensures navbar appears above content */
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
