package model;

import java.sql.*;

public class AdminDashboardDAO {

	// get total number of users using my stored procedure
	public int getTotalUsers() {
		int total = 0;

		try {
			Connection conn = DBConnection.getConnection();

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

	// get most popular service
	public String getPopularService() {
		String service = "No data";

		try {
			Connection conn = DBConnection.getConnection();
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

	// get revenue for range
	public double getRevenue(String range) {
		double revenue = 0;

		try {
			Connection conn = DBConnection.getConnection();

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
