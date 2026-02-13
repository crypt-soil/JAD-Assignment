<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*,model.Service.Service,model.caregiver.Caregiver"%>
<!-- Lois Poh 2429478 -->
<%
/* Reads service list from request scope; servlet/controller should set "services" attribute */
@SuppressWarnings("unchecked")
List<Service> services = (List<Service>) request.getAttribute("services");

/* Initializes empty list when attribute missing to prevent null checks during rendering */
if (services == null)
	services = new ArrayList<>();

/* Reads caregiver list from request scope; servlet/controller should set "caregivers" attribute */
@SuppressWarnings("unchecked")
List<Caregiver> caregivers = (List<Caregiver>) request.getAttribute("caregivers");

/* Initializes empty list when attribute missing to prevent null checks during rendering */
if (caregivers == null)
	caregivers = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Service Inquiry - Silver Care</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f5f3ff;
	font-family: "Poppins", sans-serif;
}

.wrap {
	max-width: 760px;
	margin: 36px auto;
	padding: 0 16px;
}

.cardx {
	background: #fff;
	border-radius: 14px;
	box-shadow: 0 10px 25px rgba(0, 0, 0, .08);
	padding: 28px 26px;
	border: 1px solid #ede9fe;
}

.title {
	color: #4b37b8;
	font-weight: 800;
}

.hint {
	color: #6b7280;
}

.btn-purple {
	background-color: #6d4a8d;
	color: #fff;
	border: none;
	border-radius: 8px;
	padding: 10px 18px;
	font-weight: 600;
}

.btn-purple:hover {
	filter: brightness(.95);
}

.form-label {
	font-weight: 600;
	color: #374151;
}
</style>
</head>

<body>
	<%-- Includes shared navbar fragment for consistent site navigation --%>
	<%@ include file="/common/navbar.jsp"%>

	<div class="wrap">
		<div class="cardx">
			<h2 class="title mb-2">Service Inquiry</h2>
			<p class="hint mb-4">Send us your question and our team will get
				back to you shortly.</p>

			<%
			/* Reads optional query parameters used to show success/error banners after redirect */
			String err = request.getParameter("error");
			String ok = request.getParameter("success");

			/* Shows success message when redirect includes success=true */
			if ("true".equals(ok)) {
			%>
			<div class="alert alert-success">Inquiry submitted! We’ll
				contact you soon.</div>
			<%
			/* Shows error message when redirect includes a non-empty error parameter */
			} else if (err != null && !err.isBlank()) {
			%>
			<div class="alert alert-danger"><%=err%></div>
			<%
			}
			%>

			<%-- Inquiry submission form posts to create endpoint; HTML validation enabled by required attributes --%>
			<form method="post"
				action="<%=request.getContextPath()%>/inquiry/create"
				class="needs-validation" novalidate>

				<div class="row g-3">

					<!-- Name -->
					<div class="col-md-6">
						<label class="form-label">Name *</label>
						<%-- Captures inquirer name; required field with max length constraint --%>
						<input name="name"
							type="text" class="form-control" maxlength="100" required>
					</div>

					<!-- Email -->
					<div class="col-md-6">
						<label class="form-label">Email *</label>
						<%-- Captures inquirer email; browser validates format via type="email" --%>
						<input name="email"
							type="email" class="form-control" maxlength="100" required>
					</div>

					<!-- Category -->
					<div class="col-12">
						<label class="form-label">Inquiry Category *</label>
						<%-- Category selection controls whether service/caregiver dropdown is shown by JavaScript --%>
						<select
							name="category" id="categorySelect" class="form-select" required>
							<option value="" selected disabled>Choose one...</option>
							<option value="General">General</option>
							<option value="Service">Care Service</option>
							<option value="Caregiver">Caregiver</option>
							<option value="Pricing">Pricing / Packages</option>
							<option value="Other">Other</option>
						</select>
					</div>

					<!-- Service dropdown -->
					<%-- Hidden by default; revealed only when category == "Service" --%>
					<div class="col-12 d-none" id="serviceWrap">
						<label class="form-label">Select Service *</label>
						<select
							name="serviceId" class="form-select">
							<option value="" selected disabled>Choose a service...</option>
							<%
							/* Populates service options from services list provided by servlet/controller */
							for (Service s : services) {
							%>
							<option value="<%=s.getId()%>"><%=s.getName()%></option>
							<%
							}
							%>
						</select>
					</div>

					<!-- Caregiver dropdown -->
					<%-- Hidden by default; revealed only when category == "Caregiver" --%>
					<div class="col-12 d-none" id="caregiverWrap">
						<label class="form-label">Select Caregiver *</label>
						<select
							name="caregiverId" class="form-select">
							<option value="" selected disabled>Choose a caregiver...</option>
							<%
							/* Populates caregiver options from caregivers list provided by servlet/controller */
							for (Caregiver c : caregivers) {
							%>
							<option value="<%=c.getId()%>"><%=c.getFullName()%></option>
							<%
							}
							%>
						</select>
					</div>

					<!-- Message -->
					<div class="col-12">
						<label class="form-label">Message *</label>
						<%-- Captures inquiry message body; required multiline input --%>
						<textarea name="message" class="form-control" rows="5" required></textarea>
					</div>

					<!-- Preferred contact -->
					<div class="col-12">
						<label class="form-label d-block">Preferred contact method
							*</label>

						<div class="form-check form-check-inline">
							<%-- Default contact method is EMAIL; used by JavaScript to toggle phone input requirement --%>
							<input class="form-check-input" type="radio"
								name="preferredContact" id="pcEmail" value="EMAIL" checked>
							<label class="form-check-label" for="pcEmail">Email</label>
						</div>

						<div class="form-check form-check-inline">
							<%-- Selecting PHONE reveals phone input and marks it required via JavaScript --%>
							<input class="form-check-input" type="radio"
								name="preferredContact" id="pcPhone" value="PHONE">
							<label
								class="form-check-label" for="pcPhone">Phone</label>
						</div>

						<%-- Phone field hidden by default; shown and required only when PHONE contact method selected --%>
						<div id="phoneWrap" class="mt-2 d-none">
							<label class="form-label">Phone Number *</label>
							<input
								name="phone" id="phoneInput" type="text" class="form-control"
								maxlength="20">
						</div>
					</div>

					<!-- Buttons -->
					<div class="col-12 d-flex gap-2">
						<%-- Submits inquiry form to create endpoint --%>
						<button class="btn btn-purple" type="submit">Submit
							Inquiry</button>

						<%-- Returns to categories listing without submitting form --%>
						<a class="btn btn-outline-secondary"
							href="<%=request.getContextPath()%>/categories">Back</a>
					</div>

				</div>
			</form>
		</div>
	</div>

	<script>
/* References category select and dependent dropdown wrappers for dynamic UI behavior */
const categorySelect = document.getElementById("categorySelect");
const serviceWrap = document.getElementById("serviceWrap");
const caregiverWrap = document.getElementById("caregiverWrap");

/* Updates visibility of service/caregiver selectors based on selected category */
categorySelect.addEventListener("change", () => {
  // Hides both dependent selectors before applying category-specific rule
  serviceWrap.classList.add("d-none");
  caregiverWrap.classList.add("d-none");

  // Reveals service selector when category indicates a service-related inquiry
  if (categorySelect.value === "Service") {
    serviceWrap.classList.remove("d-none");
  }

  // Reveals caregiver selector when category indicates a caregiver-related inquiry
  if (categorySelect.value === "Caregiver") {
    caregiverWrap.classList.remove("d-none");
  }
});

// Phone toggle
/* References preferred contact radio inputs and phone input wrapper for requirement toggling */
const pcEmail = document.getElementById("pcEmail");
const pcPhone = document.getElementById("pcPhone");
const phoneWrap = document.getElementById("phoneWrap");
const phoneInput = document.getElementById("phoneInput");

/* Shows phone input and marks required when PHONE is selected; hides and clears when EMAIL is selected */
function togglePhone() {
  if (pcPhone.checked) {
    phoneWrap.classList.remove("d-none");
    phoneInput.required = true;
  } else {
    phoneWrap.classList.add("d-none");
    phoneInput.required = false;
    phoneInput.value = "";
  }
}

/* Registers listeners so phone field updates immediately when contact method changes */
pcEmail.addEventListener("change", togglePhone);
pcPhone.addEventListener("change", togglePhone);

/* Applies initial state on page load to match default selected contact method */
togglePhone();
</script>

	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
