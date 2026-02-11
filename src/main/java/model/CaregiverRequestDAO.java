package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CaregiverRequestDAO {

	public enum AcceptResult {
		OK, NOT_FOUND, ALREADY_TAKEN, TIME_CONFLICT
	}

	// Open requests:
	// booking is pending (status = 1)
	// booking detail is not assigned (caregiver_status = 0, caregiver_id is NULL)
	public List<CaregiverVisit> getOpenRequests(int caregiverId) {
		List<CaregiverVisit> list = new ArrayList<>();

		String sql = "SELECT bd.detail_id, bd.booking_id, s.name AS service_name, "
				+ "       c.full_name AS customer_name, c.address AS customer_address, "
				+ "       bd.start_time, bd.end_time, bd.special_request, "
				+ "       bd.caregiver_status, bd.check_in_at, bd.check_out_at "
				+ "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "JOIN customers c ON c.customer_id = b.customer_id "
				+ "JOIN service s ON s.service_id = bd.service_id "
				+ "JOIN caregiver_service cs ON cs.service_id = bd.service_id "
				+ "WHERE cs.caregiver_id = ? "
				+ "  AND b.status = 1 "
				+ "  AND bd.caregiver_status = 0 "
				+ "  AND bd.caregiver_id IS NULL "
				+ "ORDER BY bd.start_time ASC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, caregiverId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					CaregiverVisit v = new CaregiverVisit();
					v.setDetailId(rs.getInt("detail_id"));
					v.setBookingId(rs.getInt("booking_id"));
					v.setServiceName(rs.getString("service_name"));
					v.setCustomerName(rs.getString("customer_name"));
					v.setCustomerAddress(rs.getString("customer_address"));
					v.setStartTime(rs.getTimestamp("start_time"));
					v.setEndTime(rs.getTimestamp("end_time"));
					v.setSpecialRequest(rs.getString("special_request"));
					v.setCaregiverStatus(rs.getInt("caregiver_status"));
					v.setCheckInAt(rs.getTimestamp("check_in_at"));
					v.setCheckOutAt(rs.getTimestamp("check_out_at"));
					list.add(v);
				}
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}

		return list;
	}

	// Accept request:
	// 1) request must exist
	// 2) request must still be open (caregiver_id NULL and caregiver_status = 0)
	// 3) caregiver cannot accept overlapping assigned jobs (DATETIME overlap)
	// 4) accept update only allowed when booking is pending (b.status = 1)
	// 5) booking becomes confirmed (status = 2) when all booking_details are assigned
	public AcceptResult acceptRequest(int detailId, int caregiverId) throws SQLException {

		Integer bookingId = null;
		Integer existingCaregiverId = null;
		int existingCaregiverStatus = -1;
		Timestamp startTime = null;
		Timestamp endTime = null;

		String rowSql = "SELECT bd.booking_id, bd.caregiver_id, bd.caregiver_status, bd.start_time, bd.end_time "
				+ "FROM booking_details bd "
				+ "WHERE bd.detail_id = ?";
		
		String conflictCheckSql = "SELECT COUNT(*) AS conflict_count "
		        + "FROM booking_details bd2 "
		        + "WHERE bd2.caregiver_id = ? "
		        + "  AND bd2.detail_id <> ? "
		        + "  AND bd2.caregiver_status IN (1,2) "
		        + "  AND bd2.start_time < ? "
		        + "  AND bd2.end_time > ?";

		String updateSql = "UPDATE booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "SET bd.caregiver_id = ?, "
				+ "    bd.caregiver_status = 1, "
				+ "    bd.check_in_at = NULL, "
				+ "    bd.check_out_at = NULL "
				+ "WHERE bd.detail_id = ? "
				+ "  AND b.status = 1 "
				+ "  AND bd.caregiver_id IS NULL "
				+ "  AND bd.caregiver_status = 0";

		String remainingSql = "SELECT COUNT(*) AS remaining "
				+ "FROM booking_details "
				+ "WHERE booking_id = ? "
				+ "  AND (caregiver_id IS NULL OR caregiver_status = 0)";

		String confirmBookingSql = "UPDATE bookings "
				+ "SET status = 2 "
				+ "WHERE booking_id = ? "
				+ "  AND status = 1";

		try (Connection conn = DBConnection.getConnection()) {
			conn.setAutoCommit(false);

			// Read request row
			try (PreparedStatement ps1 = conn.prepareStatement(rowSql)) {
				ps1.setInt(1, detailId);
				try (ResultSet rs = ps1.executeQuery()) {
					if (!rs.next()) {
						conn.rollback();
						return AcceptResult.NOT_FOUND;
					}

					bookingId = rs.getInt("booking_id");
					existingCaregiverId = (Integer) rs.getObject("caregiver_id");
					existingCaregiverStatus = rs.getInt("caregiver_status");
					startTime = rs.getTimestamp("start_time");
					endTime = rs.getTimestamp("end_time");
				}
			}

			// Invalid slot data
			if (startTime == null || endTime == null || bookingId == null) {
				conn.rollback();
				return AcceptResult.NOT_FOUND;
			}

			// Already accepted or no longer open
			if (existingCaregiverId != null || existingCaregiverStatus != 0) {
				conn.rollback();
				return AcceptResult.ALREADY_TAKEN;
			}

			// Check for DATETIME overlaps against caregiver assigned jobs
			try (PreparedStatement ps2 = conn.prepareStatement(conflictCheckSql)) {
				ps2.setInt(1, caregiverId);
				ps2.setInt(2, detailId);
				ps2.setTimestamp(3, endTime);
				ps2.setTimestamp(4, startTime);

				try (ResultSet rs = ps2.executeQuery()) {
					if (rs.next() && rs.getInt("conflict_count") > 0) {
						conn.rollback();
						return AcceptResult.TIME_CONFLICT;
					}
				}
			}

			// Accept request (atomic guard)
			int updated;
			try (PreparedStatement ps3 = conn.prepareStatement(updateSql)) {
				ps3.setInt(1, caregiverId);
				ps3.setInt(2, detailId);
				updated = ps3.executeUpdate();
			}

			// Update did not apply:
			// - booking not pending anymore
			// - another caregiver already accepted
			// - request no longer open
			if (updated == 0) {
				conn.rollback();
				return AcceptResult.ALREADY_TAKEN;
			}

			// Confirm booking if all booking_details are assigned
			int remaining = 0;
			try (PreparedStatement ps4 = conn.prepareStatement(remainingSql)) {
				ps4.setInt(1, bookingId);
				try (ResultSet rs = ps4.executeQuery()) {
					if (rs.next()) {
						remaining = rs.getInt("remaining");
					}
				}
			}

			if (remaining == 0) {
				try (PreparedStatement ps5 = conn.prepareStatement(confirmBookingSql)) {
					ps5.setInt(1, bookingId);
					ps5.executeUpdate();
				}
			}

			conn.commit();
			return AcceptResult.OK;

		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		}
	}

	// Useful for customer notification: who owns this booking detail
	public Integer getCustomerIdByDetailId(int detailId) {
		String sql = "SELECT b.customer_id "
				+ "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "WHERE bd.detail_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, detailId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getInt("customer_id");
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
}
