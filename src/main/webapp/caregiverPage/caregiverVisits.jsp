<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="java.time.*"%>
<%@ page import="model.caregiver.CaregiverVisit"%>
<%@ page import="java.text.SimpleDateFormat"%>
<!-- Lois Poh 2429478 -->
<%
/* Declares formatter used to display start/end timestamps in a consistent yyyy-MM-dd HH:mm format */
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<%
Integer cgId = (Integer) session.getAttribute("caregiver_id");

if (cgId == null) {
	response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
	return;
}

String caregiverName = (String) request.getAttribute("caregiverName");

/* Provides fallback label when caregiver name attribute missing */
if (caregiverName == null)
	caregiverName = "Caregiver";

/* Reads schedule filter selection from request attributes; attribute expected to be set by servlet/controller */
String filter = (String) request.getAttribute("filter");

/* Defaults filter to "today" when no filter attribute provided */
if (filter == null)
	filter = "today";

/* Reads visits list from request attributes; list expected to contain CaregiverVisit DTOs */
@SuppressWarnings("unchecked")
List<CaregiverVisit> visits = (List<CaregiverVisit>) request.getAttribute("visits");

/* Initializes empty list to avoid null checks during rendering */
if (visits == null)
	visits = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silver Care - Caregiver Schedule</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrap {
	max-width: 1200px;
	margin: 40px auto 60px auto;
}

.cardx {
	background: #ffffff;
	border-radius: 20px;
	padding: 24px;
	box-shadow: 0 16px 40px rgba(0, 0, 0, 0.08);
}

.title {
	font-weight: 700;
	color: #3c2a99;
	margin: 0;
}

.muted {
	color: #666;
}

.small-note {
	color: #888;
	font-size: 0.85rem;
}
</style>
</head>

<body>
	<%-- Includes shared navbar fragment for consistent caregiver layout and navigation --%>
	<%@ include file="../common/navbar.jsp"%>

	<div class="wrap">

		<div class="cardx mb-3">
			<div
				class="d-flex justify-content-between align-items-start flex-wrap gap-2">
				<div>
					<h3 class="title">Schedule</h3>
					<div class="muted">
						Caregiver: <strong><%=caregiverName%></strong>
					</div>
				</div>

				<%-- Filter form submits GET request to refresh table with selected filter value --%>
				<form method="get"
					action="<%=request.getContextPath()%>/caregiver/visits"
					class="d-flex gap-2 align-items-center">
					<label class="form-label mb-0"><strong>Filter</strong></label> <select
						name="filter" class="form-select" onchange="this.form.submit()">
						<option value="today"
							<%="today".equalsIgnoreCase(filter) ? "selected" : ""%>>Today</option>
						<option value="future"
							<%="future".equalsIgnoreCase(filter) ? "selected" : ""%>>Future</option>
						<option value="all"
							<%="all".equalsIgnoreCase(filter) ? "selected" : ""%>>All</option>
					</select>
				</form>
			</div>

			<div class="small-note mt-2">Check-in/out is allowed only on
				the appointment day.</div>
		</div>

		<div class="cardx">
			<div class="table-responsive">
				<table class="table align-middle">
					<thead>
						<tr>
							<th>Time</th>
							<th>Service</th>
							<th>Customer</th>
							<th>Address</th>
							<th>Status</th>
							<th>Request</th>
							<th style="width: 220px;">Actions</th>
						</tr>
					</thead>
					<tbody>
						<%
						/* Captures current local date to decide whether a visit is eligible for check-in/out */
						LocalDate today = LocalDate.now();

						/* Iterates each scheduled visit and renders one table row per visit */
						/* Per-visit logic computes: appointment day match, status badge text/class, and button enablement rules */
						for (CaregiverVisit v : visits) {

							/* Extracts visit calendar date from start timestamp for "is today" comparison */
							LocalDate visitDate = v.getStartTime().toLocalDateTime().toLocalDate();

							/* Determines whether the visit occurs on the current day */
							boolean isToday = visitDate.equals(today);

							/* Initializes default badge styling and label for status display */
							String badgeClass = "bg-secondary";
							String badgeText = "Not Assigned";

							/* Maps caregiver status code into a badge color and readable label */
							switch (v.getCaregiverStatus()) {
							case 1:
								badgeClass = "bg-info text-dark";
								badgeText = "Assigned";
								break;
							case 2:
								badgeClass = "bg-warning text-dark";
								badgeText = "Checked In";
								break;
							case 3:
								badgeClass = "bg-dark";
								badgeText = "Checked Out";
								break;
							case 4:
								badgeClass = "bg-secondary";
								badgeText = "Cancelled";
								break;
							default:
								badgeClass = "bg-secondary";
								badgeText = "Not Assigned";
								break;
							}

							/* Enables Check In only when appointment is today and status is Assigned */
							boolean canCheckIn = isToday && v.getCaregiverStatus() == 1;

							/* Enables Check Out only when appointment is today and status is Checked In */
							boolean canCheckOut = isToday && v.getCaregiverStatus() == 2;
						%>
						<tr>
							<td>
								<div>
									<strong><%= sdf.format(v.getStartTime()) %></strong>
								</div>
								<div class="small-note">
									to
									<%= sdf.format(v.getEndTime()) %></div>
							</td>

							<td>
								<div>
									<strong><%=v.getServiceName()%></strong>
								</div>
								<div class="small-note">
									Booking #<%=v.getBookingId()%>
									• Detail #<%=v.getDetailId()%></div>
							</td>

							<td><%=v.getCustomerName()%></td>
							<td><%=v.getCustomerAddress() == null ? "-" : v.getCustomerAddress()%></td>

							<td><span class="badge <%=badgeClass%>"><%=badgeText%></span></td>

							<td><%=v.getSpecialRequest() == null ? "-" : v.getSpecialRequest()%></td>

							<td>
								<div class="d-flex flex-column gap-2">

									<%-- Check-in form posts detailId to caregiver check-in servlet; button disabled when canCheckIn is false --%>
									<form method="post"
										action="<%=request.getContextPath()%>/caregiver/checkin"
										class="m-0">
										<input type="hidden" name="detailId"
											value="<%=v.getDetailId()%>">
										<button type="submit" class="btn btn-success btn-sm"
											<%=canCheckIn ? "" : "disabled"%>>Check In</button>
									</form>

									<%-- Check-out form posts detailId to caregiver check-out servlet; button disabled when canCheckOut is false --%>
									<form method="post"
										action="<%=request.getContextPath()%>/caregiver/checkout"
										class="m-0">
										<input type="hidden" name="detailId"
											value="<%=v.getDetailId()%>">
										<button type="submit" class="btn btn-dark btn-sm"
											<%=canCheckOut ? "" : "disabled"%>>Check Out</button>
									</form>

									<%
									/* Shows explanatory note when visit is not scheduled for the current day */
									if (!isToday) {
									%>
									<div class="small-note text-muted">Can only check in on
										the day of appointment</div>
									<%
									}
									%>
								</div>
							</td>
						</tr>
						<%
						}

						/* Displays empty state when visit list contains no rows after filtering */
						if (visits.isEmpty()) {
						%>
						<tr>
							<td colspan="7" class="text-center text-muted py-4">No
								visits found for this filter.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>

	</div>

	<%-- Includes shared footer fragment --%>
	<%@ include file="../common/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
