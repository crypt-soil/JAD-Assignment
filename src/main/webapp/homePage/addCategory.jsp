<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Add Category</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
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

.page-title {
	font-weight: 700;
	font-size: 1.7rem;
	color: #4b37b8;
}

.label-text {
	font-weight: 600;
	color: #4b4b4b;
}

.form-control {
	padding: 12px;
	border-radius: 10px;
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

.btn-soft-cancel {
	background: #f1f1f1; /* soft light grey */
	color: #555; /* medium grey text */
	border: 1px solid #d6d6d6; /* subtle grey border */
	font-weight: 600;
	border-radius: 10px;
	padding: 10px 22px;
}

.btn-soft-cancel:hover {
	background: #e4e4e4; /* slightly darker grey */
	color: #333;
	border-color: #c2c2c2;
}
</style>

</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="wrapper">
		<div class="form-card">

			<h2 class="page-title mb-3">Add New Service Category</h2>
			<p class="text-muted mb-4">Fill in the details to create a new
				category.</p>

			<form action="<%=request.getContextPath()%>/categories" method="post">

				<input type="hidden" name="action" value="create"> <input
					type="hidden" name="redirectUrl"
					value="<%=request.getHeader("referer")%>">

				<!-- CATEGORY NAME -->
				<div class="mb-3">
					<label class="form-label label-text">Category Name</label> <input
						type="text" name="name" class="form-control" required>
				</div>

				<!-- DESCRIPTION -->
				<div class="mb-3">
					<label class="form-label label-text">Description</label>
					<textarea name="description" class="form-control" rows="4" required></textarea>
				</div>

				<!-- IMAGE URL -->
				<div class="mb-3">
					<label class="form-label label-text">Image URL</label> <input
						type="text" name="imageUrl" class="form-control">
				</div>

				<div class="mt-4">
					<button type="submit" class="btn btn-soft-primary btn-sm me-2">Save
						Category</button>

					<a href="<%=request.getHeader("referer")%>"
						class="btn btn-soft-cancel btn-sm ms-2">Cancel</a>

				</div>

			</form>

		</div>
	</div>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
