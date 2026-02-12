<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="model.Profile.Profile"%>
<%@ page import="model.Bookings.Booking,model.Bookings.BookingItem"%>
<%@ page import="model.MedicalInfo.MedicalInfo"%>
<%@ page import="model.EmergencyContact.EmergencyContact"%>
<%@ page import="java.util.List"%>


<%
Profile p = (Profile) request.getAttribute("profile");

String success = request.getParameter("success");
String tab = request.getParameter("tab");
if (tab == null || tab.trim().isEmpty())
	tab = "profile";

List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");

MedicalInfo medicalInfo = (MedicalInfo) request.getAttribute("medicalInfo");



List<EmergencyContact> emergencyContacts = (List<EmergencyContact>) request.getAttribute("emergencyContacts");

// "modal" control via URL params (NO JS)
String addContact = request.getParameter("addContact");
String editIdStr = request.getParameter("editContactId");

// ✅ Feedback overlay controls (service-level)
String feedback = request.getParameter("feedback");
String feedbackBookingIdStr = request.getParameter("bookingId");
String feedbackServiceIdStr = request.getParameter("serviceId");

// ✅ Update overlay controls (service-level)
String editService = request.getParameter("editService");
String editBookingIdStr = request.getParameter("bookingId");
String editServiceIdStr = request.getParameter("serviceId");

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
		/* ignore */ }
}

// ✅ Helper: find selected BookingItem for update overlay prefill
BookingItem editItem = null;
Integer editBookingId = null;
Integer editServiceId = null;

try {
	if (editService != null && editBookingIdStr != null && editServiceIdStr != null) {
		editBookingId = Integer.parseInt(editBookingIdStr);
		editServiceId = Integer.parseInt(editServiceIdStr);

		if (bookings != null) {
	for (Booking b : bookings) {
		if (b.getBookingId() == editBookingId.intValue()) {
			for (BookingItem it : b.getItems()) {
				if (it.getServiceId() == editServiceId.intValue()) {
					editItem = it;
					break;
				}
			}
		}
		if (editItem != null)
			break;
	}
		}
	}
} catch (Exception e) {
	// ignore
}

// Prefill fields
int editQty = (editItem != null ? editItem.getQuantity() : 1);

// If your BookingItem has getSpecialRequest(), use it. Otherwise set "".
String editSpecialRequest = "";
try {
	if (editItem != null && editItem.getSpecialRequest() != null) {
		editSpecialRequest = editItem.getSpecialRequest();
	}
} catch (Exception ex) {
	// If getSpecialRequest doesn't exist yet, ignore.
	editSpecialRequest = "";
}
%>

<%@ page import="java.time.*"%>

<%
String editServiceDate = "";
int editHour = 9; // default

try {
	if (editItem != null && editItem.getStartTime() != null) {
		LocalDateTime startLdt = editItem.getStartTime().toLocalDateTime();
		editServiceDate = startLdt.toLocalDate().toString();
		editHour = startLdt.getHour();
	}
} catch (Exception e) {
	editServiceDate = "";
	editHour = 9;
}

if (editServiceDate == null || editServiceDate.isEmpty()) {
	editServiceDate = LocalDate.now().toString();
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

/* NO-JS overlay */
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
	max-width: 620px;
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
				<div>
					<h4 class="mb-0">
						<%=(p.getFullName() != null && !p.getFullName().isEmpty()) ? p.getFullName() : p.getUsername()%>
					</h4>
					<small class="text-muted"><%=(p.getEmail() != null ? p.getEmail() : "")%></small>
				</div>
			</div>

			<!-- Tabs -->
			<div class="d-flex gap-2 mb-3">
				<a
					class="btn <%="profile".equals(tab) ? "btn-primary" : "btn-outline-primary"%>"
					href="<%=request.getContextPath()%>/profile?tab=profile">Profile
					Details</a> <a
					class="btn <%="bookings".equals(tab) ? "btn-primary" : "btn-outline-primary"%>"
					href="<%=request.getContextPath()%>/profile?tab=bookings">My
					Bookings</a>
			</div>

			<%
			if ("profile".equals(tab)) {
			%>

			<!-- PROFILE DETAILS -->
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

			<%
			// ===== Medical conditions list =====
			String[] conditionOptions = { "Diabetes", "Heart Disease", "Heart Failure", "Stroke", "Asthma", "COPD", "Arthritis",
					"Cancer", "High Blood Pressure", "Alzheimer’s Disease / Dementia", "Other" };

			// Read saved values from backend (you will update MedicalInfo model later)
			String savedConditionsCsv = "";
			String savedAllergies = "";

			if (medicalInfo != null) {
				try {
					savedConditionsCsv = (medicalInfo.getConditionsCsv() != null) ? medicalInfo.getConditionsCsv() : "";
				} catch (Exception e) {
				}
				try {
					savedAllergies = (medicalInfo.getAllergiesText() != null) ? medicalInfo.getAllergiesText() : "";
				} catch (Exception e) {
				}
			}

			// Helper: check if option is selected (simple contains check on CSV)
			// Pad commas to avoid partial match (e.g. "COPD" vs "COPD-like")
			String padded = "," + savedConditionsCsv.replace(" ", "") + ",";
			%>

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

						<label class="info-label mb-2">Medical Conditions</label>

						<div class="row g-2 mb-3">
							<%
							for (String opt : conditionOptions) {
								String key = opt.replace(" ", "_").replace("’", "").replace("/", "_");
								boolean checked = padded.contains("," + opt.replace(" ", "") + ","); // matches CSV without spaces
							%>
							<div class="col-12 col-md-6 col-lg-4">
								<div class="form-check">
									<input class="form-check-input" type="checkbox"
										name="conditions" id="cond_<%=key%>" value="<%=opt%>"
										<%=checked ? "checked" : ""%>> <label
										class="form-check-label" for="cond_<%=key%>"> <%=opt%>
									</label>
								</div>
							</div>
							<%
							}
							%>
						</div>

						<div class="mb-3">
							<label class="info-label">Allergies (food / medication /
								environmental)</label>
							<textarea class="form-control input-box" name="allergies"
								rows="3" placeholder="e.g. Penicillin, shellfish, dust"><%=savedAllergies%></textarea>
						</div>

						<div class="d-flex gap-2 mt-3">
							<button type="submit" class="btn btn-primary">Save
								Medical Info</button>

							<!-- you can keep your clear servlet -->
							<a class="btn btn-outline-danger"
								href="<%=request.getContextPath()%>/ClearMedicalInfoServlet"
								onclick="return confirm('Clear medical information?');">Clear</a>
						</div>
					</form>

					<small class="text-muted d-block mt-2"> Tip: Tick the
						conditions, then list allergies below. </small>
				</div>
			</div>


			<!-- EMERGENCY CONTACTS -->
			<div class="card mt-4">
				<div
					class="card-header d-flex justify-content-between align-items-center">
					<strong>Emergency Contacts</strong> <a
						class="btn btn-sm btn-primary"
						href="<%=request.getContextPath()%>/profile?tab=profile&addContact=1">+
						Add Contact</a>
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
										href="<%=request.getContextPath()%>/profile?tab=profile&editContactId=<%=c.getContactId()%>">Edit</a>
										<a class="btn btn-sm btn-outline-danger"
										href="<%=request.getContextPath()%>/DeleteEmergencyContactServlet?id=<%=c.getContactId()%>"
										onclick="return confirm('Delete this contact?');">Delete</a></td>
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

			<!-- BOOKINGS -->
			<%
			if (bookings == null || bookings.isEmpty()) {
			%>
			<p class="text-muted mt-2">You have no bookings yet.</p>
			<%
			} else {
			%>

			<%
			for (Booking b : bookings) {
				String statusLabel, statusClass;
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
								class="text-muted"><%=(b.getBookingDate() != null ? b.getBookingDate().toString() : "")%></small>
						</div>
						<span class="badge badge-status <%=statusClass%>"><%=statusLabel%></span>
					</div>

					<div class="table-responsive">
						<table class="table table-sm mb-0 align-middle">
							<thead>
								<tr>
									<th>Service</th>
									<th style="width: 70px;">Qty</th>
									<th style="width: 150px;">Caregiver</th>
									<th style="width: 150px;">Contact</th>
									<th style="width: 150px;">Caregiver Status</th>
									<th style="width: 120px;" class="text-end">Subtotal</th>
									<th style="width: 120px;">Feedback</th>
									<th style="width: 120px;">Cancel</th>
									<th style="width: 120px;">Update</th>
								</tr>
							</thead>
							<tbody>

								<%
								for (BookingItem item : b.getItems()) {
									String cgLabel, cgClass;
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

									boolean isNotAssigned = (item.getCaregiverStatus() == 0);
									boolean isCheckedOut = (item.getCaregiverStatus() == 3);
									boolean isCancelled = (item.getCaregiverStatus() == 4);
								%>

								<tr>
									<td><%=item.getServiceName()%></td>
									<td><%=item.getQuantity()%></td>
									<td><%=(item.getCaregiverName() != null ? item.getCaregiverName() : "-")%></td>
									<td><%=(item.getCaregiverContact() != null ? item.getCaregiverContact() : "-")%></td>
									<td><span class="badge badge-status <%=cgClass%>"><%=cgLabel%></span></td>
									<td class="text-end">$<%=String.format("%.2f", item.getSubtotal())%></td>

									<!-- FEEDBACK -->
									<td>
										<%
										if (isCheckedOut) {
										%> <a class="btn btn-sm btn-outline-primary"
										href="<%=request.getContextPath()%>/profile?tab=bookings&feedback=1&bookingId=<%=b.getBookingId()%>&serviceId=<%=item.getServiceId()%>">
											<i class="bi bi-chat-left-text me-1"></i> Feedback
									</a> <%
 } else {
 %>
										<button class="btn btn-sm btn-outline-secondary" disabled>Feedback</button>
										<%
										}
										%>
									</td>

									<!-- CANCEL -->
									<td>
										<%
										if (isNotAssigned) {
										%> <a class="btn btn-sm btn-outline-danger"
										href="<%=request.getContextPath()%>/CancelBookingItemServlet?bookingId=<%=b.getBookingId()%>&serviceId=<%=item.getServiceId()%>"
										onclick="return confirm('Cancel this service from the booking?');">
											<i class="bi bi-x-circle me-1"></i> Cancel
									</a> <%
 } else if (isCancelled) {
 %> <span class="badge bg-dark text-white">Cancelled</span> <%
 } else {
 %>
										<button class="btn btn-sm btn-outline-secondary" disabled>Cancel</button>
										<%
										}
										%>
									</td>

									<!-- UPDATE -->
									<td>
										<%
										if (isNotAssigned) {
										%> <a class="btn btn-sm btn-outline-warning"
										href="<%=request.getContextPath()%>/profile?tab=bookings&editService=1&bookingId=<%=b.getBookingId()%>&serviceId=<%=item.getServiceId()%>">
											<i class="bi bi-pencil-square me-1"></i> Update
									</a> <%
 } else {
 %>
										<button class="btn btn-sm btn-outline-secondary" disabled>Update</button>
										<%
										}
										%>
									</td>
								</tr>

								<%
								}
								%>
							</tbody>
						</table>
					</div>

					<div class="text-end mt-2">
						<strong>Total: $<%=String.format("%.2f", b.getTotalAmount())%></strong>
					</div>

				</div>
			</div>

			<%
			}
			%>
			<%
			}
			%>

			<%
			}
			%>
		</div>
	</div>

	<!-- ================= OVERLAYS ================= -->

	<!-- FEEDBACK OVERLAY -->
	<%
	if (feedback != null) {
	%>
	<div class="overlay">
		<div class="overlay-card">
			<div
				class="p-3 border-bottom d-flex justify-content-between align-items-center">
				<strong>Submit Feedback <%=(feedbackBookingIdStr != null ? "(Booking #" + feedbackBookingIdStr + ")" : "")%></strong>
				<a class="btn btn-sm btn-outline-secondary"
					href="<%=request.getContextPath()%>/profile?tab=bookings">X</a>
			</div>

			<div class="p-3">
				<form method="post"
					action="<%=request.getContextPath()%>/SubmitFeedbackServlet">
					<input type="hidden" name="booking_id"
						value="<%=(feedbackBookingIdStr != null ? feedbackBookingIdStr : "")%>">
					<input type="hidden" name="service_id"
						value="<%=(feedbackServiceIdStr != null ? feedbackServiceIdStr : "")%>">

					<div class="mb-3">
						<label class="form-label">Service Rating</label> <select
							name="service_rating" class="form-control" required>
							<option value="" disabled selected>Select a rating</option>
							<option value="5">5 - Excellent</option>
							<option value="4">4 - Good</option>
							<option value="3">3 - Okay</option>
							<option value="2">2 - Bad</option>
							<option value="1">1 - Very Bad</option>
						</select> <small class="text-muted">Rate the service</small>
					</div>

					<div class="mb-3">
						<label class="form-label">Service Remarks</label>
						<textarea name="service_remarks" class="form-control" rows="3"
							required
							placeholder="What did you like/dislike about the service?"></textarea>
					</div>

					<hr class="my-4">

					<div class="mb-3">
						<label class="form-label">Caregiver Rating</label> <select
							name="caregiver_rating" class="form-control" required>
							<option value="" disabled selected>Select a rating</option>
							<option value="5">5 - Excellent</option>
							<option value="4">4 - Good</option>
							<option value="3">3 - Okay</option>
							<option value="2">2 - Bad</option>
							<option value="1">1 - Very Bad</option>
						</select> <small class="text-muted">Rate the caregiver assigned</small>
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

				<small class="text-muted d-block mt-2">Thank you! Your
					feedback helps us improve.</small>
			</div>
		</div>
	</div>
	<%
	}
	%>

	<!-- UPDATE SERVICE OVERLAY -->
	<%
	if (editService != null) {
	%>
	<div class="overlay">
		<div class="overlay-card">
			<div
				class="p-3 border-bottom d-flex justify-content-between align-items-center">
				<strong> Update Service <%=(editBookingIdStr != null ? "(Booking #" + editBookingIdStr + ")" : "")%>
				</strong> <a class="btn btn-sm btn-outline-secondary"
					href="<%=request.getContextPath()%>/profile?tab=bookings">X</a>
			</div>

			<div class="p-3">
				<%
				if (editItem == null) {
				%>
				<div class="alert alert-warning mb-0">Could not find this
					booking item (missing/invalid bookingId/serviceId).</div>
				<%
				} else {
				%>
				<div class="mb-2">
					<span class="badge bg-light text-dark border"> Service: <strong><%=editItem.getServiceName()%></strong>
					</span>
				</div>

				<form method="post"
					action="<%=request.getContextPath()%>/UpdateBookingItemServlet">

					<input type="hidden" name="bookingId" value="<%=editBookingIdStr%>">
					<input type="hidden" name="serviceId" value="<%=editServiceIdStr%>">

					<div class="mb-3">
						<label class="form-label">Service Date</label> <input type="date"
							class="form-control" name="serviceDate"
							value="<%=editServiceDate%>" required>
					</div>


					<div class="mb-3">
						<label class="form-label">Service Time (Hour)</label> <select
							class="form-control" name="serviceHour" required>
							<%
							for (int h = 0; h < 24; h++) {
								String label = String.format("%02d:00", h);
								String selected = (h == editHour) ? "selected" : "";
							%>
							<option value="<%=h%>" <%=selected%>><%=label%></option>
							<%
							}
							%>
						</select> <small class="text-muted">Only whole hours can be
							selected.</small>
					</div>


					<div class="mb-3">
						<label class="form-label">Quantity</label> <input type="number"
							class="form-control" value="<%=editQty%>" disabled> <small
							class="text-muted">Quantity cannot be changed after
							payment.</small>
					</div>

					<input type="hidden" name="quantity" value="<%=editQty%>">


					<div class="mb-3">
						<label class="form-label">Special Request</label>
						<textarea class="form-control" name="specialRequest" rows="3"><%=editSpecialRequest%></textarea>
					</div>

					<div class="d-flex gap-2">
						<a class="btn btn-outline-secondary"
							href="<%=request.getContextPath()%>/profile?tab=bookings">
							Cancel </a>
						<button class="btn btn-primary" type="submit">Save
							Changes</button>
					</div>
				</form>


				<small class="text-muted d-block mt-2">Changes are locked
					once assigned / checked in.</small>
				<%
				}
				%>
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
