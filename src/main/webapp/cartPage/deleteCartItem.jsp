<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

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

    // IMPORTANT — Parameter must match cart page
    String itemParam = request.getParameter("item_id");
    if (itemParam == null) {
%>
<script>
    alert("Invalid item selected.");
    window.location.href = "<%=request.getContextPath()%>/cartPage/cartPage.jsp";
</script>
<%
        return;
    }

    int itemId = Integer.parseInt(itemParam);

    Connection conn = null;
    PreparedStatement ps = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/silvercare",
            "root",
            "root1234"
        );

        // Ensure the item belongs to this customer's cart
        String deleteSql =
            "DELETE ci FROM cart_items ci " +
            "JOIN cart c ON ci.cart_id = c.cart_id " +
            "WHERE ci.item_id = ? AND c.customer_id = ?";

        ps = conn.prepareStatement(deleteSql);
        ps.setInt(1, itemId);
        ps.setInt(2, customerId);
        ps.executeUpdate();
%>
<script>
    window.location.href = "<%=request.getContextPath()%>/cartPage/cartPage.jsp";
</script>
<%
    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
        try { if (conn != null) conn.close(); } catch (Exception ignore) {}
    }
%>
