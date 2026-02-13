package model.customer;
/*
 * Ong Jin Kai
 * 2429465
 */
import java.sql.*;
import java.util.*;

import model.DBConnection;

public class CustomerDAO {

	// get connection from DBConnection.java
	private Connection getConnection() throws Exception {
		return DBConnection.getConnection();
	}

	// read all customers
	public List<Customer> getAllCustomers() {
		List<Customer> customers = new ArrayList<>();
		String sql = "SELECT * FROM customers";

		try (Connection conn = getConnection();
				PreparedStatement stmt = conn.prepareStatement(sql);
				ResultSet rs = stmt.executeQuery()) {

			while (rs.next()) {
				Customer c = new Customer(rs.getInt("customer_id"), rs.getString("username"), rs.getString("password"),
						rs.getString("full_name"), rs.getString("email"), rs.getString("phone"),
						rs.getString("address"), rs.getString("zipcode"));
				customers.add(c);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return customers;
	}

	// ✅ NEW: inquiry (search + filter)
	// q searches: username / full_name / email / phone
	// zipcode filters: exact match
	public List<Customer> searchCustomers(String q, String zipcode) {
		List<Customer> customers = new ArrayList<>();

		StringBuilder sql = new StringBuilder("SELECT * FROM customers WHERE 1=1 ");
		List<Object> params = new ArrayList<>();

		if (q != null && !q.trim().isEmpty()) {
			sql.append(" AND (username LIKE ? OR full_name LIKE ? OR email LIKE ? OR phone LIKE ?) ");
			String like = "%" + q.trim() + "%";
			params.add(like);
			params.add(like);
			params.add(like);
			params.add(like);
		}

		if (zipcode != null && !zipcode.trim().isEmpty()) {
			sql.append(" AND zipcode = ? ");
			params.add(zipcode.trim());
		}

		sql.append(" ORDER BY customer_id DESC");

		try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql.toString())) {

			for (int i = 0; i < params.size(); i++) {
				stmt.setObject(i + 1, params.get(i));
			}

			try (ResultSet rs = stmt.executeQuery()) {
				while (rs.next()) {
					Customer c = new Customer(rs.getInt("customer_id"), rs.getString("username"),
							rs.getString("password"), rs.getString("full_name"), rs.getString("email"),
							rs.getString("phone"), rs.getString("address"), rs.getString("zipcode"));
					customers.add(c);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return customers;
	}

	// read customer by id
	public Customer getCustomerById(int id) {
		String sql = "SELECT * FROM customers WHERE customer_id=?";

		try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, id);

			try (ResultSet rs = stmt.executeQuery()) {
				if (rs.next()) {
					return new Customer(rs.getInt("customer_id"), rs.getString("username"), rs.getString("password"),
							rs.getString("full_name"), rs.getString("email"), rs.getString("phone"),
							rs.getString("address"), rs.getString("zipcode"));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return null;
	}

	// create new customer
	public boolean addCustomer(Customer c) {
		String sql = "INSERT INTO customers (username, password, full_name, email, phone, address, zipcode) VALUES (?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

	// update customer information (without password)
	public boolean updateCustomer(Customer c) {
		String sql = "UPDATE customers SET username=?, full_name=?, email=?, phone=?, address=?, zipcode=? WHERE customer_id=?";

		try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

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

	// ✅ OPTIONAL: update including password (use only if admin changed password)
	public boolean updateCustomerWithPassword(Customer c) {
		String sql = "UPDATE customers SET username=?, password=?, full_name=?, email=?, phone=?, address=?, zipcode=? WHERE customer_id=?";

		try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setString(1, c.getUsername());
			stmt.setString(2, c.getPassword());
			stmt.setString(3, c.getFull_name());
			stmt.setString(4, c.getEmail());
			stmt.setString(5, c.getPhone());
			stmt.setString(6, c.getAddress());
			stmt.setString(7, c.getZipcode());
			stmt.setInt(8, c.getCustomer_id());

			return stmt.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	// delete customer
	public boolean deleteCustomer(int id) {
		String sql = "DELETE FROM customers WHERE customer_id=?";

		try (Connection conn = getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {

			stmt.setInt(1, id);
			return stmt.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}
}
