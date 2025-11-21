<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Update Cart Quantity</title>


<%
    Integer customerId = (Integer) session.getAttribute("customer_id");
    if (customerId == null) {
%>
<script>
    alert("Please login first.");
    window.location.href = "<%=request.getContextPath()%>/loginPage/login.jsp";
</script>
<%
        return;
    }

    int serviceId = Integer.parseInt(request.getParameter("id"));
    String action = request.getParameter("action");

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

        // 1. Get cart ID
        int cartId = 0;
        ps = conn.prepareStatement("SELECT cart_id FROM cart WHERE customer_id=?");
        ps.setInt(1, customerId);
        rs = ps.executeQuery();
        if (rs.next()) cartId = rs.getInt("cart_id");
        rs.close();
        ps.close();

        // 2. Get current qty
        ps = conn.prepareStatement("SELECT quantity FROM cart_items WHERE cart_id=? AND service_id=?");
        ps.setInt(1, cartId);
        ps.setInt(2, serviceId);
        rs = ps.executeQuery();

        if (rs.next()) {
            int qty = rs.getInt("quantity");
            rs.close();
            ps.close();

            if ("inc".equals(action)) {
                qty++;
                ps = conn.prepareStatement("UPDATE cart_items SET quantity=? WHERE cart_id=? AND service_id=?");
                ps.setInt(1, qty);
                ps.setInt(2, cartId);
                ps.setInt(3, serviceId);
                ps.executeUpdate();
            } else if ("dec".equals(action)) {
                if (qty > 1) {
                    qty--;
                    ps = conn.prepareStatement("UPDATE cart_items SET quantity=? WHERE cart_id=? AND service_id=?");
                    ps.setInt(1, qty);
                    ps.setInt(2, cartId);
                    ps.setInt(3, serviceId);
                    ps.executeUpdate();
                } else {
                    // qty hits 1 -> remove item
                    ps = conn.prepareStatement("DELETE FROM cart_items WHERE cart_id=? AND service_id=?");
                    ps.setInt(1, cartId);
                    ps.setInt(2, serviceId);
                    ps.executeUpdate();
                }
            }
        }
%>
<script>
    window.location.href = "<%=request.getContextPath()%>/cartPage/cartPage.jsp";
</script>
<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignore) {}
        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
        try { if (conn != null) conn.close(); } catch (Exception ignore) {}
    }
%>

</head>
<body>

</body>
</html>