package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

    // =====================================
    // GET ALL CATEGORIES
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
    // GET ONE CATEGORY BY ID
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
