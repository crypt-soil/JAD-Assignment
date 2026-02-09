<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, model.DBConnection"%>

<%
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

List<Map<String, Object>> caregivers = new ArrayList<>();

try {
	conn = DBConnection.getConnection();

	// load all caregivers (excluding caregiver_id in UI only)
	String sql = "SELECT full_name, gender, years_experience, rating, description, photo_url FROM caregiver ORDER BY full_name";

	ps = conn.prepareStatement(sql);
	rs = ps.executeQuery();

	while (rs.next()) {
		Map<String, Object> c = new HashMap<>();
		c.put("name", rs.getString("full_name"));
		c.put("gender", rs.getString("gender"));
		c.put("exp", rs.getInt("years_experience"));
		c.put("rating", rs.getDouble("rating"));
		c.put("desc", rs.getString("description"));
		c.put("photo", rs.getString("photo_url")); // can be http... OR uploads/...
		caregivers.add(c);
	}

} catch (Exception e) {
	e.printStackTrace();
} finally {
	try {
		if (rs != null)
	rs.close();
	} catch (Exception ignore) {
	}
	try {
		if (ps != null)
	ps.close();
	} catch (Exception ignore) {
	}
	try {
		if (conn != null)
	conn.close();
	} catch (Exception ignore) {
	}
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
	padding: 0 16px;
}

.caregiver-card {
	background: #fff;
	border-radius: 18px;
	padding: 25px;
	box-shadow: 0 14px 40px rgba(0, 0, 0, 0.08);
	transition: 0.3s;
	border: 1px solid #ede9fe;
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
	flex: 0 0 auto;
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

.muted {
	color: #666;
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
			for (Map<String, Object> c : caregivers) {
			%>

			<%
			String photo = (String) c.get("photo");
			String photoSrc;

			if (photo == null || photo.trim().isEmpty()) {
				photoSrc = "https://via.placeholder.com/110";
			} else if (photo.startsWith("http")) {
				photoSrc = photo; // external image url
			} else {
				// uploaded image stored like "uploads/caregivers/xxxx.png"
				photoSrc = request.getContextPath() + "/" + photo;
			}
			%>

			<div class="col-md-6">
				<div class="caregiver-card d-flex gap-3 align-items-start">

					<img src="<%=photoSrc%>" alt="Caregiver Photo"
						class="caregiver-photo">

					<div>
						<div class="caregiver-name"><%=c.get("name")%></div>

						<div class="muted">
							<span class="caregiver-detail-label">Gender:</span><%=c.get("gender")%>
						</div>

						<div class="muted">
							<span class="caregiver-detail-label">Experience:</span><%=c.get("exp")%>
							years
						</div>

						<div class="muted">
							<span class="caregiver-detail-label">Rating:</span>⭐
							<%=c.get("rating")%>
						</div>

						<div class="mt-2">
							<span class="caregiver-detail-label">About:</span> <span><%=c.get("desc")%></span>
						</div>
					</div>

				</div>
			</div>

			<%
			}
			%>

		</div>

	</div>

</body>
</html>