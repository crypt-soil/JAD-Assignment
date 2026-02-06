package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class CaregiverDAO {

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
}
