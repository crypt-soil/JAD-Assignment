package model.category;
/*
 * Ong Jin Kai
 * 2429465
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.DBConnection;
import model.Service.Service;

/**
 * Data Access Object (DAO) for interacting with the `service_category` table.
 *
 * Responsibilities: - Retrieve categories (with or without services) - Insert
 * new categories - Update category details - Delete categories
 *
 * Note: Connection handling is performed via DBConnection.getConnection() and
 * DBConnection.closeConnection().
 */
public class CategoryDAO {

	// ============================================================
	// GET ALL CATEGORIES (NO SERVICES LOADED)
	// ============================================================
	/**
	 * Retrieves all categories from the database.
	 *
	 * @return List of Category objects (services not included)
	 */
	public List<Category> getAllCategories() {
		List<Category> list = new ArrayList<>();

		try {
			Connection conn = DBConnection.getConnection();

			String sql = "SELECT * FROM service_category";
			PreparedStatement ps = conn.prepareStatement(sql);

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Category c = new Category();
				c.setId(rs.getInt("cat_id"));
				c.setName(rs.getString("name"));
				c.setDescription(rs.getString("description"));
				c.setImageUrl(rs.getString("image_url"));

				list.add(c);
			}

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	// ============================================================
	// INSERT CATEGORY
	// ============================================================
	/**
	 * Inserts a new category into the database.
	 *
	 * @param c Category object to insert
	 */
	public void insertCategory(Category c) {
		try {
			Connection conn = DBConnection.getConnection();

			String sql = "INSERT INTO service_category (name, description, image_url) VALUES (?, ?, ?)";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, c.getName());
			ps.setString(2, c.getDescription());
			ps.setString(3, c.getImageUrl());

			ps.executeUpdate();

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ============================================================
	// GET CATEGORY BY ID (NO SERVICES LOADED)
	// ============================================================
	/**
	 * Retrieves a category by its ID (does NOT load services).
	 *
	 * @param id category ID
	 * @return Category object or null if not found
	 */
	public Category getCategoryById(int id) {
		Category c = null;

		try {
			Connection conn = DBConnection.getConnection();

			String sql = "SELECT * FROM service_category WHERE cat_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, id);

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				c = new Category();
				c.setId(rs.getInt("cat_id"));
				c.setName(rs.getString("name"));
				c.setDescription(rs.getString("description"));
				c.setImageUrl(rs.getString("image_url"));
			}

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return c;
	}

	// ============================================================
	// GET CATEGORY WITH SERVICES
	// ============================================================
	/**
	 * Retrieves a category AND all services belonging to it.
	 *
	 * @param id category ID
	 * @return Category object fully populated with services, or null if not found
	 */
	public Category getCategoryWithServices(int id) {

		Category c = null;

		try {
			Connection conn = DBConnection.getConnection();

			// -----------------------------------------------------
			// 1. Retrieve the category details
			// -----------------------------------------------------
			String sqlCat = "SELECT * FROM service_category WHERE cat_id = ?";
			PreparedStatement psCat = conn.prepareStatement(sqlCat);
			psCat.setInt(1, id);

			ResultSet rsCat = psCat.executeQuery();

			if (rsCat.next()) {
				c = new Category();
				c.setId(rsCat.getInt("cat_id"));
				c.setName(rsCat.getString("name"));
				c.setDescription(rsCat.getString("description"));
				c.setImageUrl(rsCat.getString("image_url"));
			}

			// If category not found → return null
			if (c == null) {
				DBConnection.closeConnection(conn);
				return null;
			}

			// -----------------------------------------------------
			// 2. Retrieve services under this category
			// -----------------------------------------------------
			String sqlServices = "SELECT * FROM service WHERE cat_id = ?";

			PreparedStatement psService = conn.prepareStatement(sqlServices);
			psService.setInt(1, id);

			ResultSet rsS = psService.executeQuery();

			List<Service> services = new ArrayList<>();

			while (rsS.next()) {
				Service s = new Service();
				s.setId(rsS.getInt("service_id"));
				s.setName(rsS.getString("name"));
				s.setDescription(rsS.getString("description"));
				s.setImageUrl(rsS.getString("image_url"));
				s.setPrice(rsS.getDouble("price"));

				services.add(s);
			}

			c.setServices(services);

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return c;
	}

	// ============================================================
	// UPDATE CATEGORY
	// ============================================================
	/**
	 * Updates an existing category.
	 *
	 * @param c Category object with updated fields
	 */
	public void updateCategory(Category c) {
		try {
			Connection conn = DBConnection.getConnection();

			String sql = "UPDATE service_category SET name = ?, description = ?, image_url = ? WHERE cat_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setString(1, c.getName());
			ps.setString(2, c.getDescription());
			ps.setString(3, c.getImageUrl());
			ps.setInt(4, c.getId());

			ps.executeUpdate();

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// ============================================================
	// DELETE CATEGORY
	// ============================================================
	/**
	 * Deletes a category based on ID.
	 *
	 * @param id category ID
	 */
	public void deleteCategory(int id) {
		try {
			Connection conn = DBConnection.getConnection();

			String sql = "DELETE FROM service_category WHERE cat_id = ?";
			PreparedStatement ps = conn.prepareStatement(sql);

			ps.setInt(1, id);
			ps.executeUpdate();

			DBConnection.closeConnection(conn);

		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
