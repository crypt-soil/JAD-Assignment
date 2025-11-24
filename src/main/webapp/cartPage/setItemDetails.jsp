<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, java.text.*" %>

<%
    // ---- AUTH CHECK ----
    Integer sCustomerId = (Integer) session.getAttribute("customer_id");
    if (sCustomerId == null) {
%>
    <script>
        alert("Please login before editing your cart item.");
        window.location.href = "<%=request.getContextPath()%>/loginPage/login.jsp";
    </script>
<%
        return;
    }

    // ---- INPUT: item_id from query string ----
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

    String errorMsg = null;

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/silvercare",
            "root",
            "root1234"
        );

        // ---- load current cart item + service info (ensure item belongs to this user) ----
        String loadSql =
            "SELECT ci.quantity, ci.start_time, ci.end_time, " +
            "       s.service_id, s.name, s.description, s.price " +
            "FROM cart_items ci " +
            "JOIN cart c ON ci.cart_id = c.cart_id " +
            "JOIN service s ON ci.service_id = s.service_id " +
            "WHERE ci.item_id = ? AND c.customer_id = ?";
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
        }
        rs.close();
        ps.close();

        // ---- HANDLE FORM SUBMIT (POST) ----
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            String qtyParam = request.getParameter("quantity");
            String startParam = request.getParameter("startDateTime");
            String endParam = request.getParameter("endDateTime");

            try {
                quantity = Integer.parseInt(qtyParam);
                if (quantity < 1) quantity = 1;
            } catch (Exception ex) {
                quantity = 1;
            }

            // convert datetime-local (yyyy-MM-dd'T'HH:mm) to Timestamp
            if (startParam != null && endParam != null &&
                !startParam.isEmpty() && !endParam.isEmpty()) {

                String startFormatted = startParam.replace("T", " ") + ":00";
                String endFormatted   = endParam.replace("T", " ") + ":00";
                java.sql.Timestamp newStart = java.sql.Timestamp.valueOf(startFormatted);
                java.sql.Timestamp newEnd   = java.sql.Timestamp.valueOf(endFormatted);

                if (newEnd.before(newStart)) {
                    errorMsg = "End time must be after start time.";
                } else {
                    // ---- CHECK FOR OVERLAPPING CONFIRMED BOOKINGS ----
                    String overlapSql =
                        "SELECT 1 " +
                        "FROM booking_details bd " +
                        "JOIN bookings b ON bd.booking_id = b.booking_id " +
                        "WHERE b.customer_id = ? " +
                        "  AND bd.service_id = ? " +
                        "  AND b.status IN (1,2,3) " + // pending/confirmed/completed
                        "  AND NOT ( ? >= bd.end_time OR ? <= bd.start_time ) " +
                        "LIMIT 1";

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
                        // ---- UPDATE cart_items ----
                        String updateSql =
                            "UPDATE cart_items " +
                            "SET quantity = ?, start_time = ?, end_time = ? " +
                            "WHERE item_id = ?";
                        ps = conn.prepareStatement(updateSql);
                        ps.setInt(1, quantity);
                        ps.setTimestamp(2, newStart);
                        ps.setTimestamp(3, newEnd);
                        ps.setInt(4, itemId);
                        ps.executeUpdate();
                        ps.close();

                        // redirect to cart
                        response.sendRedirect(request.getContextPath() + "/cartPage/cartPage.jsp");
                        return;
                    }

                    // if we reach here, there was an error, so keep values in form
                    startTime = newStart;
                    endTime = newEnd;
                }
            } else {
                errorMsg = "Please select both start and end date/time.";
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
        errorMsg = "An error occurred: " + e.getMessage();
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignore) {}
        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
        try { if (conn != null) conn.close(); } catch (Exception ignore) {}
    }

    // ---- format timestamps for datetime-local value ----
    String startValue = "";
    String endValue = "";
    if (startTime != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        startValue = sdf.format(startTime);
    }
    if (endTime != null) {
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        endValue = sdf.format(endTime);
    }

%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Set Booking Details</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
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
        background: #ffffff;
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

<%@ include file="../common/navbar.jsp" %>

<div class="wrapper">
    <div class="form-card">
        <h2 class="page-title mb-2">Set Booking Details</h2>
        
        <% if (errorMsg != null) { %>
            <div class="alert alert-warning">
                <%= errorMsg %>
            </div>
        <% } %>

        <form method="post">
            <!-- display-only info -->
			<div class="fw-normal fs-6 mb-3">
            	You are booking: <strong><%= serviceName %></strong>
        	</div>
			<div class="mb-3">
			    <label class="label-text">Description</label>
			    <div class="p-3 rounded" style="background:#faf8ff; border:1px solid #eee;">
			        <%= serviceDesc %>
			    </div>
			</div>
			
			<div class="mb-3">
			    <label class="label-text">Price per Session</label>
			    <div class="price-pill">
			        S$ <%= String.format("%.2f", unitPrice) %>
			    </div>
			</div>
			<input type="hidden" id="unitPrice" value="<%= unitPrice %>">
            <!-- quantity -->
            <div class="mb-3">
                <label for="quantity" class="label-text">Number of Helpers (Quantity)</label>
                <input type="number" class="form-control" id="quantity" name="quantity"
                       min="1" value="<%= quantity %>">
            </div>

            <!-- datetime -->
            <div class="mb-3">
                <label for="startDateTime" class="label-text">Start Date & Time</label>
                <input type="datetime-local" class="form-control" id="startDateTime"
                       name="startDateTime" required
                       value="<%= startValue %>">
            </div>

            <div class="mb-3">
                <label for="endDateTime" class="label-text">End Date & Time</label>
                <input type="datetime-local" class="form-control" id="endDateTime"
                       name="endDateTime" required
                       value="<%= endValue %>">
            </div>

            <!-- total price display only -->
            <div class="mb-4">
                <label class="label-text">Estimated Total Price</label>
                <div class="fs-5 fw-semibold mt-1">
                    S$ <span id="totalPrice">0.00</span>
                </div>
                <small class="text-muted">
                    Final amount will be confirmed at checkout based on your selected quantity.
                </small>
            </div>

            <div class="d-flex gap-2">
                <button type="submit" class="btn btn-primary-custom">
                    Save &amp; Go to Cart
                </button>
                <a href="<%=request.getContextPath()%>/cartPage/cartPage.jsp"
                   class="btn btn-outline-custom">
                    Cancel
                </a>
            </div>
        </form>
    </div>
</div>

<script>
    const unitPriceInput = document.getElementById("unitPrice");
    const qtyInput = document.getElementById("quantity");
    const totalSpan = document.getElementById("totalPrice");

    function updateTotal() {
        const unitPrice = parseFloat(unitPriceInput.value) || 0;
        let qty = parseInt(qtyInput.value) || 1;
        if (qty < 1) qty = 1;
        qtyInput.value = qty;
        const total = unitPrice * qty;
        totalSpan.textContent = total.toFixed(2);
    }

    qtyInput.addEventListener("input", updateTotal);
    window.addEventListener("load", updateTotal);
</script>

</body>
</html>
