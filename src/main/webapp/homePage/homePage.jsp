<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Category"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Home</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body>

	<%@ include file="../common/navbar.jsp"%>

	<%
	// Retrieve session attributes
	String role = (String) session.getAttribute("role");
	String username = (String) session.getAttribute("username");
	if (role == null)
		role = "public";

	// Retrieve categories ONCE (for all roles)
	@SuppressWarnings("unchecked")
	List<Category> categories = (List<Category>) request.getAttribute("categories");
	%>

	<!-- Success login notification -->
	<%
	String loginMsg = (String) session.getAttribute("loginMessage");
	if (loginMsg != null) {
	%>
	<div class="alert alert-success text-center mt-3" role="alert">
		<h1><%=loginMsg%></h1>
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

		<h2 class="mt-5"></h2>

		<div class="container mt-4">
			<div class="row align-items-center">

				<!-- LEFT: IMAGE -->
				<div class="col-md-6">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="img-fluid rounded shadow-sm"
						style="max-height: 350px; object-fit: cover;">
				</div>

				<!-- RIGHT: TEXT -->
				<div class="col-md-6">
					<h2>Your Loved Ones, Our Priority</h2>
					<p>
						In need of Hair, call Silver Care!<br> We make elderly care
						simple, personal, and worry-free.<br> Browse our range of
						compassionate care services and find the support that best fits
						your family’s needs.
					</p>
					<a href="register.jsp" class="btn btn-primary mt-2">Book Now</a>
				</div>

			</div>
		</div>


		<h3 class="mt-5">Service Categories</h3>
		<hr>

		<div class="row mt-3 g-4">
			<%
			for (Category c : categories) {
			%>

			<div class="col-md-4 d-flex">
				<div class="card shadow-sm flex-fill">

					<%
					if (c.getImageUrl() != null) {
					%>
					<img src="<%=c.getImageUrl()%>" class="card-img-top"
						style="height: 200px; object-fit: cover;">
					<%
					}
					%>

					<div class="card-body">
						<h5 class="card-title"><%=c.getName()%></h5>
						<p class="card-text"><%=c.getDescription()%></p>
					</div>
				</div>
			</div>

			<%
			}
			%>
		</div>


		<%
		} // end public
		%>

		<!-- ============================
         MEMBER VIEW 
============================ -->
		<%
		if (role.equals("member")) {
		%>


		<div class="container mt-4">
			<div class="row align-items-center">

				<!-- LEFT: IMAGE -->
				<div class="col-md-6">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="img-fluid rounded shadow-sm"
						style="max-height: 350px; object-fit: cover;">
				</div>

				<!-- RIGHT: TEXT -->
				<div class="col-md-6">
					<h2>
						Welcome,
						<%=username%>!
					</h2>
					<p>
						In need of Hair, call Silver Care!<br> At Silver Care, we
						make elderly care simple, personal, and worry-free.<br>
						Explore services tailored to support your loved ones.
					</p>
					<a href="#categories" class="btn btn-primary mt-2">Book Now</a>
				</div>

			</div>
		</div>


		<h3 id="categories" class="mt-5">Service Categories</h3>
		<hr>

		<div class="row mt-3 g-4">
			<%
			for (Category c : categories) {
			%>

			<div class="col-md-4 d-flex">
				<div class="card shadow-sm flex-fill">

					<%
					if (c.getImageUrl() != null) {
					%>
					<img src="<%=c.getImageUrl()%>" class="card-img-top"
						style="height: 200px; object-fit: cover;">
					<%
					}
					%>

					<div class="card-body">
						<h5 class="card-title"><%=c.getName()%></h5>
						<p class="card-text"><%=c.getDescription()%></p>
						<a href="#" class="btn btn-dark btn-sm">View</a>
					</div>

				</div>
			</div>

			<%
			}
			%>
		</div>


		<%
		} // end member
		%>

		<!-- ============================
         ADMIN VIEW 
============================ -->
		<%
		if (role.equals("admin")) {
		%>

		<div class="container mt-4">
			<div class="row align-items-center">

				<!-- LEFT: IMAGE -->
				<div class="col-md-6">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="img-fluid rounded shadow-sm"
						style="max-height: 350px; object-fit: cover;">
				</div>

				<!-- RIGHT: TEXT -->
				<div class="col-md-6">
					<h2>
						Welcome, Admin
						<%=username%>!
					</h2>
					<p>
						Manage service categories, update descriptions, and oversee the
						Silver Care system effectively.<br> Thank you for keeping our
						platform running smoothly.
					</p>
					<button class="btn btn-secondary mt-2" disabled>Book Now
						(disabled)</button>
				</div>

			</div>
		</div>


		<h3 class="mt-5">Service Categories</h3>
		<hr>

		<div class="row mt-3 g-4">
			<%
			for (Category c : categories) {
			%>

			<div class="col-md-4 d-flex">
				<div class="card shadow-sm flex-fill">

					<%
					if (c.getImageUrl() != null) {
					%>
					<img src="<%=c.getImageUrl()%>" class="card-img-top"
						style="height: 200px; object-fit: cover;">
					<%
					}
					%>

					<div class="card-body">
						<h5 class="card-title"><%=c.getName()%></h5>
						<p class="card-text"><%=c.getDescription()%></p>

						<a href="#" class="btn btn-dark btn-sm">Edit</a> <a href="#"
							class="btn btn-danger btn-sm">Delete</a>
					</div>

				</div>
			</div>

			<%
			}
			%>
		</div>


		<%
		} // end admin
		%>

	</div>
</body>
</html>
