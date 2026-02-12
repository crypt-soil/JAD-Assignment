<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.category.Category"%>
<%@ page import="model.Service.Service"%>

<%
// Retrieve the selected category object passed from the servlet
Category cat = (Category) request.getAttribute("category");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%=cat.getName()%> - Details</title>

<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ============================
   GLOBAL STYLING
   ============================ */
body {
	background: #f6f4ff;
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

/* HERO IMAGE */
.hero-img {
	height: 380px;
	width: 100%;
	object-fit: cover;
	border-radius: 14px;
	box-shadow: 0 8px 20px rgba(0, 0, 0, 0.08);
}

/* Category header */
.product-title {
	font-weight: 700;
	font-size: 1.8rem;
}

.product-desc {
	font-size: 0.98rem;
	color: #555;
	line-height: 1.6;
}

/* Role badge */
.role-tag {
	padding: 4px 10px;
	border-radius: 999px;
	font-size: 0.75rem;
	font-weight: 600;
	background: #efe9ff;
	color: #6b4cd8;
	text-transform: uppercase;
}

/* Services section title */
.section-title {
	font-weight: 700;
	font-size: 1.3rem;
}

/* ============================
   SERVICE CARD
   ============================ */
.service-card {
	border-radius: 12px;
	overflow: hidden;
	background: white;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
	transition: transform .2s;
}

.service-card:hover {
	transform: translateY(-3px);
}

.service-card img {
	width: 100%;
	height: 220px;
	object-fit: cover;
}

.service-card .card-body {
	padding: 20px 22px;
}

.service-title {
	font-weight: 600;
	font-size: 1.15rem;
}

.service-desc {
	font-size: 0.95rem;
	color: #555;
}

.service-price {
	font-weight: bold;
	color: #333;
}

/* Buttons */
.btn-soft-primary {
	background: #efe9ff;
	color: #6b4cd8;
	border-color: #d1c2ff;
	font-weight: 600;
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
</style>
</head>

<body>

	<!-- Shared navbar -->
	<%@ include file="../common/navbar.jsp"%>

	<%
	// Determine user role — default to public
	role = (String) session.getAttribute("role");
	if (role == null)
		role = "public";
	%>

	<div class="product-wrapper">
		<div class="product-card">

			<!-- ============================
                 HERO SECTION (Image + Category Info)
                 ============================ -->
			<div class="row align-items-center">

				<!-- LEFT: category image -->
				<div class="col-md-6 mb-4 mb-md-0">
					<img src="<%=cat.getImageUrl()%>" class="hero-img"
						alt="<%=cat.getName()%>">
				</div>

				<!-- RIGHT: category details + admin buttons -->
				<div class="col-md-6 ps-md-4">

					<!-- Role tag changes depending on session -->
					<span class="role-tag"> <%
 if ("admin".equals(role)) {
 %>
						Admin View <%
 } else if ("member".equals(role)) {
 %> Member View <%
 } else {
 %>
						Public View <%
 }
 %>
					</span>

					<h3 class="product-title mt-3"><%=cat.getName()%></h3>
					<p class="product-desc"><%=cat.getDescription()%></p>

					<!-- ============================
                         ADMIN — Edit/Delete Category
                         ============================ -->
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

			<!-- ============================
                 SERVICES HEADER + Admin Add Button
                 ============================ -->
			<div class="d-flex justify-content-between align-items-center mt-5">
				<h4 class="section-title m-0"><%=cat.getName()%>
					Services
				</h4>

				<%
				if ("admin".equals(role)) {
				%>
				<!-- Admin can add a new service -->
				<a
					href="<%=request.getContextPath()%>/service?action=add&catId=<%=cat.getId()%>"
					class="btn btn-soft-primary btn-sm me-2">Add</a>
				<%
				}
				%>
			</div>

			<p class="text-muted mb-3" style="font-size: 0.9rem;">Explore the
				available services under this care category.</p>

			<!-- ============================
                 SERVICES GRID
                 Shows different actions depending on role
                 ============================ -->
			<div class="row g-4 mt-1">

				<%
				// Display services OR fallback message
				if (cat.getServices() != null && !cat.getServices().isEmpty()) {
					for (Service s : cat.getServices()) {
				%>

				<div class="col-md-4">
					<!-- Clicking card = go to service details -->
					<a
						href="<%=request.getContextPath()%>/serviceDetail?id=<%=s.getId()%>"
						class="text-decoration-none text-dark">

						<div class="service-card">

							<!-- Fallback image if none -->
							<img
								src="<%=(s.getImageUrl() != null && !s.getImageUrl().isEmpty()) ? s.getImageUrl()
		: "https://via.placeholder.com/300x180?text=No+Image"%>"
								alt="<%=s.getName()%>">

							<div class="card-body">
								<h5 class="service-title"><%=s.getName()%></h5>
								<p class="service-desc"><%=s.getDescription()%></p>
								<p class="service-price">
									$<%=String.format("%.2f", s.getPrice())%></p>

								<!-- ============================
                                     ROLE-BASED ACTION BUTTONS
                                     ============================ -->

								<%
								if ("member".equals(role)) {
								%>

								<!-- Members can add to cart -->
								<form
									action="<%=request.getContextPath()%>/cartPage/addToCart.jsp?mode=create"
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

								<!-- Admin: edit/delete service -->
								<a
									href="<%=request.getContextPath()%>/service?action=edit&id=<%=s.getId()%>"
									class="btn btn-soft-warning btn-sm me-2">Edit</a> <a
									href="<%=request.getContextPath()%>/service?action=confirmDelete&id=<%=s.getId()%>"
									class="btn btn-soft-danger btn-sm me-2">Delete</a>

								<%
								}
								%>

							</div>
						</div>
					</a>
				</div>

				<%
				}
				} else {
				%>

				<!-- No services message -->
				<div class="col-12">
					<p class="text-muted fst-italic">No services have been added
						under this category yet.</p>
				</div>

				<%
				}
				%>

			</div>
			<!-- /services grid -->
		</div>
		<!-- /product-card -->
	</div>
	<!-- /product-wrapper -->

	<!-- Shared footer -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
