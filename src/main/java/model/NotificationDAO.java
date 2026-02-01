package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    public void create(int customerId, Integer bookingId, Integer detailId, String title, String message) {
        String sql = "INSERT INTO notifications (customer_id, booking_id, detail_id, title, message) VALUES (?,?,?,?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            if (bookingId == null) ps.setNull(2, Types.INTEGER);
            else ps.setInt(2, bookingId);

            if (detailId == null) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, detailId);

            ps.setString(4, title);
            ps.setString(5, message);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public int getUnreadCount(int customerId) {
        String sql = "SELECT COUNT(*) FROM notifications WHERE customer_id = ? AND is_read = 0";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    // get latest notifications (for dropdown)
    public List<Notification> getLatest(int customerId, int limit) {
        List<Notification> list = new ArrayList<>();
        String sql =
            "SELECT notification_id, customer_id, booking_id, detail_id, title, message, is_read, created_at " +
            "FROM notifications WHERE customer_id = ? " +
            "ORDER BY created_at DESC, notification_id DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notification_id"));
                    n.setCustomerId(rs.getInt("customer_id"));

                    int bId = rs.getInt("booking_id");
                    n.setBookingId(rs.wasNull() ? null : bId);

                    int dId = rs.getInt("detail_id");
                    n.setDetailId(rs.wasNull() ? null : dId);

                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getInt("is_read") == 1);
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // get unread notifications since lastId (for toast “LIVE”)
    public List<Notification> getUnreadSince(int customerId, int lastId) {
        List<Notification> list = new ArrayList<>();
        String sql =
            "SELECT notification_id, booking_id, detail_id, title, message, is_read, created_at " +
            "FROM notifications WHERE customer_id = ? AND is_read = 0 AND notification_id > ? " +
            "ORDER BY notification_id ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            ps.setInt(2, lastId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Notification n = new Notification();
                    n.setNotificationId(rs.getInt("notification_id"));

                    int bId = rs.getInt("booking_id");
                    n.setBookingId(rs.wasNull() ? null : bId);

                    int dId = rs.getInt("detail_id");
                    n.setDetailId(rs.wasNull() ? null : dId);

                    n.setTitle(rs.getString("title"));
                    n.setMessage(rs.getString("message"));
                    n.setRead(rs.getInt("is_read") == 1);
                    n.setCreatedAt(rs.getTimestamp("created_at"));
                    list.add(n);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean markRead(int notificationId, int customerId) {
        String sql = "UPDATE notifications SET is_read = 1 WHERE notification_id = ? AND customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            ps.setInt(2, customerId);
            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
