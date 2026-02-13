<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*,model.Service.ServiceInquiry"%>
<!-- Ong Jin Kai, 2429465 -->
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

	<%-- Includes shared navigation bar fragment for consistent admin layout --%>
	<%@ include file="../common/navbar.jsp"%>

	<div class="container mt-5">

		<%
		// ===== ADMIN GUARD =====
		// Retrieves existing session without creating a new one
		HttpSession s = request.getSession(false);

		// Redirects to login when session missing or role is not admin
		if (s == null || !"admin".equals(s.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
			return;
		}

		// Reads inquiries list from request scope; controller should populate this attribute
		@SuppressWarnings("unchecked")
		List<ServiceInquiry> inquiries = (List<ServiceInquiry>) request.getAttribute("inquiries");

		// Reads current status filter from query string; defaults to empty string for "All"
		String status = request.getParameter("status");
		if (status == null)
			status = "";

		// Reads free-text search query from query string; defaults to empty string when missing
		String q = request.getParameter("q");
		if (q == null)
			q = "";
		%>

		<%-- Page heading --%>
		<h1 class="mb-4">Service Inquiries</h1>

		<!-- FILTER BAR -->
		<div class="revenue-card mb-4">
			<div
				class="d-flex justify-content-between align-items-center flex-wrap gap-3">
				<%-- Section title for filter controls --%>
				<h5 class="fw-bold mb-0">Manage inquiries</h5>

				<%-- GET form submits filter/search parameters to the inquiries listing endpoint --%>
				<form method="get"
					action="<%=request.getContextPath()%>/admin/inquiries"
					class="d-flex align-items-center gap-3">
					<span class="filter-text">Filter by</span>

					<%-- Dropdown selects inquiry status; preserves selected option based on current query parameter --%>
					<select name="status"
						class="form-select form-select-sm" style="width: 160px;">
						<option value="" <%=status.equals("") ? "selected" : ""%>>All</option>
						<option value="NEW" <%=status.equals("NEW") ? "selected" : ""%>>NEW</option>
						<option value="READ"
							<%=status.equals("READ") ? "selected" : ""%>>READ</option>
						<option value="ARCHIVED"
							<%=status.equals("ARCHIVED") ? "selected" : ""%>>ARCHIVED</option>
					</select>

					<%-- Search input for filtering by name/email; preserves typed value across requests --%>
					<input type="text" name="q" value="<%=q%>"
						class="form-control form-control-sm" style="width: 260px;"
						placeholder="Search name/email">

					<%-- Submits filters to reload the page with selected status and search query --%>
					<button class="btn btn-dark btn-sm" type="submit">Apply</button>

					<%-- Resets filters by navigating to listing endpoint without parameters --%>
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
							<%-- Table headers describing inquiry fields displayed --%>
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
						// Displays empty state row when no inquiries are available
						if (inquiries == null || inquiries.isEmpty()) {
						%>
						<tr>
							<td colspan="8" class="text-center py-4 text-muted">No
								inquiries found.</td>
						</tr>
						<%
						} else {
						// Iterates each inquiry and renders a table row
						for (ServiceInquiry si : inquiries) {

							// Reads status value to determine badge label and styling
							String st = si.getStatus();

							// Default badge style is "read" unless overridden by NEW or ARCHIVED
							String badgeClass = "badge-read";
							if ("NEW".equals(st))
								badgeClass = "badge-new";
							if ("ARCHIVED".equals(st))
								badgeClass = "badge-archived";
						%>
						<tr>
							<%-- Renders inquiry identifier with # prefix for readability --%>
							<td>#<%=si.getInquiryId()%></td>

							<%-- Renders created timestamp/string as provided by model --%>
							<td><%=si.getCreatedAt()%></td>

							<%-- Renders requester name --%>
							<td><%=si.getName()%></td>

							<%-- Renders requester email --%>
							<td><%=si.getEmail()%></td>

							<%-- Renders inquiry category --%>
							<td><%=si.getCategory()%></td>

							<%-- Renders preferred contact method --%>
							<td><%=si.getPreferredContact()%></td>

							<%-- Renders status with a colored badge based on status type --%>
							<td><span class="badge <%=badgeClass%>"><%=st%></span></td>

							<%-- Provides link to view inquiry details; auto=1 can be used by controller to mark as read --%>
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
