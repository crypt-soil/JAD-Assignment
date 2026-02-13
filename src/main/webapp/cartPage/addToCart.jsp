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
        		"jdbc:mysql://silvercare-db-unique123.mysql.database.azure.com:3306/silvercare"
        			    + "?useSSL=true"
        			    + "&requireSSL=true"
        			    + "&verifyServerCertificate=false"
        			    + "&serverTimezone=UTC",
            "silveradmin", 
            "Jvss1234"      
        );

        // get or create the cart for user
        int cartId = 0;

        String selectCartSql = "SELECT cart_id FROM cart WHERE customer_id = ?";
        ps = conn.prepareStatement(selectCartSql);
        ps.setInt(1, customerId);
        rs = ps.executeQuery();

        if (rs.next()) {
            cartId = rs.getInt("cart_id");
        } else {
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
        
        rs.close();
        ps.close();
        
        // insert cart item
        int itemId = 0;

        String insertItemSql = 
            "INSERT INTO cart_items (cart_id, service_id, quantity) VALUES (?, ?, 1)";
        ps = conn.prepareStatement(insertItemSql, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, cartId);
        ps.setInt(2, serviceId);
        ps.executeUpdate();

        rs = ps.getGeneratedKeys();
        if (rs.next()) 
            itemId = rs.getInt(1);  // get new item_id

%>
    <script>
        // redirect to booking details page WITH mode=create
        window.location.href = "setItemDetails.jsp?item_id=<%=itemId%>&mode=create";
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
