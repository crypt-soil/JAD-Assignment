package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

	// =====================================
	// GET SERVICES BY CATEGORY
	// =====================================
	public List<Service> getServicesByCategory(int catId) {
		List<Service> list = new ArrayList<>();

		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT * FROM service WHERE cat_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, catId);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Service s = new Service();
				s.setId(rs.getInt("service_id"));
				s.setName(rs.getString("name"));
				s.setDescription(rs.getString("description"));
				s.setPrice(rs.getDouble("price"));
				s.setImageUrl(rs.getString("image_url"));
				s.setCategoryId(rs.getInt("cat_id"));

				list.add(s);
			}

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// =====================================
	// GET ONE SERVICE BY ID
	// =====================================
	public Service getServiceById(int id) {
		Service s = null;

		try {
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT * FROM service WHERE service_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				s = new Service();
				s.setId(rs.getInt("service_id"));
				s.setName(rs.getString("name"));
				s.setDescription(rs.getString("description"));
				s.setPrice(rs.getDouble("price"));
				s.setImageUrl(rs.getString("image_url"));
				s.setCategoryId(rs.getInt("cat_id"));
			}

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return s;
	}

	// =====================================
	// INSERT SERVICE
	// =====================================
	public void insertService(Service s) {
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "INSERT INTO service (name, description, price, image_url, cat_id) "
					+ "VALUES (?, ?, ?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, s.getName());
			ps.setString(2, s.getDescription());
			ps.setDouble(3, s.getPrice());
			ps.setString(4, s.getImageUrl());
			ps.setInt(5, s.getCategoryId());

			ps.executeUpdate();

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// =====================================
	// UPDATE SERVICE
	// =====================================
	public void updateService(Service s) {
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "UPDATE service SET name = ?, description = ?, price = ?, image_url = ?, cat_id = ? "
					+ "WHERE service_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, s.getName());
			ps.setString(2, s.getDescription());
			ps.setDouble(3, s.getPrice());
			ps.setString(4, s.getImageUrl());
			ps.setInt(5, s.getCategoryId());
			ps.setInt(6, s.getId());

			ps.executeUpdate();

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// =====================================
	// DELETE SERVICE
	// =====================================
	public void deleteService(int id) {
		try {
			Connection conn = DBConnection.getConnection();
			String sql = "DELETE FROM service WHERE service_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);

			ps.executeUpdate();

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
