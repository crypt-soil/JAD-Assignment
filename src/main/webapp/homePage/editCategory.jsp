<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Category"%>

<%
Category c = (Category) request.getAttribute("category");
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Category</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body class="container mt-5">

	<h3>Edit Category</h3>
	<hr>

	<form action="<%=request.getContextPath()%>/categories" method="post">

		<input type="hidden" name="action" value="update"> <input
			type="hidden" name="id" value="<%=c.getId()%>">

		<div class="mb-3">
			<label class="form-label">Category Name</label> <input type="text"
				name="name" class="form-control" value="<%=c.getName()%>" required>
		</div>

		<div class="mb-3">
			<label>Description</label>
			<textarea name="description" class="form-control" rows="4" required><%=c.getDescription()%></textarea>
		</div>

		<div class="mb-3">
			<label>Image URL</label> <input type="text" name="imageUrl"
				class="form-control" value="<%=c.getImageUrl()%>">
		</div>

		<button class="btn btn-primary">Save Changes</button>
		<a href="<%=request.getContextPath()%>/categories"
			class="btn btn-secondary">Cancel</a>

	</form>

</body>
</html>
