package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CaregiverVisitDAO {

	public List<CaregiverVisit> getVisits(int caregiverId, String filter) {
		List<CaregiverVisit> list = new ArrayList<>();

		String whereDate = "";
		if ("today".equalsIgnoreCase(filter)) {
			whereDate = " AND DATE(bd.start_time) = CURDATE() ";
		} else if ("future".equalsIgnoreCase(filter)) {
			whereDate = " AND DATE(bd.start_time) > CURDATE() ";
		}

		String sql = "SELECT bd.detail_id, bd.booking_id, s.name AS service_name, "
				+ "       c.full_name AS customer_name, c.address AS customer_address, "
				+ "       bd.start_time, bd.end_time, bd.special_request, "
				+ "       bd.caregiver_status, bd.check_in_at, bd.check_out_at " + "FROM booking_details bd "
				+ "JOIN bookings b ON b.booking_id = bd.booking_id "
				+ "JOIN customers c ON c.customer_id = b.customer_id "
				+ "JOIN service s ON s.service_id = bd.service_id " + "WHERE bd.caregiver_id = ? "
				+ "  AND b.status IN (1,2) " + "  AND bd.caregiver_status IN (1,2,3) " + whereDate
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
}
