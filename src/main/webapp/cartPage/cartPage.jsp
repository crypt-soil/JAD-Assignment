<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Your Cart</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

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
    box-shadow: 0 12px 30px rgba(0,0,0,0.08);
}

.cart-title {
    font-weight: 700;
    font-size: 1.7rem;
    color: #4b37b8;
}

.qty-box a {
    padding: 4px 10px;
    border-radius: 6px;
    border: 1px solid #ccc;
    background-color: #fafafa;
    text-decoration: none;
    color: #333;
    font-weight: 600;
}

.qty-box a:hover {
    background-color: #eee;
}

</style>
</head>
<body>

<%@ include file="../common/navbar.jsp" %>

<div class="cart-wrapper">
<div class="cart-card">

<%

    if (customerId == null) {
%>
        <h2 class="cart-title mb-4">Your Cart</h2>
        <p>Please <a href="<%=request.getContextPath()%>/loginPage/login.jsp">login</a> to view your cart.</p>
<%
    } else {

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        double grandTotal = 0;
        int itemCount = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/silvercare",
                "root",
                "root1234"
            );

            String sql =
                "SELECT ci.item_id, s.service_id, s.name, s.price, ci.quantity " +
                "FROM cart c " +
                "JOIN cart_items ci ON c.cart_id = ci.cart_id " +
                "JOIN service s ON ci.service_id = s.service_id " +
                "WHERE c.customer_id = ?";

            ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            rs = ps.executeQuery();

            List<Map<String,Object>> cartItems = new ArrayList<>();

            while (rs.next()) {
                Map<String,Object> item = new HashMap<>();
                item.put("serviceId", rs.getInt("service_id"));
                item.put("name", rs.getString("name"));
                item.put("price", rs.getDouble("price"));
                item.put("qty", rs.getInt("quantity"));
                cartItems.add(item);
            }

            itemCount = cartItems.size();
%>

        <h2 class="cart-title mb-4">Your Cart (<%=itemCount%> items)</h2>

<%
            if (itemCount == 0) {
%>
        <p>Your cart is empty. Browse <a href="<%=request.getContextPath()%>/categories">services</a>.</p>
<%
            } else {
%>

<table class="table align-middle">
<thead>
<tr>
    <th>Service</th>
    <th>Price</th>
    <th style="width: 180px;">Quantity</th>
    <th>Total</th>
    <th></th>
</tr>
</thead>

<tbody>

<%
    for (Map<String,Object> item : cartItems) {
        int serviceId = (int) item.get("serviceId");
        String name = (String) item.get("name");
        double price = (double) item.get("price");
        int qty = (int) item.get("qty");
        double total = price * qty;
        grandTotal += total;
%>

<tr>
    <td><%=name%></td>
    <td>$<%=String.format("%.2f", price)%></td>

    <td>
        <div class="qty-box d-flex align-items-center gap-2">

            <a href="<%=request.getContextPath()%>/cartPage/updateCart.jsp?action=dec&id=<%=serviceId%>">-</a>

            <span><%=qty%></span>

            <a href="<%=request.getContextPath()%>/cartPage/updateCart.jsp?action=inc&id=<%=serviceId%>">+</a>

        </div>
    </td>

    <td>$<%=String.format("%.2f", total)%></td>

    <td>
        <a href="<%=request.getContextPath()%>/cartPage/deleteCartItem.jsp?id=<%=serviceId%>"
           class="btn btn-sm btn-outline-danger">x</a>
    </td>
</tr>

<%
    } // end loop
%>

</tbody>
</table>

<hr>

<div class="text-end">
    <h4>Grand Total: <strong>$<%=String.format("%.2f", grandTotal)%></strong></h4>
    <a href="#" class="btn btn-dark mt-3">Checkout</a>
</div>

<%
            } // end if items
        } catch (Exception e) {
%>
    <p class="text-danger">Error loading cart: <%=e.getMessage()%></p>
<%
        } finally {
            try { if (rs != null) rs.close(); } catch (Exception ignore) {}
            try { if (ps != null) ps.close(); } catch (Exception ignore) {}
            try { if (conn != null) conn.close(); } catch (Exception ignore) {}
        }
    }
%>

</div>
</div>

<%@ include file="../common/footer.jsp" %>
</body>
</html>
