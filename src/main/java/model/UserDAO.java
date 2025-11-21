package model;
import java.sql.*;

public class UserDAO {

    // Check customers table
    public Profile validateMember(String username, String password) {
    	System.out.println(username);
        boolean isValid = false;
        Profile profile = null;
        try (Connection conn = DBConnection.getConnection()) {
            registerModel rm = new registerModel();
            String hashedPassword = rm.hashPassword(password);

            String sql = "SELECT * FROM customers WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, username);
            stmt.setString(2, username);
            stmt.setString(3, hashedPassword);
//            System.out.println("DEBUG HASH: " + hashedPassword);

            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
            	profile = new Profile(
                        rs.getInt("customer_id"),
                        rs.getString("username"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("zipcode")
                    );
                isValid = true;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return profile; //null means invalid login
    }

    // Check admin table
    public boolean validateAdmin(String username, String password) {
        boolean isValid = false;

        try (Connection conn = DBConnection.getConnection()) {
            registerModel rm = new registerModel();
            String hashedPassword = rm.hashPassword(password);

            String sql = "SELECT * FROM admin_user WHERE (username = ? OR email = ?) AND password = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);

            stmt.setString(1, username);
            stmt.setString(2, username);
            stmt.setString(3, hashedPassword);

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
