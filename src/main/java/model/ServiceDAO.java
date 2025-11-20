package model;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ServiceDAO {

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
                s.setCategoryId(catId);

                list.add(s);
            }

            DBConnection.closeConnection(conn);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}
