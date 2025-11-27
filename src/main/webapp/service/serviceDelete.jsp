<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Service"%>

<%
// Retrieve the service object passed from the servlet
Service s = (Service) request.getAttribute("service");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Delete Service - <%=s.getName()%></title>

<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ============================
   GLOBAL STYLES
   ============================ */
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrapper {
	max-width: 600px;
	margin: 60px auto;
}

/* Card container */
.confirm-card {
	background: #ffffff;
	padding: 35px 40px;
	border-radius: 16px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.07);
	text-align: center;
}

/* Heading styles */
.title {
	font-weight: 700;
	font-size: 1.6rem;
	color: #c62828;
}

/* Warning icon */
.icon-warning {
	font-size: 55px;
	color: #e53935;
	margin-bottom: 12px;
}

/* Service info styles */
.service-name {
	font-size: 1.3rem;
	font-weight: 600;
	color: #4b37b8;
}

.service-desc {
	color: #555;
	font-size: 0.95rem;
	margin-top: 8px;
}

.service-price {
	font-weight: bold;
	margin: 8px 0;
	color: #333;
}

/* Preview image */
.preview-img {
	width: 100%;
	max-width: 280px;
	height: 160px;
	object-fit: cover;
	border-radius: 10px;
	margin: 12px auto;
	display: block;
	box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
}

/* Buttons */
.btn-danger-custom {
	background: #e53935;
	border-color: #e53935;
	padding: 10px 22px;
	border-radius: 10px;
	font-weight: 600;
}

.btn-danger-custom:hover {
	background: #c62828;
	border-color: #c62828;
}

.btn-soft-cancel {
	background: #f1f1f1;
	color: #555;
	border: 1px solid #d6d6d6;
	font-weight: 600;
	border-radius: 10px;
	padding: 10px 22px;
}

.btn-soft-cancel:hover {
	background: #e4e4e4;
	color: #333;
	border-color: #c2c2c2;
}
</style>
</head>

<body>

	<!-- Shared navbar -->
	<%@ include file="../common/navbar.jsp"%>

	<div class="wrapper">
		<div class="confirm-card">

			<!-- Page Title -->
			<h2 class="title mb-2">Delete Service</h2>

			<p class="text-muted mb-3">You are about to permanently remove
				this service.</p>

			<!-- SERVICE INFORMATION -->
			<div class="service-name"><%=s.getName()%></div>
			<p class="service-desc"><%=s.getDescription()%></p>

			<p class="service-price">
				$<%=String.format("%.2f", s.getPrice())%>
			</p>

			<!-- Service Image Preview -->
			<img
				src="<%=(s.getImageUrl() != null && !s.getImageUrl().isEmpty()) ? s.getImageUrl()
		: "https://via.placeholder.com/300x180?text=No+Image"%>"
				class="preview-img">

			<!-- ============================
                 DELETE FORM
                 Calls /service with action=delete
                 ============================ -->
			<form action="<%=request.getContextPath()%>/service" method="post"
				class="mt-3">

				<!-- Hidden fields needed by servlet -->
				<input type="hidden" name="action" value="delete"> <input
					type="hidden" name="id" value="<%=s.getId()%>"> <input
					type="hidden" name="catId" value="<%=s.getCategoryId()%>">

				<!-- Submit delete -->
				<button type="submit" class="btn btn-danger-custom me-2">
					Yes, Delete</button>

				<!-- Cancel -> back to product detail page -->
				<a
					href="<%=request.getContextPath()%>/productDetail?id=<%=s.getCategoryId()%>"
					class="btn btn-soft-cancel btn-sm ms-2"> Cancel </a>

			</form>

		</div>
	</div>

	<%@ include file="../common/footer.jsp"%>

</body>
</html>
