package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class registerModel {

    public boolean registerUser(String username, String email, String fullName,
                                String phoneNumber, String address, String zipcode, String password) {

        boolean result = false;

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO customers (username, email, full_name, phone, address, zipcode, password) " +
                         "VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ps.setString(2, email);
            ps.setString(3, fullName);
            ps.setString(4, phoneNumber);
            ps.setString(5, address);
            ps.setString(6, zipcode);
            ps.setString(7, hashPassword(password)); 

            int rows = ps.executeUpdate();
            if (rows > 0) {
                result = true;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }

    // 🔒 Password hashing method
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hashedBytes = md.digest(password.getBytes());
            StringBuilder sb = new StringBuilder();

            for (byte b : hashedBytes) {
                sb.append(String.format("%02x", b)); // Convert bytes to hex
            }

            return sb.toString();
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return null;
        }
    }
}
