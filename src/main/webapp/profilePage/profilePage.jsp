<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="model.Profile"%>
<%@ page import="model.Booking, model.BookingItem"%>
<%@ page import="java.util.List"%>

<%
    Profile p = (Profile) request.getAttribute("profile");
    String success = request.getParameter("success");
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
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

    .nav-pills .nav-link.active {
        background-color: #6d4a8d;
    }

    .badge-status {
        border-radius: 999px;
        padding: 4px 10px;
        font-size: 0.75rem;
    }
</style>
</head>

<body>

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
                <h4 class="mb-0"><%= p.getFullName() != null && !p.getFullName().isEmpty() ? p.getFullName() : p.getUsername() %></h4>
                <small class="text-muted"><%= p.getEmail() != null ? p.getEmail() : "" %></small>
            </div>
        </div>

        <!-- TABS -->
        <ul class="nav nav-pills mb-3" id="profileTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link active" id="tab-profile-btn" data-bs-toggle="pill"
                        data-bs-target="#tab-profile" type="button" role="tab">
                    Profile Details
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link" id="tab-bookings-btn" data-bs-toggle="pill"
                        data-bs-target="#tab-bookings" type="button" role="tab">
                    My Bookings
                </button>
            </li>
        </ul>

        <div class="tab-content mt-3">

            <!-- PROFILE TAB -->
            <div class="tab-pane fade show active" id="tab-profile" role="tabpanel">
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

                    <button type="button" class="btn-edit mt-3" id="editBtn">Edit</button>
                    <button type="submit" class="btn btn-primary mt-3 d-none" id="saveBtn">Save Changes</button>
                </form>
            </div>

            <!-- BOOKINGS TAB -->
            <div class="tab-pane fade" id="tab-bookings" role="tabpanel">
                <%
                    if (bookings == null || bookings.isEmpty()) {
                %>
                    <p class="text-muted mt-2">You have no bookings yet.</p>
                <%
                    } else {
                        for (Booking b : bookings) {
                            String statusLabel;
                            String statusClass;
                            switch (b.getStatus()) {
                                case 2: statusLabel = "Confirmed"; statusClass = "bg-success text-white"; break;
                                case 3: statusLabel = "Completed"; statusClass = "bg-primary text-white"; break;
                                case 4: statusLabel = "Cancelled"; statusClass = "bg-secondary text-white"; break;
                                default: statusLabel = "Pending"; statusClass = "bg-warning text-dark"; break;
                            }
                %>
                    <div class="card mb-3">
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div>
                                    <strong>Booking #<%= b.getBookingId() %></strong><br>
                                    <small class="text-muted">
                                        <%= b.getBookingDate() != null ? b.getBookingDate().toString() : "" %>
                                    </small>
                                </div>
                                <span class="badge badge-status <%= statusClass %>"><%= statusLabel %></span>
                            </div>

                            <table class="table table-sm mb-0">
                                <thead>
                                    <tr>
                                        <th>Service</th>
                                        <th style="width:100px;">Qty</th>
                                        <th style="width:120px;" class="text-end">Subtotal</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    for (BookingItem item : b.getItems()) {
                                %>
                                    <tr>
                                        <td><%= item.getServiceName() %></td>
                                        <td><%= item.getQuantity() %></td>
                                        <td class="text-end">$<%= String.format("%.2f", item.getSubtotal()) %></td>
                                    </tr>
                                <%
                                    }
                                %>
                                </tbody>
                            </table>

                            <div class="text-end mt-2">
                                <strong>Total: $<%= String.format("%.2f", b.getTotalAmount()) %></strong>
                            </div>
                        </div>
                    </div>
                <%
                        } // end for bookings
                    } // end else
                %>
            </div>

        </div> <!-- /tab-content -->

    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
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
