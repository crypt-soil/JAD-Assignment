package model.Service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

import model.DBConnection;

public class ServiceInquiryDAO {

    // =========================
    // INSERT
    // =========================
    public int insert(ServiceInquiry s) {
        int rows = 0;

        String sql = "INSERT INTO service_inquiries "
                + "(customer_id, service_id, caregiver_id, name, email, category, message, preferred_contact, phone) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);

            if (s.getCustomerId() == null) ps.setNull(1, Types.INTEGER);
            else ps.setInt(1, s.getCustomerId());

            if (s.getServiceId() == null) ps.setNull(2, Types.INTEGER);
            else ps.setInt(2, s.getServiceId());

            if (s.getCaregiverId() == null) ps.setNull(3, Types.INTEGER);
            else ps.setInt(3, s.getCaregiverId());

            ps.setString(4, s.getName());
            ps.setString(5, s.getEmail());
            ps.setString(6, s.getCategory());
            ps.setString(7, s.getMessage());
            ps.setString(8, s.getPreferredContact());

            if (s.getPhone() == null || s.getPhone().isBlank())
                ps.setNull(9, Types.VARCHAR);
            else
                ps.setString(9, s.getPhone());

            rows = ps.executeUpdate();

            ps.close();
            DBConnection.closeConnection(conn);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rows;
    }

    // =========================
    // ADMIN: LIST
    // =========================
    public List<ServiceInquiry> getAll(String status, String keyword) {
        List<ServiceInquiry> list = new ArrayList<>();

        String sql =
            "SELECT si.*, s.name AS service_name, c.full_name AS caregiver_name " +
            "FROM service_inquiries si " +
            "LEFT JOIN service s ON si.service_id = s.service_id " +
            "LEFT JOIN caregiver c ON si.caregiver_id = c.caregiver_id " +
            "WHERE (? IS NULL OR si.status = ?) " +
            "AND (? IS NULL OR si.name LIKE ? OR si.email LIKE ?) " +
            "ORDER BY si.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            // status filter
            if (status == null || status.isBlank()) {
                ps.setNull(1, Types.VARCHAR);
                ps.setNull(2, Types.VARCHAR);
            } else {
                ps.setString(1, status);
                ps.setString(2, status);
            }

            // keyword search
            if (keyword == null || keyword.isBlank()) {
                ps.setNull(3, Types.VARCHAR);
                ps.setNull(4, Types.VARCHAR);
                ps.setNull(5, Types.VARCHAR);
            } else {
                String k = "%" + keyword.trim() + "%";
                ps.setString(3, keyword);
                ps.setString(4, k);
                ps.setString(5, k);
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ServiceInquiry si = mapRow(rs);
                si.setServiceName(rs.getString("service_name"));
                si.setCaregiverName(rs.getString("caregiver_name"));
                list.add(si);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================
    // ADMIN: VIEW ONE
    // =========================
    public ServiceInquiry getById(int id) {
        String sql =
            "SELECT si.*, s.name AS service_name, c.full_name AS caregiver_name " +
            "FROM service_inquiries si " +
            "LEFT JOIN service s ON si.service_id = s.service_id " +
            "LEFT JOIN caregiver c ON si.caregiver_id = c.caregiver_id " +
            "WHERE si.inquiry_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                ServiceInquiry si = mapRow(rs);
                si.setServiceName(rs.getString("service_name"));
                si.setCaregiverName(rs.getString("caregiver_name"));
                return si;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================
    // ADMIN: UPDATE STATUS
    // =========================
    public int updateStatus(int inquiryId, String status) {
        String sql = "UPDATE service_inquiries SET status = ? WHERE inquiry_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, inquiryId);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // HELPER: MAP RESULTSET
    // =========================
    private ServiceInquiry mapRow(ResultSet rs) throws Exception {
        ServiceInquiry si = new ServiceInquiry();
        si.setInquiryId(rs.getInt("inquiry_id"));
        si.setCustomerId((Integer) rs.getObject("customer_id"));
        si.setServiceId((Integer) rs.getObject("service_id"));
        si.setCaregiverId((Integer) rs.getObject("caregiver_id"));

        si.setName(rs.getString("name"));
        si.setEmail(rs.getString("email"));
        si.setCategory(rs.getString("category"));
        si.setMessage(rs.getString("message"));

        si.setPreferredContact(rs.getString("preferred_contact"));
        si.setPhone(rs.getString("phone"));

        // make sure your ServiceInquiry model has these fields!
        si.setStatus(rs.getString("status"));
        si.setCreatedAt(rs.getTimestamp("created_at"));

        return si;
    }
}
