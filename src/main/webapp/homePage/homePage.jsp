<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.List"%>
<%@ page import="model.Category"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silver Care - Home</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<style>
body {
	background: #f6f4ff; /* soft lilac */
	font-family: "Poppins", sans-serif;
} /* Overall wrapper spacing */
.home-wrapper {
	max-width: 1200px;
	margin: 40px auto 60px auto;
} /* HERO SECTION */
.hero-card {
	background: #ffffff;
	border-radius: 20px;
	padding: 32px;
	box-shadow: 0 16px 40px rgba(0, 0, 0, 0.08);
}

.hero-img {
	width: 100%;
	max-height: 360px;
	border-radius: 18px;
	object-fit: cover;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.12);
}

.hero-title {
	font-weight: 700;
	font-size: 2rem;
	color: #4b37b8;
}

.hero-subtitle {
	color: #555;
	font-size: 0.98rem;
	line-height: 1.7;
	margin-top: 12px;
}

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
} /* SECTION TITLE */
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
} /* SEARCH BAR */
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
} /* CATEGORY CARDS */
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

.category-card img {
	width: 100%;
	height: 200px;
	object-fit: cover;
}

.category-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 16px 36px rgba(0, 0, 0, 0.09);
}

.category-card .card-body {
	padding: 16px 18px 18px 18px;
}

.category-name {
	font-weight: 600;
	font-size: 1.1rem;
	margin-bottom: 4px;
}

.category-desc {
	font-size: 0.9rem;
	color: #666;
	min-height: 44px;
}

.services-label {
	font-size: 0.8rem;
	text-transform: uppercase;
	letter-spacing: 0.06em;
	color: #999;
	font-weight: 600;
	margin-top: 10px;
	margin-bottom: 4px;
}

.services-list {
	list-style: none;
	padding-left: 0;
	margin-bottom: 10px;
	font-size: 0.9rem;
}

.services-list li {
	margin-bottom: 2px;
} /* highlighted service from search */
.highlight-service {
	font-weight: 600;
	background: #fff3cd;
	padding: 3px 6px;
	border-radius: 6px;
} /* Buttons on card bottom */
.card-actions .btn {
	font-size: 0.85rem;
	padding: 6px 12px;
} /* Small role tag (admin/member/public) */
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

.btn-soft-primary {
	background: #efe9ff; /* soft purple background */
	color: #6b4cd8; /* purple text */
	border-color: #d1c2ff; /* light purple border */
	font-weight: 600;
}

.btn-soft-primary:hover {
	background: #e2d6ff; /* slightly darker on hover */
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
	background: #ffefb0;   /* slightly darker yellow on hover */
	color: #8a6c00;       /* deeper gold text */
	border-color: #ffd35c;
}


.btn-soft-danger:hover {
	background: #ffd4d4;   /* slightly darker soft red */
	color: #9f1f1f;       /* deeper red text */
	border-color: #ff9b9b;
}


.btn-soft-blue {
	background: #e7f1ff; /* soft pastel blue */
	color: #1b6ec2; /* medium blue text */
	border-color: #bcd9ff; /* light blue border */
	font-weight: 600;
	padding: 9px 20px;
}

.btn-soft-blue:hover {
	background: #d8e7ff; /* darker soft blue */
	color: #155a9c;
	border-color: #9cc7ff;
}
</style>
</head>
<body>
	<%@ include file="../common/navbar.jsp"%>
	<%
	if (role == null)
		role = "public";
	@SuppressWarnings("unchecked")
	List<Category> categories = (List<Category>) request.getAttribute("categories");
	%>
	<!-- Success login notification -->
	<%
	String loginMsg = (String) session.getAttribute("loginMessage");
	if (loginMsg != null) {
	%>
	<div class="alert alert-success text-center mt-3" role="alert">
		<h5 class="mb-0"><%=loginMsg%></h5>
	</div>
	<%
	session.removeAttribute("loginMessage");
	}
	%>
	<div class="home-wrapper">
		<!-- ============================ PUBLIC VIEW ============================ -->
		<%
		if (role.equals("public")) {
		%>
		<!-- HERO -->
		<div class="hero-card mb-4">
			<div class="row align-items-center">
				<div class="col-md-6 mb-3 mb-md-0">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="hero-img" alt="Silver Care – Elderly care">
				</div>
				<div class="col-md-6 ps-md-4">
					<span class="role-tag">Public View</span>
					<h2 class="hero-title mt-3">Your Loved Ones, Our Priority</h2>
					<p class="hero-subtitle">In need of care, call Silver Care! We
						make elderly care simple, personal, and worry-free. Browse our
						caring services and find the support that best fits your family’s
						needs.</p>
					<a
						href="<%=request.getContextPath()%>/registerPage/registerPage.jsp"
						class="btn btn-soft-primary btn-sm me-2"> Book Now </a>
				</div>
			</div>
		</div>
		<!-- SECTION HEADER -->
		<div class="section-header">
			<h3 class="section-title">Service Categories</h3>
			<span class="section-subtitle">Browse available care options
				at a glance.</span>
		</div>
		<hr>
		<!-- SEARCH -->
		<div class="search-card">
			<form class="d-flex" method="get"
				action="<%=request.getContextPath()%>/categories">
				<input type="text" class="form-control me-2" name="search"
					placeholder="Search by category or service name..."
					value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
				<button class="btn btn-soft-blue" type="submit">Search</button>
			</form>
		</div>
		<!-- CATEGORY GRID -->
		<div class="row mt-3 g-4">
			<%
			for (Category c : categories) {
			%>
			<div class="col-md-4 d-flex">
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=c.getId()%>"
					class="text-decoration-none text-dark" style="flex: 1;">
					<div class="category-card flex-fill">
						<%
						if (c.getImageUrl() != null) {
						%>
						<img src="<%=c.getImageUrl()%>" alt="<%=c.getName()%>">
						<%
						}
						%>
						<div class="card-body">
							<h5 class="category-name"><%=c.getName()%></h5>
							<p class="category-desc"><%=c.getDescription()%></p>
							<p class="services-label">Type of services</p>
							<ul class="services-list">
								<%
								if (c.getServices() != null && !c.getServices().isEmpty()) {
									for (model.Service s : c.getServices()) {
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
			}
			%>
		</div>
		<%
		} // end public
		%>
		<!-- ============================ MEMBER VIEW ============================ -->
		<%
		if (role.equals("member")) {
		%>
		<div class="hero-card mb-4">
			<div class="row align-items-center">
				<div class="col-md-6 mb-3 mb-md-0">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="hero-img" alt="Silver Care – Elderly care">
				</div>
				<div class="col-md-6 ps-md-4">
					<span class="role-tag">Member View</span>
					<h2 class="hero-title mt-3">
						Welcome,
						<%=username%>!
					</h2>
					<p class="hero-subtitle">In need of care, call Silver Care!
						Explore curated services tailored to support your loved ones in
						the comfort of home.</p>
					<a href="#categories" class="btn btn-soft-primary btn-sm me-2"> Book Now </a>
				</div>
			</div>
		</div>
		<div class="section-header" id="categories">
			<h3 class="section-title">Service Categories</h3>
			<span class="section-subtitle">Choose a category to see
				service details.</span>
		</div>
		<hr>
		<div class="search-card">
			<form class="d-flex mb-0" method="get"
				action="<%=request.getContextPath()%>/categories">
				<input type="text" class="form-control me-2" name="search"
					placeholder="Search by category or service name..."
					value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
				<button class="btn btn-soft-blue" type="submit">Search</button>

			</form>
		</div>
		<div class="row mt-3 g-4">
			<%
			for (Category c : categories) {
			%>
			<div class="col-md-4 d-flex">
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=c.getId()%>"
					class="text-decoration-none text-dark" style="flex: 1;">
					<div class="category-card flex-fill">
						<%
						if (c.getImageUrl() != null) {
						%>
						<img src="<%=c.getImageUrl()%>" alt="<%=c.getName()%>">
						<%
						}
						%>
						<div class="card-body">
							<h5 class="category-name"><%=c.getName()%></h5>
							<p class="category-desc"><%=c.getDescription()%></p>
							<p class="services-label">Type of services</p>
							<ul class="services-list">
								<%
								if (c.getServices() != null && !c.getServices().isEmpty()) {
									for (model.Service s : c.getServices()) {
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
			}
			%>
		</div>
		<%
		} // end member
		%>
		<!-- ============================ ADMIN VIEW ============================ -->
		<%
		if (role.equals("admin")) {
		%>
		<div class="hero-card mb-4">
			<div class="row align-items-center">
				<div class="col-md-6 mb-3 mb-md-0">
					<img
						src="https://img.freepik.com/premium-photo/healthcare-homecare-nurse-with-grandma-support-her-retirement-medical-old-age-caregiver-volunteer-trust-social-worker-helping-senior-woman-with-demantia-alzheimer_590464-84580.jpg"
						class="hero-img" alt="Silver Care – Elderly care">
				</div>
				<div class="col-md-6 ps-md-4">
					<span class="role-tag">Admin View</span>
					<h2 class="hero-title mt-3">
						Welcome, Admin
						<%=username%>!
					</h2>
					<p class="hero-subtitle">Manage service categories, update
						descriptions, and ensure that families can easily find the support
						they need.</p>
					<button class="btn btn-secondary mt-2" disabled>Book Now
						(disabled)</button>
				</div>
			</div>
		</div>
		<div class="section-header">
			<h3 class="section-title m-0">Service Categories</h3>
			<a href="<%=request.getContextPath()%>/categories?action=add"
				class="btn btn-soft-primary btn-sm me-2"> Add </a>
		</div>
		<hr>
		<div class="search-card">
			<form class="d-flex mb-0" method="get"
				action="<%=request.getContextPath()%>/categories">
				<input type="text" class="form-control me-2" name="search"
					placeholder="Search by category or service name..."
					value="<%=request.getParameter("search") != null ? request.getParameter("search") : ""%>">
				<button class="btn btn-soft-blue" type="submit">Search</button>

			</form>
		</div>
		<div class="row mt-3 g-4">
			<%
			for (Category c : categories) {
			%>
			<div class="col-md-4 d-flex">
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=c.getId()%>"
					class="text-decoration-none text-dark" style="flex: 1;">
					<div class="category-card flex-fill">
						<%
						if (c.getImageUrl() != null) {
						%>
						<img src="<%=c.getImageUrl()%>" alt="<%=c.getName()%>">
						<%
						}
						%>
						<div class="card-body">
							<h5 class="category-name"><%=c.getName()%></h5>
							<p class="category-desc"><%=c.getDescription()%></p>
							<p class="services-label">Type of services</p>
							<ul class="services-list">
								<%
								if (c.getServices() != null && !c.getServices().isEmpty()) {
									for (model.Service s : c.getServices()) {
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
								<li style="color: #888;">No services available</li>
								<%
								}
								%>
							</ul>
							<div class="card-actions mt-2">
								<a
									href="<%=request.getContextPath()%>/categories?action=edit&id=<%=c.getId()%>"
									class="btn btn-soft-warning btn-sm me-2"> Edit </a> <a
									href="<%=request.getContextPath()%>/categories?action=delete&id=<%=c.getId()%>"
									class="btn btn-soft-danger btn-sm me-2"> Delete </a>
							</div>
						</div>
					</div>
				</a>
			</div>
			<%
			}
			%>
		</div>
		<%
		} // end admin
		%>
	</div>
	<!-- /home-wrapper -->
	<%@ include file="../common/footer.jsp"%>
</body>
</html>