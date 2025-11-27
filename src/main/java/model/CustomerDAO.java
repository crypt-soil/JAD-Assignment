package model;

import java.sql.*;
import java.util.*;

public class CustomerDAO {
	// get connection from DBConnection.java
    private Connection getConnection() throws Exception {
        return DBConnection.getConnection();
    }
    
    //read all customers
    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();

        String sql = "SELECT * FROM customers";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {
                Customer c = new Customer(
                        rs.getInt("customer_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("zipcode")
                );
                customers.add(c);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return customers;
    }

    // read customer by id 
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM customers WHERE customer_id=?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return new Customer(
                        rs.getInt("customer_id"),
                        rs.getString("username"),
                        rs.getString("password"),
                        rs.getString("full_name"),
                        rs.getString("email"),
                        rs.getString("phone"),
                        rs.getString("address"),
                        rs.getString("zipcode")
                );
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // create new customer
    public boolean addCustomer(Customer c) {
        String sql = "INSERT INTO customers (username, password, full_name, email, phone, address, zipcode) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, c.getUsername());
            stmt.setString(2, c.getPassword());
            stmt.setString(3, c.getFull_name());
            stmt.setString(4, c.getEmail());
            stmt.setString(5, c.getPhone());
            stmt.setString(6, c.getAddress());
            stmt.setString(7, c.getZipcode());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // update customer information 
    
    public boolean updateCustomer(Customer c) {
        String sql = "UPDATE customers SET username=?, full_name=?, email=?, phone=?, address=?, zipcode=? WHERE customer_id=?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, c.getUsername());
            stmt.setString(2, c.getFull_name());
            stmt.setString(3, c.getEmail());
            stmt.setString(4, c.getPhone());
            stmt.setString(5, c.getAddress());
            stmt.setString(6, c.getZipcode());
            stmt.setInt(7, c.getCustomer_id());

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // delete customer 
    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM customers WHERE customer_id=?";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, id);

            return stmt.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}
