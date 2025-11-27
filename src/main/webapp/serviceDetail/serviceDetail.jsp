<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Service"%>

<%
Service service = (Service) request.getAttribute("service");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title><%=service.getName()%> - Service Details</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff;
	font-family: 'Poppins', sans-serif;
}

.detail-wrapper {
	max-width: 1000px;
	margin: 40px auto;
}

.detail-card {
	background: #fff;
	border-radius: 16px;
	padding: 32px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
}

.detail-img {
	width: 100%;
	height: 360px;
	object-fit: cover;
	border-radius: 14px;
}

.service-title {
	font-size: 2rem;
	font-weight: 700;
}

.service-desc {
	font-size: 1rem;
	color: #555;
	line-height: 1.6;
	margin: 15px 0;
}

.service-price {
	font-size: 1.3rem;
	font-weight: 600;
	color: #4b37b8;
}

.role-tag {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 999px;
	font-size: 0.75rem;
	font-weight: 600;
	background: #efe9ff;
	color: #6b4cd8;
	margin-bottom: 10px;
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

	<div class="detail-wrapper">

		<div class="detail-card">
			<div class="d-flex justify-content-between align-items-center mb-4">
				<!-- LEFT: Role tag -->
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

				<!-- RIGHT: Back to category -->
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=service.getCategoryId()%>"
					class="btn btn-outline-secondary"> ← Back to Category </a>
			</div>



			<div class="row align-items-center mt-2">
				<!-- Left: Image -->
				<div class="col-md-6">
					<img
						src="<%=service.getImageUrl() != null ? service.getImageUrl() : "https://via.placeholder.com/400x300"%>"
						class="detail-img" alt="<%=service.getName()%>">
				</div>

				<!-- Right: Details -->
				<div class="col-md-6 ps-md-4">
					<h2 class="service-title"><%=service.getName()%></h2>
					<p class="service-desc"><%=service.getDescription()%></p>

					<p class="service-price">
						$<%=String.format("%.2f", service.getPrice())%></p>

					<!-- Role-Based Buttons -->
					<%
					if ("member".equals(role)) {
					%>
					<form action="<%=request.getContextPath()%>/cartPage/addToCart.jsp" method="post" style="display:inline;">
					    <input type="hidden" name="serviceId" value="<%=service.getId()%>">
					    <input type="hidden" name="serviceName" value="<%=service.getName()%>">
					    <input type="hidden" name="servicePrice" value="<%=service.getPrice()%>">
					    <button type="submit" class="btn btn-soft-primary btn-sm me-2">
					        Add to Cart
					    </button>
					</form>

					<%
					} else if ("admin".equals(role)) {
					%>
					<a
						href="<%=request.getContextPath()%>/service?action=edit&id=<%=service.getId()%>"
						class="btn btn-soft-warning btn-sm me-2">Edit</a> <a
						href="<%=request.getContextPath()%>/service?action=confirmDelete&id=<%=service.getId()%>"
						class="btn btn-soft-danger btn-sm me-2">Delete</a>

					<%
					}
					%>

					<!-- Public has no buttons -->
				</div>
			</div>

		</div>
	</div>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
