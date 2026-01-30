package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CaregiverRequestDAO {

    // Open requests = booking confirmed, unassigned, caregiver_status = 0
    public List<CaregiverVisit> getOpenRequests(int caregiverId) {
        List<CaregiverVisit> list = new ArrayList<>();

        String sql =
            "SELECT bd.detail_id, bd.booking_id, s.name AS service_name, " +
            "       c.full_name AS customer_name, c.address AS customer_address, " +
            "       bd.start_time, bd.end_time, bd.special_request, " +
            "       bd.caregiver_status, bd.check_in_at, bd.check_out_at " +
            "FROM booking_details bd " +
            "JOIN bookings b ON b.booking_id = bd.booking_id " +
            "JOIN customers c ON c.customer_id = b.customer_id " +
            "JOIN service s ON s.service_id = bd.service_id " +
            "JOIN caregiver_service cs ON cs.service_id = bd.service_id " +
            "WHERE cs.caregiver_id = ? " +
            "  AND b.status = 2 " +                 // booking confirmed
            "  AND bd.caregiver_status = 0 " +     // not_assigned
            "  AND bd.caregiver_id IS NULL " +
            "ORDER BY bd.start_time ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

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

    public boolean acceptRequest(int detailId, int caregiverId) {
        String sql =
            "UPDATE booking_details bd " +
            "JOIN bookings b ON b.booking_id = bd.booking_id " +
            "SET bd.caregiver_id = ?, bd.caregiver_status = 1 " +  // assigned
            "WHERE bd.detail_id = ? " +
            "  AND b.status = 2 " +
            "  AND bd.caregiver_id IS NULL " +
            "  AND bd.caregiver_status = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);
            ps.setInt(2, detailId);
            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
