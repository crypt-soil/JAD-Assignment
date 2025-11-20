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
</head>
<body class="container mt-5">

	<h3>Add New Service Category</h3>
	<hr>

	<form action="<%=request.getContextPath()%>/categories" method="post">

		<!-- IMPORTANT FIX -->
		<input type="hidden" name="action" value="create">

		<div class="mb-3">
			<label class="form-label">Category Name</label> <input type="text"
				name="name" class="form-control" required>
		</div>

		<div class="mb-3">
			<label class="form-label">Description</label>
			<textarea name="description" class="form-control" rows="4" required></textarea>
		</div>

		<div class="mb-3">
			<label class="form-label">Image URL</label> <input type="text"
				name="imageUrl" class="form-control">
		</div>

		<button type="submit" class="btn btn-primary">Save</button>
		<a href="<%=request.getContextPath()%>/categories"
			class="btn btn-secondary">Cancel</a>
	</form>


</body>
</html>
