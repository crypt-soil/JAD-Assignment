<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Home</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<%@ include file="../common/navbar.jsp" %>

<%
    // Retrieve session attributes
    // String role = (String) session.getAttribute("role");
    // String username = (String) session.getAttribute("username");
    

    if (role == null) {
        role = "public"; // default
    }
%>

<!-- Success login notification -->
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

<div class="container mt-5">

    <!-- ============================
         		PUBLIC VIEW 
         ============================ -->
    <%
        if (role.equals("public")) {
    %>
<%= session.getAttribute("role") %>

        <h2>Your Loved Ones, Our Priority</h2>
        <p>
            In need of Hair, call Silver Care! <br>
            At Silver Care, we make elderly care simple, personal, and worry-free.
        </p>
        <a href="booking.jsp" class="btn btn-primary">Book Now</a>

        <div class="mt-4">
            <img src="assets/img/hero1.jpg" class="img-fluid">
        </div>

        <h3 class="mt-5">Service Categories</h3>
        <div class="row mt-3">
            <div class="col-md-4">Cat 1<br>• Service 1<br>• Service 2</div>
            <div class="col-md-4">Cat 2<br>Body text...</div>
            <div class="col-md-4">Cat 3<br>Body text...</div>
        </div>

    <%
        }  // end public view
    %>

    <!-- ============================
         		MEMBER VIEW 
         ============================ -->
    <%
        if (role.equals("member")) {
    %>
<%= session.getAttribute("role") %>

        <h2>Welcome, <%= username %>!</h2>
        <p>
            In need of Hair, call Silver Care! <br>
            At Silver Care, we make elderly care simple, personal, and worry-free.
        </p>
        <a href="booking.jsp" class="btn btn-primary">Book Now</a>

        <div class="mt-4">
            <img src="assets/img/hero2.jpg" class="img-fluid">
        </div>

        <h3 class="mt-5">Service Categories</h3>
        <div class="row mt-3">
            <div class="col-md-4">
                Cat 1<br>Body text...<br>
                <button class="btn btn-dark btn-sm mt-2">Add to cart</button>
            </div>
            <div class="col-md-4">
                Cat 2<br>Body text...<br>
                <button class="btn btn-dark btn-sm mt-2">Add to cart</button>
            </div>
            <div class="col-md-4">
                Cat 3<br>Body text...<br>
                <button class="btn btn-dark btn-sm mt-2">Add to cart</button>
            </div>
        </div>

    <%
        }  // end member view
    %>

    <!-- ============================
         		ADMIN VIEW 
         ============================ -->
    <%
        if (role.equals("admin")) {
    %>
<%= session.getAttribute("role") %>

        <h2>Welcome, Admin <%= username %>!</h2>
        <p>
            In need of Hair, call Silver Care! <br>
            Admin dashboard view.
        </p>
        <button class="btn btn-secondary" disabled>Book Now (disabled)</button>

        <div class="mt-4">
            <img src="assets/img/hero3.jpg" class="img-fluid">
        </div>

        <h3 class="mt-5">Service Categories</h3>
        <div class="row mt-3">

            <div class="col-md-4">
                Cat 1<br>Body text...<br>
                <button class="btn btn-dark btn-sm mt-2">Edit</button>
                <button class="btn btn-danger btn-sm mt-2">Delete</button>
            </div>

            <div class="col-md-4">
                Cat 2<br>Body text...<br>
                <button class="btn btn-dark btn-sm mt-2">Edit</button>
                <button class="btn btn-danger btn-sm mt-2">Delete</button>
            </div>

            <div class="col-md-4">
                Cat 3<br>Body text...<br>
                <button class="btn btn-dark btn-sm mt-2">Edit</button>
                <button class="btn btn-danger btn-sm mt-2">Delete</button>
            </div>

        </div>

    <%
        }  // end admin view
    %>

</div>

</body>
</html>
