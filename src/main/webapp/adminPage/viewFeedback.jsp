<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="model.Feedback.FeedbackView"%>
<!-- Ong Jin Kai
2429465 -->
<%
@SuppressWarnings("unchecked")
List<FeedbackView> feedbackList = (List<FeedbackView>) request.getAttribute("feedbackList");

String success = request.getParameter("success");
String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Feedback</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">

<style>
body {
	background: #f2f4f7;
	font-family: "Poppins", sans-serif;
}

.wrap {
	max-width: 1100px;
	margin: 40px auto;
	padding: 0 16px;
}

.cardx {
	background: #fff;
	border-radius: 18px;
	padding: 28px;
	box-shadow: 0 6px 25px rgba(0, 0, 0, .08);
}

.star {
	color: #f59e0b;
}

.muted {
	color: #6b7280;
}

.badge-soft {
	background: #f3f4f6;
	border: 1px solid #e5e7eb;
	color: #374151;
	border-radius: 999px;
	padding: 4px 10px;
	font-size: .75rem;
	font-weight: 600;
}

.remarks-box {
	background: #f9fafb;
	border: 1px solid #e5e7eb;
	border-radius: 12px;
	padding: 10px 12px;
}
</style>
</head>

<body>
	<%@ include file="../common/navbar.jsp"%>

	<div class="wrap">
		<div class="cardx">
			<div class="d-flex justify-content-between align-items-center mb-3">
				<div>
					<h3 class="mb-0">My Feedback</h3>
					<div class="muted">Your submitted feedback for each booked
						service</div>
				</div>
				<a class="btn btn-outline-secondary"
					href="<%=request.getContextPath()%>/profile?tab=bookings"> <i
					class="bi bi-arrow-left"></i> Back to Bookings
				</a>
			</div>

			<%
			if (success != null) {
			%>
			<div class="alert alert-success"><%=success%></div>
			<%
			}
			%>

			<%
			if (error != null) {
			%>
			<div class="alert alert-danger"><%=error%></div>
			<%
			}
			%>

			<%
			if (feedbackList == null || feedbackList.isEmpty()) {
			%>
			<div class="alert alert-info mb-0">No feedback submitted yet.</div>
			<%
			} else {
			%>

			<div class="table-responsive">
				<table class="table align-middle">
					<thead>
						<tr>
							<th style="width: 110px;">Booking</th>
							<th>Service</th>
							<th style="width: 220px;">Caregiver</th>
							<th style="width: 220px;">Ratings</th>
							<th>Remarks</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (FeedbackView f : feedbackList) {
							int sr = f.getServiceRating(); 
							int cr = f.getCaregiverRating();
							String sRem = f.getServiceRemarks();
							String cRem = f.getCaregiverRemarks();
						%>
						<tr>
							<td>#<%=f.getBookingId()%></td>
							<td><%=f.getServiceName()%></td>
							<td><%=(f.getCaregiverName() == null || f.getCaregiverName().trim().isEmpty()) ? "-" : f.getCaregiverName()%></td>

							<!-- Ratings (split) -->
							<td>
								<div class="d-flex flex-column gap-1">
									<div>
										<span class="badge-soft me-2">Service</span>
										<%
										for (int i = 1; i <= 5; i++) {
											if (i <= sr) {
										%><i class="bi bi-star-fill star"></i>
										<%
										} else {
										%><i class="bi bi-star star"></i>
										<%
										}
										}
										%>
										<span class="ms-1 muted">(<%=sr%>/5)
										</span>
									</div>

									<div>
										<span class="badge-soft me-2">Caregiver</span>
										<%
										for (int i = 1; i <= 5; i++) {
											if (i <= cr) {
										%><i class="bi bi-star-fill star"></i>
										<%
										} else {
										%><i class="bi bi-star star"></i>
										<%
										}
										}
										%>
										<span class="ms-1 muted">(<%=cr%>/5)
										</span>
									</div>
								</div>
							</td>

							<!-- Remarks (split) -->
							<td>
								<div class="d-flex flex-column gap-2">
									<div class="remarks-box">
										<div class="muted mb-1">
											<strong>Service remarks</strong>
										</div>
										<div><%=(sRem == null || sRem.trim().isEmpty()) ? "-" : sRem%></div>
									</div>
									<div class="remarks-box">
										<div class="muted mb-1">
											<strong>Caregiver remarks</strong>
										</div>
										<div><%=(cRem == null || cRem.trim().isEmpty()) ? "-" : cRem%></div>
									</div>
								</div>
							</td>
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
</body>
</html>
