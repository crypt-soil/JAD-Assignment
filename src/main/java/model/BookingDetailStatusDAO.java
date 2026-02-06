package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDetailStatusDAO {

	// status codes aligned with booking_details.caregiver_status
	// 0=not_assigned, 1=assigned, 2=checked_in, 3=checked_out, 4=cancelled

	public boolean checkIn(int detailId, int caregiverId) {
		String sql = "UPDATE booking_details " + "SET caregiver_status = 2, "
				+ "    check_in_at = COALESCE(check_in_at, NOW()) " + "WHERE detail_id = ? " + "  AND caregiver_id = ? "
				+ "  AND DATE(start_time) = CURDATE() " + "  AND caregiver_status = 1";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, detailId);
			ps.setInt(2, caregiverId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean checkOut(int detailId, int caregiverId) {
		String sql = "UPDATE booking_details " + "SET caregiver_status = 3, "
				+ "    check_out_at = COALESCE(check_out_at, NOW()) " + "WHERE detail_id = ? "
				+ "  AND caregiver_id = ? " + "  AND DATE(start_time) = CURDATE() " + "  AND caregiver_status = 2";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, detailId);
			ps.setInt(2, caregiverId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// customer-safe: only return statuses for a booking that belongs to that
	// customer_id
	public List<BookingDetailStatus> getStatusesByBookingId(int bookingId, int customerId) {
		List<BookingDetailStatus> list = new ArrayList<>();

		String sql = "SELECT bd.detail_id, bd.caregiver_status " + "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id " + "WHERE bd.booking_id = ? "
				+ "  AND b.customer_id = ? " + "ORDER BY bd.detail_id ASC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, bookingId);
			ps.setInt(2, customerId);

			try (ResultSet rs = ps.executeQuery()) {
				while (rs.next()) {
					BookingDetailStatus s = new BookingDetailStatus();
					s.setDetailId(rs.getInt("detail_id"));
					s.setCaregiverStatus(rs.getInt("caregiver_status"));
					list.add(s);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
}
