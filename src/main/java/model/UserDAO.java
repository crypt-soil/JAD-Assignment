package model;
import java.sql.*;

public class UserDAO {
    public boolean checkLogin(String usernameOrEmail, String password) {
        boolean isValid = false;

        try (Connection conn = DBConnection.getConnection()) {
        	registerModel rm = new registerModel();
        	String hashedPassword = rm.hashPassword(password);
        	System.out.println(hashedPassword);
            String sql = "SELECT * FROM customers WHERE (username = ? OR email = ?) AND password = ?";
            System.out.println(sql);
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, usernameOrEmail);   // username
            stmt.setString(2, usernameOrEmail);   // email
            stmt.setString(3, hashedPassword);    // password

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
