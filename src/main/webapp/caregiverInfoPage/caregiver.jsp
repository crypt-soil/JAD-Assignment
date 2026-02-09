<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="java.util.List, java.util.ArrayList, model.Caregiver"%>

<%
@SuppressWarnings("unchecked")
List<Caregiver> caregivers = (List<Caregiver>) request.getAttribute("caregivers");
if (caregivers == null) {
	caregivers = new ArrayList<>();
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Our Caregivers</title>

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

.page-wrapper {
	max-width: 1100px;
	margin: 40px auto;
}

.caregiver-card {
	background: #fff;
	border-radius: 18px;
	padding: 25px;
	box-shadow: 0 14px 40px rgba(0, 0, 0, 0.08);
	transition: 0.3s;
}

.caregiver-card:hover {
	transform: translateY(-4px);
}

.caregiver-photo {
	width: 110px;
	height: 110px;
	border-radius: 50%;
	object-fit: cover;
	border: 3px solid #e6dfff;
}

.caregiver-name {
	font-size: 1.4rem;
	font-weight: 700;
	color: #4b37b8;
}

.caregiver-detail-label {
	font-weight: 600;
	color: #444;
	margin-right: 4px;
}
</style>

</head>
<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="page-wrapper">

		<h2 class="mb-4 fw-bold text-center" style="color: #4b37b8;">
			Meet Our Caregivers</h2>

		<div class="row g-4">
			<%
			for (Caregiver c : caregivers) {
			%>
			<div class="col-md-6">
				<div class="caregiver-card d-flex gap-3 align-items-start">

					<img src="<%=c.getPhotoUrl()%>" alt="Caregiver Photo"
						class="caregiver-photo">

					<div>
						<div class="caregiver-name"><%=c.getFullName()%></div>

						<div>
							<span class="caregiver-detail-label">Gender:</span><%=c.getGender()%></div>
						<div>
							<span class="caregiver-detail-label">Experience:</span><%=c.getYearsExperience()%>
							years
						</div>
						<div>
							<span class="caregiver-detail-label">Rating:</span>⭐
							<%=c.getRating()%></div>

						<div class="mt-2">
							<span class="caregiver-detail-label">About:</span> <span><%=c.getDescription()%></span>
						</div>

					</div>
				</div>
			</div>
			<%
			}
			%>

		</div>

	</div>

	<%@ include file="../common/footer.jsp"%>

</body>
</html>
