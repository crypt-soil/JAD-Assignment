package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BookingDetailsStatusDAO {

	// check in allowed only when assigned (1) on the appointment day
	public boolean checkIn(int detailId, int caregiverId) {
		String sql = "UPDATE booking_details " + "SET caregiver_status = 2, " + // checked_in
				"    check_in_at = COALESCE(check_in_at, NOW()), " + "    check_out_at = NULL " + "WHERE detail_id = ? "
				+ "  AND caregiver_id = ? " + "  AND DATE(start_time) = CURDATE() " + "  AND caregiver_status = 1"; // assigned

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, detailId);
			ps.setInt(2, caregiverId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// check out allowed only when checked_in (2) on the appointment day
	public boolean checkOut(int detailId, int caregiverId) {
		String sql = "UPDATE booking_details " + "SET caregiver_status = 3, " + // checked_out
				"    check_out_at = COALESCE(check_out_at, NOW()) " + "WHERE detail_id = ? " + "  AND caregiver_id = ? "
				+ "  AND DATE(start_time) = CURDATE() " + "  AND caregiver_status = 2"; // checked_in

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, detailId);
			ps.setInt(2, caregiverId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

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

	public String[] getBookingInfoByDetailId(int detailId) {
		String sql = "SELECT bd.booking_id, s.name AS service_name " + "FROM booking_details bd "
				+ "JOIN service s ON s.service_id = bd.service_id " + "WHERE bd.detail_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, detailId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					String bookingId = String.valueOf(rs.getInt("booking_id"));
					String serviceName = rs.getString("service_name");
					return new String[] { bookingId, serviceName };
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}
}
