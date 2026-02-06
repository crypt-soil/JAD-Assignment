package model;

import java.sql.*;
import java.util.*;

public class BookingItemDAO {

    // ✅ ALL items (no cart filter)
    public List<BookingItem> getAllItems() throws SQLException {

        List<BookingItem> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        String sql =
            "SELECT " +
            "  s.name AS service_name, " +
            "  bi.quantity, " +
            "  (s.price * bi.quantity) AS subtotal, " +
            "  bi.status AS caregiver_status, " +
            "  c.full_name AS caregiver_name, " +
            "  c.phone AS caregiver_contact " +
            "FROM cart_items bi " +
            "JOIN service s ON bi.service_id = s.service_id " +
            "LEFT JOIN caregiver c ON bi.caregiver_id = c.caregiver_id";

        PreparedStatement ps = conn.prepareStatement(sql);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            BookingItem item = new BookingItem(
                rs.getString("service_name"),
                rs.getInt("quantity"),
                rs.getDouble("subtotal"),
                rs.getInt("caregiver_status"),
                rs.getString("caregiver_name"),
                rs.getString("caregiver_contact")
            );
            list.add(item);
        }

        return list;
    }

    // ✅ Filter by cart_id (optional)
    public List<BookingItem> getBookingItemsByCart(int cartId) throws SQLException {

        List<BookingItem> list = new ArrayList<>();
        Connection conn = DBConnection.getConnection();

        String sql =
            "SELECT " +
            "  s.name AS service_name, " +
            "  bi.quantity, " +
            "  (s.price * bi.quantity) AS subtotal, " +
            "  bi.status AS caregiver_status, " +
            "  c.full_name AS caregiver_name, " +
            "  c.phone AS caregiver_contact " +
            "FROM cart_items bi " +
            "JOIN service s ON bi.service_id = s.service_id " +
            "LEFT JOIN caregiver c ON bi.caregiver_id = c.caregiver_id " +
            "WHERE bi.cart_id = ?";

        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, cartId);
        ResultSet rs = ps.executeQuery();

        while (rs.next()) {
            BookingItem item = new BookingItem(
                rs.getString("service_name"),
                rs.getInt("quantity"),
                rs.getDouble("subtotal"),
                rs.getInt("caregiver_status"),
                rs.getString("caregiver_name"),
                rs.getString("caregiver_contact")
            );
            list.add(item);
        }

        return list;
    }
}
