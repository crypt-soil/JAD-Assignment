package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.List;

import model.CartDAO;
import model.CartItem;
import model.DBConnection;

@WebServlet("/confirmCheckout")
public class ConfirmCheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CartDAO cartDAO = new CartDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer customerId = (Integer) request.getSession().getAttribute("customer_id");
		if (customerId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		List<CartItem> items = cartDAO.getCartItemsByCustomerId(customerId);
		if (items == null || items.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/checkout");
			return;
		}

		// ✅ totals (not stored in bookings table; for any future use)
		double subtotal = 0.0;
		for (CartItem item : items) {
			subtotal += item.getLineTotal(); // ✅ now includes durationHours * qty * hourly rate
		}
		double gstRate = 0.09;
		double gstAmount = subtotal * gstRate;
		double total = subtotal + gstAmount;

		Connection conn = null;
		PreparedStatement psBooking = null;
		PreparedStatement psDetails = null;
		ResultSet keys = null;

		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			// 1) Insert into bookings (booking_date handled by DB default or triggers if
			// any)
			String bookingSql = "INSERT INTO bookings (customer_id, status) VALUES (?, ?)";
			psBooking = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS);
			psBooking.setInt(1, customerId);
			psBooking.setInt(2, 1); // 1 = pending
			psBooking.executeUpdate();

			keys = psBooking.getGeneratedKeys();
			if (!keys.next())
				throw new SQLException("Failed to create booking (no generated key).");
			int bookingId = keys.getInt(1);

			// 2) Insert booking_details
			String detailSql = "INSERT INTO booking_details "
					+ "(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

			psDetails = conn.prepareStatement(detailSql);

			for (CartItem item : items) {

				// ✅ basic validation (optional but safer)
				if (item.getQuantity() < 1) {
					throw new SQLException("Invalid quantity for item_id=" + item.getItemId());
				}
				if (item.getStartTime() == null || item.getEndTime() == null) {
					throw new SQLException("Missing start/end time for item_id=" + item.getItemId());
				}
				if (!item.getEndTime().after(item.getStartTime())) {
					throw new SQLException("End time must be after start time for item_id=" + item.getItemId());
				}

				psDetails.setInt(1, bookingId);
				psDetails.setInt(2, item.getServiceId());

				if (item.getCaregiverId() == null) {
					psDetails.setNull(3, Types.INTEGER);
				} else {
					psDetails.setInt(3, item.getCaregiverId());
				}

				psDetails.setInt(4, item.getQuantity());
				psDetails.setTimestamp(5, item.getStartTime());
				psDetails.setTimestamp(6, item.getEndTime());

				// ✅ IMPORTANT CHANGE:
				// subtotal MUST include duration-based pricing
				// CartItem.getLineTotal() = price(hourly) * durationHours * quantity
				double lineSubtotal = item.getLineTotal();
				psDetails.setDouble(7, lineSubtotal);

				psDetails.setString(8, item.getSpecialRequest());

				int caregiverStatus = (item.getCaregiverId() == null) ? 0 : 1; // 0=not_assigned, 1=assigned
				psDetails.setInt(9, caregiverStatus);

				psDetails.addBatch();
			}

			psDetails.executeBatch();

			// 3) clear cart (ideally should use same conn; keeping your DAO call as-is)
			cartDAO.clearCartByCustomerId(customerId);

			conn.commit();

			// flash message
			HttpSession session = request.getSession();
			session.setAttribute("checkoutSuccessMessage", "Booking successful! Your booking ID is #" + bookingId);

			// Redirect back to Categories page
			response.sendRedirect(request.getContextPath() + "/categories");

		} catch (Exception e) {
			e.printStackTrace();
			try {
				if (conn != null)
					conn.rollback();
			} catch (SQLException ignore) {
			}

			response.sendRedirect(request.getContextPath() + "/checkout?error=checkout_failed");

		} finally {
			try {
				if (keys != null)
					keys.close();
			} catch (Exception ignore) {
			}
			try {
				if (psDetails != null)
					psDetails.close();
			} catch (Exception ignore) {
			}
			try {
				if (psBooking != null)
					psBooking.close();
			} catch (Exception ignore) {
			}
			try {
				if (conn != null)
					conn.close();
			} catch (Exception ignore) {
			}
		}
	}
}
