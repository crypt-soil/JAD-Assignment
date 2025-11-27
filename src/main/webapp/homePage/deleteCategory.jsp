<%@ page language="java"%>
<%@ page import="model.Category"%>

<%
Category c = (Category) request.getAttribute("category");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Delete Category - <%=c.getName()%></title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrapper {
	max-width: 600px;
	margin: 60px auto;
}

.confirm-card {
	background: #ffffff;
	padding: 35px 40px;
	border-radius: 16px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.07);
	text-align: center;
}

.title {
	font-weight: 700;
	font-size: 1.6rem;
	color: #c62828;
	margin-bottom: 10px;
}

.category-name {
	font-size: 1.3rem;
	font-weight: 600;
	color: #4b37b8;
}

.category-desc {
	color: #555;
	font-size: 0.95rem;
	margin: 10px 0 25px;
}

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

.icon-warning {
	font-size: 55px;
	color: #e53935;
	margin-bottom: 12px;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="wrapper">
		<div class="confirm-card">


			<h2 class="title">Confirm Delete</h2>
			<p class="text-muted mb-3">You are about to permanently remove
				this category.</p>

			<!-- CATEGORY DETAILS -->
			<div class="category-name"><%=c.getName()%></div>
			<p class="category-desc"><%=c.getDescription()%></p>

			<!-- FORM -->
			<form action="<%=request.getContextPath()%>/categories" method="post"
				class="mt-3">
				<input type="hidden" name="action" value="delete"> <input
					type="hidden" name="id" value="<%=c.getId()%>"> <input
					type="hidden" name="redirectUrl"
					value="<%=request.getHeader("referer")%>">

				<button type="submit" class="btn btn-danger-custom me-2">
					Yes, Delete</button>

				<a href="<%=request.getHeader("referer")%>"
					class="btn btn-soft-cancel btn-sm ms-2"> Cancel </a>

			</form>

		</div>
	</div>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
