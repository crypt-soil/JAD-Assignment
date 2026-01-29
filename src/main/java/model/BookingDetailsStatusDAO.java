package model;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class BookingDetailsStatusDAO {

    public boolean checkIn(int detailId, int caregiverId) {
        String sql =
            "UPDATE booking_details " +
            "SET caregiver_status = 1, " +
            "    check_in_at = COALESCE(check_in_at, NOW()), " +
            "    check_out_at = NULL " +
            "WHERE detail_id = ? " +
            "  AND caregiver_id = ? " +
            "  AND DATE(start_time) = CURDATE() " +
            "  AND caregiver_status = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailId);
            ps.setInt(2, caregiverId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean checkOut(int detailId, int caregiverId) {
        String sql =
            "UPDATE booking_details " +
            "SET caregiver_status = 2, check_out_at = NOW() " +
            "WHERE detail_id = ? " +
            "  AND caregiver_id = ? " +
            "  AND DATE(start_time) = CURDATE() " +
            "  AND caregiver_status = 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, detailId);
            ps.setInt(2, caregiverId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
