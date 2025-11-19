<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.AdminDashboardDAO" %>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Silvercare - Analytics Dashboard</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    .metric-card {
        background-color:#f9f9f9;
        padding:30px;
        height:150px;
        border-radius:8px;
        border:1px solid #e0e0e0;
    }

    .revenue-card {
        background-color:#f9f9f9;
        height:280px;
        border-radius:8px;
        border:1px solid #e0e0e0;
        padding:25px;
    }

    body {
        background-color:#ffffff;
    }

    h1 {
        font-weight:700;
        color:#333;
    }

    .filter-text {
        font-size:15px;
        font-weight:500;
        cursor:pointer;
        color:#333;
    }
</style>
</head>

<body>

<%@ include file="../common/navbar.jsp" %>

<div class="container mt-5">

<%
    //thisdaoobject
    AdminDashboardDAO dao = new AdminDashboardDAO();

    //thisanalyticsdata
    int totalUsers = dao.getTotalUsers();
    String popularService = dao.getPopularService();

    //thisrangeparam
    String range = request.getParameter("range");
    if (range == null) range = "year";

    //thisrevenuedata
    double revenue = dao.getRevenue(range);

    //thisrevenueheading
    String revenueHeading =
        range.equals("week") ? "Total revenue this week" :
        range.equals("month") ? "Total revenue this month" :
        "Total revenue this year";
%>

    <h1 class="mb-5">Analytics Dashboard</h1>

    <div class="row mb-5">

        <div class="col-md-4">
            <div class="metric-card">
                <h5 class="fw-bold">Total Users</h5>
                <p class="mt-3 fs-4"><%= totalUsers %></p>
            </div>
        </div>

        <div class="col-md-1"></div>

        <div class="col-md-4">
            <div class="metric-card">
                <h5 class="fw-bold">Most Popular Service</h5>
                <p class="mt-3 fs-5"><%= popularService %></p>
            </div>
        </div>

    </div>

    <div class="row">
        <div class="col-md-12">
            <div class="revenue-card">

                <div class="d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold"><%= revenueHeading %></h5>

                    <form method="get" class="d-flex align-items-center gap-5">
                        <span class="filter-text me-3">Filter by</span>
                        <select name="range" class="form-select form-select-sm" onchange="this.form.submit()">
                            <option value="week"  <%= range.equals("week") ? "selected" : "" %>>Week</option>
                            <option value="month" <%= range.equals("month") ? "selected" : "" %>>Month</option>
                            <option value="year"  <%= range.equals("year") ? "selected" : "" %>>Year</option>
                        </select>
                    </form>
                </div>

                <p class="mt-4 fs-3">$<%= String.format("%.2f", revenue) %></p>

            </div>
        </div>
    </div>

</div>

</body>
</html>
