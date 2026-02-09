package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class CaregiverDAO {

    // Existing method (unchanged)
    public String getCaregiverNameById(int caregiverId) {
        String sql = "SELECT full_name FROM caregiver WHERE caregiver_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, caregiverId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getString("full_name");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "Caregiver";
    }

    // New list method
    public List<Caregiver> getAllCaregivers() {
        List<Caregiver> caregivers = new ArrayList<>();

        String sql =
            "SELECT caregiver_id, full_name, gender, years_experience, rating, description, photo_url " +
            "FROM caregiver ORDER BY full_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Caregiver c = new Caregiver();
                c.setCaregiverId(rs.getInt("caregiver_id"));
                c.setFullName(rs.getString("full_name"));
                c.setGender(rs.getString("gender"));
                c.setYearsExperience(rs.getInt("years_experience"));
                c.setRating(rs.getDouble("rating"));
                c.setDescription(rs.getString("description"));
                c.setPhotoUrl(rs.getString("photo_url"));

                caregivers.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return caregivers;
    }
}
