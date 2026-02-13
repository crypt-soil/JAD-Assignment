<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.customer.Customer" %>

<%
    Customer c = (Customer) request.getAttribute("customer");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Edit Customer - Silver Care</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background: #f3f0ff;
        font-family: "Poppins", sans-serif;
    }
    .wrapper {
        max-width: 700px;
        margin: 60px auto;
    }
    .card-custom {
        background: #ffffff;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 8px 30px rgba(0,0,0,0.08);
    }
    .title {
        font-weight: 700;
        color: #4b37b8;
        font-size: 1.9rem;
        margin-bottom: 5px;
    }
    .subtitle {
        color: #5a5a5a;
        margin-bottom: 25px;
        font-size: 0.95rem;
    }
    .btn-purple {
        background: #6a4bc7;
        color: white;
        border-radius: 8px;
        padding: 10px 20px;
        border: none;
        font-weight: 500;
    }
    .btn-purple:hover {
        background: #5a3ab1;
    }
    .btn-cancel {
        background: #e9e9e9;
        color: #333;
        border-radius: 8px;
        padding: 10px 20px;
        border: none;
        font-weight: 500;
    }
    .btn-cancel:hover {
        background: #d6d6d6;
    }
</style>
</head>

<body>

<%@ include file="../common/navbar.jsp" %>

<div class="wrapper">
    <div class="card-custom">

        <h2 class="title">Edit Customer</h2>
        <p class="subtitle">You are editing the user: <strong><%= c.getUsername() %></strong></p>

        <form method="post" action="<%= request.getContextPath() %>/admin/clients/update">

            <input type="hidden" name="id" value="<%= c.getCustomer_id() %>">

            <div class="mb-3">
                <label class="form-label">Username</label>
                <input class="form-control" type="text" name="username" value="<%= c.getUsername() %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Full Name</label>
                <input class="form-control" type="text" name="fullname" value="<%= c.getFull_name() %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Email</label>
                <input class="form-control" type="email" name="email" value="<%= c.getEmail() %>">
            </div>

            <div class="mb-3">
                <label class="form-label">Phone</label>
                <input class="form-control" type="text" name="phone" value="<%= c.getPhone() %>">
            </div>

            <div class="mb-3">
                <label class="form-label">Address</label>
                <input class="form-control" type="text" name="address" value="<%= c.getAddress() %>">
            </div>

            <div class="mb-4">
                <label class="form-label">Zipcode</label>
                <input class="form-control" type="text" name="zipcode" value="<%= c.getZipcode() %>">
            </div>

            <button class="btn-purple" type="submit">Save Changes</button>
            <a href="<%= request.getContextPath() %>/admin/management" class="btn-cancel ms-2">Cancel</a>

        </form>

    </div>
</div>

</body>
</html>
