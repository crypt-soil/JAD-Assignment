<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.CartItem"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout Page</title>
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<style>
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
}

.cardish {
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
}

.title {
	font-weight: 700;
	color: #4b37b8;
}

.muted {
	color: #6b7280;
}
</style>
</head>
<body>
	<%@ include file="../common/navbar.jsp"%>

	<div class="container my-5">
		<div class="cardish p-4 p-md-5">

			<h2 class="mb-4 title">Checkout</h2>

			<%
			List<CartItem> items = (List<CartItem>) request.getAttribute("cartItems");
			Double subtotal = (Double) request.getAttribute("subtotal");
			Double gstRate = (Double) request.getAttribute("gstRate");
			Double gstAmount = (Double) request.getAttribute("gstAmount");
			Double total = (Double) request.getAttribute("total");

			// Safety defaults (avoid null pointer if controller forgets to set)
			if (subtotal == null)
				subtotal = 0.0;
			if (gstRate == null)
				gstRate = 0.0;
			if (gstAmount == null)
				gstAmount = 0.0;
			if (total == null)
				total = 0.0;
			%>

			<%
			if (items == null || items.isEmpty()) {
			%>

			<div class="alert alert-info mb-0">Your cart is empty. Go back
				to services.</div>

			<%
			} else {
			%>

			<div class="table-responsive">
				<table class="table align-middle mb-0">
					<thead>
						<tr>
							<th>Service</th>
							<th class="text-center" style="width: 90px;">Qty</th>
							<th style="width: 140px;">Hourly Rate</th>
							<th style="width: 140px;">Line Total</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (CartItem item : items) {
						%>
						<tr>
							<td><strong><%=item.getServiceName()%></strong>
								<div class="small muted">
									<!-- OPTIONAL: show duration if your CartItem has it -->
									<%
									// If you added durationHours into CartItem, uncomment:
									// out.print("Duration: " + item.getDurationHours() + " hour(s)");
									%>
								</div></td>

							<td class="text-center"><%=item.getQuantity()%></td>

							<!-- Treat item.getPrice() as hourly rate -->
							<td>S$ <%=String.format("%.2f", item.getPrice())%> / hr
							</td>

							<!-- Must already be computed as: price * durationHours * qty -->
							<td><strong>S$ <%=String.format("%.2f", item.getLineTotal())%></strong></td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
			</div>

			<hr class="my-4">

			<div class="text-end">
				<p class="mb-1">
					Subtotal (without GST): <strong>S$ <%=String.format("%.2f", subtotal)%></strong>
				</p>

				<p class="mb-1">
					GST (<%=(int) (gstRate * 100)%>%): <strong>S$ <%=String.format("%.2f", gstAmount)%></strong>
				</p>

				<h4 class="mt-2">
					Total (with GST): <strong>S$ <%=String.format("%.2f", total)%></strong>
				</h4>

				<form method="post"
					action="<%=request.getContextPath()%>/confirmCheckout"
					class="mt-3">
					<button type="submit" class="btn btn-dark">Confirm Booking</button>
					<a href="<%=request.getContextPath()%>/cartPage/cartPage.jsp"
						class="btn btn-outline-secondary ms-2">Back to Cart</a>
				</form>
			</div>

			<%
			}
			%>

		</div>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>
