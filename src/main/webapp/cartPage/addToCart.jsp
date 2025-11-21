<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.sql.*" %>

<%
    // ensure user is logged in
    Integer customerId = (Integer) session.getAttribute("customer_id");
    if (customerId == null) {
%>
    <script>
        alert("Please login before adding services to your cart.");
        window.location.href = "<%=request.getContextPath()%>/loginPage/login.jsp";
    </script>
<%
        return;
    }

    // retrieve form data
    int serviceId = Integer.parseInt(request.getParameter("serviceId"));
    String name = request.getParameter("serviceName");
    double price = Double.parseDouble(request.getParameter("servicePrice"));
	
    //open connection
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

        //get or create cart for user
        int cartId = 0;

        String selectCartSql = "SELECT cart_id FROM cart WHERE customer_id = ?";
        ps = conn.prepareStatement(selectCartSql);
        ps.setInt(1, customerId);
        rs = ps.executeQuery();

        if (rs.next()) {
            cartId = rs.getInt("cart_id");
        } else {
            //if no cart yet, create one
            rs.close();
            ps.close();

            String insertCartSql = "INSERT INTO cart (customer_id) VALUES (?)";
            ps = conn.prepareStatement(insertCartSql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, customerId);
            ps.executeUpdate();
            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                cartId = rs.getInt(1);
            }
        }

        //close before reusing
        if (rs != null) { rs.close(); }
        if (ps != null) { ps.close(); }

        //check if this service already exists in cart_items
        String checkItemSql = "SELECT quantity FROM cart_items WHERE cart_id = ? AND service_id = ?";
        ps = conn.prepareStatement(checkItemSql);
        ps.setInt(1, cartId);
        ps.setInt(2, serviceId);
        rs = ps.executeQuery();

        if (rs.next()) {
            int currentQty = rs.getInt("quantity");
            rs.close();
            ps.close();

            String updateQtySql = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND service_id = ?";
            ps = conn.prepareStatement(updateQtySql);
            ps.setInt(1, currentQty + 1);
            ps.setInt(2, cartId);
            ps.setInt(3, serviceId);
            ps.executeUpdate();
        } else {
            rs.close();
            ps.close();

            String insertItemSql = "INSERT INTO cart_items (cart_id, service_id, quantity) VALUES (?, ?, ?)";
            ps = conn.prepareStatement(insertItemSql);
            ps.setInt(1, cartId);
            ps.setInt(2, serviceId);
            ps.setInt(3, 1);
            ps.executeUpdate();
        }

%>
    <script>
        alert("Service added to cart successfully!");
        window.location.href = "<%=request.getContextPath()%>/cartPage/cartPage.jsp";
    </script>
<%
    } catch (Exception e) {
        e.printStackTrace();
%>
    <p>Error while adding to cart: <%=e.getMessage()%></p>
<%
    } finally {
        try { if (rs != null) rs.close(); } catch (Exception ignore) {}
        try { if (ps != null) ps.close(); } catch (Exception ignore) {}
        try { if (conn != null) conn.close(); } catch (Exception ignore) {}
    }
%>
