<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%--
Ong Jin Kai
2429465
 --%>
<%@ page import="java.util.List"%>
<%@ page import="model.Bookings.BookingDetailAppointment"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Appointment Management</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">
<style>
:root {
	--bg: #f6f7fb;
	--card: #ffffff;
	--text: #1f2937;
	--muted: #6b7280;
	--border: #e5e7eb;
	--shadow: 0 8px 24px rgba(0, 0, 0, .08);
	--blue: #2563eb;
	--blue2: #1d4ed8;
	--green: #16a34a;
	--amber: #d97706;
	--red: #dc2626;
	--slate: #64748b;
	--purple: #7c3aed;
}

* {
	box-sizing: border-box;
}

body {
	margin: 0;
	font-family: system-ui, -apple-system, Segoe UI, Roboto, Arial,
		sans-serif;
	background: var(--bg);
	color: var(--text);
}

.page {
	max-width: 1200px;
	margin: 28px auto;
	padding: 0 16px;
}

.header {
	display: flex;
	align-items: center;
	justify-content: space-between;
	gap: 16px;
	margin-bottom: 16px;
}

.title h2 {
	margin: 0;
	font-size: 22px;
	letter-spacing: .2px;
}

.title p {
	margin: 4px 0 0;
	color: var(--muted);
	font-size: 13px;
}

.card {
	background: var(--card);
	border: 1px solid var(--border);
	border-radius: 14px;
	box-shadow: var(--shadow);
	overflow: hidden;
}

.table-wrap {
	width: 100%;
}

table {
	width: 100%;
	table-layout: fixed; /* 🔑 forces columns to fit */
}

thead th {
	position: sticky;
	top: 0;
	background: #f9fafb;
	color: #111827;
	font-weight: 600;
	font-size: 13px;
	text-transform: uppercase;
	letter-spacing: .04em;
	border-bottom: 1px solid var(--border);
	padding: 12px 10px;
	white-space: nowrap;
}

tbody td {
	border-bottom: 1px solid var(--border);
	padding: 12px 10px;
	font-size: 14px;
	vertical-align: top;
}

tbody tr:nth-child(even) {
	background: #fcfcfd;
}

.muted {
	color: var(--muted);
	font-size: 13px;
}

.mono {
	font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas,
		"Liberation Mono", "Courier New", monospace;
}

.time {
	font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas,
		"Liberation Mono", "Courier New", monospace;
	font-size: 12px;
	line-height: 1.35;
	white-space: normal;
	word-break: break-word;
}

.time .lbl {
	color: var(--muted);
	font-weight: 600;
	font-size: 11px;
	margin-right: 6px;
}

/* status badge */
.badge {
	display: inline-block;
	padding: 4px 10px;
	border-radius: 999px;
	font-size: 12px;
	font-weight: 600;
	border: 1px solid transparent;
	white-space: nowrap;
}

.b0 {
	background: rgba(100, 116, 139, .12);
	color: var(--slate);
	border-color: rgba(100, 116, 139, .25);
} /* not assigned */
.b1 {
	background: rgba(22, 163, 74, .12);
	color: var(--green);
	border-color: rgba(22, 163, 74, .25);
} /* assigned */
.b2 {
	background: rgba(217, 119, 6, .12);
	color: var(--amber);
	border-color: rgba(217, 119, 6, .25);
} /* checked in */
.b3 {
	background: rgba(124, 58, 237, .12);
	color: var(--purple);
	border-color: rgba(124, 58, 237, .25);
} /* checked out */
.b4 {
	background: rgba(220, 38, 38, .12);
	color: var(--red);
	border-color: rgba(220, 38, 38, .25);
} /* cancelled */

/* action area */
.actions {
	display: flex;
	flex-direction: column;
	gap: 8px;
	min-width: 190px;
}

form {
	margin: 0;
}

select, input[type="number"] {
	width: 100%;
	padding: 8px 10px;
	border: 1px solid var(--border);
	border-radius: 10px;
	outline: none;
	font-size: 13px;
	background: #fff;
}

select:focus, input[type="number"]:focus {
	border-color: rgba(37, 99, 235, .45);
	box-shadow: 0 0 0 3px rgba(37, 99, 235, .12);
}

.page .btn {
	width: 100%;
	padding: 9px 10px;
	border: 1px solid transparent;
	border-radius: 10px;
	font-weight: 600;
	font-size: 13px;
	cursor: pointer;
}

.page .btn-primary {
	background: var(--blue);
	color: white;
}

.page .btn-primary:hover {
	background: var(--blue2);
}

.page .btn-outline {
	background: white;
	border-color: var(--border);
	color: #111827;
}

.page .btn-outline:hover {
	background: #f9fafb;
}

.page .btn-danger {
	background: #fff;
	border-color: rgba(220, 38, 38, .35);
	color: var(--red);
}

.page .btn-danger:hover {
	background: rgba(220, 38, 38, .08);
}

.empty {
	padding: 18px;
	color: var(--muted);
	font-size: 14px;
}

.cell-small {
	white-space: nowrap;
}

.cell-wide {
	min-width: 220px;
}

th, td {
	word-wrap: break-word;
	overflow-wrap: break-word;
}

.col-customer {
	width: 170px;
}

.col-service {
	width: 160px;
}

.col-time {
	width: 200px;
}

.col-req {
	width: 220px;
}

.col-status {
	width: 110px;
}

.col-caregiver {
	width: 160px;
}

.col-actions {
	width: 190px;
}
</style>
</head>

<body>
	<%-- Includes shared navbar fragment for consistent admin navigation --%>
	<%@ include file="../common/navbar.jsp"%>
	<div class="page">

		<div class="header">
			<div class="title">
				<h2>Appointment Management (Admin)</h2>
				<p>
					Paid appointments from <span class="mono">booking_details</span>.
					Assign caregiver, update status, or cancel.
				</p>
			</div>
		</div>

		<%
		// Reads appointment list from request scope; servlet/controller should set "items" attribute
		List<BookingDetailAppointment> items = (List<BookingDetailAppointment>) request.getAttribute("items");

		// Displays empty state when no appointment records are available
		if (items == null || items.isEmpty()) {
		%>
		<div class="card">
			<div class="empty">No appointments found.</div>
		</div>
		<%
		} else {
		%>

		<div class="card">
			<div class="table-wrap">
				<table>
					<thead>
						<tr>
							<th class="col-customer">Customer</th>
							<th class="col-service">Service</th>
							<th class="col-time">Time</th>
							<th class="col-status">Status</th>
							<th class="col-caregiver">Caregiver</th>
							<th class="col-actions">Actions</th>
						</tr>
					</thead>


					<tbody>
						<%
						// Iterates every appointment record and renders a single table row per record
						// Each iteration derives display label and CSS badge class based on caregiver_status value
						// Data fields are pulled from BookingDetailAppointment getters for customer/service/time/caregiver details
						// Action forms embed the current detailId so updates target the correct booking_details row
						for (BookingDetailAppointment item : items) {
							// Reads caregiver status code for conditional rendering and form pre-selection
							int st = item.getCaregiverStatus();

							// Converts numeric status code into human-readable label for status column
							String label = (st == 0) ? "Not Assigned"
							: (st == 1) ? "Assigned"
									: (st == 2) ? "Checked In" : (st == 3) ? "Checked Out" : (st == 4) ? "Cancelled" : "Unknown";

							// Maps numeric status code into a corresponding badge CSS class for visual styling
							String badgeClass = (st == 0) ? "badge b0"
							: (st == 1) ? "badge b1"
									: (st == 2) ? "badge b2" : (st == 3) ? "badge b3" : (st == 4) ? "badge b4" : "badge b0";
						%>
						<tr>
							<td>
								<div>
									<strong><%=item.getCustomerName()%></strong>
								</div>
								<div class="muted"><%=item.getCustomerPhone()%></div>
							</td>

							<td><strong><%=item.getServiceName()%></strong> <%
 if (item.getSpecialRequest() != null && !item.getSpecialRequest().isBlank()) {
 %>
								<div class="muted" style="margin-top: 4px;">
									<em>Request:</em>
									<%=item.getSpecialRequest()%>
								</div> <%
 }
 %></td>


							<td>
								<div class="time">
									<div>
										<span class="lbl">Start:</span><%=item.getStartTime()%></div>
									<div>
										<span class="lbl">End:</span><%=item.getEndTime()%></div>
								</div>
							</td>


							<td><span class="<%=badgeClass%>"><%=label%></span></td>

							<td>
								<%
								if (item.getCaregiverName() == null) {
								%> <span class="muted">Not Assigned</span> <%
 } else {
 %> <strong><%=item.getCaregiverName()%></strong><br> <span
								class="muted"><%=item.getCaregiverContact()%></span> <%
 }
 %>
							</td>


							<td>
								<div class="actions">

									<!-- Update caregiver_status -->
									<form action="<%=request.getContextPath()%>/admin/appointments"
										method="post">
										<input type="hidden" name="action" value="status"> <input
											type="hidden" name="detailId" value="<%=item.getDetailId()%>">
										<select name="caregiverStatus">
											<option value="0" <%=(st == 0 ? "selected" : "")%>>Not
												Assigned</option>
											<option value="1" <%=(st == 1 ? "selected" : "")%>>Assigned</option>
											<option value="2" <%=(st == 2 ? "selected" : "")%>>Checked
												In</option>
											<option value="3" <%=(st == 3 ? "selected" : "")%>>Checked
												Out</option>
											<option value="4" <%=(st == 4 ? "selected" : "")%>>Cancelled</option>
										</select>

										<button class="btn btn-primary" type="submit">Update
											Status</button>
									</form>

									<!-- Assign caregiver -->
									<form action="<%=request.getContextPath()%>/admin/appointments"
										method="post">
										<input type="hidden" name="action" value="assign"> <input
											type="hidden" name="detailId" value="<%=item.getDetailId()%>">
										<input type="number" name="caregiverId"
											placeholder="Caregiver ID" min="1" required>
										<button class="btn btn-outline" type="submit">Assign
											Caregiver</button>
									</form>

									<!-- Cancel -->
									<form action="<%=request.getContextPath()%>/admin/appointments"
										method="post"
										onsubmit="return confirm('Cancel this appointment?');">
										<input type="hidden" name="action" value="cancel"> <input
											type="hidden" name="detailId" value="<%=item.getDetailId()%>">

										<button class="btn btn-danger" type="submit">Cancel
											Appointment</button>
									</form>

								</div>
							</td>
						</tr>

						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>

		<%
		}
		%>

	</div>
	<%@ include file="../common/footer.jsp"%>
</body>
</html>
