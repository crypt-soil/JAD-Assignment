
<%@ page import="java.sql.*, org.DBConnection" %>
<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Verify Registration</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light p-5">

<%
    // Retrieve form values
    String username = request.getParameter("username");
    String email = request.getParameter("email");
    String fullName = request.getParameter("fullName");
    String phoneNumber = request.getParameter("phoneNumber");
    String address = request.getParameter("address");
    String zipcode = request.getParameter("zipcode");
    String password = request.getParameter("password");
    String password2 = request.getParameter("password2");

    // Basic validation
    if (!password.equals(password2)) {
%>
        <div class="container text-center mt-5">
            <h3 class="text-danger">Passwords do not match!</h3>
            <a href="registerPage.jsp" class="btn btn-secondary mt-3">Go Back</a>
        </div>
<%
    } else {
        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            // ✅ Use your DBConnection class
            conn = DBConnection.getConnection();

            // SQL insert
            String sql = "INSERT INTO customers (username, password, full_name, email, phone, address, zipcode) VALUES (?, ?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1,username);
            stmt.setString(2, password.trim());
            stmt.setString(3, fullName);
            stmt.setString(4, email);
            stmt.setString(5, phoneNumber);
            stmt.setString(6, address);
            stmt.setString(7, zipcode.trim());

            int rows = stmt.executeUpdate();

            if (rows > 0) {
%>
                <div class="container text-center mt-5">
                    <h3 class="text-success">🎉 Registration Successful!</h3>
                    <p>You can now <a href="../loginPage/login.jsp">log in</a>.</p>
                </div>
<%
            } else {
%>
                <div class="container text-center mt-5">
                    <h3 class="text-danger">Registration failed. Please try again.</h3>
                    <a href="registerPage.jsp" class="btn btn-secondary mt-3">Go Back</a>
                </div>
<%
            }
        } catch (SQLException e) {
%>
            <div class="container mt-5">
                <h3 class="text-danger">Database Error: <%= e.getMessage() %></h3>
                <a href="registerPage.jsp" class="btn btn-secondary mt-3">Go Back</a>
            </div>
<%
        } catch (Exception e) {
%>
            <div class="container mt-5">
                <h3 class="text-danger">Unexpected Error: <%= e.getMessage() %></h3>
            </div>
<%
        } finally {
            if (stmt != null) try { stmt.close(); } catch (Exception ex) {}
            if (conn != null) DBConnection.closeConnection(conn);
        }
    }
%>

</body>
</html>
