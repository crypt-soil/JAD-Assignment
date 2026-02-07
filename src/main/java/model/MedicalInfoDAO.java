package model;

import java.sql.*;

public class MedicalInfoDAO {

    public MedicalInfo getByCustomerId(int customerId) {
        MedicalInfo info = null;

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM customer_medical_info WHERE customer_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                info = new MedicalInfo(
                    rs.getInt("medical_id"),
                    rs.getInt("customer_id"),
                    rs.getString("medical_info")
                );
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return info; // can be null if no row yet
    }

    // Upsert: if exists -> update, else -> insert
    public void saveOrUpdate(int customerId, String medicalInfo) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql =
                "INSERT INTO customer_medical_info (customer_id, medical_info) " +
                "VALUES (?, ?) " +
                "ON DUPLICATE KEY UPDATE medical_info = VALUES(medical_info)";

            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setString(2, medicalInfo);

            ps.executeUpdate();
            conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void clearMedicalInfo(int customerId) {
        saveOrUpdate(customerId, null);
    }
}
