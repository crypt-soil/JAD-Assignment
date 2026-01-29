<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, model.CartItem" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Checkout Page</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="../common/navbar.jsp"%>

<div class="container my-5">
  <h2 class="mb-4">Checkout</h2>

  <%
    List<CartItem> items = (List<CartItem>) request.getAttribute("cartItems");
    Double subtotal = (Double) request.getAttribute("subtotal");
    Double gstRate = (Double) request.getAttribute("gstRate");
    Double gstAmount = (Double) request.getAttribute("gstAmount");
    Double total = (Double) request.getAttribute("total");
  %>

  <% if (items == null || items.isEmpty()) { %>
    <div class="alert alert-info">Your cart is empty. Go back to services.</div>
  <% } else { %>

    <table class="table align-middle">
      <thead>
        <tr>
          <th>Service</th>
          <th>Qty</th>
          <th>Price</th>
          <th>Line Total</th>
        </tr>
      </thead>
      <tbody>
      <% for (CartItem item : items) { %>
        <tr>
          <td><strong><%= item.getServiceName() %></strong></td>
          <td><%= item.getQuantity() %></td>
          <td>S$ <%= String.format("%.2f", item.getPrice()) %></td>
          <td>S$ <%= String.format("%.2f", item.getLineTotal()) %></td>
        </tr>
      <% } %>
      </tbody>
    </table>

    <div class="text-end">
      <p class="mb-1">Subtotal (without GST): <strong>S$ <%= String.format("%.2f", subtotal) %></strong></p>
      <p class="mb-1">GST (<%= (int)(gstRate * 100) %>%): <strong>S$ <%= String.format("%.2f", gstAmount) %></strong></p>
      <h4>Total (with GST): <strong>S$ <%= String.format("%.2f", total) %></strong></h4>

      <form method="post" action="<%= request.getContextPath() %>/confirmCheckout" class="mt-3">
        <button type="submit" class="btn btn-dark">Confirm Booking</button>
        <a href="<%= request.getContextPath() %>/cartPage/cartPage.jsp" class="btn btn-outline-secondary ms-2">Back to Cart</a>
      </form>
    </div>

  <% } %>
</div>

<%@ include file="../common/footer.jsp"%>
</body>
</html>
