<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile" %>

<%
    Profile p = (Profile) request.getAttribute("profile");
    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Profile</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">

<style>
    body {
        background: #f2f4f7;
        font-family: 'Poppins', sans-serif;
    }

    .profile-wrapper {
        max-width: 1000px;
        margin: 40px auto;
    }

    .profile-card {
        background: #fff;
        border-radius: 18px;
        padding: 35px;
        box-shadow: 0 6px 25px rgba(0,0,0,0.08);
    }

    .profile-header {
        display: flex;
        align-items: center;
        gap: 20px;
        margin-bottom: 30px;
    }

    .profile-header img {
        width: 85px;
        height: 85px;
        border-radius: 50%;
        object-fit: cover;
    }

    .section-title {
        font-weight: 600;
        margin-top: 30px;
        margin-bottom: 10px;
        color: #444;
    }

    .info-label {
        font-weight: 500;
        color: #555;
        margin-bottom: 5px;
    }

    .input-box {
        background: #f7f7f7;
        border: none;
        border-radius: 10px;
        padding: 12px;
    }

    .add-btn {
        cursor: pointer;
        color: #7b50c7;
        font-weight: 600;
        padding-top: 6px;
    }

    .btn-edit {
        background: #6d4a8d;
        color: white;
        border-radius: 8px;
        padding: 8px 18px;
        font-weight: 500;
        border: none;
    }

    .btn-edit:hover {
        background: #5c3c7a;
    }

    .delete-btn {
        border: none;
        background: none;
        color: #d9534f;
        font-size: 1.2rem;
        margin-left: 10px;
        cursor: pointer;
    }
</style>

</head>

<body>

<!-- NAVBAR -->
<%@ include file="../common/navbar.jsp" %>

<div class="profile-wrapper">

    <% if (success != null) { %>
        <div class="alert alert-success text-center"><%= success %></div>
    <% } %>

    <div class="profile-card">

        <!-- HEADER -->
        <div class="profile-header">
            <img src="https://via.placeholder.com/90" alt="Profile">
            <div>
                <h4 class="mb-0"><%= p.getFullName() != null ? p.getFullName() : p.getUsername() %></h4>
            </div>

            <button type="button" class="btn-edit ms-auto" id="editBtn">Edit</button>
        </div>

        <form action="<%= request.getContextPath() %>/UpdateProfileServlet" method="post" id="profileForm">

            <div class="row">

                <!-- LEFT COLUMN -->
                <div class="col-md-6">

                    <!-- FULL NAME -->
                    <label class="info-label">Full Name</label>
                    <div class="d-flex mb-3 align-items-start">
                        <% if (p.getFullName() != null && !p.getFullName().isEmpty()) { %>
                            <input type="text" class="form-control input-box profile-field" name="full_name"
                                   value="<%= p.getFullName() %>" disabled>
                            <a class="delete-btn" href="<%= request.getContextPath() %>/DeleteFieldServlet?field=full_name">
                                <i class="bi bi-trash"></i>
                            </a>
                        <% } else { %>
                            <span class="add-btn" onclick="enableField('full_name')">+ Add</span>
                            <input type="text" class="form-control input-box d-none add-input"
                                   id="full_name-input" name="full_name" placeholder="Enter full name">
                        <% } %>
                    </div>

                    <!-- PHONE -->
                    <label class="info-label">Phone Number</label>
                    <div class="d-flex mb-3 align-items-start">
                        <% if (p.getPhone() != null && !p.getPhone().isEmpty()) { %>
                            <input type="text" class="form-control input-box profile-field" name="phone"
                                   value="<%= p.getPhone() %>" disabled>
                            <a class="delete-btn" href="<%= request.getContextPath() %>/DeleteFieldServlet?field=phone">
                                <i class="bi bi-trash"></i>
                            </a>
                        <% } else { %>
                            <span class="add-btn" onclick="enableField('phone')">+ Add</span>
                            <input type="text" class="form-control input-box d-none add-input"
                                   id="phone-input" name="phone" placeholder="Enter phone number">
                        <% } %>
                    </div>

                </div>

                <!-- RIGHT COLUMN -->
                <div class="col-md-6">

                    <!-- ADDRESS -->
                    <label class="info-label">Address</label>
                    <div class="d-flex mb-3 align-items-start">
                        <% if (p.getAddress() != null && !p.getAddress().isEmpty()) { %>
                            <input type="text" class="form-control input-box profile-field" name="address"
                                   value="<%= p.getAddress() %>" disabled>
                            <a class="delete-btn" href="<%= request.getContextPath() %>/DeleteFieldServlet?field=address">
                                <i class="bi bi-trash"></i>
                            </a>
                        <% } else { %>
                            <span class="add-btn" onclick="enableField('address')">+ Add</span>
                            <input type="text" class="form-control input-box d-none add-input"
                                   id="address-input" name="address" placeholder="Enter address">
                        <% } %>
                    </div>

                    <!-- ZIPCODE -->
                    <label class="info-label">Zip Code</label>
                    <div class="d-flex mb-3 align-items-start">
                        <% if (p.getZipcode() != null && !p.getZipcode().isEmpty()) { %>
                            <input type="text" class="form-control input-box profile-field" name="zipcode"
                                   value="<%= p.getZipcode() %>" disabled>
                            <a class="delete-btn" href="<%= request.getContextPath() %>/DeleteFieldServlet?field=zipcode">
                                <i class="bi bi-trash"></i>
                            </a>
                        <% } else { %>
                            <span class="add-btn" onclick="enableField('zipcode')">+ Add</span>
                            <input type="text" class="form-control input-box d-none add-input"
                                   id="zipcode-input" name="zipcode" placeholder="Enter zipcode">
                        <% } %>
                    </div>

                </div>

            </div>

            <button type="submit" class="btn btn-primary mt-4 d-none" id="saveBtn">Save Changes</button>
        </form>
    </div>
</div>


<script>
// Unlock fields when clicking Edit
document.getElementById("editBtn").onclick = function () {
    document.querySelectorAll(".profile-field").forEach(f => f.disabled = false);
    document.getElementById("saveBtn").classList.remove("d-none");
};

// Enable +Add field
function enableField(field) {
    document.getElementById(field + "-input").classList.remove("d-none");
    document.getElementById("saveBtn").classList.remove("d-none");
}
</script>

</body>
</html>
