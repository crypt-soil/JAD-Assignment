<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silvercare - Analytics Dashboard</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
.metric-card {
	background-color: #f9f9f9;
	padding: 30px;
	height: 150px;
	border-radius: 8px;
	border: 1px solid #e0e0e0;
}

.revenue-card {
	background-color: #f9f9f9;
	height: 280px;
	border-radius: 8px;
	border: 1px solid #e0e0e0;
	padding: 25px;
}

.panel-card {
	background: #f9f9f9;
	border: 1px solid #e0e0e0;
	border-radius: 8px;
	padding: 18px;
	height: 100%;
}

body {
	background-color: #ffffff;
}

h1 {
	font-weight: 700;
	color: #333;
}

.filter-text {
	font-size: 15px;
	font-weight: 500;
	cursor: pointer;
	color: #333;
}

.muted {
	color: #6b7280;
}

.badge-soft {
	background: #eef2ff;
	color: #3730a3;
	border: 1px solid #e0e7ff;
	font-weight: 600;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<%
	// ✅ Values come from servlet (AdminDashboardServlet)
	Integer totalUsersObj = (Integer) request.getAttribute("totalUsers");
	String popularService = (String) request.getAttribute("popularService");
	Double revenueObj = (Double) request.getAttribute("revenue");
	String range = (String) request.getAttribute("range");

	int totalUsers = (totalUsersObj != null) ? totalUsersObj : 0;
	if (popularService == null)
		popularService = "No data";
	double revenue = (revenueObj != null) ? revenueObj : 0.0;
	if (range == null)
		range = "year";

	@SuppressWarnings("unchecked")
	List<Map<String, Object>> topCaregivers = (List<Map<String, Object>>) request.getAttribute("topCaregivers");
	@SuppressWarnings("unchecked")
	List<Map<String, Object>> worstCaregivers = (List<Map<String, Object>>) request.getAttribute("worstCaregivers");
	@SuppressWarnings("unchecked")
	List<Map<String, Object>> topServices = (List<Map<String, Object>>) request.getAttribute("topServices");
	@SuppressWarnings("unchecked")
	List<Map<String, Object>> worstServices = (List<Map<String, Object>>) request.getAttribute("worstServices");

	// ✅ NEW: demand + availability lists
	@SuppressWarnings("unchecked")
	List<Map<String, Object>> highDemandServices = (List<Map<String, Object>>) request.getAttribute("highDemandServices");
	@SuppressWarnings("unchecked")
	List<Map<String, Object>> lowAvailabilityServices = (List<Map<String, Object>>) request
			.getAttribute("lowAvailabilityServices");

	if (topCaregivers == null)
		topCaregivers = new ArrayList<>();
	if (worstCaregivers == null)
		worstCaregivers = new ArrayList<>();
	if (topServices == null)
		topServices = new ArrayList<>();
	if (worstServices == null)
		worstServices = new ArrayList<>();
	if (highDemandServices == null)
		highDemandServices = new ArrayList<>();
	if (lowAvailabilityServices == null)
		lowAvailabilityServices = new ArrayList<>();

	String revenueHeading = "week".equals(range) ? "Total revenue this week"
			: "month".equals(range) ? "Total revenue this month" : "Total revenue this year";
	%>

	<div class="container mt-5">

		<div class="d-flex justify-content-between align-items-center mb-4">
			<h1 class="mb-0">Analytics Dashboard</h1>
			<span class="badge badge-soft px-3 py-2">Admin only</span>
		</div>

		<!-- TOP METRICS -->
		<div class="row mb-5">
			<div class="col-md-4">
				<div class="metric-card">
					<h5 class="fw-bold">Total Users</h5>
					<p class="mt-3 fs-4"><%=totalUsers%></p>
				</div>
			</div>

			<div class="col-md-1"></div>

			<div class="col-md-4">
				<div class="metric-card">
					<h5 class="fw-bold">Most Popular Service</h5>
					<p class="mt-3 fs-5"><%=popularService%></p>
				</div>
			</div>
		</div>

		<!-- REVENUE -->
		<div class="row mb-5">
			<div class="col-md-12">
				<div class="revenue-card">

					<div class="d-flex justify-content-between align-items-center">
						<h5 class="fw-bold"><%=revenueHeading%></h5>

						<form method="get"
							action="<%=request.getContextPath()%>/admin/analytics"
							class="d-flex align-items-center gap-5">
							<span class="filter-text">Filter by</span> <select name="range"
								class="form-select form-select-sm" onchange="this.form.submit()">
								<option value="week"
									<%="week".equals(range) ? "selected" : ""%>>Week</option>
								<option value="month"
									<%="month".equals(range) ? "selected" : ""%>>Month</option>
								<option value="year"
									<%="year".equals(range) ? "selected" : ""%>>Year</option>
							</select>
						</form>
					</div>

					<p class="mt-4 fs-3">
						$<%=String.format("%.2f", revenue)%></p>
					<div class="muted">
						Based on your function
						<code>fn_revenue(range)</code>
					</div>

				</div>
			</div>
		</div>

		<!-- FEEDBACK-BASED RANKINGS -->
		<div class="row g-4 mb-5">

			<!-- CAREGIVER TOP -->
			<div class="col-md-6">
				<div class="panel-card">
					<h5 class="fw-bold mb-1">Top Rated Caregivers</h5>
					<div class="muted mb-3">Based on caregiver overall rating</div>

					<%
					if (topCaregivers.isEmpty()) {
					%>
					<div class="alert alert-info mb-0">No caregiver rating data
						yet.</div>
					<%
					} else {
					%>
					<div class="table-responsive">
						<table class="table table-sm align-middle mb-0">
							<thead>
								<tr>
									<th>Caregiver</th>
									<th style="width: 140px;">Rating</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Map<String, Object> row : topCaregivers) {
									String name = (String) row.get("name");
									Object rObj = row.get("rating");
									double r = (rObj instanceof Number) ? ((Number) rObj).doubleValue() : 0.0;
								%>
								<tr>
									<td><%=name%></td>
									<td><span class="badge text-bg-success"><%=String.format("%.1f", r)%></span></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
					<%
					}
					%>
				</div>
			</div>

			<!-- CAREGIVER WORST -->
			<div class="col-md-6">
				<div class="panel-card">
					<h5 class="fw-bold mb-1">Lowest Rated Caregivers</h5>
					<div class="muted mb-3">Based on caregiver overall rating</div>

					<%
					if (worstCaregivers.isEmpty()) {
					%>
					<div class="alert alert-info mb-0">No caregiver rating data
						yet.</div>
					<%
					} else {
					%>
					<div class="table-responsive">
						<table class="table table-sm align-middle mb-0">
							<thead>
								<tr>
									<th>Caregiver</th>
									<th style="width: 140px;">Rating</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Map<String, Object> row : worstCaregivers) {
									String name = (String) row.get("name");
									Object rObj = row.get("rating");
									double r = (rObj instanceof Number) ? ((Number) rObj).doubleValue() : 0.0;
								%>
								<tr>
									<td><%=name%></td>
									<td><span class="badge text-bg-danger"><%=String.format("%.1f", r)%></span></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
					<%
					}
					%>
				</div>
			</div>

			<!-- SERVICE TOP -->
			<div class="col-md-6">
				<div class="panel-card">
					<h5 class="fw-bold mb-1">Top Rated Services</h5>
					<div class="muted mb-3">Computed from feedback service
						ratings</div>

					<%
					if (topServices.isEmpty()) {
					%>
					<div class="alert alert-info mb-0">No service feedback data
						yet.</div>
					<%
					} else {
					%>
					<div class="table-responsive">
						<table class="table table-sm align-middle mb-0">
							<thead>
								<tr>
									<th>Service</th>
									<th style="width: 140px;">Avg Rating</th>
									<th style="width: 120px;">Count</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Map<String, Object> row : topServices) {
									String name = (String) row.get("name");
									Object avgObj = row.get("avgRating");
									Object cntObj = row.get("count");

									double avg = (avgObj instanceof Number) ? ((Number) avgObj).doubleValue() : 0.0;
									int cnt = (cntObj instanceof Number) ? ((Number) cntObj).intValue() : 0;
								%>
								<tr>
									<td><%=name%></td>
									<td><span class="badge text-bg-success"><%=String.format("%.1f", avg)%></span></td>
									<td><span class="badge text-bg-secondary"><%=cnt%></span></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
					<%
					}
					%>
				</div>
			</div>

			<!-- SERVICE WORST -->
			<div class="col-md-6">
				<div class="panel-card">
					<h5 class="fw-bold mb-1">Lowest Rated Services</h5>
					<div class="muted mb-3">Computed from feedback service
						ratings</div>

					<%
					if (worstServices.isEmpty()) {
					%>
					<div class="alert alert-info mb-0">No service feedback data
						yet.</div>
					<%
					} else {
					%>
					<div class="table-responsive">
						<table class="table table-sm align-middle mb-0">
							<thead>
								<tr>
									<th>Service</th>
									<th style="width: 140px;">Avg Rating</th>
									<th style="width: 120px;">Count</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Map<String, Object> row : worstServices) {
									String name = (String) row.get("name");
									Object avgObj = row.get("avgRating");
									Object cntObj = row.get("count");

									double avg = (avgObj instanceof Number) ? ((Number) avgObj).doubleValue() : 0.0;
									int cnt = (cntObj instanceof Number) ? ((Number) cntObj).intValue() : 0;
								%>
								<tr>
									<td><%=name%></td>
									<td><span class="badge text-bg-danger"><%=String.format("%.1f", avg)%></span></td>
									<td><span class="badge text-bg-secondary"><%=cnt%></span></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
					<%
					}
					%>
				</div>
			</div>

		</div>

		<!-- ✅ NEW: DEMAND + AVAILABILITY -->
		<div class="row g-4 mb-5">

			<!-- HIGH DEMAND -->
			<div class="col-md-6">
				<div class="panel-card">
					<h5 class="fw-bold mb-1">High Demand Services</h5>
					<div class="muted mb-3">Most booked services in selected time
						range</div>

					<%
					if (highDemandServices.isEmpty()) {
					%>
					<div class="alert alert-info mb-0">No demand data yet.</div>
					<%
					} else {
					%>
					<div class="table-responsive">
						<table class="table table-sm align-middle mb-0">
							<thead>
								<tr>
									<th>Service</th>
									<th style="width: 160px;">Bookings</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Map<String, Object> row : highDemandServices) {
									String name = (String) row.get("name");
									Object dObj = row.get("demandCount");
									int demand = (dObj instanceof Number) ? ((Number) dObj).intValue() : 0;
								%>
								<tr>
									<td><%=name%></td>
									<td><span class="badge text-bg-primary"><%=demand%></span></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
					<%
					}
					%>
				</div>
			</div>

			<!-- LOW AVAILABILITY -->
			<div class="col-md-6">
				<div class="panel-card">
					<h5 class="fw-bold mb-1">Low Availability Services</h5>
					<div class="muted mb-3">Proxy: few assigned caregivers / many
						unassigned</div>

					<%
					if (lowAvailabilityServices.isEmpty()) {
					%>
					<div class="alert alert-info mb-0">No availability data yet.</div>
					<%
					} else {
					%>
					<div class="table-responsive">
						<table class="table table-sm align-middle mb-0">
							<thead>
								<tr>
									<th>Service</th>
									<th style="width: 120px;">Demand</th>
									<th style="width: 140px;">Caregivers</th>
									<th style="width: 140px;">Unassigned</th>
									<th style="width: 140px;">Unassigned %</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (Map<String, Object> row : lowAvailabilityServices) {
									String name = (String) row.get("name");

									int demand = (row.get("demandCount") instanceof Number) ? ((Number) row.get("demandCount")).intValue() : 0;

									int caregiverCount = (row.get("caregiverCount") instanceof Number) ? ((Number) row.get("caregiverCount")).intValue()
									: 0;

									int unassignedCount = (row.get("unassignedCount") instanceof Number)
									? ((Number) row.get("unassignedCount")).intValue()
									: 0;

									double unassignedRate = (row.get("unassignedRate") instanceof Number)
									? ((Number) row.get("unassignedRate")).doubleValue()
									: 0.0;
								%>
								<tr>
									<td><%=name%></td>
									<td><span class="badge text-bg-secondary"><%=demand%></span></td>
									<td><span class="badge text-bg-info"><%=caregiverCount%></span></td>
									<td><span class="badge text-bg-warning"><%=unassignedCount%></span></td>
									<td><span class="badge text-bg-danger"><%=String.format("%.1f", unassignedRate)%>%</span></td>
								</tr>
								<%
								}
								%>
							</tbody>
						</table>
					</div>
					<%
					}
					%>
				</div>
			</div>

		</div>

	</div>

</body>
</html>
