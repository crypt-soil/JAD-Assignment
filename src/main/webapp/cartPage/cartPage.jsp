<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*, model.DBConnection"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Cart</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.cart-wrapper {
	max-width: 1100px;
	margin: 40px auto;
}

.cart-card {
	background: #fff;
	padding: 30px;
	border-radius: 16px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
}

.cart-title {
	font-weight: 700;
	font-size: 1.7rem;
	color: #4b37b8;
}
</style>
</head>
<body>

	<%@ include file="../common/navbar.jsp"%>

	<div class="cart-wrapper">
		<div class="cart-card">

			<%
			if (customerId == null) { //check for customerId 
			%>
			<h2 class="cart-title mb-4">Your Cart</h2>
			<p>
				Please <a href="<%=request.getContextPath()%>/loginPage/login.jsp">login</a>
				to view your cart.
			</p>
			<%
			} else {
				
			Connection conn = null;
			PreparedStatement ps = null;
			ResultSet rs = null;

			double grandTotal = 0;
			int itemCount = 0;

			try {
				conn = DBConnection.getConnection();

				String sql = "SELECT ci.item_id, s.name, s.price, ci.quantity, ci.start_time, ci.end_time " + "FROM cart c "
				+ "JOIN cart_items ci ON c.cart_id = ci.cart_id " + "JOIN service s ON ci.service_id = s.service_id "
				+ "WHERE c.customer_id = ?";

				ps = conn.prepareStatement(sql);
				ps.setInt(1, customerId);
				rs = ps.executeQuery();

				List<Map<String, Object>> items = new ArrayList<>();

				while (rs.next()) {
					// create a hash map with each result row 
					Map<String, Object> m = new HashMap<>();
					m.put("itemId", rs.getInt("item_id"));
					m.put("name", rs.getString("name"));
					m.put("price", rs.getDouble("price"));
					m.put("qty", rs.getInt("quantity"));
					m.put("start", rs.getTimestamp("start_time"));
					m.put("end", rs.getTimestamp("end_time"));
					items.add(m);
				}
				
				itemCount = items.size();
			%>

			<h2 class="cart-title mb-4">
				<!-- get the number of items in the cart based on hash map size -->
				Your Cart (<%=itemCount%> items)
			</h2>

			<%
			if (itemCount == 0) {
			%>
			<p>
				Your cart is empty. Browse <a href="<%=request.getContextPath()%>/categories">services</a>.
			</p>
			<%
			} else {
			%>

			<table class="table table-borderless align-middle">
				<thead class="fw-semibold">
					<tr>
						<th>Service</th>
						<th>Date & Time</th>
						<th>Quantity</th>
						<th>Price</th>
						<th>Total</th>
						<th></th>
					</tr>
				</thead>

				<tbody>

					<%
					for (Map<String, Object> item : items) {

						int itemId = (int) item.get("itemId");
						String name = (String) item.get("name");
						double price = (double) item.get("price");
						int qty = (int) item.get("qty");
						Timestamp start = (Timestamp) item.get("start");
						Timestamp end = (Timestamp) item.get("end");

						double total = price * qty;
						grandTotal += total;

						String startFmt = (start != null) ? start.toString().replace(".0", "") : "Not set";
						String endFmt = (end != null) ? end.toString().replace(".0", "") : "Not set";
					%>

					<tr>
						<!-- Name -->
						<td><strong><%=name%></strong></td>

						<!-- Datetimes -->
						<td style="min-width: 220px;">
							<div>
								<strong>Start:</strong>
								<%=startFmt%></div>
							<div>
								<strong>End:</strong>
								<%=endFmt%></div>
						</td>

						<!-- Quantity -->
						<td><%=qty%></td>

						<!-- Price -->
						<td>S$ <%=String.format("%.2f", price)%></td>

						<!-- Total -->
						<td><strong>S$ <%=String.format("%.2f", total)%></strong></td>

						<!-- Actions -->
						<td><a
							href="setItemDetails.jsp?item_id=<%=itemId%>&mode=edit"class="btn btn-sm btn-outline-primary me-2">Edit</a> 
							<a href="deleteCartItem.jsp?item_id=<%=itemId%>" class="btn btn-sm btn-outline-danger">Remove</a></td>
					</tr>

					<%
					}
					%>

				</tbody>
			</table>

			<hr>

			<div class="text-end">
				<h4>
					Grand Total: <strong>S$ <%=String.format("%.2f", grandTotal)%></strong>
				</h4>
				<a href="#" class="btn btn-dark mt-3">Checkout</a>
			</div>

			<%
			}
			} catch (Exception e) {
			%>
			<p class="text-danger">
				Error loading cart:
				<%=e.getMessage()%></p>
			<%
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
			}
			%>

		</div>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>
