<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.CaregiverVisit"%>

<%
Integer cgId = (Integer) session.getAttribute("caregiver_id");
if (cgId == null) {
	response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
	return;
}

String caregiverName = (String) request.getAttribute("caregiverName");
if (caregiverName == null)
	caregiverName = "Caregiver";

@SuppressWarnings("unchecked")
List<CaregiverVisit> requests = (List<CaregiverVisit>) request.getAttribute("requests");
if (requests == null)
	requests = new ArrayList<>();
%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
SimpleDateFormat dt = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silver Care - Service Requests</title>

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
	<%@ include file="../common/navbar.jsp"%>

	<div class="wrap">

		<div class="cardx mb-3">
			<div
				class="d-flex justify-content-between align-items-start flex-wrap gap-2">
				<div>
					<h3 class="title">Service Requests</h3>
					<div class="muted">
						Caregiver: <strong><%=caregiverName%></strong>
					</div>
				</div>
			</div>

			<div class="small-note mt-2">Accepting a request assigns the
				service to you.</div>
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
							<th>Request</th>
							<th style="width: 180px;">Actions</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (CaregiverVisit v : requests) {
						%>
						<tr>
							<td>
								<div>
									<strong><%=dt.format(v.getStartTime())%></strong>
								</div>
								<div class="small-note">
									to
									<%=dt.format(v.getEndTime())%></div>
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
							<td><%=(v.getCustomerAddress() == null || v.getCustomerAddress().trim().isEmpty()) ? "-" : v.getCustomerAddress()%></td>

							<td><%=(v.getSpecialRequest() == null || v.getSpecialRequest().trim().isEmpty()) ? "-" : v.getSpecialRequest()%></td>


							<td>
								<form method="post"
									action="<%=request.getContextPath()%>/caregiver/accept"
									class="m-0">
									<input type="hidden" name="detailId"
										value="<%=v.getDetailId()%>">
									<button type="submit" class="btn btn-primary btn-sm">
										Accept</button>
								</form>
							</td>
						</tr>
						<%
						}

						if (requests.isEmpty()) {
						%>
						<tr>
							<td colspan="6" class="text-center text-muted py-4">No open
								service requests.</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>
		</div>

	</div>

	<%@ include file="../common/footer.jsp"%>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
