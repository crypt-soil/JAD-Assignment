package model.MedicalInfo;
/*
 * Ong Jin Kai
 * 2429465
 */
import java.sql.*;

import model.DBConnection;

public class MedicalInfoDAO {

	public MedicalInfo getByCustomerId(int customerId) {
		MedicalInfo info = null;

		String sql = "SELECT medical_id, customer_id, conditions_csv, allergies_text "
				+ "FROM customer_medical_info WHERE customer_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, customerId);

			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next()) {
					info = new MedicalInfo(rs.getInt("medical_id"), rs.getInt("customer_id"),
							rs.getString("conditions_csv"), rs.getString("allergies_text"));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return info; // can be null if no row yet
	}

	// Upsert: if exists -> update, else -> insert
	public void saveOrUpdate(int customerId, String conditionsCsv, String allergiesText) {
		String checkSql = "SELECT medical_id FROM customer_medical_info WHERE customer_id=?";
		String insertSql = "INSERT INTO customer_medical_info (customer_id, conditions_csv, allergies_text) VALUES (?, ?, ?)";
		String updateSql = "UPDATE customer_medical_info SET conditions_csv=?, allergies_text=? WHERE customer_id=?";

		try (Connection conn = DBConnection.getConnection();
				PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

			checkStmt.setInt(1, customerId);

			try (ResultSet rs = checkStmt.executeQuery()) {
				if (rs.next()) {
					// update
					try (PreparedStatement stmt = conn.prepareStatement(updateSql)) {
						stmt.setString(1, conditionsCsv);
						stmt.setString(2, allergiesText);
						stmt.setInt(3, customerId);
						stmt.executeUpdate();
					}
				} else {
					// insert
					try (PreparedStatement stmt = conn.prepareStatement(insertSql)) {
						stmt.setInt(1, customerId);
						stmt.setString(2, conditionsCsv);
						stmt.setString(3, allergiesText);
						stmt.executeUpdate();
					}
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void clearMedicalInfo(int customerId) {
		// clear both columns
		saveOrUpdate(customerId, "", "");
	}
}
