<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="jakarta.servlet.http.HttpSession, java.util.*, model.Customer"%>

<%
// validates for session and get role attribute
if (session == null || !"admin".equals(session.getAttribute("role"))) {
	response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
	return;
}

@SuppressWarnings("unchecked")
List<Customer> clientList = (List<Customer>) request.getAttribute("clientList");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Silver Care - Management Overview</title>

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
	margin-bottom: 0;
}

.subtitle {
	color: #6b7280;
	margin-top: 6px;
	margin-bottom: 0;
	font-size: 0.95rem;
}

.add-btn {
	background: #ede3ff;
	color: #4b37b8;
	border-radius: 12px;
	padding: 9px 18px;
	font-weight: 700;
	border: none;
	transition: 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 8px;
}

.add-btn:hover {
	background: #d9c7ff;
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
	min-width: 0;
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
	flex-shrink: 0;
}

.user-meta {
	min-width: 0;
}

.username-label {
	font-weight: 700;
	font-size: 1.05rem;
	color: #1f2937;
	margin: 0;
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	max-width: 520px;
}

.small-info {
	margin: 3px 0 0 0;
	color: #6b7280;
	font-size: 0.92rem;
	display: flex;
	flex-wrap: wrap;
	gap: 10px;
	align-items: center;
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
	transition: 0.2s;
}

.btn-edit:hover {
	background: #5a3ab1;
	color: white;
}

.btn-profile {
	background: #ffffff;
	border: 1px solid #d9c7ff;
	color: #4b37b8;
	border-radius: 10px;
	padding: 7px 14px;
	font-weight: 700;
	transition: 0.2s;
}

.btn-profile:hover {
	background: #f5f0ff;
	color: #4b37b8;
}

.btn-delete-icon {
	background: transparent;
	border: none;
	color: #e63946;
	font-size: 1.4rem;
	cursor: pointer;
	padding: 2px 6px;
	border-radius: 10px;
}

.btn-delete-icon:hover {
	color: #b0232f;
	background: rgba(230, 57, 70, 0.08);
}

.user-row-top {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 16px;
	gap: 12px;
}

.top-left {
	display: flex;
	flex-direction: column;
	gap: 2px;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="dashboard-wrapper">

		<!-- TITLE + ADD BUTTON -->
		<div class="user-row-top">
			<div class="top-left">
				<h2 class="section-title">User List</h2>
				<p class="subtitle">Manage user accounts and view medical +
					emergency contact details.</p>
			</div>

			<form action="<%=request.getContextPath()%>/admin/clients/add"
				method="get" class="m-0">
				<button type="submit" class="add-btn">
					<i class="bi bi-plus-lg"></i> Add User
				</button>
			</form>
		</div>

		<!-- USER CARDS -->
		<%
		if (clientList != null && !clientList.isEmpty()) {
			for (Customer c : clientList) {

				String uname = (c.getUsername() == null ? "" : c.getUsername());
				String initials = uname.length() >= 1 ? uname.substring(0, 1).toUpperCase() : "U";

				String email = (c.getEmail() == null || c.getEmail().trim().isEmpty()) ? "-" : c.getEmail();
				String phone = (c.getPhone() == null || c.getPhone().trim().isEmpty()) ? "-" : c.getPhone();
		%>

		<div class="user-card">

			<div class="user-left">
				<div class="avatar"><%=initials%></div>

				<div class="user-meta">
					<p class="username-label mb-0"><%=c.getUsername()%></p>
					<div class="small-info">
						<span class="small-pill">ID: <%=c.getCustomer_id()%></span> <span><i
							class="bi bi-envelope me-1"></i><%=email%></span> <span><i
							class="bi bi-telephone me-1"></i><%=phone%></span>
					</div>
				</div>
			</div>

			<div style="display: flex; gap: 10px; align-items: center;">

				<!-- PROFILE DETAILS (NEW) -->
				<form action="<%=request.getContextPath()%>/admin/clients/profile"
					method="get" class="m-0">
					<input type="hidden" name="id" value="<%=c.getCustomer_id()%>">
					<button type="submit" class="btn-profile">
						<i class="bi bi-person-lines-fill me-1"></i> Profile
					</button>
				</form>

				<!-- EDIT BUTTON -->
				<form action="<%=request.getContextPath()%>/admin/clients/edit"
					method="get" class="m-0">
					<input type="hidden" name="id" value="<%=c.getCustomer_id()%>">
					<button type="submit" class="btn-edit">
						<i class="bi bi-pencil-square me-1"></i> Edit
					</button>
				</form>

				<!-- DELETE BUTTON -->
				<form action="<%=request.getContextPath()%>/admin/clients/delete"
					method="post" class="m-0"
					onsubmit="return confirm('Are you sure you want to delete this user?');">
					<input type="hidden" name="id" value="<%=c.getCustomer_id()%>">
					<button type="submit" class="btn-delete-icon" title="Delete user">🗑️</button>
				</form>
			</div>
		</div>

		<%
		}
		} else {
		%>

		<p class="text-muted mt-4">No registered users found.</p>

		<%
		}
		%>

	</div>

</body>
</html>
