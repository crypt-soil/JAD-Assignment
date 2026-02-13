<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%--
Ong Jin Kai
2429465
 --%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Add Category</title>

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ============================
   PAGE STYLES
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

.page-title {
	font-weight: 700;
	font-size: 1.7rem;
	color: #4b37b8;
}

/* Labels */
.label-text {
	font-weight: 600;
	color: #4b4b4b;
}

/* Inputs */
.form-control {
	padding: 12px;
	border-radius: 10px;
}

/* Primary soft button */
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

	<!-- ============================
         NAVBAR INCLUDE
         ============================ -->
	<%@ include file="../common/navbar.jsp"%>

	<div class="wrapper">
		<div class="form-card">

			<!-- Page heading -->
			<h2 class="page-title mb-3">Add New Service Category</h2>
			<p class="text-muted mb-4">Fill in the details to create a new
				category.</p>

			<!-- ==================================================
                 CATEGORY CREATE FORM
                 IMPORTANT: multipart/form-data for file uploads
                 ================================================== -->
			<form action="<%=request.getContextPath()%>/categories" method="post"
				enctype="multipart/form-data">

				<!-- Hidden fields to tell servlet what action to perform -->
				<input type="hidden" name="action" value="create">

				<!-- Store previous page URL so user can be redirected back -->
				<input type="hidden" name="redirectUrl"
					value="<%=request.getHeader("referer")%>">

				<!-- CATEGORY NAME -->
				<div class="mb-3">
					<label class="form-label label-text">Category Name</label> <input
						type="text" name="name" class="form-control"
						placeholder="e.g. Home Care" required>
				</div>

				<!-- DESCRIPTION -->
				<div class="mb-3">
					<label class="form-label label-text">Description</label>
					<textarea name="description" class="form-control" rows="4"
						placeholder="Describe this category..." required></textarea>
				</div>

				<!-- IMAGE URL (Optional) -->
				<div class="mb-3">
					<label class="form-label label-text">Image URL (optional)</label> <input
						type="text" name="imageUrl" class="form-control"
						placeholder="https://...">
					<div class="form-text">If you upload an image below, it will
						override this URL.</div>
				</div>

				<!-- IMAGE UPLOAD (Optional) -->
				<div class="mb-3">
					<label class="form-label label-text">Upload Image
						(optional)</label> <input type="file" name="categoryImage"
						class="form-control" accept="image/*">
				</div>

				<!-- BUTTONS -->
				<div class="mt-4">
					<!-- Submit form to create category -->
					<button type="submit" class="btn btn-soft-primary btn-sm me-2">
						Save Category</button>

					<!-- Cancel: go back to previous page -->
					<a href="<%=request.getHeader("referer")%>"
						class="btn btn-soft-cancel btn-sm ms-2"> Cancel </a>
				</div>

			</form>

		</div>
	</div>

	<!-- ============================
         FOOTER INCLUDE
         ============================ -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
