<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Service.ServiceInquiry"%>
<%
// ===== ADMIN GUARD =====
HttpSession s = request.getSession(false);
if (s == null || !"admin".equals(s.getAttribute("role"))) {
	response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
	return;
}

ServiceInquiry inquiry = (ServiceInquiry) request.getAttribute("inquiry");
if (inquiry == null) {
	response.sendRedirect(request.getContextPath() + "/admin/inquiries?error=NotFound");
	return;
}

String st = inquiry.getStatus();
String badgeClass = "badge-read";
if ("NEW".equals(st))
	badgeClass = "badge-new";
if ("ARCHIVED".equals(st))
	badgeClass = "badge-archived";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silvercare - Inquiry Details</title>

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
	padding: 25px;
	border-radius: 8px;
	border: 1px solid #e0e0e0;
}

.revenue-card {
	background-color: #f9f9f9;
	border-radius: 8px;
	border: 1px solid #e0e0e0;
	padding: 25px;
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

.label {
	font-size: 13px;
	color: #666;
	font-weight: 600;
}

.btn-purple {
	background-color: #6d4a8d;
	color: white;
	border: none;
}

.btn-purple:hover {
	background-color: #5b3f77;
	color: white;
}
</style>
</head>

<body>
	<%@ include file="../common/navbar.jsp"%>

	<div class="container mt-5">

		<div
			class="d-flex justify-content-between align-items-center mb-4 flex-wrap gap-2">
			<h1 class="mb-0">
				Inquiry #<%=inquiry.getInquiryId()%></h1>
			<a class="btn btn-outline-secondary btn-sm"
				href="<%=request.getContextPath()%>/admin/inquiries"> Back to
				inquiries </a>
		</div>

		<!-- TOP CARD: STATUS + ACTIONS -->
		<div class="revenue-card mb-4">
			<div
				class="d-flex justify-content-between align-items-center flex-wrap gap-3">
				<div>
					<h5 class="fw-bold mb-1">Status</h5>
					<span class="badge <%=badgeClass%>"><%=st%></span>
					<div class="text-muted mt-2" style="font-size: 14px;">
						Submitted:
						<%=inquiry.getCreatedAt()%>
					</div>
				</div>
				<form method="post"
					action="<%=request.getContextPath()%>/admin/inquiries/status"
					class="d-flex gap-2">
					<input type="hidden" name="id" value="<%=inquiry.getInquiryId()%>" />

					<%
					boolean isRead = "READ".equals(st);
					boolean isArchived = "ARCHIVED".equals(st);

					String toggleText = isRead ? "Mark as UNREAD" : "Mark as READ";
					String toggleValue = isRead ? "NEW" : "READ";
					String toggleClass = isRead ? "btn-purple" : "btn-outline-primary";

					String archiveText = isArchived ? "Unarchive" : "Archive";
					String archiveValue = isArchived ? "READ" : "ARCHIVED";
					String archiveClass = isArchived ? "btn-outline-secondary" : "btn-outline-dark";
					%>

					<button class="btn btn-sm <%=toggleClass%>" type="submit"
						name="status" value="<%=toggleValue%>"
						<%=isArchived ? "disabled" : ""%>>
						<%=toggleText%>
					</button>

					<button class="btn btn-sm <%=archiveClass%>" type="submit"
						name="status" value="<%=archiveValue%>">
						<%=archiveText%>
					</button>
				</form>


			</div>
		</div>

		<!-- DETAILS CARD -->
		<div class="metric-card">
			<div class="row g-4">

				<div class="col-md-6">
					<div class="label">Name</div>
					<div class="fw-semibold"><%=inquiry.getName()%></div>
				</div>

				<div class="col-md-6">
					<div class="label">Email</div>
					<div class="fw-semibold"><%=inquiry.getEmail()%></div>
				</div>

				<div class="col-md-6">
					<div class="label">Category</div>
					<div class="fw-semibold"><%=inquiry.getCategory()%></div>
				</div>

				<div class="col-md-6">
					<div class="label">Preferred Contact</div>
					<div class="fw-semibold">
						<%=inquiry.getPreferredContact()%>
						<%
						if ("PHONE".equals(inquiry.getPreferredContact()) && inquiry.getPhone() != null) {
						%>
						<span class="text-muted"> ( <%=inquiry.getPhone()%> )
						</span>
						<%
						}
						%>
					</div>
				</div>

				<div class="col-md-6">
					<div class="label">Target Service</div>
					<div class="fw-semibold">
						<%
						if (inquiry.getServiceId() != null) {
							String serviceLabel = (inquiry.getServiceName() != null && !inquiry.getServiceName().isBlank())
							? inquiry.getServiceName()
							: "Service #" + inquiry.getServiceId();
						%>
						<%=serviceLabel%>
						<%
						} else {
						%>
						<span class="text-muted">—</span>
						<%
						}
						%>
					</div>
				</div>

				<div class="col-md-6">
					<div class="label">Target Caregiver</div>
					<div class="fw-semibold">
						<%
						if (inquiry.getCaregiverId() != null) {
							String caregiverLabel = (inquiry.getCaregiverName() != null && !inquiry.getCaregiverName().isBlank())
							? inquiry.getCaregiverName()
							: "Caregiver #" + inquiry.getCaregiverId();
						%>
						<%=caregiverLabel%>
						<%
						} else {
						%>
						<span class="text-muted">—</span>
						<%
						}
						%>
					</div>
				</div>

				<div class="col-12">
					<div class="label">Message</div>
					<div class="p-3 border rounded-3 bg-white"
						style="white-space: pre-wrap;">
						<%=inquiry.getMessage()%>
					</div>
				</div>

			</div>
		</div>

	</div>

</body>
</html>
