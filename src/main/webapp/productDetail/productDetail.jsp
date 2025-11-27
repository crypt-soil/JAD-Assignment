<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Category"%>
<%@ page import="model.Service"%>

<%
Category cat = (Category) request.getAttribute("category");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%=cat.getName()%> - Details</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff; /* soft lilac */
}

.product-wrapper {
	max-width: 1100px;
	margin: 40px auto;
}

.product-card {
	background: #ffffff;
	border-radius: 16px;
	padding: 32px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.06);
}

.hero-img {
	height: 380px;
	width: 100%;
	object-fit: cover;
	border-radius: 14px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

.product-title {
	font-weight: 700;
	font-size: 1.8rem;
	margin-bottom: 12px;
}

.product-desc {
	font-size: 0.98rem;
	color: #555;
	line-height: 1.6;
}

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

.section-title {
	font-weight: 700;
	font-size: 1.3rem;
	margin-top: 32px;
	margin-bottom: 12px;
}

.service-card {
	border-radius: 12px;
	overflow: hidden; /* prevents image sticking out */
	background: white;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
	transition: transform .2s;
}

.service-card img {
	width: 100%;
	height: 220px;
	object-fit: cover;
}

.service-card:hover {
	transform: translateY(-3px);
}

.service-card .card-body {
	padding: 20px 22px;
	/* <-- THIS IS WHY content won’t be compact anymore */
}

.service-title {
	font-weight: 600;
	font-size: 1.15rem;
	margin-bottom: 6px;
}

.service-desc {
	color: #555;
	font-size: 0.95rem;
	margin-bottom: 12px;
	line-height: 1.45;
}

.service-price {
	font-weight: bold;
	margin-bottom: 15px;
	color: #333;
}

/* Buttons row spacing */
.service-card .btn {
	padding: 6px 14px;
	font-size: 0.9rem;
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
	background: #ffefb0; /* slightly darker yellow on hover */
	color: #8a6c00; /* deeper gold text */
	border-color: #ffd35c;
}

.btn-soft-danger:hover {
	background: #ffd4d4; /* slightly darker soft red */
	color: #9f1f1f; /* deeper red text */
	border-color: #ff9b9b;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<%
	role = (String) session.getAttribute("role");
	if (role == null)
		role = "public";
	%>

	<div class="product-wrapper">
		<div class="product-card">

			<!-- HERO SECTION (shared across all roles) -->
			<div class="row align-items-center">
				<!-- LEFT: Image -->
				<div class="col-md-6 mb-4 mb-md-0">
					<img src="<%=cat.getImageUrl()%>" class="hero-img"
						alt="<%=cat.getName()%>">
				</div>

				<!-- RIGHT: Text + (Admin controls) -->
				<div class="col-md-6 ps-md-4">
					<span class="role-tag"> <%
 if ("admin".equals(role)) {
 %> Admin View <%
 } else if ("member".equals(role)) {
 %> Member View <%
 } else {
 %> Public View <%
 }
 %>
					</span>

					<h3 class="product-title mt-3"><%=cat.getName()%></h3>

					<p class="product-desc">
						<%=cat.getDescription()%>
					</p>

					<!-- ADMIN CATEGORY BUTTONS -->
					<%
					if ("admin".equals(role)) {
					%>
					<div class="mt-3">
						<a
							href="<%=request.getContextPath()%>/categories?action=edit&id=<%=cat.getId()%>"
							class="btn btn-soft-warning btn-sm me-2">Edit</a> <a
							href="<%=request.getContextPath()%>/categories?action=delete&id=<%=cat.getId()%>"
							class="btn btn-soft-danger btn-sm me-2">Delete</a>
					</div>
					<%
					}
					%>
				</div>
			</div>

			<!-- SERVICES TITLE + Add Service (Admin Only) -->
			<div class="d-flex justify-content-between align-items-center mt-5">
				<h4 class="section-title m-0"><%=cat.getName()%>
					Services
				</h4>

				<%
				if ("admin".equals(role)) {
				%>
				<a
					href="<%=request.getContextPath()%>/service?action=add&catId=<%=cat.getId()%>"
					class="btn btn-soft-primary btn-sm me-2"> Add </a>
				<%
				}
				%>
			</div>

			<p class="text-muted mb-3" style="font-size: 0.9rem;">Explore the
				available services under this care category.</p>


			<!-- SERVICES GRID (role-based content) -->
			<div class="row g-4 mt-1">

				<%
				if (cat.getServices() != null && !cat.getServices().isEmpty()) {
					for (Service s : cat.getServices()) {
				%>
				<div class="col-md-4">
					<a
						href="<%=request.getContextPath()%>/serviceDetail?id=<%=s.getId()%>"
						class="text-decoration-none text-dark">
						<div class="service-card">

							<img
								src="<%=(s.getImageUrl() != null && !s.getImageUrl().isEmpty()) ? s.getImageUrl()
		: "https://via.placeholder.com/300x180?text=No+Image"%>"
								alt="<%=s.getName()%>">

							<div class="card-body">
								<h5 class="service-title"><%=s.getName()%></h5>
								<p class="service-desc"><%=s.getDescription()%></p>
								<p class="service-price">
									$<%=String.format("%.2f", s.getPrice())%>
								</p>

								<!-- ROLE-SPECIFIC ACTIONS -->
								<%
								if ("member".equals(role)) {
								%>
								<!-- Member: Add to cart only -->
								<form
									action="<%=request.getContextPath()%>/cartPage/addToCart.jsp"
									method="post" onClick="event.stopPropagation();"
									style="display: inline;">

									<input type="hidden" name="serviceId" value="<%=s.getId()%>">
									<input type="hidden" name="serviceName"
										value="<%=s.getName()%>"> <input type="hidden"
										name="servicePrice" value="<%=s.getPrice()%>">

									<button type="submit" class="btn btn-soft-primary btn-sm me-2">
										Add to Cart</button>
								</form>


								<%
								} else if ("admin".equals(role)) {
								%>
								<!-- Admin: edit / delete -->
								<a
									href="<%=request.getContextPath()%>/service?action=edit&id=<%=s.getId()%>"
									class="btn btn-soft-warning btn-sm me-2">Edit</a> <a
									href="<%=request.getContextPath()%>/service?action=confirmDelete&id=<%=s.getId()%>"
									class="btn btn-soft-danger btn-sm me-2">Delete</a>


								<%
								} // public: no buttons
								%>
							</div>

						</div>
					</a>
				</div>
				<%
				}
				} else {
				%>
				<div class="col-12">
					<p class="text-muted fst-italic">No services have been added
						under this category yet.</p>
				</div>
				<%
				}
				%>

			</div>

		</div>
		<!-- /product-card -->
	</div>
	<!-- /product-wrapper -->
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
