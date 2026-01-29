<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Silver Care Login</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600&display=swap" rel="stylesheet">

<style>
body {
    font-family: 'Poppins', sans-serif;
    background-color: #f9f9f9;
    margin: 0;
}

.full-height { min-height: 100vh; }

.login-image {
    background-size: cover;
    background-position: center;
    min-height: 100vh;
}

.form-side {
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 80px 100px;
    background-color: #fff;
}

.subtitle {
    font-size: 0.9rem;
    color: #666;
    margin-top: 6px;
    margin-bottom: 18px;
}

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
.btn-login:hover { background-color: #693fb3; }

.nav-pills .nav-link {
    border-radius: 999px;
    font-weight: 600;
    color: #6b4cd8;
    padding: 8px 16px;
}
.nav-pills .nav-link.active {
    background-color: #6b4cd8;
    color: #fff;
}
</style>
</head>

<body>

<%@ include file="../common/navbar.jsp" %>

<div class="container-fluid g-0 full-height">
    <div class="row g-0 full-height">

        <div class="col-md-6 login-image"></div>

        <div class="col-md-6 form-side">

            <ul class="nav nav-pills mb-4 justify-content-center" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" data-bs-toggle="pill" data-bs-target="#customerTab" type="button" role="tab">
                        Customer
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" data-bs-toggle="pill" data-bs-target="#caregiverTab" type="button" role="tab">
                        Caregiver
                    </button>
                </li>
            </ul>

            <%
                String errorMsg = (String) request.getAttribute("errorMsg");
                if (errorMsg != null) {
            %>
                <div class="alert alert-danger text-center" role="alert">
                    <%= errorMsg %>
                </div>
            <%
                }
            %>

            <div class="tab-content">

                <div class="tab-pane fade show active" id="customerTab" role="tabpanel">
                    <h2 class="mb-0">Welcome back!</h2>
                    <p class="subtitle">Customer Portal</p>

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

                        <p class="form-text mt-3 text-center">
                            No Account yet?
                            <a href="${pageContext.request.contextPath}/registerPage/registerPage.jsp">SIGN UP</a>
                        </p>
                    </form>
                </div>

                <div class="tab-pane fade" id="caregiverTab" role="tabpanel">
                    <h2 class="mb-0">Caregiver Portal</h2>
                    <p class="subtitle">Log in to manage today’s care visits</p>

                    <form action="${pageContext.request.contextPath}/CaregiverLoginServlet" method="post">
                        <div class="mb-3">
                            <label class="form-label">Username</label>
                            <input type="text" class="form-control" name="username" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Password</label>
                            <input type="password" class="form-control" name="password" required>
                        </div>

                        <button type="submit" class="btn btn-login">LOG IN</button>

                        <p class="form-text mt-3 text-center">
                            Not a customer?
                            <a href="${pageContext.request.contextPath}/registerPage/registerPage.jsp">Register as Customer</a>
                        </p>
                    </form>
                </div>

            </div>

        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
