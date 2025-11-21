package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

	// =====================================
	// GET ALL CATEGORIES (with no services)
	// =====================================
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

	// =====================================
	// INSERT (CREATE)
	// =====================================
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

	// =====================================
	// GET CATEGORY BY ID (no services)
	// =====================================
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

	// =====================================
	// NEW: GET CATEGORY + SERVICES
	// =====================================
	public Category getCategoryWithServices(int id) {

		Category c = null;

		try {
			Connection conn = DBConnection.getConnection();

			// 1. Retrieve the category
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

			if (c == null) {
				DBConnection.closeConnection(conn);
				return null;
			}

			// 2. Retrieve services under category
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

	// =====================================
	// UPDATE CATEGORY
	// =====================================
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

	// =====================================
	// DELETE CATEGORY
	// =====================================
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
