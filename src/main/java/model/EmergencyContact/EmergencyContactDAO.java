package model.EmergencyContact;
/*
 * Ong Jin Kai
 * 2429465
 */
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import model.DBConnection;

public class EmergencyContactDAO {

    public List<EmergencyContact> getByCustomerId(int customerId) {
        List<EmergencyContact> list = new ArrayList<>();

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM emergency_contacts WHERE customer_id = ? ORDER BY contact_id ASC";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new EmergencyContact(
                    rs.getInt("contact_id"),
                    rs.getInt("customer_id"),
                    rs.getString("contact_name"),
                    rs.getString("relationship"),
                    rs.getString("phone"),
                    rs.getString("email")
                ));
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public void addContact(int customerId, String name, String relationship, String phone, String email) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO emergency_contacts (customer_id, contact_name, relationship, phone, email) " +
                         "VALUES (?, ?, ?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, customerId);
            ps.setString(2, name);
            ps.setString(3, relationship);
            ps.setString(4, phone);
            ps.setString(5, email);

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void updateContact(int contactId, int customerId, String name, String relationship, String phone, String email) {
        try {
            Connection conn = DBConnection.getConnection();

            // customerId included to ensure user can only update their own contact
            String sql = "UPDATE emergency_contacts SET contact_name=?, relationship=?, phone=?, email=? " +
                         "WHERE contact_id=? AND customer_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, name);
            ps.setString(2, relationship);
            ps.setString(3, phone);
            ps.setString(4, email);
            ps.setInt(5, contactId);
            ps.setInt(6, customerId);

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void deleteContact(int contactId, int customerId) {
        try {
            Connection conn = DBConnection.getConnection();

            String sql = "DELETE FROM emergency_contacts WHERE contact_id=? AND customer_id=?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, contactId);
            ps.setInt(2, customerId);

            ps.executeUpdate();
            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
