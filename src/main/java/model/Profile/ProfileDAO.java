package model.Profile;

import java.sql.*;

import model.DBConnection;

public class ProfileDAO {

	public Profile getProfileById(int customerId) {
		Profile profile = null;

		try {
			Connection conn = DBConnection.getConnection();

			String sql = "SELECT * FROM customers WHERE customer_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, customerId);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				profile = new Profile(rs.getInt("customer_id"), rs.getString("username"), rs.getString("full_name"),
						rs.getString("email"), rs.getString("phone"), rs.getString("address"), rs.getString("zipcode"));
			}

			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return profile;
	}

	public void updateEmail(int customerId, String email) {
		try {
			Connection conn = DBConnection.getConnection();

			String sql = "UPDATE customers SET email=? WHERE customer_id=?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, email);
			ps.setInt(2, customerId);

			ps.executeUpdate();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void updateAllFields(int id, String full, String phone, String addr, String zip) {
		try {
			Connection conn = DBConnection.getConnection();

			String sql = "UPDATE customers SET full_name=?, phone=?, address=?, zipcode=? WHERE customer_id=?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, full);
			ps.setString(2, phone);
			ps.setString(3, addr);
			ps.setString(4, zip);
			ps.setInt(5, id);

			ps.executeUpdate();
			conn.close();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void clearField(int id, String field) {
		String allowed = switch (field) {
		case "email", "phone", "address", "zipcode", "full_name" -> field;
		default -> null;
		};
		if (allowed == null)
			return;

		try {
			Connection conn = DBConnection.getConnection();
			String sql = "UPDATE customers SET " + allowed + " = NULL WHERE customer_id=?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);
			ps.executeUpdate();
			conn.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
