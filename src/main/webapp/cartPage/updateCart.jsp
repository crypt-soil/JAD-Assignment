<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, model.DBConnection" %>
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

    // now using item_id instead of service_id
    int itemId = Integer.parseInt(request.getParameter("id"));
    String action = request.getParameter("action");

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        conn = DBConnection.getConnection();

        // get qty from cart_items
        ps = conn.prepareStatement("SELECT quantity FROM cart_items WHERE item_id = ?");
        ps.setInt(1, itemId);
        rs = ps.executeQuery();

        if (rs.next()) {
            int qty = rs.getInt("quantity");
            rs.close();
            ps.close();

            if ("inc".equals(action)) {

                qty++;
                ps = conn.prepareStatement("UPDATE cart_items SET quantity=? WHERE item_id=?");
                ps.setInt(1, qty);
                ps.setInt(2, itemId);
                ps.executeUpdate();

            } else if ("dec".equals(action)) {

                if (qty > 1) {
                    qty--;
                    ps = conn.prepareStatement("UPDATE cart_items SET quantity=? WHERE item_id=?");
                    ps.setInt(1, qty);
                    ps.setInt(2, itemId);
                    ps.executeUpdate();
                } else {
                    // qty == 1 → removing the item
                    ps = conn.prepareStatement("DELETE FROM cart_items WHERE item_id=?");
                    ps.setInt(1, itemId);
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