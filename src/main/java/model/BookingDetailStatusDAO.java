package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDetailStatusDAO {

    // Check-in = set booking_details.caregiver_id + upsert status row to 1
    public boolean checkIn(int detailId, int caregiverId) {
        String updateDetail =
            "UPDATE booking_details SET caregiver_id = ? WHERE detail_id = ?";

        String upsertStatus =
            "INSERT INTO booking_detail_status (detail_id, caregiver_status, check_in_time) " +
            "VALUES (?, 1, NOW()) " +
            "ON DUPLICATE KEY UPDATE " +
            "caregiver_status = 1, " +
            "check_in_time = COALESCE(check_in_time, NOW()), " +
            "check_out_time = NULL";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            if (conn == null) return false;

            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(updateDetail)) {
                ps1.setInt(1, caregiverId);
                ps1.setInt(2, detailId);
                ps1.executeUpdate();
            }

            try (PreparedStatement ps2 = conn.prepareStatement(upsertStatus)) {
                ps2.setInt(1, detailId);
                ps2.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            if (conn != null) {
                try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            }
            return false;
        } finally {
            if (conn != null) {
                try { conn.setAutoCommit(true); conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    }

    // Check-out = only allowed if already checked-in (status=1) and caregiver matches booking_details.caregiver_id
    public boolean checkOut(int detailId, int caregiverId) {
        String sql =
            "UPDATE booking_detail_status bds " +
            "JOIN booking_details bd ON bd.detail_id = bds.detail_id " +
            "SET bds.caregiver_status = 2, bds.check_out_time = NOW() " +
            "WHERE bds.detail_id = ? " +
            "AND bds.caregiver_status = 1 " +
            "AND bd.caregiver_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) return false;

            ps.setInt(1, detailId);
            ps.setInt(2, caregiverId);

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Customer-safe: only return statuses for a booking that belongs to that customer_id
    public List<BookingDetailStatus> getStatusesByBookingId(int bookingId, int customerId) {
        List<BookingDetailStatus> list = new ArrayList<>();

        String sql =
            "SELECT bd.detail_id, " +
            "       COALESCE(bds.caregiver_status, 0) AS caregiver_status, " +
            "       bds.check_in_time, bds.check_out_time, bds.updated_at " +
            "FROM booking_details bd " +
            "JOIN bookings b ON b.booking_id = bd.booking_id " +
            "LEFT JOIN booking_detail_status bds ON bds.detail_id = bd.detail_id " +
            "WHERE bd.booking_id = ? AND b.customer_id = ? " +
            "ORDER BY bd.detail_id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) return list;

            ps.setInt(1, bookingId);
            ps.setInt(2, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BookingDetailStatus s = new BookingDetailStatus();
                    s.setDetailId(rs.getInt("detail_id"));
                    s.setCaregiverStatus(rs.getInt("caregiver_status"));
                    s.setCheckInTime(rs.getTimestamp("check_in_time"));
                    s.setCheckOutTime(rs.getTimestamp("check_out_time"));
                    s.setUpdatedAt(rs.getTimestamp("updated_at"));
                    list.add(s);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}
