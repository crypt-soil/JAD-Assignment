package model;

import java.sql.*;

public class AdminDashboardDAO {

    private String url = "jdbc:mysql://localhost:3306/silvercare?useSSL=false&serverTimezone=UTC";
    private String username = "root";
    private String password = "root1234";

    // get total number of users using my stored procedure
    public int getTotalUsers() {
        int total = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, username, password);

            CallableStatement cs = conn.prepareCall("{CALL sp_total_users()}");
            ResultSet rs = cs.executeQuery();

            if (rs.next()) {
                total = rs.getInt("total");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return total;
    }

    // ===============================
    // 2. Get Most Popular Service
    // ===============================
    public String getPopularService() {
        String service = "No data";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, username, password);

            CallableStatement cs = conn.prepareCall("{CALL sp_popular_service()}");
            ResultSet rs = cs.executeQuery();

            if (rs.next()) {
                service = rs.getString("name");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return service;
    }

    // ===============================
    // 3. Get Revenue for Current Month
    // ===============================
    public double getRevenue(String range) {
        double revenue = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(url, username, password);

            CallableStatement cs = conn.prepareCall("SELECT fn_revenue(?) AS revenue");
            cs.setString(1, range);
            ResultSet rs = cs.executeQuery();

            if (rs.next()) {
                revenue = rs.getDouble("revenue");
            }

            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return revenue;
    }
}
