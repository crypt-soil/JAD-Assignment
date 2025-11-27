<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Silver Care Login Page</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

<style>
body {
    font-family: 'Poppins', sans-serif;
    background-color: #f9f9f9;
    margin: 0;
}

/* Make the whole section take up full screen */
.full-height {
    min-height: 100vh;
}

/* Left image side */
.login-image {
    background-size: cover;
    background-position: center;
    min-height: 100vh;
}

/* Right form side */
.form-side {
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 80px 100px;
    background-color: #fff;
}

.form-side h2 {
    font-weight: 600;
    margin-bottom: 30px;
}

/* Purple login button */
.btn-login {
    background-color: #7b50c7;
    color: white;
    border: none;
    border-radius: 25px;
    padding: 10px;
    width: 100%;
    font-weight: 600;
    box-shadow: 0 3px 10px rgba(120, 90, 255, 0.3);
}

.btn-login:hover {
    background-color: #693fb3;
}
</style>
</head>

<body>

    <!-- Purple Navbar -->
    <%@ include file="../common/navbar.jsp" %>

    <!-- Full width, split login section -->
    <div class="container-fluid g-0 full-height">
        <div class="row g-0 full-height">
            <!-- Left Image -->
            <div class="col-md-6 login-image"></div>


            <div class="col-md-6 form-side">
                <h2>Welcome back!</h2>
                <!-- Show error from loginServlet if login fails -->
                <%
                    String errorMsg = (String) request.getAttribute("errorMsg");
                    if (errorMsg != null) {
                %>
                    <div class="alert alert-danger text-center" role="alert">
                        <%= errorMsg %>
                    </div>
                <% } %>
                <!--  Send login data to the servlet -->
                <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
				<div class="mb-3">
				<label class="form-label">Email or Username</label>
                        <input type="text" class="form-control" name="username" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Password</label>
                        <input type="password" class="form-control" name="password" required>
                    </div>
                    <button type="submit" class="btn btn-login">LOG IN</button>
                    <p class="form-text mt-3 text-center">  <!-- link to register page -->
                        No Account yet? <a href="${pageContext.request.contextPath}/registerPage/registerPage.jsp">SIGN UP</a>
                    </p>
                </form>
            </div>
        </div>
    </div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
