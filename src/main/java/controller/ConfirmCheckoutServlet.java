package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.*;
import java.util.List;

import model.DBConnection;
import model.cart.CartDAO;
import model.cart.CartItem;

@WebServlet("/confirmCheckout")
public class ConfirmCheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CartDAO cartDAO = new CartDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession sess = request.getSession(false);
		Integer customerId = (sess == null) ? null : (Integer) sess.getAttribute("customer_id");
		if (customerId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		List<CartItem> items = cartDAO.getCartItemsByCustomerId(customerId);
		if (items == null || items.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/checkout");
			return;
		}

		Connection conn = null;
		PreparedStatement psBooking = null;
		PreparedStatement psDraft = null;
		PreparedStatement psDraftItems = null;
		ResultSet bookingKeys = null;

		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			// Reuse existing pending unpaid booking draft instead of creating another.
			Integer existingBookingId = findExistingPendingDraftBooking(conn, customerId);
			if (existingBookingId != null) {
				System.out.println("[CONFIRM CHECKOUT] Reusing existing pending bookingId=" + existingBookingId);
				conn.commit();
				response.sendRedirect(
						request.getContextPath() + "/stripe/create-checkout-session?bookingId=" + existingBookingId);
				return;
			}

			// 1) create booking header (pending + unpaid)
			String bookingSql = "INSERT INTO bookings (customer_id, status, payment_status) VALUES (?, ?, ?)";
			psBooking = conn.prepareStatement(bookingSql, Statement.RETURN_GENERATED_KEYS);
			psBooking.setInt(1, customerId);
			psBooking.setInt(2, 1); // pending
			psBooking.setInt(3, 0); // unpaid
			psBooking.executeUpdate();

			bookingKeys = psBooking.getGeneratedKeys();
			if (!bookingKeys.next())
				throw new SQLException("Failed to create booking (no generated key).");
			int bookingId = bookingKeys.getInt(1);

			// 2) create booking_drafts row
			String draftSql = "INSERT INTO booking_drafts (booking_id, customer_id, status) VALUES (?, ?, 0)";
			psDraft = conn.prepareStatement(draftSql, Statement.RETURN_GENERATED_KEYS);
			psDraft.setInt(1, bookingId);
			psDraft.setInt(2, customerId);
			psDraft.executeUpdate();

			ResultSet draftKeys = psDraft.getGeneratedKeys();
			if (!draftKeys.next())
				throw new SQLException("Failed to create draft (no generated key).");
			int draftId = draftKeys.getInt(1);
			draftKeys.close();

			// 3) snapshot cart -> booking_draft_items
			String draftItemSql = "INSERT INTO booking_draft_items "
					+ "(draft_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status) "
					+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
			psDraftItems = conn.prepareStatement(draftItemSql);

			for (CartItem item : items) {
				if (item.getQuantity() < 1)
					throw new SQLException("Invalid quantity for item_id=" + item.getItemId());
				if (item.getStartTime() == null || item.getEndTime() == null)
					throw new SQLException("Missing start/end time for item_id=" + item.getItemId());
				if (!item.getEndTime().after(item.getStartTime()))
					throw new SQLException("End time must be after start time for item_id=" + item.getItemId());

				psDraftItems.setInt(1, draftId);
				psDraftItems.setInt(2, item.getServiceId());

				if (item.getCaregiverId() == null)
					psDraftItems.setNull(3, Types.INTEGER);
				else
					psDraftItems.setInt(3, item.getCaregiverId());

				psDraftItems.setInt(4, item.getQuantity());
				psDraftItems.setTimestamp(5, item.getStartTime());
				psDraftItems.setTimestamp(6, item.getEndTime());
				psDraftItems.setDouble(7, item.getLineTotal());
				psDraftItems.setString(8, item.getSpecialRequest());

				int caregiverStatus = (item.getCaregiverId() == null) ? 0 : 1;
				psDraftItems.setInt(9, caregiverStatus);

				psDraftItems.addBatch();
			}
			psDraftItems.executeBatch();

			conn.commit();

			System.out.println("[CONFIRM CHECKOUT] Created bookingId=" + bookingId + ", draft snapshot saved.");

			// 4) redirect to Stripe
			response.sendRedirect(request.getContextPath() + "/stripe/create-checkout-session?bookingId=" + bookingId);

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
				if (bookingKeys != null)
					bookingKeys.close();
			} catch (Exception ignore) {
			}
			try {
				if (psDraftItems != null)
					psDraftItems.close();
			} catch (Exception ignore) {
			}
			try {
				if (psDraft != null)
					psDraft.close();
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

	// Finds an existing pending unpaid booking that has a draft (status=0)
	private Integer findExistingPendingDraftBooking(Connection conn, int customerId) throws SQLException {
		String sql = "SELECT b.booking_id " + "FROM bookings b "
				+ "JOIN booking_drafts d ON d.booking_id = b.booking_id "
				+ "WHERE b.customer_id=? AND b.payment_status=0 AND d.status=0 " + "ORDER BY b.booking_id DESC LIMIT 1";
		try (PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setInt(1, customerId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				return rs.getInt("booking_id");
			}
		}
	}
}
