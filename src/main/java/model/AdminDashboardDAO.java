package model;
/*
 * Ong Jin Kai
 * 2429465
 */
import java.sql.*;
import java.util.*;

public class AdminDashboardDAO {

	// get total number of users using stored procedure: sp_total_users()
	public int getTotalUsers() throws SQLException {
		String sql = "{CALL sp_total_users()}";
		try (Connection conn = DBConnection.getConnection();
				CallableStatement cs = conn.prepareCall(sql);
				ResultSet rs = cs.executeQuery()) {

			return rs.next() ? rs.getInt("total") : 0;
		}
	}

	// get most popular service using stored procedure: sp_popular_service()
	public String getPopularService() throws SQLException {
		String sql = "{CALL sp_popular_service()}";
		try (Connection conn = DBConnection.getConnection();
				CallableStatement cs = conn.prepareCall(sql);
				ResultSet rs = cs.executeQuery()) {

			return rs.next() ? rs.getString("name") : "No data";
		}
	}

	// get revenue using function: fn_revenue(range)
	public double getRevenue(String range) throws SQLException {
		String sql = "SELECT fn_revenue(?) AS revenue";
		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, range);

			try (ResultSet rs = ps.executeQuery()) {
				return rs.next() ? rs.getDouble("revenue") : 0.0;
			}
		}
	}

	// =========================
	// CAREGIVER RANKINGS
	// =========================

	// Top caregivers: ONLY those with a rating
	public List<Map<String, Object>> getTopCaregivers(int limit) throws SQLException {
		String sql = "SELECT c.full_name AS name, c.rating AS rating " + "FROM caregiver c "
				+ "WHERE c.rating IS NOT NULL " + "ORDER BY c.rating DESC, c.full_name ASC " + "LIMIT ?";

		return queryNameRating(sql, limit);
	}

	// Worst caregivers: ONLY those with a rating
	public List<Map<String, Object>> getWorstCaregivers(int limit) throws SQLException {
		String sql = "SELECT c.full_name AS name, c.rating AS rating " + "FROM caregiver c "
				+ "WHERE c.rating IS NOT NULL " + "ORDER BY c.rating ASC, c.full_name ASC " + "LIMIT ?";

		return queryNameRating(sql, limit);
	}

	// helper for caregiver lists
	private List<Map<String, Object>> queryNameRating(String sql, int limit) throws SQLException {
		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, limit);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("name", rs.getString("name"));
					row.put("rating", rs.getDouble("rating"));
					list.add(row);
				}
			}
		}
		return list;
	}

	// =========================
	// SERVICE RANKINGS (FROM FEEDBACK)
	// =========================

	// Top services by AVG(feedback.service_rating)
	public List<Map<String, Object>> getTopServicesByFeedback(int limit) throws SQLException {
		String sql = "SELECT s.name AS name, " + "       ROUND(AVG(f.service_rating), 1) AS avgRating, "
				+ "       COUNT(*) AS count " + "FROM feedback f " + "JOIN service s ON s.service_id = f.service_id "
				+ "WHERE f.service_rating IS NOT NULL " + "GROUP BY s.service_id, s.name "
				+ "ORDER BY avgRating DESC, count DESC, s.name ASC " + "LIMIT ?";

		return queryServiceAgg(sql, limit);
	}

	// Worst services by AVG(feedback.service_rating)
	public List<Map<String, Object>> getWorstServicesByFeedback(int limit) throws SQLException {
		String sql = "SELECT s.name AS name, " + "       ROUND(AVG(f.service_rating), 1) AS avgRating, "
				+ "       COUNT(*) AS count " + "FROM feedback f " + "JOIN service s ON s.service_id = f.service_id "
				+ "WHERE f.service_rating IS NOT NULL " + "GROUP BY s.service_id, s.name "
				+ "ORDER BY avgRating ASC, count DESC, s.name ASC " + "LIMIT ?";

		return queryServiceAgg(sql, limit);
	}

	// helper for service lists
	private List<Map<String, Object>> queryServiceAgg(String sql, int limit) throws SQLException {
		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, limit);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("name", rs.getString("name"));
					row.put("avgRating", rs.getDouble("avgRating"));
					row.put("count", rs.getInt("count"));
					list.add(row);
				}
			}
		}

		return list;
	}

	// =========================
	// DEMAND + AVAILABILITY (PROXY)
	// =========================

	// Map "range" to days back
	private int rangeToDays(String range) {
		if (range == null)
			return 365;
		switch (range) {
		case "week":
			return 7;
		case "month":
			return 30;
		default:
			return 365; // year
		}
	}

	// High demand services (most booking_details in window)
	public List<Map<String, Object>> getHighDemandServices(String range, int limit) throws SQLException {
		int days = rangeToDays(range);

		String sql = "SELECT s.name AS name, COUNT(*) AS demandCount " + "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id " + "JOIN service s ON s.service_id = bd.service_id "
				+ "WHERE b.booking_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " + "GROUP BY s.service_id, s.name "
				+ "ORDER BY demandCount DESC, s.name ASC " + "LIMIT ?";

		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, days);
			ps.setInt(2, limit);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("name", rs.getString("name"));
					row.put("demandCount", rs.getInt("demandCount"));
					list.add(row);
				}
			}
		}

		return list;
	}

	// Low availability services (proxy): few caregivers + high unassigned rate
	public List<Map<String, Object>> getLowAvailabilityServices(String range, int limit) throws SQLException {
		int days = rangeToDays(range);

		String sql = "SELECT s.name AS name, " + "       COUNT(*) AS demandCount, "
				+ "       COUNT(DISTINCT bd.caregiver_id) AS caregiverCount, "
				+ "       SUM(CASE WHEN bd.caregiver_id IS NULL OR bd.caregiver_status = 0 THEN 1 ELSE 0 END) AS unassignedCount, "
				+ "       ROUND((SUM(CASE WHEN bd.caregiver_id IS NULL OR bd.caregiver_status = 0 THEN 1 ELSE 0 END) / COUNT(*)) * 100, 1) AS unassignedRate "
				+ "FROM booking_details bd " + "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "JOIN service s ON s.service_id = bd.service_id "
				+ "WHERE b.booking_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " + "GROUP BY s.service_id, s.name "
				+ "HAVING COUNT(*) > 0 "
				+ "ORDER BY caregiverCount ASC, unassignedRate DESC, demandCount DESC, s.name ASC " + "LIMIT ?";

		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, days);
			ps.setInt(2, limit);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("name", rs.getString("name"));
					row.put("demandCount", rs.getInt("demandCount"));
					row.put("caregiverCount", rs.getInt("caregiverCount"));
					row.put("unassignedCount", rs.getInt("unassignedCount"));
					row.put("unassignedRate", rs.getDouble("unassignedRate"));
					list.add(row);
				}
			}
		}

		return list;
	}

	// =========================
	// SALES & REPORTS (FEATURE 5)
	// =========================

	// 1) Booking / Care schedule rows (by range)
	public List<Map<String, Object>> getBookingSchedule(String range, int limit) throws SQLException {
		int days = rangeToDays(range);

		String sql = "SELECT bd.detail_id AS detailId, " + "       b.booking_id AS bookingId, "
				+ "       b.booking_date AS bookingDate, " + "       bd.start_time AS startTime, "
				+ "       bd.end_time AS endTime, " + "       c.full_name AS customerName, "
				+ "       s.name AS serviceName, " + "       cg.full_name AS caregiverName, "
				+ "       bd.caregiver_status AS caregiverStatus, " + "       bd.subtotal AS subtotal "
				+ "FROM booking_details bd " + "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "JOIN customers c ON c.customer_id = b.customer_id "
				+ "JOIN service s ON s.service_id = bd.service_id "
				+ "LEFT JOIN caregiver cg ON cg.caregiver_id = bd.caregiver_id "
				+ "WHERE b.booking_date >= DATE_SUB(NOW(), INTERVAL ? DAY) "
				+ "ORDER BY bd.start_time ASC, b.booking_id ASC " + "LIMIT ?";

		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, days);
			ps.setInt(2, limit);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("detailId", rs.getInt("detailId"));
					row.put("bookingId", rs.getInt("bookingId"));
					row.put("bookingDate", rs.getTimestamp("bookingDate"));
					row.put("startTime", rs.getTimestamp("startTime"));
					row.put("endTime", rs.getTimestamp("endTime"));
					row.put("customerName", rs.getString("customerName"));
					row.put("serviceName", rs.getString("serviceName"));
					row.put("caregiverName", rs.getString("caregiverName")); // can be null
					row.put("caregiverStatus", rs.getInt("caregiverStatus"));
					row.put("subtotal", rs.getDouble("subtotal"));
					list.add(row);
				}
			}
		}

		return list;
	}

	// 2) Top clients by total value spent (by range)
	public List<Map<String, Object>> getTopClientsByValue(String range, int limit) throws SQLException {
		int days = rangeToDays(range);

		String sql = "SELECT c.customer_id AS customerId, " + "       c.full_name AS customerName, "
				+ "       COUNT(DISTINCT b.booking_id) AS bookingCount, " + "       COUNT(bd.detail_id) AS itemCount, "
				+ "       ROUND(IFNULL(SUM(bd.subtotal), 0), 2) AS totalSpent " + "FROM customers c "
				+ "JOIN bookings b ON b.customer_id = c.customer_id "
				+ "JOIN booking_details bd ON bd.booking_id = b.booking_id "
				+ "WHERE b.booking_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " + "GROUP BY c.customer_id, c.full_name "
				+ "ORDER BY totalSpent DESC, bookingCount DESC, c.full_name ASC " + "LIMIT ?";

		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, days);
			ps.setInt(2, limit);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("customerId", rs.getInt("customerId"));
					row.put("customerName", rs.getString("customerName"));
					row.put("bookingCount", rs.getInt("bookingCount"));
					row.put("itemCount", rs.getInt("itemCount"));
					row.put("totalSpent", rs.getDouble("totalSpent"));
					list.add(row);
				}
			}
		}

		return list;
	}

	// 3) Clients who booked a certain service (by range + serviceId)
	public List<Map<String, Object>> getClientsByService(String range, int serviceId, int limit) throws SQLException {
		int days = rangeToDays(range);

		String sql = "SELECT c.customer_id AS customerId, " + "       c.full_name AS customerName, "
				+ "       COUNT(bd.detail_id) AS timesBooked, "
				+ "       ROUND(IFNULL(SUM(bd.subtotal), 0), 2) AS totalSpent " + "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "JOIN customers c ON c.customer_id = b.customer_id "
				+ "WHERE b.booking_date >= DATE_SUB(NOW(), INTERVAL ? DAY) " + "  AND bd.service_id = ? "
				+ "GROUP BY c.customer_id, c.full_name "
				+ "ORDER BY timesBooked DESC, totalSpent DESC, c.full_name ASC " + "LIMIT ?";

		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, days);
			ps.setInt(2, serviceId);
			ps.setInt(3, limit);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					Map<String, Object> row = new HashMap<>();
					row.put("customerId", rs.getInt("customerId"));
					row.put("customerName", rs.getString("customerName"));
					row.put("timesBooked", rs.getInt("timesBooked"));
					row.put("totalSpent", rs.getDouble("totalSpent"));
					list.add(row);
				}
			}
		}

		return list;
	}

	// 4) Services list for dropdown
	public List<Map<String, Object>> getActiveServices() throws SQLException {
		String sql = "SELECT service_id AS serviceId, name AS name FROM service WHERE status = 1 ORDER BY name ASC";

		List<Map<String, Object>> list = new ArrayList<>();

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				Map<String, Object> row = new HashMap<>();
				row.put("serviceId", rs.getInt("serviceId"));
				row.put("name", rs.getString("name"));
				list.add(row);
			}
		}

		return list;
	}

}
