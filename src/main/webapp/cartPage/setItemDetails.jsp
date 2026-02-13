<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page
	import="java.util.*, java.sql.*, java.text.*, model.DBConnection"%>

<%
// get parameter mode
String mode = request.getParameter("mode");
if (mode == null)
	mode = "edit"; // default

// check for customer_id
Integer sCustomerId = (Integer) session.getAttribute("customer_id");
if (sCustomerId == null) {
%>
<script>
            alert("Please login before editing your cart item.");
            window.location.href = "<%=request.getContextPath()%>
	/loginPage/login.jsp";
</script>
<%
return;
}

// input item_id from query string
String itemIdParam = request.getParameter("item_id");
if (itemIdParam == null) {
%>
<p>Invalid cart item.</p>
<%
return;
}
int itemId = Integer.parseInt(itemIdParam);

// variables to display in the form
String serviceName = "";
String serviceDesc = "";
double unitPrice = 0.0;
int serviceId = 0;
int quantity = 1;

java.sql.Timestamp startTime = null;
java.sql.Timestamp endTime = null;

String specialRequest = "";
Integer existingCaregiverId = null;

// NEW: Hour-only inputs
String serviceDateValue = "";
int startHourValue = 9; // default
int durationHoursValue = 1; // default
int MAX_DURATION_HOURS = 12; // change if you want

// caregiver list
List<Map<String, Object>> caregivers = new ArrayList<>();

String errorMsg = null;

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

try {
conn = DBConnection.getConnection();

// load current cart item and service info
String loadSql = "SELECT ci.quantity, ci.start_time, ci.end_time, ci.special_request, ci.caregiver_id, "
		+ "       s.service_id, s.name, s.description, s.price " + "FROM cart_items ci "
		+ "JOIN cart c ON ci.cart_id = c.cart_id " + "JOIN service s ON ci.service_id = s.service_id "
		+ "WHERE ci.item_id = ? AND c.customer_id = ?";

ps = conn.prepareStatement(loadSql);
ps.setInt(1, itemId);
ps.setInt(2, sCustomerId);
rs = ps.executeQuery();

if (!rs.next()) {
%>
<p>Cart item not found or does not belong to you.</p>
<%
rs.close();
ps.close();
return;
} else {
quantity = rs.getInt("quantity");
startTime = rs.getTimestamp("start_time");
endTime = rs.getTimestamp("end_time");
serviceId = rs.getInt("service_id");
serviceName = rs.getString("name");
serviceDesc = rs.getString("description");
unitPrice = rs.getDouble("price");
specialRequest = rs.getString("special_request");

Object cgObj = rs.getObject("caregiver_id");
existingCaregiverId = (cgObj == null) ? null : ((Number) cgObj).intValue();

// Prefill date + hour + duration (hour-only)
if (startTime != null) {
	serviceDateValue = new SimpleDateFormat("yyyy-MM-dd").format(startTime);
	Calendar cal = Calendar.getInstance();
	cal.setTimeInMillis(startTime.getTime());
	startHourValue = cal.get(Calendar.HOUR_OF_DAY);
}

if (startTime != null && endTime != null) {
	long diffMs = endTime.getTime() - startTime.getTime();
	long diffHours = diffMs / (1000L * 60L * 60L);
	durationHoursValue = (int) Math.max(1, diffHours);
	if (durationHoursValue > MAX_DURATION_HOURS)
		durationHoursValue = MAX_DURATION_HOURS;
}
}

rs.close();
ps.close();

// handle post form submit (save & go cart)
if ("POST".equalsIgnoreCase(request.getMethod())) {

String qtyParam = request.getParameter("quantity");
String dateParam = request.getParameter("serviceDate"); // yyyy-MM-dd
String startHourParam = request.getParameter("startHour"); // 0..23
String durationParam = request.getParameter("durationHours"); // 1..MAX

String caregiverParam = request.getParameter("caregiver_id");
String specialParam = request.getParameter("special_request");
if (specialParam != null)
	specialRequest = specialParam;

Integer caregiverId = null;
if (caregiverParam != null && !caregiverParam.isEmpty()) {
	caregiverId = Integer.parseInt(caregiverParam);
}

try {
	quantity = Integer.parseInt(qtyParam);
	if (quantity < 1)
		quantity = 1;
} catch (Exception ex) {
	quantity = 1;
}

// Validate date + hour + duration
if (dateParam == null || dateParam.isEmpty() || startHourParam == null || startHourParam.isEmpty()
		|| durationParam == null || durationParam.isEmpty()) {

	errorMsg = "Please select service date, start hour, and duration.";
} else {

	int startH = -1;
	int durH = -1;

	try {
		startH = Integer.parseInt(startHourParam);
		durH = Integer.parseInt(durationParam);
	} catch (Exception ex) {
		errorMsg = "Invalid time inputs.";
	}

	if (errorMsg == null) {
		if (startH < 0 || startH > 23) {
	errorMsg = "Invalid start hour selected.";
		} else if (durH < 1 || durH > MAX_DURATION_HOURS) {
	errorMsg = "Duration must be between 1 and " + MAX_DURATION_HOURS + " hours.";
		}
	}

	if (errorMsg == null) {
		// Build start timestamp: yyyy-MM-dd HH:00:00
		String startFormatted = String.format("%s %02d:00:00", dateParam, startH);
		java.sql.Timestamp newStart = java.sql.Timestamp.valueOf(startFormatted);

		// Compute end = start + durationHours
		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(newStart.getTime());
		cal.add(Calendar.HOUR_OF_DAY, durH);
		java.sql.Timestamp newEnd = new java.sql.Timestamp(cal.getTimeInMillis());

		// Optional: prevent past start time
		if (newStart.before(new java.sql.Timestamp(System.currentTimeMillis()))) {
	errorMsg = "Start time cannot be in the past.";
		}

		if (errorMsg == null) {
	// check for overlapping bookings (customer conflicts)
	String overlapSql = "SELECT 1 FROM booking_details bd " + "JOIN bookings b ON bd.booking_id = b.booking_id "
			+ "WHERE b.customer_id = ? " + "  AND bd.service_id = ? " + "  AND b.status IN (1,2,3) "
			+ "  AND NOT ( ? >= bd.end_time OR ? <= bd.start_time ) " + "LIMIT 1";

	ps = conn.prepareStatement(overlapSql);
	ps.setInt(1, sCustomerId);
	ps.setInt(2, serviceId);
	ps.setTimestamp(3, newStart);
	ps.setTimestamp(4, newEnd);
	rs = ps.executeQuery();

	boolean hasConflict = rs.next();
	rs.close();
	ps.close();

	if (hasConflict) {
		errorMsg = "You already have a booking for this service that overlaps this time. Please choose another time.";
	} else {

		// caregiver availability check (only if caregiver is selected)
		if (caregiverId != null) {
			String cgOverlapSql = "SELECT 1 " + "FROM booking_details bd "
					+ "JOIN bookings b ON b.booking_id = bd.booking_id " + "WHERE bd.caregiver_id = ? "
					+ "  AND b.status = 2 " + // confirmed blocks
					"  AND bd.caregiver_status IN (1,2) " + "  AND bd.start_time < ? "
					+ "  AND bd.end_time > ? " + "LIMIT 1";

			ps = conn.prepareStatement(cgOverlapSql);
			ps.setInt(1, caregiverId);
			ps.setTimestamp(2, newEnd);
			ps.setTimestamp(3, newStart);
			rs = ps.executeQuery();

			boolean caregiverBusy = rs.next();
			rs.close();
			ps.close();

			if (caregiverBusy) {
				errorMsg = "Selected caregiver is not available during this time. Please choose another caregiver or time.";
			}
		}

		// proceed to update only if no errorMsg
		if (errorMsg == null) {
			String updateSql = "UPDATE cart_items "
					+ "SET quantity = ?, start_time = ?, end_time = ?, caregiver_id = ?, special_request = ? "
					+ "WHERE item_id = ?";

			ps = conn.prepareStatement(updateSql);
			ps.setInt(1, quantity);
			ps.setTimestamp(2, newStart);
			ps.setTimestamp(3, newEnd);

			if (caregiverId != null)
				ps.setInt(4, caregiverId);
			else
				ps.setNull(4, java.sql.Types.INTEGER);

			ps.setString(5, specialRequest);
			ps.setInt(6, itemId);

			ps.executeUpdate();
			ps.close();

			response.sendRedirect(request.getContextPath() + "/cartPage/cartPage.jsp");
			return;
		}
	}
		}

		// keep values for re-render if error
		startTime = newStart;
		endTime = newEnd;
		serviceDateValue = dateParam;
		startHourValue = startH;
		durationHoursValue = durH;
		existingCaregiverId = caregiverId; // keep selection
	}
}
}

// load caregivers for this service using bridge table (many-to-many)
// If start_time and end_time exist, filter out caregivers with time conflicts
String cgSql = "SELECT c.caregiver_id, c.full_name, c.rating " + "FROM caregiver c "
		+ "JOIN caregiver_service cs ON c.caregiver_id = cs.caregiver_id " + "WHERE cs.service_id = ? "
		+ "  AND ( ? IS NULL OR ? IS NULL OR NOT EXISTS ( " + "      SELECT 1 " + "      FROM booking_details bd "
		+ "      JOIN bookings b ON b.booking_id = bd.booking_id " + "      WHERE bd.caregiver_id = c.caregiver_id "
		+ "        AND b.status = 2 " + "        AND bd.caregiver_status IN (1,2) " + "        AND bd.start_time < ? "
		+ "        AND bd.end_time > ? " + "  ))";

ps = conn.prepareStatement(cgSql);
ps.setInt(1, serviceId);

ps.setTimestamp(2, startTime);
ps.setTimestamp(3, endTime);

// overlap check params (newEnd, newStart)
ps.setTimestamp(4, endTime);
ps.setTimestamp(5, startTime);

rs = ps.executeQuery();
while (rs.next()) {
Map<String, Object> row = new HashMap<>();
row.put("id", rs.getInt("caregiver_id"));
row.put("name", rs.getString("full_name"));
row.put("rating", rs.getDouble("rating"));
caregivers.add(row);
}
rs.close();
ps.close();

} catch (Exception e) {
e.printStackTrace();
errorMsg = "An error occurred: " + e.getMessage();

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

// If still empty (e.g. startTime null), set date default to today for nicer UX
if (serviceDateValue == null || serviceDateValue.isEmpty()) {
serviceDateValue = new SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date());
}
%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Set Booking Details</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.wrapper {
	max-width: 800px;
	margin: 40px auto;
}

.form-card {
	background: #fff;
	padding: 35px 40px;
	border-radius: 16px;
	box-shadow: 0 12px 28px rgba(0, 0, 0, 0.07);
}

.page-title {
	font-weight: 700;
	font-size: 1.8rem;
	color: #4b37b8;
}

.label-text {
	font-weight: 600;
	font-size: 0.95rem;
	color: #333;
}

.btn-primary-custom {
	background-color: #8f5bf3;
	border-color: #8f5bf3;
}

.btn-primary-custom:hover {
	background-color: #7b4ad6;
	border-color: #7b4ad6;
}

.btn-outline-custom {
	border-color: #d0d0e6;
	color: #555;
	background: #f9f9ff;
}

.btn-outline-custom:hover {
	background: #ececff;
	border-color: #c2c2e0;
}

.price-pill {
	display: inline-block;
	padding: 6px 14px;
	border-radius: 999px;
	background: #f0e8ff;
	color: #5a36b8;
	font-weight: 600;
	font-size: 0.9rem;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="wrapper">
		<div class="form-card">
			<h2 class="page-title mb-2">Set Booking Details</h2>

			<%
			if (errorMsg != null) {
			%>
			<div class="alert alert-warning"><%=errorMsg%></div>
			<%
			}
			%>

			<form method="post">

				<!-- Display info -->
				<div class="fw-normal fs-6 mb-3">
					You are booking: <strong><%=serviceName%></strong>
				</div>

				<div class="mb-3">
					<label class="label-text">Description</label>
					<div class="p-3 rounded"
						style="background: #faf8ff; border: 1px solid #eee;">
						<%=serviceDesc%>
					</div>
				</div>

				<div class="mb-3">
					<label class="label-text">Price per Hour</label>
					<div class="price-pill">
						S$
						<%=String.format("%.2f", unitPrice)%>
						/ hr
					</div>

				</div>

				<input type="hidden" id="unitPrice" value="<%=unitPrice%>">

				<div class="mb-3">
					<label for="quantity" class="label-text">Number of Helpers
						(Quantity)</label> <input type="number" class="form-control" id="quantity"
						name="quantity" min="1" value="<%=quantity%>">
				</div>

				<!-- NEW: Date + Start Hour + Duration (hours) -->
				<div class="mb-3">
					<label class="label-text">Service Date</label> <input type="date"
						class="form-control" name="serviceDate" required
						value="<%=serviceDateValue%>">
				</div>

				<div class="mb-3">
					<label class="label-text">Start Hour</label> <select
						class="form-select" name="startHour" required>
						<%
						for (int h = 0; h < 24; h++) {
							String selected = (h == startHourValue) ? "selected" : "";
						%>
						<option value="<%=h%>" <%=selected%>><%=String.format("%02d:00", h)%></option>
						<%
						}
						%>
					</select> <small class="text-muted">Only whole hours are allowed.</small>
				</div>

				<div class="mb-3">
					<label class="label-text">Duration (Hours)</label> <input
						type="number" class="form-control" id="durationHours"
						name="durationHours" min="1" max="<%=MAX_DURATION_HOURS%>"
						required value="<%=durationHoursValue%>"> <small
						class="text-muted">End time will be automatically computed
						(start + duration).</small>
				</div>

				<!-- Caregiver selection -->
				<div class="mb-3">
					<label class="label-text">Preferred Caregiver (Optional)</label> <select
						name="caregiver_id" class="form-select">
						<option value="">No preference</option>
						<%
						for (Map<String, Object> cg : caregivers) {
						%>
						<option value="<%=cg.get("id")%>"
							<%=(existingCaregiverId != null && existingCaregiverId.equals(cg.get("id"))) ? "selected" : ""%>>
							<%=cg.get("name")%> (⭐
							<%=cg.get("rating")%>)
						</option>
						<%
						}
						%>
					</select> <small class="text-muted">Caregivers shown are filtered
						based on your selected time (if available).</small>
				</div>

				<!-- Special request -->
				<div class="mb-3">
					<label class="label-text">Special Request (Optional)</label>
					<textarea name="special_request" class="form-control" rows="3"><%=specialRequest == null ? "" : specialRequest%></textarea>
				</div>

				<div class="mb-4">
					<label class="label-text">Estimated Total Price</label>
					<div class="fs-5 fw-semibold mt-1">
						S$ <span id="totalPrice">0.00</span>
					</div>
					<small class="text-muted">Final amount will be confirmed at
						checkout based on your selected quantity.</small>
				</div>

				<div class="d-flex gap-2">
					<button type="submit" class="btn btn-primary-custom">Save
						&amp; Go to Cart</button>

					<%
					if ("create".equals(mode)) {
					%>
					<a
						href="<%=request.getContextPath()%>/cartPage/deleteCartItem.jsp?item_id=<%=itemId%>"
						class="btn btn-outline-custom">Cancel</a>
					<%
					} else {
					%>
					<a href="<%=request.getContextPath()%>/cartPage/cartPage.jsp"
						class="btn btn-outline-custom">Cancel</a>
					<%
					}
					%>
				</div>
			</form>
		</div>
	</div>

	<script>
    const unitPriceInput = document.getElementById("unitPrice");
    const qtyInput = document.getElementById("quantity");
    const durInput = document.getElementById("durationHours");
    const totalSpan = document.getElementById("totalPrice");

    function updateTotal() {
        const unitPrice = parseFloat(unitPriceInput.value) || 0;

        let qty = parseInt(qtyInput.value) || 1;
        let dur = parseInt(durInput.value) || 1;

        if (qty < 1) qty = 1;
        if (dur < 1) dur = 1;

        qtyInput.value = qty;
        durInput.value = dur;

        // hourly rate × duration × quantity
        const total = unitPrice * dur * qty;
        totalSpan.textContent = total.toFixed(2);
    }

    qtyInput.addEventListener("input", updateTotal);
    durInput.addEventListener("input", updateTotal);
    window.addEventListener("load", updateTotal);
</script>


</body>
</html>
