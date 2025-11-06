package model;
import java.sql.*;

public class UserDAO {
    public boolean checkLogin(String usernameOrEmail, String password) {
        boolean isValid = false;

        try (Connection conn = DBConnection.getConnection()) {
<<<<<<< Updated upstream
            String sql = "SELECT * FROM users WHERE username = ? AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, username);
            stmt.setString(2, password);
=======
        	registerModel rm = new registerModel();
        	String hashedPassword = rm.hashPassword(password);
        	System.out.println(hashedPassword);
            String sql = "SELECT * FROM customers WHERE (username = ? OR email = ?) AND password = ?";
            System.out.println(sql);
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setString(1, usernameOrEmail);   // username
            stmt.setString(2, usernameOrEmail);   // email
            stmt.setString(3, hashedPassword);    // password
>>>>>>> Stashed changes

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
