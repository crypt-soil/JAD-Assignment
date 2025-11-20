<%@ page language="java"%>
<%@ page import="model.Category"%>

<%
Category c = (Category) request.getAttribute("category");
%>

<!DOCTYPE html>
<html>
<head>
<title>Delete Category</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
</head>
<body class="container mt-5">

	<h3>Delete Category</h3>
	<hr>

	<p>Are you sure you want to delete the category:</p>

	<h4><%=c.getName()%></h4>
	<p><%=c.getDescription()%></p>

	<form action="<%=request.getContextPath()%>/categories" method="post">
		<input type="hidden" name="action" value="delete"> <input
			type="hidden" name="id" value="<%=c.getId()%>">

		<button class="btn btn-danger">Yes, Delete</button>
		<a href="<%=request.getContextPath()%>/categories"
			class="btn btn-secondary">Cancel</a>
	</form>

</body>
</html>
