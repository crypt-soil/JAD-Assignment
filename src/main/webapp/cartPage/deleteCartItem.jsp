<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
<title>Delete Cart from Item</title>

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

        // Get cart id
        int cartId = 0;
        ps = conn.prepareStatement("SELECT cart_id FROM cart WHERE customer_id=?");
        ps.setInt(1, customerId);
        rs = ps.executeQuery();
        if (rs.next()) cartId = rs.getInt("cart_id");
        rs.close();
        ps.close();

        ps = conn.prepareStatement("DELETE FROM cart_items WHERE cart_id=? AND service_id=?");
        ps.setInt(1, cartId);
        ps.setInt(2, serviceId);
        ps.executeUpdate();
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