<%@ page language="java"%>
<%@ page import="model.Category"%>

<%
// Retrieve the category object passed from the servlet
Category c = (Category) request.getAttribute("category");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Delete Category - <%=c.getName()%></title>

<!-- Bootstrap -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
/* ============================
   PAGE STYLING
   ============================ */
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrapper {
	max-width: 600px;
	margin: 60px auto;
}

/* Confirmation card container */
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

/* Highlight the category name being deleted */
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

/* Delete (danger) button */
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

/* Warning icon (if you want to add icons later) */
.icon-warning {
	font-size: 55px;
	color: #e53935;
	margin-bottom: 12px;
}
</style>
</head>

<body>

	<!-- ============================
         NAVBAR INCLUDE
         Loads the shared navigation bar
         ============================ -->
	<%@ include file="../common/navbar.jsp"%>

	<div class="wrapper">
		<div class="confirm-card">

			<!-- Title and short message -->
			<h2 class="title">Confirm Delete</h2>
			<p class="text-muted mb-3">You are about to permanently remove
				this category.</p>

			<!-- Display category details for confirmation -->
			<div class="category-name"><%=c.getName()%></div>
			<p class="category-desc"><%=c.getDescription()%></p>

			<!-- ==========================================
                 DELETE FORM
                 Sends POST to /categories?action=delete
                 ========================================== -->
			<form action="<%=request.getContextPath()%>/categories" method="post"
				class="mt-3">

				<!-- Tell servlet to perform DELETE action -->
				<input type="hidden" name="action" value="delete">

				<!-- Category ID to delete -->
				<input type="hidden" name="id" value="<%=c.getId()%>">

				<!-- For redirecting user back after action -->
				<input type="hidden" name="redirectUrl"
					value="<%=request.getHeader("referer")%>">

				<!-- Confirm delete button -->
				<button type="submit" class="btn btn-danger-custom me-2">
					Yes, Delete</button>

				<!-- Cancel button → return to previous page -->
				<a href="<%=request.getHeader("referer")%>"
					class="btn btn-soft-cancel btn-sm ms-2"> Cancel </a>

			</form>

		</div>
	</div>

	<!-- ============================
         FOOTER INCLUDE
         Shared site footer
         ============================ -->
	<%@ include file="../common/footer.jsp"%>

</body>
</html>
