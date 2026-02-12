<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.caregiver.Caregiver"%>

<%
Caregiver c = (Caregiver) request.getAttribute("caregiver");
if (c == null) {
	response.sendRedirect(request.getContextPath() + "/homePage/homePage.jsp");
	return;
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Caregiver Profile</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrapper {
	max-width: 820px;
	margin: 40px auto;
	padding: 0 16px;
}

.cardx {
	background: #fff;
	padding: 34px 34px;
	border-radius: 18px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, .08);
	border: 1px solid #ede9fe;
}

.profile-grid {
	display: grid;
	grid-template-columns: 320px 1fr;
	gap: 22px;
}

@media ( max-width : 860px) {
	.profile-grid {
		grid-template-columns: 1fr;
	}
}

.profile-img {
	width: 100%;
	height: 280px;
	object-fit: cover;
	border-radius: 14px;
	border: 1px solid #eee;
}

.label-text {
	font-weight: 600;
	color: #4b4b4b;
}

.h-title {
	font-weight: 800;
	color: #4b37b8;
	margin-bottom: 6px;
}

.subtext {
	color: #666;
	margin-bottom: 18px;
}

.btn-soft-primary {
	background: #efe9ff;
	color: #6b4cd8;
	border: 1px solid #d1c2ff;
	font-weight: 600;
}

.btn-soft-primary:hover {
	background: #e2d6ff;
	color: #5936cf;
	border-color: #b9a1ff;
}

.helper {
	font-size: 0.85rem;
	color: #777;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<%
	String img = c.getPhotoUrl();
	String src;
	if (img == null || img.trim().isEmpty())
		src = "https://via.placeholder.com/400x300";
	else if (img.startsWith("http"))
		src = img;
	else
		src = request.getContextPath() + "/" + img;
	%>

	<div class="wrapper">
		<div class="cardx">

			<h2 class="h-title">My Caregiver Profile</h2>
			<p class="subtext">Update your personal and professional details.</p>

			<form action="<%=request.getContextPath()%>/caregiverProfile"
				method="post" enctype="multipart/form-data">

				<input type="hidden" name="action" value="update"> <input
					type="hidden" name="id" value="<%=c.getId()%>">

				<div class="profile-grid">

					<!-- LEFT: PHOTO -->
					<div>
						<label class="label-text d-block mb-2">Current Photo</label> <img
							src="<%=src%>" class="profile-img" alt="Caregiver photo">

						<div class="mt-3">
							<label class="label-text">Upload New Photo</label> <input
								type="file" name="caregiverImage" class="form-control"
								accept="image/*">
							<div class="helper mt-1">Accepted: jpg, jpeg, png, webp</div>
						</div>

						<div class="mt-3">
							<label class="label-text">Photo URL (optional)</label> <input
								type="text" name="photoUrl" class="form-control"
								value="<%=c.getPhotoUrl() == null ? "" : c.getPhotoUrl()%>"
								placeholder="https://...">
							<div class="helper mt-1">If you upload a photo, it
								overrides this URL.</div>
						</div>
					</div>

					<!-- RIGHT: DETAILS -->
					<div>
						<div class="mb-3">
							<label class="label-text">Full Name</label> <input type="text"
								name="fullName" class="form-control"
								value="<%=c.getFullName()%>" required>
						</div>

						<div class="row g-3">
							<div class="col-md-6">
								<label class="label-text">Gender</label> <select name="gender"
									class="form-control">
									<option value="Female"
										<%="Female".equals(c.getGender()) ? "selected" : ""%>>Female</option>
									<option value="Male"
										<%="Male".equals(c.getGender()) ? "selected" : ""%>>Male</option>
								</select>
							</div>

							<div class="col-md-6">
								<label class="label-text">Years of Experience</label> <input
									type="number" name="yearsExperience" class="form-control"
									min="0" value="<%=c.getYearsExperience()%>" required>
							</div>
						</div>

						<div class="mt-3">
							<label class="label-text">Description</label>
							<textarea name="description" rows="6" class="form-control"
								required><%=c.getDescription()%></textarea>
						</div>

						<!-- Optional read-only fields (nice touch) -->
						<div class="row g-3 mt-2">
							<div class="col-md-6">
								<label class="label-text">Email (read-only)</label> <input
									type="email" name="email" class="form-control"
									value="<%=c.getEmail()%>" required>

							</div>
							<div class="col-md-6">
								<label class="label-text">Phone (read-only)</label> <input
									type="text" name="phone" class="form-control"
									value="<%=c.getPhone()%>" pattern="[0-9]{8}"
									title="Enter an 8-digit phone number" required>

							</div>
						</div>

						<div class="mt-3">
							<label class="label-text">Rating (read-only)</label> <input
								type="text" class="form-control"
								value="<%=String.format("%.1f", c.getRating())%>" disabled>
						</div>

						<div class="mt-4 d-flex gap-2">
							<button type="submit" class="btn btn-soft-primary">Save
								Profile</button>

							<a
								href="<%=request.getContextPath()%>/caregiverPage/caregiverHomePage.jsp"
								class="btn btn-outline-secondary"> Back </a>
						</div>
					</div>

				</div>
			</form>

		</div>
	</div>

	<%@ include file="../common/footer.jsp"%>

</body>
</html>
