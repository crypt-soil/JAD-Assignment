<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="jakarta.servlet.http.HttpSession, java.util.*, model.Customer"%>
<%@ page import="model.MedicalInfo, model.EmergencyContact"%>

<%
// Admin guard
HttpSession sess = request.getSession(false);
if (sess == null || !"admin".equals(sess.getAttribute("role"))) {
	response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
	return;
}

Customer customer = (Customer) request.getAttribute("customer");
MedicalInfo medicalInfo = (MedicalInfo) request.getAttribute("medicalInfo");

@SuppressWarnings("unchecked")
List<EmergencyContact> emergencyContacts = (List<EmergencyContact>) request.getAttribute("emergencyContacts");

if (customer == null) {
	response.sendRedirect(request.getContextPath() + "/admin/management");
	return;
}

String savedConditionsCsv = "";
String savedAllergies = "";

if (medicalInfo != null) {
	if (medicalInfo.getConditionsCsv() != null)
		savedConditionsCsv = medicalInfo.getConditionsCsv();
	if (medicalInfo.getAllergiesText() != null)
		savedAllergies = medicalInfo.getAllergiesText();
}

// for checkbox matching
String padded = "," + savedConditionsCsv.replace(" ", "") + ",";
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin - Customer Profile</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
	rel="stylesheet">

<style>
body {
	background: #f2f0ff;
	font-family: "Poppins", sans-serif;
}

.wrap {
	max-width: 1050px;
	margin: 35px auto;
	padding: 0 16px;
}

.topbar {
	display: flex;
	justify-content: space-between;
	align-items: center;
	gap: 12px;
	margin-bottom: 16px;
}

.title {
	font-weight: 800;
	color: #4b37b8;
	margin: 0;
}

.subtitle {
	color: #6b7280;
	margin: 4px 0 0 0;
	font-size: 0.95rem;
}

.btn-back {
	background: #ffffff;
	border: 1px solid #d9c7ff;
	color: #4b37b8;
	border-radius: 10px;
	padding: 8px 14px;
	font-weight: 700;
}

.card-soft {
	border: none;
	border-radius: 18px;
	box-shadow: 0 8px 22px rgba(0, 0, 0, 0.10);
}

.card-soft .card-header {
	background: #ffffff;
	border-bottom: 1px solid #efe7ff;
	border-top-left-radius: 18px;
	border-top-right-radius: 18px;
	padding: 14px 18px;
	display: flex;
	justify-content: space-between;
	align-items: center;
}

.chip {
	background: #f5f0ff;
	color: #4b37b8;
	border-radius: 999px;
	padding: 4px 10px;
	font-weight: 800;
	font-size: 0.82rem;
}

.label {
	font-weight: 700;
	color: #374151;
	font-size: 0.9rem;
	margin-bottom: 6px;
}

.input-soft {
	background: #f7f7f7;
	border: 1px solid #efe7ff;
	border-radius: 12px;
	padding: 10px 12px;
}

.btn-primary-soft {
	background: #6a4bc7;
	border: none;
	border-radius: 12px;
	padding: 8px 16px;
	font-weight: 800;
}

.btn-primary-soft:hover {
	background: #5a3ab1;
}

.btn-outline-soft {
	border: 1px solid #d9c7ff;
	color: #4b37b8;
	border-radius: 12px;
	padding: 8px 16px;
	font-weight: 800;
	background: #fff;
}

.btn-outline-soft:hover {
	background: #f5f0ff;
}

.btn-danger-icon {
	background: transparent;
	border: none;
	color: #e63946;
	font-size: 1.2rem;
	padding: 4px 8px;
	border-radius: 10px;
}

.btn-danger-icon:hover {
	color: #b0232f;
	background: rgba(230, 57, 70, 0.08);
}

.table thead th {
	color: #6b7280;
	font-weight: 800;
	font-size: 0.85rem;
	border-top: none;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="wrap">

		<div class="topbar">
			<div>
				<h3 class="title">Customer Profile</h3>
				<p class="subtitle mb-0">
					Managing: <strong><%=customer.getUsername()%></strong> <span
						class="chip ms-2">ID: <%=customer.getCustomer_id()%></span>
				</p>
			</div>

			<a class="btn-back"
				href="<%=request.getContextPath()%>/admin/management"> <i
				class="bi bi-arrow-left me-1"></i> Back
			</a>
		</div>

		<!-- BASIC CUSTOMER INFO -->
		<div class="card card-soft mb-4">
			<div class="card-header">
				<strong>Basic Details</strong>
			</div>

			<div class="card-body">
				<div class="row g-3">
					<div class="col-md-6">
						<div class="label">Full Name</div>
						<div class="input-soft"><%=customer.getFull_name() == null ? "-" : customer.getFull_name()%></div>
					</div>

					<div class="col-md-6">
						<div class="label">Email</div>
						<div class="input-soft"><%=customer.getEmail() == null ? "-" : customer.getEmail()%></div>
					</div>

					<div class="col-md-6">
						<div class="label">Phone</div>
						<div class="input-soft"><%=customer.getPhone() == null ? "-" : customer.getPhone()%></div>
					</div>

					<div class="col-md-6">
						<div class="label">Zip Code</div>
						<div class="input-soft"><%=customer.getZipcode() == null ? "-" : customer.getZipcode()%></div>
					</div>

					<div class="col-12">
						<div class="label">Address</div>
						<div class="input-soft"><%=customer.getAddress() == null ? "-" : customer.getAddress()%></div>
					</div>
				</div>
			</div>
		</div>

		<!-- MEDICAL INFO -->
		<div class="card card-soft mb-4">
			<div class="card-header">
				<strong>Medical Information</strong>
			</div>

			<div class="card-body">
				<%
				String[] conditionOptions = {"Diabetes", "Heart Disease", "Heart Failure", "Stroke", "Asthma", "COPD", "Arthritis",
						"Cancer", "High Blood Pressure", "Alzheimer’s Disease / Dementia", "Other"};
				%>

				<form method="post"
					action="<%=request.getContextPath()%>/admin/clients/medical/update">

					<input type="hidden" name="customer_id"
						value="<%=customer.getCustomer_id()%>">

					<div class="label mb-2">Medical Conditions</div>

					<div class="row g-2">
						<%
						for (String opt : conditionOptions) {
							String key = opt.replace(" ", "_").replace("’", "").replace("/", "_");
							boolean checked = padded.contains("," + opt.replace(" ", "") + ",");
						%>
						<div class="col-12 col-md-6 col-lg-4">
							<div class="form-check">
								<input class="form-check-input" type="checkbox"
									name="conditions" id="cond_<%=key%>" value="<%=opt%>"
									<%=checked ? "checked" : ""%>> <label
									class="form-check-label" for="cond_<%=key%>"><%=opt%></label>
							</div>
						</div>
						<%
						}
						%>
					</div>

					<div class="mt-3">
						<div class="label">Allergies</div>
						<textarea class="form-control input-soft" name="allergies"
							rows="3" placeholder="e.g. Penicillin, shellfish, dust"><%=savedAllergies%></textarea>
					</div>

					<div class="d-flex gap-2 mt-3">
						<button type="submit" class="btn btn-primary-soft">
							<i class="bi bi-save me-1"></i> Save Medical Info
						</button>
					</div>
				</form>
			</div>
		</div>


		<!-- EMERGENCY CONTACTS -->
		<div class="card card-soft">
			<div class="card-header">
				<strong>Emergency Contacts</strong>

				<button class="btn btn-primary-soft btn-sm" type="button"
					data-bs-toggle="modal" data-bs-target="#addContactModal">
					<i class="bi bi-plus-lg me-1"></i> Add Contact
				</button>
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
								<th style="width: 170px;">Actions</th>
							</tr>
						</thead>
						<tbody>
							<%
							for (EmergencyContact c : emergencyContacts) {
								String rel = (c.getRelationship() == null ? "-" : c.getRelationship());
								String em = (c.getEmail() == null ? "-" : c.getEmail());
							%>
							<tr>
								<td><%=c.getContactName()%></td>
								<td><%=rel%></td>
								<td><%=c.getPhone()%></td>
								<td><%=em%></td>
								<td class="d-flex gap-2">
									<!-- Edit: use data-* (safer than inline string concat) -->
									<button type="button" class="btn btn-outline-soft btn-sm"
										data-bs-toggle="modal" data-bs-target="#editContactModal"
										data-id="<%=c.getContactId()%>"
										data-name="<%=c.getContactName()%>"
										data-relationship="<%=c.getRelationship() == null ? "" : c.getRelationship()%>"
										data-phone="<%=c.getPhone()%>"
										data-email="<%=c.getEmail() == null ? "" : c.getEmail()%>">
										<i class="bi bi-pencil-square me-1"></i> Edit
									</button> <!-- Delete --> <a class="btn-danger-icon"
									href="<%=request.getContextPath()%>/admin/clients/emergency/delete?customer_id=<%=customer.getCustomer_id()%>&id=<%=c.getContactId()%>"
									onclick="return confirm('Delete this contact?');"
									title="Delete"> <i class="bi bi-trash"></i>
								</a>
								</td>
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

	</div>

	<!-- ADD CONTACT MODAL -->
	<div class="modal fade" id="addContactModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<form class="modal-content" method="post"
				action="<%=request.getContextPath()%>/admin/clients/emergency/save">
				<div class="modal-header">
					<h5 class="modal-title">Add Emergency Contact</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<div class="modal-body">
					<input type="hidden" name="customer_id"
						value="<%=customer.getCustomer_id()%>"> <input
						type="hidden" name="contact_id" value="">

					<div class="mb-3">
						<label class="form-label">Name</label> <input
							class="form-control input-soft" name="contact_name" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Relationship</label> <input
							class="form-control input-soft" name="relationship"
							placeholder="e.g. Mother, Son">
					</div>

					<div class="mb-3">
						<label class="form-label">Phone</label> <input
							class="form-control input-soft" name="phone" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Email (optional)</label> <input
							class="form-control input-soft" name="email" type="email">
					</div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-outline-soft"
						data-bs-dismiss="modal">Cancel</button>
					<button type="submit" class="btn btn-primary-soft">Save</button>
				</div>
			</form>
		</div>
	</div>

	<!-- EDIT CONTACT MODAL -->
	<div class="modal fade" id="editContactModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<form class="modal-content" method="post"
				action="<%=request.getContextPath()%>/admin/clients/emergency/save">
				<div class="modal-header">
					<h5 class="modal-title">Edit Emergency Contact</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
				</div>

				<div class="modal-body">
					<input type="hidden" name="customer_id"
						value="<%=customer.getCustomer_id()%>"> <input
						type="hidden" id="edit_contact_id" name="contact_id">

					<div class="mb-3">
						<label class="form-label">Name</label> <input
							class="form-control input-soft" id="edit_contact_name"
							name="contact_name" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Relationship</label> <input
							class="form-control input-soft" id="edit_relationship"
							name="relationship">
					</div>

					<div class="mb-3">
						<label class="form-label">Phone</label> <input
							class="form-control input-soft" id="edit_phone" name="phone"
							required>
					</div>

					<div class="mb-3">
						<label class="form-label">Email (optional)</label> <input
							class="form-control input-soft" id="edit_email" name="email"
							type="email">
					</div>
				</div>

				<div class="modal-footer">
					<button type="button" class="btn btn-outline-soft"
						data-bs-dismiss="modal">Cancel</button>
					<button type="submit" class="btn btn-primary-soft">Save
						Changes</button>
				</div>
			</form>
		</div>
	</div>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

	<script>
		// Fill Edit modal using data-* attributes (safe for quotes)
		const editModal = document.getElementById('editContactModal');
		editModal
				.addEventListener(
						'show.bs.modal',
						function(event) {
							const btn = event.relatedTarget;

							document.getElementById("edit_contact_id").value = btn.dataset.id
									|| "";
							document.getElementById("edit_contact_name").value = btn.dataset.name
									|| "";
							document.getElementById("edit_relationship").value = btn.dataset.relationship
									|| "";
							document.getElementById("edit_phone").value = btn.dataset.phone
									|| "";
							document.getElementById("edit_email").value = btn.dataset.email
									|| "";
						});
	</script>

</body>
</html>
s
