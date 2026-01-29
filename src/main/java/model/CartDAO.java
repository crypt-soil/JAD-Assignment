package model;

import java.sql.*;
import java.util.*;

public class CartDAO {

    // Get the user's cart_id (create if missing)
    public int getOrCreateCartId(int customerId) throws SQLException {
        String findSql = "SELECT cart_id FROM cart WHERE customer_id = ?";
        String insertSql = "INSERT INTO cart (customer_id) VALUES (?)";

        try (Connection conn = DBConnection.getConnection()) {
            // 1) find
            try (PreparedStatement ps = conn.prepareStatement(findSql)) {
                ps.setInt(1, customerId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt("cart_id");
                }
            }
            // 2) create
            try (PreparedStatement ps = conn.prepareStatement(insertSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, customerId);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        }
        throw new SQLException("Unable to create cart for customer_id=" + customerId);
    }

    public List<CartItem> getCartItemsByCustomerId(int customerId) {
        List<CartItem> items = new ArrayList<>();

        String sql =
            "SELECT ci.item_id, ci.service_id, s.name, s.price, ci.quantity, " +
            "       ci.start_time, ci.end_time, ci.caregiver_id, ci.special_request " +
            "FROM cart c " +
            "JOIN cart_items ci ON c.cart_id = ci.cart_id " +
            "JOIN service s ON ci.service_id = s.service_id " +
            "WHERE c.customer_id = ? " +
            "ORDER BY ci.item_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Integer caregiverId = (rs.getObject("caregiver_id") == null) ? null : rs.getInt("caregiver_id");

                    items.add(new CartItem(
                        rs.getInt("item_id"),
                        rs.getInt("service_id"),
                        rs.getString("name"),
                        rs.getDouble("price"),
                        rs.getInt("quantity"),
                        rs.getTimestamp("start_time"),
                        rs.getTimestamp("end_time"),
                        caregiverId,
                        rs.getString("special_request")
                    ));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return items;
    }

    public void clearCartByCustomerId(int customerId) throws SQLException {
        String sql =
            "DELETE ci FROM cart_items ci " +
            "JOIN cart c ON c.cart_id = ci.cart_id " +
            "WHERE c.customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
        }
    }
}
