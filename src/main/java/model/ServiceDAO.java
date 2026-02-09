package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Data Access Object (DAO) for interacting with the `service` table.
 *
 * Responsibilities: - Retrieve services (by category or id) - Insert new
 * services - Update existing services - Delete services
 *
 * Used by: - ServiceServlet - CategoryDAO (when loading category with services)
 */
public class ServiceDAO {

	// ============================================================
	// GET SERVICES BY CATEGORY
	// ============================================================
	/**
	 * Returns all services that belong to a specific category.
	 *
	 * @param catId ID of the category
	 * @return List of Service objects
	 */
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

	// ============================================================
	// GET SERVICE BY ID
	// ============================================================
	/**
	 * Retrieves a single service based on its ID.
	 *
	 * @param id the service ID
	 * @return Service object or null if not found
	 */
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

	// ============================================================
	// INSERT SERVICE
	// ============================================================
	/**
	 * Inserts a new service record into the database.
	 *
	 * @param s Service object containing the data to insert
	 */
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

	// ============================================================
	// UPDATE SERVICE
	// ============================================================
	/**
	 * Updates an existing service's details.
	 *
	 * @param s Service object containing updated values
	 */
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

	// ============================================================
	// DELETE SERVICE
	// ============================================================
	/**
	 * Deletes a service from the database.
	 *
	 * @param id ID of the service to delete
	 */
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

	public List<Service> getAllServices() {
		List<Service> list = new ArrayList<>();

		try {
			Connection conn = DBConnection.getConnection();

			String sql = "SELECT service_id, name, description, price, image_url, cat_id "
					+ "FROM service WHERE status = 1 ORDER BY name";
			PreparedStatement ps = conn.prepareStatement(sql);
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
}
