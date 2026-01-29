package model;

import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.*;

public class CaregiverUserDAO {

    public CaregiverUser login(String username, String plainPassword) {
        String sql = "SELECT caregiver_user_id, caregiver_id, username, password " +
                     "FROM caregiver_user WHERE username = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) return null;

            ps.setString(1, username);

            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;

                String storedHash = rs.getString("password");
                String inputHash = sha256Hex(plainPassword);

                if (!storedHash.equalsIgnoreCase(inputHash)) return null;

                CaregiverUser user = new CaregiverUser();
                user.setCaregiverUserId(rs.getInt("caregiver_user_id"));
                user.setCaregiverId(rs.getInt("caregiver_id"));
                user.setUsername(rs.getString("username"));
                return user;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    private String sha256Hex(String input) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashBytes = md.digest(input.getBytes(StandardCharsets.UTF_8));
            StringBuilder sb = new StringBuilder();
            for (byte b : hashBytes) {
                sb.append(String.format("%02x", b));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("SHA-256 not available", e);
        }
    }
}
