<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*,model.Service.ServiceInquiry"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silvercare - Service Inquiries</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background-color: #ffffff;
}

h1 {
	font-weight: 700;
	color: #333;
}

.metric-card {
	background-color: #f9f9f9;
	padding: 20px;
	border-radius: 8px;
	border: 1px solid #e0e0e0;
}

.revenue-card {
	background-color: #f9f9f9;
	border-radius: 8px;
	border: 1px solid #e0e0e0;
	padding: 25px;
}

.filter-text {
	font-size: 15px;
	font-weight: 500;
	cursor: pointer;
	color: #333;
}

.badge-new {
	background: #6d28d9;
}

.badge-read {
	background: #2563eb;
}

.badge-archived {
	background: #64748b;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="container mt-5">

		<%
		// ===== ADMIN GUARD =====
		HttpSession s = request.getSession(false);
		if (s == null || !"admin".equals(s.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
			return;
		}

		@SuppressWarnings("unchecked")
		List<ServiceInquiry> inquiries = (List<ServiceInquiry>) request.getAttribute("inquiries");

		String status = request.getParameter("status");
		if (status == null)
			status = "";

		String q = request.getParameter("q");
		if (q == null)
			q = "";
		%>

		<h1 class="mb-4">Service Inquiries</h1>

		<!-- FILTER BAR -->
		<div class="revenue-card mb-4">
			<div
				class="d-flex justify-content-between align-items-center flex-wrap gap-3">
				<h5 class="fw-bold mb-0">Manage inquiries</h5>

				<form method="get"
					action="<%=request.getContextPath()%>/admin/inquiries"
					class="d-flex align-items-center gap-3">
					<span class="filter-text">Filter by</span> <select name="status"
						class="form-select form-select-sm" style="width: 160px;">
						<option value="" <%=status.equals("") ? "selected" : ""%>>All</option>
						<option value="NEW" <%=status.equals("NEW") ? "selected" : ""%>>NEW</option>
						<option value="READ"
							<%=status.equals("READ") ? "selected" : ""%>>READ</option>
						<option value="ARCHIVED"
							<%=status.equals("ARCHIVED") ? "selected" : ""%>>ARCHIVED</option>
					</select> <input type="text" name="q" value="<%=q%>"
						class="form-control form-control-sm" style="width: 260px;"
						placeholder="Search name/email">

					<button class="btn btn-dark btn-sm" type="submit">Apply</button>
					<a class="btn btn-outline-secondary btn-sm"
						href="<%=request.getContextPath()%>/admin/inquiries">Reset</a>
				</form>
			</div>
		</div>

		<!-- TABLE CARD -->
		<div class="metric-card">
			<div class="table-responsive">
				<table class="table table-hover align-middle mb-0">
					<thead>
						<tr>
							<th>ID</th>
							<th>Date</th>
							<th>Name</th>
							<th>Email</th>
							<th>Category</th>
							<th>Preferred</th>
							<th>Status</th>
							<th class="text-end">Action</th>
						</tr>
					</thead>
					<tbody>
						<%
						if (inquiries == null || inquiries.isEmpty()) {
						%>
						<tr>
							<td colspan="8" class="text-center py-4 text-muted">No
								inquiries found.</td>
						</tr>
						<%
						} else {
						for (ServiceInquiry si : inquiries) {
							String st = si.getStatus();
							String badgeClass = "badge-read";
							if ("NEW".equals(st))
								badgeClass = "badge-new";
							if ("ARCHIVED".equals(st))
								badgeClass = "badge-archived";
						%>
						<tr>
							<td>#<%=si.getInquiryId()%></td>
							<td><%=si.getCreatedAt()%></td>
							<td><%=si.getName()%></td>
							<td><%=si.getEmail()%></td>
							<td><%=si.getCategory()%></td>
							<td><%=si.getPreferredContact()%></td>
							<td><span class="badge <%=badgeClass%>"><%=st%></span></td>
							<td class="text-end"><a class="btn btn-outline-dark btn-sm"
								href="<%=request.getContextPath()%>/admin/inquiries/view?id=<%=si.getInquiryId()%>&auto=1">
									View </a></td>
						</tr>
						<%
						}
						}
						%>
					</tbody>
				</table>
			</div>
		</div>

	</div>

</body>
</html>
