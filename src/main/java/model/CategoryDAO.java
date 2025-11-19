package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CategoryDAO {

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

}
