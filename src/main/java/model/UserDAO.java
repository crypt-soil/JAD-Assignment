package model;
import java.sql.*;

public class UserDAO {
    public boolean checkLogin(String username, String password) {
        boolean isValid = false;

        try (Connection conn = DBConnection.getConnection()) {
        	registerModel rm = new registerModel();
        	String hashedPassword = rm.hashPassword(password);
            String sql = "SELECT * FROM customers WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, hashedPassword);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                isValid = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return isValid;
    }
}
