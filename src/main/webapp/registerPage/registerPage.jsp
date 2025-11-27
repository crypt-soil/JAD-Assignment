<%@ page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ============================
   GLOBAL PAGE STYLING
   ============================ */
body {
	font-family: 'Poppins', sans-serif;
	background-color: #f9f9f9;
	margin: 0;
}

/* Ensures the content stretches full height */
.full-height {
	min-height: 100vh;
}

/* ============================
   LEFT SIDE IMAGE
   ============================ */
.login-image {
	background-image:
		url('https://source.unsplash.com/900x900/?elderly,care,community');
	background-size: cover;
	background-position: center;
	min-height: 100vh;
}

/* ============================
   RIGHT SIDE FORM AREA
   ============================ */
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

/* Purple sign-up button */
.btn-register {
	background-color: #7b50c7;
	color: white;
	border: none;
	border-radius: 25px;
	padding: 10px;
	width: 100%;
	font-weight: 600;
	box-shadow: 0 3px 10px rgba(120, 90, 255, 0.3);
}

.btn-register:hover {
	background-color: #693fb3;
}
</style>

</head>
<body>

	<!-- Shared navigation bar -->
	<%@ include file="../common/navbar.jsp"%>

	<div class="container-fluid g-0 full-height">

		<!-- ============================
         DISPLAY SUCCESS / ERROR MESSAGES
         These messages come from VerifyRegisterServlet
         ============================ -->
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

			<!-- ============================
             LEFT SIDE — Decorative Image
             ============================ -->
			<div class="col-md-6 login-image"></div>

			<!-- ============================
             RIGHT SIDE — Registration Form
             ============================ -->
			<div class="col-md-6 form-side">
				<h2>Register with us!</h2>

				<!-- Secondary message block (duplicated to ensure visibility) -->
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

				<!-- ============================
                 REGISTRATION FORM
                 Sends POST to VerifyRegisterServlet
                 ============================ -->
				<form action="${pageContext.request.contextPath}/VerifyRegister"
					method="POST">

					<!-- USERNAME -->
					<div class="mb-3">
						<label class="form-label">Username</label> <input type="text"
							class="form-control" name="username" required>
					</div>

					<!-- EMAIL -->
					<div class="mb-3">
						<label class="form-label">Email</label> <input type="text"
							class="form-control" name="email" required>
					</div>

					<!-- FULL NAME -->
					<div class="mb-3">
						<label class="form-label">Full Name</label> <input type="text"
							class="form-control" name="fullName" required>
					</div>

					<!-- PHONE NUMBER -->
					<div class="mb-3">
						<label class="form-label">Phone Number</label> <input type="tel"
							class="form-control" name="phoneNumber" required>
					</div>

					<!-- ADDRESS -->
					<div class="mb-3">
						<label class="form-label">Address</label> <input type="text"
							class="form-control" name="address" required>
					</div>

					<!-- ZIPCODE -->
					<div class="mb-3">
						<label class="form-label">Zipcode</label> <input type="text"
							class="form-control" name="zipcode" required>
					</div>

					<!-- PASSWORD -->
					<div class="mb-3">
						<label class="form-label">Password</label> <input type="password"
							class="form-control" name="password" required>
					</div>

					<!-- CONFIRM PASSWORD -->
					<div class="mb-3">
						<label class="form-label">Confirm Password</label> <input
							type="password" class="form-control" name="password2" required>
					</div>

					<!-- REGISTER BUTTON -->
					<button type="submit" class="btn btn-register">SIGN UP</button>

					<!-- Already have account -->
					<p class="form-text mt-3 text-center">
						Already have an account? <a href="../loginPage/login.jsp">LOG
							IN</a>
					</p>

				</form>
			</div>
		</div>
	</div>

	<!-- Shared footer -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
