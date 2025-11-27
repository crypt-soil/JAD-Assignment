<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Service"%>

<%
// Retrieve service data passed from the servlet
Service s = (Service) request.getAttribute("service");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Edit Service - <%=s.getName()%></title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ============================
   GLOBAL PAGE STYLES
   ============================ */
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrapper {
	max-width: 650px;
	margin: 40px auto;
}

.form-card {
	background: #ffffff;
	padding: 35px 40px;
	border-radius: 16px;
	box-shadow: 0 12px 28px rgba(0, 0, 0, 0.07);
}

/* Title styling */
.page-title {
	font-weight: 700;
	font-size: 1.7rem;
	color: #4b37b8;
}

/* Label text */
.label-text {
	font-weight: 600;
	color: #4b4b4b;
}

.form-control {
	padding: 12px;
	border-radius: 10px;
}

/* Primary button: soft purple */
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

/* Cancel button */
.btn-soft-cancel {
	background: #f1f1f1;
	color: #555;
	border: 1px solid #d6d6d6;
	font-weight: 600;
	text-decoration: none;
	display: inline-block;
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
		<div class="form-card">

			<!-- Page Heading -->
			<h2 class="page-title mb-3">Edit Service</h2>
			<p class="text-muted mb-4">
				You are editing the service: <strong><%=s.getName()%></strong>
			</p>

			<!-- ============================
                 EDIT SERVICE FORM
                 Sends update request to /service
                 ============================ -->
			<form action="<%=request.getContextPath()%>/service" method="post">

				<!-- Hidden fields needed by servlet -->
				<input type="hidden" name="action" value="update"> <input
					type="hidden" name="id" value="<%=s.getId()%>"> <input
					type="hidden" name="catId" value="<%=s.getCategoryId()%>">

				<!-- SERVICE NAME -->
				<div class="mb-3">
					<label class="form-label label-text">Service Name</label> <input
						type="text" name="name" class="form-control"
						value="<%=s.getName()%>" required>
				</div>

				<!-- DESCRIPTION -->
				<div class="mb-3">
					<label class="form-label label-text">Description</label>
					<textarea name="description" class="form-control" rows="3" required><%=s.getDescription()%></textarea>
				</div>

				<!-- PRICE -->
				<div class="mb-3">
					<label class="form-label label-text">Price ($)</label> <input
						type="number" step="0.01" name="price" class="form-control"
						value="<%=s.getPrice()%>" required>
				</div>

				<!-- IMAGE URL -->
				<div class="mb-3">
					<label class="form-label label-text">Image URL</label> <input
						type="text" name="imageUrl" class="form-control"
						value="<%=s.getImageUrl()%>">
				</div>

				<!-- ACTION BUTTONS -->
				<div class="mt-4">
					<button type="submit" class="btn btn-soft-primary btn-sm me-2">
						Save Changes</button>

					<!-- Cancel → return to category details page -->
					<a
						href="<%=request.getContextPath()%>/productDetail?id=<%=s.getCategoryId()%>"
						class="btn btn-soft-cancel btn-sm ms-2"> Cancel </a>
				</div>

			</form>

		</div>
	</div>

	<!-- Shared footer -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
