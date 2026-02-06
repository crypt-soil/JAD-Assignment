package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CaregiverRequestDAO {

	// Open requests = booking confirmed, unassigned, caregiver_status = 0,
	// caregiver_id is NULL
	public List<CaregiverVisit> getOpenRequests(int caregiverId) {
		List<CaregiverVisit> list = new ArrayList<>();

		String sql = "SELECT bd.detail_id, bd.booking_id, s.name AS service_name, "
				+ "       c.full_name AS customer_name, c.address AS customer_address, "
				+ "       bd.start_time, bd.end_time, bd.special_request, "
				+ "       bd.caregiver_status, bd.check_in_at, bd.check_out_at " + "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "JOIN customers c ON c.customer_id = b.customer_id "
				+ "JOIN service s ON s.service_id = bd.service_id "
				+ "JOIN caregiver_service cs ON cs.service_id = bd.service_id " + "WHERE cs.caregiver_id = ? "
				+ "  AND b.status = 2 " + // booking confirmed
				"  AND bd.caregiver_status = 0 " + // not_assigned
				"  AND bd.caregiver_id IS NULL " + "ORDER BY bd.start_time ASC";

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

	// Accept = assign caregiver to this booking detail (only if still open)
	public boolean acceptRequest(int detailId, int caregiverId) {
		Timestamp startTime = null;
		Timestamp endTime = null;

		String timeSql = "SELECT start_time, end_time FROM booking_details WHERE detail_id = ?";

		String conflictCheckSql = "SELECT COUNT(*) as conflict_count " + "FROM booking_details bd2 "
				+ "JOIN bookings b2 ON b2.booking_id = bd2.booking_id " + "WHERE bd2.caregiver_id = ? "
				+ "  AND b2.status = 2 " + "  AND bd2.caregiver_status IN (1,2) " + "  AND bd2.start_time < ? "
				+ "  AND bd2.end_time > ?";

		String updateSql = "UPDATE booking_details bd " + "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "SET bd.caregiver_id = ?, " + "    bd.caregiver_status = 1, " + "    bd.check_in_at = NULL, "
				+ "    bd.check_out_at = NULL " + "WHERE bd.detail_id = ? " + "  AND b.status = 2 "
				+ "  AND bd.caregiver_id IS NULL " + "  AND bd.caregiver_status = 0";

		try (Connection conn = DBConnection.getConnection()) {
			// Get the time slot
			try (PreparedStatement ps1 = conn.prepareStatement(timeSql)) {
				ps1.setInt(1, detailId);
				try (ResultSet rs = ps1.executeQuery()) {
					if (rs.next()) {
						startTime = rs.getTimestamp("start_time");
						endTime = rs.getTimestamp("end_time");
					}
				}
			}

			if (startTime == null || endTime == null) {
				return false;
			}

			// Check for conflicts
			boolean hasConflict = false;
			try (PreparedStatement ps2 = conn.prepareStatement(conflictCheckSql)) {
				ps2.setInt(1, caregiverId);
				ps2.setTimestamp(2, endTime);
				ps2.setTimestamp(3, startTime);

				try (ResultSet rs = ps2.executeQuery()) {
					if (rs.next() && rs.getInt("conflict_count") > 0) {
						hasConflict = true;
					}
				}
			}

			if (hasConflict) {
				return false; // Conflict found, cannot accept
			}

			// Perform the update
			try (PreparedStatement ps3 = conn.prepareStatement(updateSql)) {
				ps3.setInt(1, caregiverId);
				ps3.setInt(2, detailId);

				return ps3.executeUpdate() > 0;
			}
		} catch (SQLException e) {
			e.printStackTrace();
			return false;
		}
	}

	// Useful for customer notification: who owns this booking detail?
	public Integer getCustomerIdByDetailId(int detailId) {
		String sql = "SELECT b.customer_id " + "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id " + "WHERE bd.detail_id = ?";

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
