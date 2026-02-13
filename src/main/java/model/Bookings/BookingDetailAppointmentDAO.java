package model.Bookings;
/*
 * Ong Jin Kai
 * 2429465
 */
import java.sql.*;
import java.util.*;

import model.DBConnection;

public class BookingDetailAppointmentDAO {

    // READ: Admin view all paid appointment details
    public List<BookingDetailAppointment> getAllAppointments() throws SQLException {
        List<BookingDetailAppointment> list = new ArrayList<>();

        String sql =
            "SELECT " +
            "  bd.detail_id, bd.booking_id, " +
            "  b.customer_id, cu.full_name AS customer_name, cu.phone AS customer_phone, " +
            "  s.name AS service_name, " +
            "  bd.quantity, bd.subtotal, bd.start_time, bd.end_time, bd.special_request, " +
            "  bd.caregiver_id, c.full_name AS caregiver_name, c.phone AS caregiver_contact, " +
            "  bd.caregiver_status, bd.check_in_at, bd.check_out_at, " +
            "  b.status AS booking_status, b.booking_date " +
            "FROM booking_details bd " +
            "JOIN bookings b ON bd.booking_id = b.booking_id " +
            "JOIN customers cu ON b.customer_id = cu.customer_id " +
            "JOIN service s ON bd.service_id = s.service_id " +
            "LEFT JOIN caregiver c ON bd.caregiver_id = c.caregiver_id " +
            "ORDER BY bd.start_time DESC, bd.detail_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(mapRow(rs));
        }

        return list;
    }

    // UPDATE: Assign caregiver + set caregiver_status to 1 (assigned)
    public int assignCaregiver(int detailId, int caregiverId) throws SQLException {
        String sql = "UPDATE booking_details SET caregiver_id = ?, caregiver_status = 1 WHERE detail_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);
            ps.setInt(2, detailId);
            return ps.executeUpdate();
        }
    }

    // UPDATE: Update caregiver_status only
    // 0=not_assigned, 1=assigned, 2=checked_in, 3=checked_out, 4=cancelled
    public int updateCaregiverStatus(int detailId, int caregiverStatus) throws SQLException {
        String sql = "UPDATE booking_details SET caregiver_status = ? WHERE detail_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverStatus);
            ps.setInt(2, detailId);
            return ps.executeUpdate();
        }
    }

    // DELETE (soft): Cancel appointment detail
    public int cancelAppointment(int detailId) throws SQLException {
        String sql = "UPDATE booking_details SET caregiver_status = 4 WHERE detail_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailId);
            return ps.executeUpdate();
        }
    }

    // Helper mapper
    private BookingDetailAppointment mapRow(ResultSet rs) throws SQLException {
        Integer caregiverId = (Integer) rs.getObject("caregiver_id");

        return new BookingDetailAppointment(
            rs.getInt("detail_id"),
            rs.getInt("booking_id"),
            rs.getInt("customer_id"),
            rs.getString("customer_name"),
            rs.getString("customer_phone"),
            rs.getString("service_name"),
            rs.getInt("quantity"),
            rs.getDouble("subtotal"),
            caregiverId,
            rs.getString("caregiver_name"),
            rs.getString("caregiver_contact"),
            rs.getTimestamp("start_time"),
            rs.getTimestamp("end_time"),
            rs.getString("special_request"),
            rs.getInt("caregiver_status"),
            rs.getTimestamp("check_in_at"),
            rs.getTimestamp("check_out_at"),
            rs.getInt("booking_status"),
            rs.getTimestamp("booking_date")
        );
    }
}
