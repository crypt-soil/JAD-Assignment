<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Profile"%>
<%@ page import="model.Booking, model.BookingItem"%>
<%@ page import="model.MedicalInfo"%>
<%@ page import="model.EmergencyContact"%>
<%@ page import="java.util.List"%>

<%
Profile p = (Profile) request.getAttribute("profile");

String success = request.getParameter("success");
String tab = request.getParameter("tab");
if (tab == null || tab.trim().isEmpty())
	tab = "profile";

List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");

MedicalInfo medicalInfo = (MedicalInfo) request.getAttribute("medicalInfo");
String medicalText = (medicalInfo != null && medicalInfo.getMedicalInfo() != null) ? medicalInfo.getMedicalInfo() : "";

List<EmergencyContact> emergencyContacts = (List<EmergencyContact>) request.getAttribute("emergencyContacts");

// "modal" control via URL params (NO JS)
String addContact = request.getParameter("addContact");
String editIdStr = request.getParameter("editContactId");

// ✅ Feedback overlay controls (service-level)
String feedback = request.getParameter("feedback");
String bookingIdStr = request.getParameter("bookingId");
String serviceIdStr = request.getParameter("serviceId");

EmergencyContact editContact = null;
if (editIdStr != null) {
	try {
		int editId = Integer.parseInt(editIdStr);
		if (emergencyContacts != null) {
	for (EmergencyContact c : emergencyContacts) {
		if (c.getContactId() == editId) {
			editContact = c;
			break;
		}
	}
		}
	} catch (Exception e) {
		// ignore
	}
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Profile</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">

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
	box-shadow: 0 6px 25px rgba(0, 0, 0, 0.08);
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

.badge-status {
	border-radius: 999px;
	padding: 4px 10px;
	font-size: 0.75rem;
}

/* NO-JS "modal" overlay */
.overlay {
	position: fixed;
	inset: 0;
	background: rgba(0, 0, 0, .45);
	display: flex;
	align-items: center;
	justify-content: center;
	padding: 16px;
	z-index: 2000;
}

.overlay-card {
	width: 100%;
	max-width: 620px; /* slightly wider for 2-section feedback */
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 20px 60px rgba(0, 0, 0, 0.18);
	overflow: hidden;
}

.overlay-card .form-label {
	font-weight: 600;
	color: #374151;
	margin-bottom: 6px;
}

.overlay-card .form-control {
	border-radius: 12px;
	border: 1px solid #e5e7eb;
	padding: 10px 12px;
	background: #f9fafb;
}

.overlay-card .form-control:focus {
	background: #fff;
	border-color: #6d4a8d;
	box-shadow: 0 0 0 0.2rem rgba(109, 74, 141, 0.15);
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="profile-wrapper">

		<%
		if (success != null) {
		%>
		<div class="alert alert-success text-center"><%=success%></div>
		<%
		}
		%>

		<div class="profile-card">

			<!-- header -->
			<div class="profile-header">
				<img src="https://via.placeholder.com/90" alt="Profile">
				<div>
					<h4 class="mb-0"><%=p.getFullName() != null && !p.getFullName().isEmpty() ? p.getFullName() : p.getUsername()%></h4>
					<small class="text-muted"><%=p.getEmail() != null ? p.getEmail() : ""%></small>
				</div>
			</div>

			<!-- SERVER-SIDE TABS (NO JS) -->
			<div class="d-flex gap-2 mb-3">
				<a
					class="btn <%="profile".equals(tab) ? "btn-primary" : "btn-outline-primary"%>"
					href="<%=request.getContextPath()%>/profile?tab=profile">
					Profile Details </a> <a
					class="btn <%="bookings".equals(tab) ? "btn-primary" : "btn-outline-primary"%>"
					href="<%=request.getContextPath()%>/profile?tab=bookings"> My
					Bookings </a>
			</div>

			<%
			if ("profile".equals(tab)) {
			%>

			<!-- ======================
                 PROFILE DETAILS
            ====================== -->
			<form action="<%=request.getContextPath()%>/UpdateProfileServlet"
				method="post" id="profileForm">
				<div class="row">
					<div class="col-md-6">

						<label class="info-label">Full Name</label>
						<div class="d-flex mb-3 align-items-start">
							<input type="text" class="form-control input-box"
								name="full_name"
								value="<%=(p.getFullName() != null ? p.getFullName() : "")%>">
							<a class="delete-btn"
								href="<%=request.getContextPath()%>/DeleteFieldServlet?field=full_name"
								onclick="return confirm('Clear full name?');"> <i
								class="bi bi-trash"></i>
							</a>
						</div>

						<label class="info-label">Phone Number</label>
						<div class="d-flex mb-3 align-items-start">
							<input type="text" class="form-control input-box" name="phone"
								value="<%=(p.getPhone() != null ? p.getPhone() : "")%>">
							<a class="delete-btn"
								href="<%=request.getContextPath()%>/DeleteFieldServlet?field=phone"
								onclick="return confirm('Clear phone number?');"> <i
								class="bi bi-trash"></i>
							</a>
						</div>

					</div>

					<div class="col-md-6">

						<label class="info-label">Address</label>
						<div class="d-flex mb-3 align-items-start">
							<input type="text" class="form-control input-box" name="address"
								value="<%=(p.getAddress() != null ? p.getAddress() : "")%>">
							<a class="delete-btn"
								href="<%=request.getContextPath()%>/DeleteFieldServlet?field=address"
								onclick="return confirm('Clear address?');"> <i
								class="bi bi-trash"></i>
							</a>
						</div>

						<label class="info-label">Zip Code</label>
						<div class="d-flex mb-3 align-items-start">
							<input type="text" class="form-control input-box" name="zipcode"
								value="<%=(p.getZipcode() != null ? p.getZipcode() : "")%>">
							<a class="delete-btn"
								href="<%=request.getContextPath()%>/DeleteFieldServlet?field=zipcode"
								onclick="return confirm('Clear zipcode?');"> <i
								class="bi bi-trash"></i>
							</a>
						</div>

					</div>
				</div>

				<button type="submit" class="btn-edit mt-2">Save Profile
					Changes</button>
			</form>

			<!-- MEDICAL INFO -->
			<div class="card mt-4">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<strong>Medical Information</strong>
				</div>

				<div class="card-body">
					<form
						action="<%=request.getContextPath()%>/UpdateMedicalInfoServlet"
						method="post">
						<textarea class="form-control input-box" name="medical_info"
							rows="4"
							placeholder="e.g. Asthma, diabetes, allergies, mobility issues, special care notes"><%=medicalText%></textarea>

						<div class="d-flex gap-2 mt-3">
							<button type="submit" class="btn btn-primary">Save
								Medical Info</button>
							<a class="btn btn-outline-danger"
								href="<%=request.getContextPath()%>/ClearMedicalInfoServlet"
								onclick="return confirm('Clear medical information?');">
								Clear </a>
						</div>
					</form>

					<small class="text-muted d-block mt-2"> Tip: Keep it short
						(conditions, allergies, special care notes). </small>
				</div>
			</div>

			<!-- EMERGENCY CONTACTS -->
			<div class="card mt-4">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<strong>Emergency Contacts</strong>

					<div class="d-flex gap-2">
						<a class="btn btn-sm btn-primary"
							href="<%=request.getContextPath()%>/profile?tab=profile&addContact=1">
							+ Add Contact </a>
					</div>
				</div>

				<div class="card-body">
					<%
					if (emergencyContacts == null || emergencyContacts.isEmpty()) {
					%>
					<p class="text-muted mb-0">No emergency contacts added yet.</p>
					<%
					} else {
					%>
					<div class="table-responsive">
						<table class="table table-sm align-middle mb-0">
							<thead>
								<tr>
									<th>Name</th>
									<th>Relationship</th>
									<th>Phone</th>
									<th>Email</th>
									<th style="width: 160px;">Actions</th>
								</tr>
							</thead>
							<tbody>
								<%
								for (EmergencyContact c : emergencyContacts) {
								%>
								<tr>
									<td><%=c.getContactName()%></td>
									<td><%=(c.getRelationship() == null ? "-" : c.getRelationship())%></td>
									<td><%=c.getPhone()%></td>
									<td><%=(c.getEmail() == null ? "-" : c.getEmail())%></td>
									<td><a class="btn btn-sm btn-outline-secondary"
										href="<%=request.getContextPath()%>/profile?tab=profile&editContactId=<%=c.getContactId()%>">
											Edit </a> <a class="btn btn-sm btn-outline-danger"
										href="<%=request.getContextPath()%>/DeleteEmergencyContactServlet?id=<%=c.getContactId()%>"
										onclick="return confirm('Delete this contact?');"> Delete
									</a></td>
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

			<%
			} else {
			%>

			<!-- ======================
                 BOOKINGS (NO JS)
            ====================== -->
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
				case 2:
					statusLabel = "Confirmed";
					statusClass = "bg-success text-white";
					break;
				case 3:
					statusLabel = "Completed";
					statusClass = "bg-primary text-white";
					break;
				case 4:
					statusLabel = "Cancelled";
					statusClass = "bg-secondary text-white";
					break;
				default:
					statusLabel = "Pending";
					statusClass = "bg-warning text-dark";
					break;
				}
			%>

			<div class="card mb-3">
				<div class="card-body">

					<div class="d-flex justify-content-between align-items-center mb-2">
						<div>
							<strong>Booking #<%=b.getBookingId()%></strong><br> <small
								class="text-muted"> <%=b.getBookingDate() != null ? b.getBookingDate().toString() : ""%>
							</small>
						</div>
						<span class="badge badge-status <%=statusClass%>"><%=statusLabel%></span>
					</div>

					<table class="table table-sm mb-0">
						<thead>
							<tr>
								<th>Service</th>
								<th style="width: 70px;">Qty</th>
								<th style="width: 150px;">Caregiver</th>
								<th style="width: 150px;">Contact</th>
								<th style="width: 150px;">Caregiver Status</th>
								<th style="width: 120px;" class="text-end">Subtotal</th>
								<th style="width: 120px;">Feedback</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (BookingItem item : b.getItems()) {
								String cgLabel;
								String cgClass;
								switch (item.getCaregiverStatus()) {
								case 0:
									cgLabel = "Not Assigned";
									cgClass = "bg-secondary text-white";
									break;
								case 1:
									cgLabel = "Assigned";
									cgClass = "bg-info text-dark";
									break;
								case 2:
									cgLabel = "Checked In";
									cgClass = "bg-warning text-dark";
									break;
								case 3:
									cgLabel = "Checked Out";
									cgClass = "bg-success text-white";
									break;
								case 4:
									cgLabel = "Cancelled";
									cgClass = "bg-dark text-white";
									break;
								default:
									cgLabel = "Unknown";
									cgClass = "bg-secondary text-white";
									break;
								}
							%>
							<tr>
								<td><%=item.getServiceName()%></td>
								<td><%=item.getQuantity()%></td>
								<td><%=item.getCaregiverName() != null ? item.getCaregiverName() : "-"%></td>
								<td><%=item.getCaregiverContact() != null ? item.getCaregiverContact() : "-"%></td>
								<td><span class="badge badge-status <%=cgClass%>"><%=cgLabel%></span></td>
								<td class="text-end">$<%=String.format("%.2f", item.getSubtotal())%></td>

								<!-- ✅ Feedback button per service row -->
								<td><a class="btn btn-sm btn-outline-primary"
									href="<%=request.getContextPath()%>/profile?tab=bookings&feedback=1&bookingId=<%=b.getBookingId()%>&serviceId=<%=item.getServiceId()%>">
										<i class="bi bi-chat-left-text me-1"></i> Feedback
								</a></td>
							</tr>
							<%
							}
							%>
						</tbody>
					</table>

					<div class="text-end mt-2">
						<strong>Total: $<%=String.format("%.2f", b.getTotalAmount())%></strong>
					</div>
				</div>
			</div>

			<%
			}
			}
			%>

			<%
			} // end tab switch
			%>

		</div>
	</div>

	<!-- ============= NO-JS OVERLAY "MODALS" ============= -->

	<!-- ✅ FEEDBACK OVERLAY (service-level, 2 ratings + 2 remarks) -->
	<%
	if (feedback != null) {
	%>
	<div class="overlay">
		<div class="overlay-card">
			<div
				class="p-3 border-bottom d-flex justify-content-between align-items-center">
				<strong> Submit Feedback <%=(bookingIdStr != null ? ("(Booking #" + bookingIdStr + ")") : "")%>
				</strong> <a class="btn btn-sm btn-outline-secondary"
					href="<%=request.getContextPath()%>/profile?tab=bookings">X</a>
			</div>

			<div class="p-3">
				<form method="post"
					action="<%=request.getContextPath()%>/SubmitFeedbackServlet">

					<input type="hidden" name="booking_id"
						value="<%=bookingIdStr != null ? bookingIdStr : ""%>"> <input
						type="hidden" name="service_id"
						value="<%=serviceIdStr != null ? serviceIdStr : ""%>">

					<!-- SERVICE -->
					<div class="mb-3">
						<label class="form-label">Service Rating</label> <select
							name="service_rating" class="form-control" required>
							<option value="" disabled selected>Select a rating</option>
							<option value="5">5 - Excellent</option>
							<option value="4">4 - Good</option>
							<option value="3">3 - Okay</option>
							<option value="2">2 - Bad</option>
							<option value="1">1 - Very Bad</option>
						</select> <small class="text-muted">Rate the service (e.g., Meal
							Prep, Escort)</small>
					</div>

					<div class="mb-3">
						<label class="form-label">Service Remarks</label>
						<textarea name="service_remarks" class="form-control" rows="3"
							required
							placeholder="What did you like/dislike about the service?"></textarea>
					</div>

					<hr class="my-4">

					<!-- CAREGIVER -->
					<div class="mb-3">
						<label class="form-label">Caregiver Rating</label> <select
							name="caregiver_rating" class="form-control" required>
							<option value="" disabled selected>Select a rating</option>
							<option value="5">5 - Excellent</option>
							<option value="4">4 - Good</option>
							<option value="3">3 - Okay</option>
							<option value="2">2 - Bad</option>
							<option value="1">1 - Very Bad</option>
						</select> <small class="text-muted">Rate the caregiver assigned for
							this service</small>
					</div>

					<div class="mb-3">
						<label class="form-label">Caregiver Remarks</label>
						<textarea name="caregiver_remarks" class="form-control" rows="3"
							required
							placeholder="How was the caregiver (attitude, punctuality, care)?"></textarea>
					</div>

					<div class="d-flex gap-2">
						<a class="btn btn-outline-secondary"
							href="<%=request.getContextPath()%>/profile?tab=bookings">Cancel</a>
						<button class="btn btn-primary" type="submit">Send</button>
					</div>
				</form>

				<small class="text-muted d-block mt-2"> Thank you! Your
					feedback helps us improve both services and caregivers. </small>
			</div>
		</div>
	</div>
	<%
	}
	%>

	<!-- ADD CONTACT OVERLAY -->
	<%
	if (addContact != null) {
	%>
	<div class="overlay">
		<div class="overlay-card">
			<div
				class="p-3 border-bottom d-flex justify-content-between align-items-center">
				<strong>Add Emergency Contact</strong> <a
					class="btn btn-sm btn-outline-secondary"
					href="<%=request.getContextPath()%>/profile?tab=profile">X</a>
			</div>

			<div class="p-3">
				<form method="post"
					action="<%=request.getContextPath()%>/SaveEmergencyContactServlet">
					<input type="hidden" name="contact_id" value="">

					<div class="mb-3">
						<label class="form-label">Name</label> <input class="form-control"
							name="contact_name" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Relationship</label> <input
							class="form-control" name="relationship">
					</div>

					<div class="mb-3">
						<label class="form-label">Phone</label> <input
							class="form-control" name="phone" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Email (optional)</label> <input
							class="form-control" name="email" type="email">
					</div>

					<div class="d-flex gap-2">
						<a class="btn btn-outline-secondary"
							href="<%=request.getContextPath()%>/profile?tab=profile">Cancel</a>
						<button class="btn btn-primary" type="submit">Save</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<%
	}
	%>

	<!-- EDIT CONTACT OVERLAY -->
	<%
	if (editContact != null) {
	%>
	<div class="overlay">
		<div class="overlay-card">
			<div
				class="p-3 border-bottom d-flex justify-content-between align-items-center">
				<strong>Edit Emergency Contact</strong> <a
					class="btn btn-sm btn-outline-secondary"
					href="<%=request.getContextPath()%>/profile?tab=profile">X</a>
			</div>

			<div class="p-3">
				<form method="post"
					action="<%=request.getContextPath()%>/SaveEmergencyContactServlet">
					<input type="hidden" name="contact_id"
						value="<%=editContact.getContactId()%>">

					<div class="mb-3">
						<label class="form-label">Name</label> <input class="form-control"
							name="contact_name" required
							value="<%=editContact.getContactName()%>">
					</div>

					<div class="mb-3">
						<label class="form-label">Relationship</label> <input
							class="form-control" name="relationship"
							value="<%=(editContact.getRelationship() == null ? "" : editContact.getRelationship())%>">
					</div>

					<div class="mb-3">
						<label class="form-label">Phone</label> <input
							class="form-control" name="phone" required
							value="<%=editContact.getPhone()%>">
					</div>

					<div class="mb-3">
						<label class="form-label">Email (optional)</label> <input
							class="form-control" name="email" type="email"
							value="<%=(editContact.getEmail() == null ? "" : editContact.getEmail())%>">
					</div>

					<div class="d-flex gap-2">
						<a class="btn btn-outline-secondary"
							href="<%=request.getContextPath()%>/profile?tab=profile">Cancel</a>
						<button class="btn btn-primary" type="submit">Save
							Changes</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	<%
	}
	%>

</body>
</html>
