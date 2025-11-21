<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

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
	background-image:
		url('https://source.unsplash.com/900x900/?elderly,care,community');
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
.btn-purple {
	background-color: #7b50c7;
	color: white;
	border: none;
	border-radius: 25px;
	padding: 10px;
	width: 100%;
	font-weight: 600;
	box-shadow: 0 3px 10px rgba(120, 90, 255, 0.3);
}

.btn-purple:hover {
	background-color: #693fb3;
}
</style>
</head>
<body class="bg-light p-5">
	<%@ include file="../common/navbar.jsp"%>


	<div class="container-fluid g-0 full-height">


		<%
		String message = request.getParameter("message");
		String reason = request.getParameter("reason");
		if (message != null) {
			if (message.equals("success")) {
		%>
		<div class="alert alert-success text-center">
			Registration successful! You can now <a href="../loginPage/login.jsp">log
				in</a>.
		</div>
		<%
		} else {
		%>
		<div class="alert alert-danger text-center fw-bold fs-4">
			<%=message + ": " + reason%>
		</div>

		<%
		}
		}
		%>
		<div class="row g-0 full-height">
			<div class="col-md-6 login-image"></div>
			<div class="col-md-6 form-side">
				<h2>Register with us!</h2>

				<!-- ✅ show success/error messages -->
				<%
				if ("success".equals(message)) {
				%>
				<div class="alert alert-success text-center">Registration
					Successful!</div>
				<%
				} else if ("error".equals(message)) {
				%>
				<div class="alert alert-danger text-center">
					Registration Failed:
					<%=(reason != null ? reason : "Unknown error")%>
				</div>
				<%
				}
				%>

				<!-- ✅ Updated form action -->
				<form action="${pageContext.request.contextPath}/VerifyRegister"
					method="POST">
					<div class="mb-3">
						<label class="form-label">Username</label> <input type="text"
							class="form-control" name="username" required>
					</div>
					<div class="mb-3">
						<label class="form-label">Email</label> <input type="text"
							class="form-control" name="email" required>
					</div>
					<div class="mb-3">
						<label class="form-label">Full Name</label> <input type="text"
							class="form-control" name="fullName" required>
					</div>
					<div class="mb-3">
						<label class="form-label">Phone Number</label> <input type="tel"
							class="form-control" name="phoneNumber" required>
					</div>
					<div class="mb-3">
						<label class="form-label">Address</label> <input type="text"
							class="form-control" name="address" required>
					</div>
					<div class="mb-3">
						<label class="form-label">Zipcode</label> <input type="text"
							class="form-control" name="zipcode" required>
					</div>
					<div class="mb-3">
						<label class="form-label">Password</label> <input type="password"
							class="form-control" name="password" required>
					</div>
					<div class="mb-3">
						<label class="form-label">Confirm Password</label> <input
							type="password" class="form-control" name="password2" required>
					</div>
					<button type="submit" class="btn btn-purple">SIGN UP</button>
					<p class="form-text mt-3 text-center">
						Already have an account? <a href="../loginPage/login.jsp">LOG
							IN</a>
					</p>
				</form>
			</div>
		</div>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>