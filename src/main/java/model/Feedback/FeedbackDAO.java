package model.Feedback;

import java.sql.*;
import java.util.*;

import model.DBConnection;

public class FeedbackDAO {

	/**
	 * Insert feedback (service + caregiver ratings/remarks) for a booking+service
	 * row. Updates ONLY caregiver.rating (service has no rating column).
	 */
	public void insertFeedbackAndUpdateRatings(int bookingId, int serviceId, Integer caregiverRating,
			Integer serviceRating, String caregiverRemarks, String serviceRemarks) throws SQLException {

		String insertSql = "INSERT INTO feedback "
				+ "(booking_id, service_id, caregiver_rating, service_rating, caregiver_remarks, service_remarks) "
				+ "VALUES (?, ?, ?, ?, ?, ?)";

		String getCaregiverSql = "SELECT caregiver_id " + "FROM booking_details "
				+ "WHERE booking_id = ? AND service_id = ? AND caregiver_id IS NOT NULL " + "LIMIT 1";

		String updateCaregiverRatingSql = "UPDATE caregiver " + "SET rating = ("
				+ "   SELECT ROUND(AVG(f.caregiver_rating), 1) " + "   FROM feedback f " + "   JOIN booking_details bd "
				+ "     ON f.booking_id = bd.booking_id AND f.service_id = bd.service_id "
				+ "   WHERE bd.caregiver_id = ? AND f.caregiver_rating IS NOT NULL" + ") " + "WHERE caregiver_id = ?";

		try (Connection conn = DBConnection.getConnection()) {
			conn.setAutoCommit(false);

			try (PreparedStatement psGetCg = conn.prepareStatement(getCaregiverSql);
					PreparedStatement psInsert = conn.prepareStatement(insertSql);
					PreparedStatement psUpdateCg = conn.prepareStatement(updateCaregiverRatingSql)) {

				// 1) Find caregiver assigned to this booking+service
				Integer caregiverId = null;
				psGetCg.setInt(1, bookingId);
				psGetCg.setInt(2, serviceId);

				try (ResultSet rs = psGetCg.executeQuery()) {
					if (rs.next())
						caregiverId = rs.getInt("caregiver_id");
				}

				// 2) Insert feedback
				psInsert.setInt(1, bookingId);
				psInsert.setInt(2, serviceId);

				// caregiver rating (NULL if no caregiver)
				if (caregiverId == null || caregiverRating == null) {
					psInsert.setNull(3, Types.INTEGER);
					psInsert.setNull(5, Types.VARCHAR);
				} else {
					psInsert.setInt(3, caregiverRating);
					psInsert.setString(5, caregiverRemarks == null || caregiverRemarks.trim().isEmpty() ? null
							: caregiverRemarks.trim());
				}

				// service rating (stored only in feedback table)
				if (serviceRating == null) {
					psInsert.setNull(4, Types.INTEGER);
				} else {
					psInsert.setInt(4, serviceRating);
				}

				psInsert.setString(6,
						serviceRemarks == null || serviceRemarks.trim().isEmpty() ? null : serviceRemarks.trim());

				psInsert.executeUpdate();

				// 3) Update caregiver overall rating (ONLY if assigned)
				if (caregiverId != null) {
					psUpdateCg.setInt(1, caregiverId);
					psUpdateCg.setInt(2, caregiverId);
					psUpdateCg.executeUpdate();
				}

				conn.commit();
			} catch (SQLException e) {
				conn.rollback();
				throw e;
			} finally {
				conn.setAutoCommit(true);
			}
		}
	}

	// ================= ADMIN VIEW =================

	public List<FeedbackView> getAllFeedback() throws SQLException {
		List<FeedbackView> list = new ArrayList<>();

		String sql = "SELECT " + "  f.feedback_id, f.booking_id, f.service_id, "
				+ "  f.service_rating, f.caregiver_rating, " + "  f.service_remarks, f.caregiver_remarks, "
				+ "  s.name AS service_name, " + "  cg.full_name AS caregiver_name " + "FROM feedback f "
				+ "JOIN service s ON s.service_id = f.service_id " + "LEFT JOIN booking_details bd "
				+ "  ON bd.booking_id = f.booking_id AND bd.service_id = f.service_id "
				+ "LEFT JOIN caregiver cg ON cg.caregiver_id = bd.caregiver_id " + "ORDER BY f.feedback_id DESC";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql);
				ResultSet rs = ps.executeQuery()) {

			while (rs.next()) {
				list.add(new FeedbackView(rs.getInt("feedback_id"), rs.getInt("booking_id"), rs.getInt("service_id"),
						rs.getString("service_name"), rs.getString("caregiver_name"), rs.getInt("service_rating"),
						rs.getInt("caregiver_rating"), rs.getString("service_remarks"),
						rs.getString("caregiver_remarks")));
			}
		}

		return list;
	}
}
