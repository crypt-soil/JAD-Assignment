<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%--
Ong Jin Kai
2429465
 --%>
<!-- Import Java List + your Category model -->
<%@ page import="java.util.List"%>
<%@ page import="model.category.Category"%>
<%
String username = (String) session.getAttribute("username");
if (username == null)
	username = "User";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silver Care - Home</title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<!-- Google Poppins Font -->
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<style>

/* =============== PAGE BACKGROUND =============== */
body {
	background: #f6f4ff; /* soft lilac background */
	font-family: "Poppins", sans-serif;
}

/* =============== PAGE WRAPPER (centers all content) =============== */
.home-wrapper {
	max-width: 1200px;
	margin: 40px auto 60px auto;
}

/* =============== HERO SECTION (big banner at top) =============== */
.hero-card {
	background: #ffffff;
	border-radius: 20px;
	padding: 32px;
	box-shadow: 0 16px 40px rgba(0, 0, 0, 0.08);
}

/* Hero image on left side */
.hero-img {
	width: 100%;
	max-height: 360px;
	border-radius: 18px;
	object-fit: cover;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
}

/* Main hero text */
.hero-title {
	font-weight: 700;
	font-size: 2rem;
	color: #4b37b8;
}

/* Subtext under title */
.hero-subtitle {
	color: #555;
	font-size: 0.98rem;
	line-height: 1.7;
	margin-top: 12px;
}

/* 'Book Now' button */
.hero-cta {
	background: #6b4cd8;
	border-color: #6b4cd8;
	border-radius: 999px;
	padding: 10px 24px;
	font-weight: 600;
	margin-top: 18px;
}

.hero-cta:hover {
	background: #5936cf;
	border-color: #5936cf;
}

/* =============== SECTION TITLES =============== */
.section-header {
	display: flex;
	align-items: baseline;
	justify-content: space-between;
	margin-top: 40px;
	margin-bottom: 8px;
}

.section-title {
	font-weight: 700;
	font-size: 1.4rem;
	color: #3c2a99;
	margin: 0;
}

.section-subtitle {
	font-size: 0.9rem;
	color: #777;
}

/* =============== SEARCH BAR =============== */
.search-card {
	background: #ffffff;
	border-radius: 14px;
	padding: 14px 18px;
	box-shadow: 0 8px 22px rgba(0, 0, 0, 0.06);
	margin-top: 16px;
	margin-bottom: 24px;
}

.search-card .form-control {
	border-radius: 999px;
	padding: 10px 16px;
}

.search-card .btn {
	border-radius: 999px;
	padding: 9px 20px;
	font-weight: 500;
}

/* =============== CATEGORY CARDS =============== */
.category-card {
	border-radius: 16px;
	overflow: hidden;
	background: #ffffff;
	box-shadow: 0 10px 26px rgba(0, 0, 0, 0.06);
	transition: transform .18s ease, box-shadow .18s ease;
	display: flex;
	flex-direction: column;
	height: 100%;
}

/* Category card image */
.category-card img {
	width: 100%;
	height: 200px;
	object-fit: cover;
}

/* Hover animation */
.category-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 16px 36px rgba(0, 0, 0, 0.09);
}

/* Card body content */
.category-card .card-body {
	padding: 16px 18px 18px 18px;
}

/* Category name */
.category-name {
	font-weight: 600;
	font-size: 1.1rem;
	margin-bottom: 4px;
}

/* Category description */
.category-desc {
	font-size: 0.9rem;
	color: #666;
	min-height: 44px;
}

/* =============== SERVICES LIST (inside category card) =============== */
.services-label {
	font-size: 0.8rem;
	text-transform: uppercase;
	letter-spacing: 0.06em;
	color: #999;
	font-weight: 600;
	margin-top: 10px;
	margin-bottom: 4px;
}

/* UL list inside card */
.services-list {
	list-style: none;
	padding-left: 0;
	margin-bottom: 10px;
	font-size: 0.9rem;
}

.services-list li {
	margin-bottom: 2px;
}

/* Highlighted service (search result) */
.highlight-service {
	font-weight: 600;
	background: #fff3cd;
	padding: 3px 6px;
	border-radius: 6px;
}

/* Buttons in the bottom of category card */
.card-actions .btn {
	font-size: 0.85rem;
	padding: 6px 12px;
}

/* =============== ROLE TAG (Public/Admin/Member badge) =============== */
.role-tag {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 999px;
	font-size: 0.75rem;
	font-weight: 600;
	background: #efe9ff;
	color: #6b4cd8;
	text-transform: uppercase;
	letter-spacing: 0.04em;
}

/* =============== BUTTON VARIANTS =============== */
.btn-soft-primary {
	background: #efe9ff;
	color: #6b4cd8;
	border-color: #d1c2ff;
	font-weight: 600;
}

.btn-soft-primary:hover {
	background: #e2d6ff;
	color: #5936cf;
	border-color: #b9a1ff;
}

.btn-soft-warning {
	background: #fff8e1;
	color: #b8860b;
	border-color: #ffe08a;
}

.btn-soft-danger {
	background: #ffe6e6;
	color: #c62828;
	border-color: #ffb3b3;
}

.btn-soft-warning:hover {
	background: #ffefb0;
	color: #8a6c00;
	border-color: #ffd35c;
}

.btn-soft-danger:hover {
	background: #ffd4d4;
	color: #9f1f1f;
	border-color: #ff9b9b;
}

.btn-soft-blue {
	background: #e7f1ff;
	color: #1b6ec2;
	border-color: #bcd9ff;
	font-weight: 600;
	padding: 9px 20px;
}

.btn-soft-blue:hover {
	background: #d8e7ff;
	color: #155a9c;
	border-color: #9cc7ff;
}
</style>

</head>
<body>
	<%@ include file="../common/navbar.jsp"%>

	<%
	/* ==========================================
	   ROLE CHECK (public/member/admin)
	   If user not logged in → treat as public
	   ========================================== */
	if (role == null)
		role = "public";

	/* ==========================================
	   Get categories list from request
	   (passed from CategoriesServlet)
	   ========================================== */
	@SuppressWarnings("unchecked")
	List<Category> categories = (List<Category>) request.getAttribute("categories");
	%>

	<!-- ==========================================
     SUCCESS LOGIN MESSAGE (one-time)
     ========================================== -->
	<%
	String loginMsg = (String) session.getAttribute("loginMessage");
	if (loginMsg != null) {
	%>
	<div class="alert alert-success text-center mt-3" role="alert">
		<h5 class="mb-0"><%=loginMsg%></h5>
	</div>
	<%
	session.removeAttribute("loginMessage"); // remove so it won’t show again
	}
	%>

	<%
	String checkoutMsg = (String) session.getAttribute("checkoutSuccessMessage");
	if (checkoutMsg != null) {
	%>
	<div class="alert alert-success text-center mt-3" role="alert">
		<h5 class="mb-0"><%=checkoutMsg%></h5>
	</div>
	<%
	// remove so it only shows once
	session.removeAttribute("checkoutSuccessMessage");
	}
	%>

	<div class="home-wrapper">

		<!-- ===========================================================
     ===================== PUBLIC VIEW ===========================
     Shown when user is NOT logged in
     =========================================================== -->
		<%
		if (role.equals("public")) {
		%>

		<!-- ==================== HERO SECTION ==================== -->
		<div class="hero-card mb-4">
			<div class="row align-items-center">

				<!-- LEFT IMAGE -->
				<div class="col-md-6 mb-3 mb-md-0">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="hero-img" alt="Silver Care – Elderly care">
				</div>

				<!-- RIGHT TEXT -->
				<div class="col-md-6 ps-md-4">
					<span class="role-tag">Public View</span>

					<h2 class="hero-title mt-3">Your Loved Ones, Our Priority</h2>
					<p class="hero-subtitle">In need of care, call Silver Care! We
						make elderly care simple, personal, and worry-free. Browse our
						caring services and find the support that best fits your family’s
						needs.</p>

					<!-- CTA Button for registration -->
					<a
						href="<%=request.getContextPath()%>/registerPage/registerPage.jsp"
						class="btn btn-soft-primary btn-sm me-2"> Book Now </a>
				</div>
			</div>
		</div>

		<!-- ==================== SECTION HEADER ==================== -->
		<div class="section-header">
			<h3 class="section-title">Service Categories</h3>
			<span class="section-subtitle">Browse available care options
				at a glance.</span>
		</div>
		<hr>

		<!-- ==================== SEARCH BAR ==================== -->
		<div class="search-card">
			<form class="d-flex" method="get"
				action="<%=request.getContextPath()%>/categories">

				<!-- Search text field (keeps previous value when searching) -->
				<input type="text" class="form-control me-2" name="search"
					placeholder="Search by category or service name..."
					value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">

				<button class="btn btn-soft-blue" type="submit">Search</button>
			</form>
		</div>

		<!-- ==================== CATEGORY GRID ==================== -->
		<div class="row mt-3 g-4">

			<%
			/* Loop through all categories */
			for (Category c : categories) {
			%>

			<div class="col-md-4 d-flex">
				<!-- Whole card links to product detail page -->
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=c.getId()%>"
					class="text-decoration-none text-dark" style="flex: 1;">

					<div class="category-card flex-fill">

						<!-- Category image -->
						<%
						if (c.getImageUrl() != null) {
						%>
						<img src="<%=c.getImageUrl()%>" alt="<%=c.getName()%>">
						<%
						}
						%>

						<!-- Card content -->
						<div class="card-body">
							<h5 class="category-name"><%=c.getName()%></h5>
							<p class="category-desc"><%=c.getDescription()%></p>

							<p class="services-label">Type of services</p>

							<!-- Services list -->
							<ul class="services-list">

								<%
								/* If category contains services */
														if (c.getServices() != null && !c.getServices().isEmpty()) {

															for (model.Service.Service s : c.getServices()) {

																/* Highlighted if search matched service name */
																if (s.isHighlighted()) {
								%>
								<li class="highlight-service"><%=s.getName()%></li>
								<%
								} else {
								%>
								<li><%=s.getName()%></li>
								<%
								}
														}

														} else {
								%>

								<!-- No services case -->
								<li style="color: #888;">No services available</li>

								<%
								}
								%>

							</ul>
						</div>
					</div>
				</a>
			</div>

			<%
			} // end category loop
			%>

		</div>

		<%
		} // END PUBLIC VIEW
		%>

		<!-- ===========================================================
     ===================== MEMBER VIEW ===========================
     Visible when logged-in user has role "member"
     =========================================================== -->
		<%
		if (role.equals("member")) {
		%>

		<!-- =============== HERO SECTION for Member =============== -->
		<div class="hero-card mb-4">
			<div class="row align-items-center">

				<!-- LEFT: Hero Image -->
				<div class="col-md-6 mb-3 mb-md-0">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="hero-img" alt="Silver Care – Elderly care">
				</div>

				<!-- RIGHT: Welcome message + book now -->
				<div class="col-md-6 ps-md-4">
					<span class="role-tag">Member View</span>

					<h2 class="hero-title mt-3">
						Welcome,
						<%=username%>!
					</h2>

					<p class="hero-subtitle">In need of care, call Silver Care!
						Explore curated services tailored to support your loved ones in
						the comfort of home.</p>

					<!-- Button scrolls to category list -->
					<a href="#categories" class="btn btn-soft-primary btn-sm me-2">Book
						Now</a>
				</div>

			</div>
		</div>

		<!-- ==================== SECTION HEADER ==================== -->
		<div class="section-header" id="categories">
			<h3 class="section-title">Service Categories</h3>
			<span class="section-subtitle"> Choose a category to see
				detailed services. </span>
		</div>
		<hr>

		<!-- ==================== SEARCH BAR ==================== -->
		<div class="search-card">
			<form class="d-flex mb-0" method="get"
				action="<%=request.getContextPath()%>/categories">

				<input type="text" class="form-control me-2" name="search"
					placeholder="Search by category or service name..."
					value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">

				<button class="btn btn-soft-blue" type="submit">Search</button>
			</form>
		</div>

		<!-- ==================== CATEGORY GRID ==================== -->
		<div class="row mt-3 g-4">

			<%
			for (Category c : categories) {
			%>

			<div class="col-md-4 d-flex">

				<!-- Entire card links to product detail page -->
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=c.getId()%>"
					class="text-decoration-none text-dark" style="flex: 1;">

					<div class="category-card flex-fill">

						<!-- Category image -->
						<%
						if (c.getImageUrl() != null) {
						%>
						<img src="<%=c.getImageUrl()%>" alt="<%=c.getName()%>">
						<%
						}
						%>

						<div class="card-body">

							<!-- Name + Description -->
							<h5 class="category-name"><%=c.getName()%></h5>
							<p class="category-desc"><%=c.getDescription()%></p>

							<!-- Services -->
							<p class="services-label">Type of services</p>

							<ul class="services-list">

								<%
								if (c.getServices() != null && !c.getServices().isEmpty()) {

															for (model.Service.Service s : c.getServices()) {

																if (s.isHighlighted()) {
								%>
								<!-- Highlight services that matched search -->
								<li class="highlight-service"><%=s.getName()%></li>
								<%
								} else {
								%>
								<li><%=s.getName()%></li>
								<%
								}
														}

														} else {
								%>
								<!-- If no services found -->
								<li style="color: #888;">No services available</li>
								<%
								}
								%>

							</ul>

						</div>
					</div>

				</a>
			</div>

			<%
			} // end category loop
			%>

		</div>

		<%
		} // END MEMBER VIEW
		%>
		<!-- ===========================================================
     ======================= ADMIN VIEW =========================
     Visible only when user role = "admin"
     =========================================================== -->
		<%
		if (role.equals("admin")) {
		%>

		<!-- ======================= HERO SECTION ======================= -->
		<div class="hero-card mb-4">
			<div class="row align-items-center">

				<!-- LEFT: Hero Image -->
				<div class="col-md-6 mb-3 mb-md-0">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="hero-img" alt="Silver Care – Elderly care">
				</div>

				<!-- RIGHT: Admin welcome text -->
				<div class="col-md-6 ps-md-4">
					<span class="role-tag">Admin View</span>

					<h2 class="hero-title mt-3">
						Welcome, Admin
						<%=username%>!
					</h2>

					<p class="hero-subtitle">Manage service categories, edit
						descriptions, and ensure families can easily find the care they
						need.</p>

					<!-- Disabled button (admins cannot book services) -->
					<button class="btn btn-secondary mt-2" disabled>Book Now
						(disabled)</button>
				</div>

			</div>
		</div>

		<!-- ======================= SECTION HEADER ======================= -->
		<div class="section-header">
			<h3 class="section-title m-0">Service Categories</h3>

			<!-- Add New Category Button -->
			<a href="<%=request.getContextPath()%>/categories?action=add"
				class="btn btn-soft-primary btn-sm me-2"> Add </a>
		</div>
		<hr>

		<!-- ======================= SEARCH BAR ======================= -->
		<div class="search-card">
			<form class="d-flex mb-0" method="get"
				action="<%=request.getContextPath()%>/categories">

				<input type="text" class="form-control me-2" name="search"
					placeholder="Search by category or service name..."
					value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">

				<button class="btn btn-soft-blue" type="submit">Search</button>
			</form>
		</div>

		<!-- ======================= CATEGORY GRID ======================= -->
		<div class="row mt-3 g-4">

			<%
			for (Category c : categories) {
			%>

			<div class="col-md-4 d-flex">

				<!-- Link entire card to product detail -->
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=c.getId()%>"
					class="text-decoration-none text-dark" style="flex: 1;">

					<div class="category-card flex-fill">

						<!-- Category image -->
						<%
						if (c.getImageUrl() != null) {
						%>
						<img src="<%=c.getImageUrl()%>" alt="<%=c.getName()%>">
						<%
						}
						%>

						<div class="card-body">

							<!-- Category info -->
							<h5 class="category-name"><%=c.getName()%></h5>
							<p class="category-desc"><%=c.getDescription()%></p>

							<p class="services-label">Type of services</p>

							<ul class="services-list">

								<%
								if (c.getServices() != null && !c.getServices().isEmpty()) {

															for (model.Service.Service s : c.getServices()) {

																if (s.isHighlighted()) {
								%>
								<!-- Highlight matching search results -->
								<li class="highlight-service"><%=s.getName()%></li>
								<%
								} else {
								%>
								<li><%=s.getName()%></li>
								<%
								}
								}

								} else {
								%>
								<!-- If no services exist -->
								<li style="color: #888;">No services available</li>
								<%
								}
								%>

							</ul>

							<!-- =================== ADMIN ACTION BUTTONS =================== -->
							<div class="card-actions mt-2">

								<!-- Edit category -->
								<a
									href="<%=request.getContextPath()%>/categories?action=edit&id=<%=c.getId()%>"
									class="btn btn-soft-warning btn-sm me-2"> Edit </a>

								<!-- Delete category -->
								<a
									href="<%=request.getContextPath()%>/categories?action=delete&id=<%=c.getId()%>"
									class="btn btn-soft-danger btn-sm me-2"> Delete </a>

							</div>

						</div>
					</div>
				</a>
			</div>

			<%
			} // end category loop
			%>

		</div>

		<%
		} // END ADMIN VIEW
		%>

	</div>
	<!-- /home-wrapper -->
	<%@ include file="../common/footer.jsp"%>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
