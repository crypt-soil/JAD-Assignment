<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- Lois Poh 2429478 -->
<%
Integer cgId = (Integer) session.getAttribute("caregiver_id");
if (cgId == null) {
    response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
    return;
}
String caregiverName = (String) request.getAttribute("caregiverName");
if (caregiverName == null) caregiverName = "Caregiver";
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silver Care - Caregiver Home</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">

<style>
body { background:#f6f4ff; font-family:"Poppins",sans-serif; }
.home-wrapper { max-width:1200px; margin:40px auto 60px auto; }
.hero-card { background:#ffffff; border-radius:20px; padding:32px; box-shadow:0 16px 40px rgba(0,0,0,0.08); }
.hero-title { font-weight:700; font-size:2rem; color:#4b37b8; }
.hero-subtitle { color:#555; font-size:0.98rem; line-height:1.7; margin-top:12px; }
.role-tag { display:inline-block; padding:4px 10px; border-radius:999px; font-size:0.75rem; font-weight:600; background:#efe9ff; color:#6b4cd8; text-transform:uppercase; letter-spacing:0.04em; }
.btn-soft-primary { background:#efe9ff; color:#6b4cd8; border-color:#d1c2ff; font-weight:600; border-radius:999px; padding:10px 18px; }
.btn-soft-primary:hover { background:#e2d6ff; color:#5936cf; border-color:#b9a1ff; }
</style>
</head>

<body>
<%@ include file="../common/navbar.jsp" %>

<div class="home-wrapper">
    <div class="hero-card">
        <span class="role-tag">Caregiver Portal</span>
        <h2 class="hero-title mt-3">Welcome, <%= caregiverName %>!</h2>
        <p class="hero-subtitle">
            View service requests, accept assignments, and update attendance using check-in/check-out.
            Families will see real-time updates on their bookings.
        </p>

        <div class="mt-3 d-flex gap-2 flex-wrap">
            <a class="btn btn-soft-primary" href="<%=request.getContextPath()%>/caregiver/requests">
                View Service Requests
            </a>

            <a class="btn btn-soft-primary" href="<%=request.getContextPath()%>/caregiver/visits?filter=today">
                View My Schedule
            </a>
        </div>
    </div>
</div>

<%@ include file="../common/footer.jsp" %>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
