<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.category.Category"%>

<%
// Retrieve the category this service belongs to
Category cat = (Category) request.getAttribute("category");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Add Service - <%=cat.getName()%></title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ============================
   GLOBAL PAGE STYLING
   ============================ */
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrapper {
	max-width: 650px;
	margin: 40px auto;
}

/* Card container for the form */
.form-card {
	background: #ffffff;
	padding: 35px 40px;
	border-radius: 16px;
	box-shadow: 0 12px 28px rgba(0, 0, 0, 0.07);
}

/* Header title */
.page-title {
	font-weight: 700;
	font-size: 1.7rem;
	color: #4b37b8;
}

/* Label text formatting */
.label-text {
	font-weight: 600;
	color: #4b4b4b;
}

.form-control {
	padding: 12px;
	border-radius: 10px;
}

/* Soft purple button */
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

/* Cancel button styling */
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

	<!-- Shared navigation bar -->
	<%@ include file="../common/navbar.jsp"%>

	<div class="wrapper">
		<div class="form-card">

			<!-- Page Heading -->
			<h2 class="page-title mb-3">Add New Service</h2>

			<!-- Subtitle showing which category we’re adding into -->
			<p class="text-muted mb-4">
				You're adding a service to the <strong><%=cat.getName()%></strong>
				category.
			</p>

			<!-- ============================================
                 ADD SERVICE FORM
                 Sends POST to /service with action=insert
                 ============================================ -->
			<form action="<%=request.getContextPath()%>/service" method="post"
				enctype="multipart/form-data">


				<!-- Hidden: command for servlet -->
				<input type="hidden" name="action" value="insert">

				<!-- Hidden: category this service belongs to -->
				<input type="hidden" name="catId" value="<%=cat.getId()%>">

				<!-- SERVICE NAME -->
				<div class="mb-3">
					<label class="form-label label-text">Service Name</label> <input
						type="text" name="name" class="form-control"
						placeholder="e.g. Daily Home Cleaning" required>
				</div>

				<!-- SERVICE DESCRIPTION -->
				<div class="mb-3">
					<label class="form-label label-text">Description</label>
					<textarea name="description" class="form-control" rows="3"
						placeholder="Describe the service..." required></textarea>
				</div>

				<!-- SERVICE PRICE -->
				<div class="mb-3">
					<label class="form-label label-text">Price ($)</label> <input
						type="number" step="0.01" name="price" class="form-control"
						placeholder="e.g. 15.00" required>
				</div>

				<!-- SERVICE IMAGE (URL or Upload) -->
				<div class="mb-3">
					<label class="form-label label-text">Image URL (optional)</label> <input
						type="text" name="imageUrl" class="form-control"
						placeholder="https://... or leave blank">
					<div class="form-text">If you upload an image below, it will
						override this URL.</div>
				</div>

				<div class="mb-3">
					<label class="form-label label-text">Upload Image
						(optional)</label> <input type="file" name="serviceImage"
						class="form-control" accept="image/*">
				</div>


				<!-- FORM BUTTONS -->
				<div class="mt-4">
					<!-- Submit new service -->
					<button type="submit" class="btn btn-soft-primary btn-sm me-2">
						Add Service</button>

					<!-- Return to category detail page -->
					<a
						href="<%=request.getContextPath()%>/productDetail?id=<%=cat.getId()%>"
						class="btn btn-soft-cancel btn-sm ms-2"> Cancel </a>
				</div>

			</form>
		</div>
	</div>

	<!-- Shared footer -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
