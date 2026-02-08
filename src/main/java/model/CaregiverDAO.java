package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CaregiverDAO {

	// ============================================================
	// GET CAREGIVER NAME (used in navbar / greetings)
	// ============================================================
	public String getCaregiverNameById(int caregiverId) {
		String sql = "SELECT full_name FROM caregiver WHERE caregiver_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

	// ============================================================
	// GET FULL CAREGIVER PROFILE (for profile page)
	// ============================================================
	public Caregiver getCaregiverById(int caregiverId) {

		Caregiver c = null;
		String sql = "SELECT * FROM caregiver WHERE caregiver_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, caregiverId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					c = new Caregiver();
					c.setId(rs.getInt("caregiver_id"));
					c.setFullName(rs.getString("full_name"));
					c.setPhone(rs.getString("phone"));
					c.setEmail(rs.getString("email"));
					c.setGender(rs.getString("gender"));
					c.setYearsExperience(rs.getInt("years_experience"));
					c.setRating(rs.getDouble("rating"));
					c.setDescription(rs.getString("description"));
					c.setPhotoUrl(rs.getString("photo_url"));
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return c;
	}

	// ============================================================
	// UPDATE CAREGIVER PROFILE (editable fields only)
	// ============================================================
	public void updateCaregiver(Caregiver c) {

		String sql = """
									UPDATE caregiver
				SET full_name = ?,
				    email = ?,
				    phone = ?,
				    gender = ?,
				    years_experience = ?,
				    description = ?,
				    photo_url = ?
				WHERE caregiver_id = ?

								""";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, c.getFullName());
			ps.setString(2, c.getEmail());
			ps.setString(3, c.getPhone());
			ps.setString(4, c.getGender());
			ps.setInt(5, c.getYearsExperience());
			ps.setString(6, c.getDescription());
			ps.setString(7, c.getPhotoUrl());
			ps.setInt(8, c.getId());

			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
