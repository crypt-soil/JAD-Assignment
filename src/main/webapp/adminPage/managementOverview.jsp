<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="jakarta.servlet.http.HttpSession, java.util.*, model.Customer"%>

<%
if (session == null || !"admin".equals(session.getAttribute("role"))) {
	response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
	return;
}

@SuppressWarnings("unchecked")
List<Customer> clientList = (List<Customer>) request.getAttribute("clientList");

String q = request.getParameter("q");
String zipcode = request.getParameter("zipcode");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Silver Care - Client Inquiry</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">

<style>
body {
	background: #f2f0ff;
	font-family: "Poppins", sans-serif;
}

.dashboard-wrapper {
	max-width: 1100px;
	margin: 40px auto;
	padding: 0 16px;
}

.section-title {
	font-weight: 700;
	font-size: 1.8rem;
	color: #4b37b8;
}

.subtitle {
	color: #6b7280;
	font-size: 0.95rem;
}

.filter-card {
	background: white;
	border-radius: 16px;
	padding: 18px;
	margin-bottom: 20px;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.08);
}

.user-card {
	background: white;
	border-radius: 16px;
	padding: 18px 20px;
	margin-bottom: 16px;
	box-shadow: 0 6px 18px rgba(0, 0, 0, 0.10);
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 16px;
}

.user-left {
	display: flex;
	align-items: center;
	gap: 14px;
}

.avatar {
	width: 44px;
	height: 44px;
	border-radius: 50%;
	background: #ede3ff;
	color: #4b37b8;
	display: flex;
	align-items: center;
	justify-content: center;
	font-weight: 800;
}

.username-label {
	font-weight: 700;
	font-size: 1.05rem;
	color: #1f2937;
	margin: 0;
}

.small-info {
	margin-top: 4px;
	color: #6b7280;
	font-size: 0.92rem;
	display: flex;
	flex-wrap: wrap;
	gap: 12px;
}

.small-pill {
	background: #f5f0ff;
	color: #4b37b8;
	border-radius: 999px;
	padding: 3px 10px;
	font-weight: 700;
	font-size: 0.82rem;
}

.btn-edit {
	background: #6a4bc7;
	color: white;
	border-radius: 10px;
	padding: 7px 16px;
	border: none;
	font-weight: 700;
}

.btn-profile {
	background: white;
	border: 1px solid #d9c7ff;
	color: #4b37b8;
	border-radius: 10px;
	padding: 7px 14px;
	font-weight: 700;
}

.btn-delete-icon {
	background: transparent;
	border: none;
	color: #e63946;
	font-size: 1.4rem;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="dashboard-wrapper">

		<!-- TITLE -->
		<h2 class="section-title">Client Inquiry</h2>
		<p class="subtitle">Search and filter clients by name or
			residential area</p>

		<!-- 🔍 FILTER / INQUIRY FORM -->
		<div class="filter-card">
			<form class="row g-3" method="get"
				action="<%=request.getContextPath()%>/admin/management">

				<div class="col-md-6">
					<label class="form-label">Search</label> <input type="text"
						class="form-control" name="q"
						placeholder="Username / Full name / Email / Phone"
						value="<%=q == null ? "" : q%>">
				</div>

				<div class="col-md-3">
					<label class="form-label">Zipcode</label> <input type="text"
						class="form-control" name="zipcode" placeholder="e.g. 123456"
						value="<%=zipcode == null ? "" : zipcode%>">
				</div>

				<div class="col-md-3 d-flex align-items-end gap-2">
					<button type="submit" class="btn btn-primary w-100">
						<i class="bi bi-search me-1"></i> Search
					</button>

					<a href="<%=request.getContextPath()%>/admin/clients"
						class="btn btn-outline-secondary w-100"> Clear </a>
				</div>
			</form>
		</div>

		<!-- 👥 CLIENT RESULTS -->
		<%
		if (clientList != null && !clientList.isEmpty()) {
			for (Customer c : clientList) {
				String uname = c.getUsername();
				String initials = uname != null && !uname.isEmpty() ? uname.substring(0, 1).toUpperCase() : "U";
		%>

		<div class="user-card">
			<div class="user-left">
				<div class="avatar"><%=initials%></div>

				<div>
					<p class="username-label"><%=c.getUsername()%></p>
					<div class="small-info">
						<span class="small-pill">ID: <%=c.getCustomer_id()%></span> <span><i
							class="bi bi-person me-1"></i><%=c.getFull_name()%></span> <span><i
							class="bi bi-envelope me-1"></i><%=c.getEmail()%></span> <span><i
							class="bi bi-telephone me-1"></i><%=c.getPhone()%></span> <span><i
							class="bi bi-house me-1"></i><%=c.getZipcode()%></span>
					</div>
				</div>
			</div>

			<div class="d-flex gap-2">
				<form action="<%=request.getContextPath()%>/admin/clients/profile"
					method="get">
					<input type="hidden" name="id" value="<%=c.getCustomer_id()%>">
					<button class="btn-profile">Profile</button>
				</form>

				<form action="<%=request.getContextPath()%>/admin/clients/edit"
					method="get">
					<input type="hidden" name="id" value="<%=c.getCustomer_id()%>">
					<button class="btn-edit">Edit</button>
				</form>

				<form action="<%=request.getContextPath()%>/admin/clients/delete"
					method="post" onsubmit="return confirm('Delete this client?');">
					<input type="hidden" name="id" value="<%=c.getCustomer_id()%>">
					<button class="btn-delete-icon">🗑️</button>
				</form>
			</div>
		</div>

		<%
		}
		} else {
		%>

		<p class="text-muted mt-4">No clients match the inquiry.</p>

		<%
		}
		%>

	</div>

</body>
</html>
