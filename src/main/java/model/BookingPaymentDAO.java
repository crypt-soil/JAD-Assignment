package model;

import java.sql.*;

public class BookingPaymentDAO {

	private Connection externalConn; // optional (for webhook transactions)

	public BookingPaymentDAO() {
	}

	public BookingPaymentDAO(Connection conn) {
		this.externalConn = conn;
	}

	private Connection getConnection() throws Exception {
		return (externalConn != null) ? externalConn : DBConnection.getConnection();
	}

	private boolean isExternalConn() {
		return externalConn != null;
	}

	// =============================
	// Auth / payment checks
	// =============================
	public boolean bookingBelongsToCustomer(int bookingId, int customerId) {
		String sql = "SELECT 1 FROM bookings WHERE booking_id=? AND customer_id=? LIMIT 1";
		try (Connection conn = isExternalConn() ? null : getConnection();
				PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			ps.setInt(2, customerId);
			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public boolean isPaid(int bookingId) {
		String sql = "SELECT payment_status FROM bookings WHERE booking_id=?";
		try (Connection conn = isExternalConn() ? null : getConnection();
				PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return false;
				return rs.getInt("payment_status") == 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// ✅ for OPTION A: amount should be computed from draft
	public double sumDraftSubtotalByBookingId(int bookingId) {
		String sql = "SELECT COALESCE(SUM(di.subtotal), 0) AS total_sub " + "FROM booking_draft_items di "
				+ "JOIN booking_drafts d ON d.draft_id = di.draft_id " + "WHERE d.booking_id=?";

		try (Connection conn = isExternalConn() ? null : getConnection();
				PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return 0.0;
				return rs.getDouble("total_sub");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return 0.0;
		}
	}

	// keep (but you'll stop using this for Stripe amount once you switch to draft)
	public double sumBookingDetailsSubtotal(int bookingId) {
		String sql = "SELECT COALESCE(SUM(subtotal), 0) AS total_sub FROM booking_details WHERE booking_id=?";
		try (Connection conn = isExternalConn() ? null : getConnection();
				PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return 0.0;
				return rs.getDouble("total_sub");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return 0.0;
		}
	}

	public void saveStripeSessionId(int bookingId, String stripeSessionId) {
		String sql = "UPDATE bookings SET stripe_session_id=? WHERE booking_id=?";
		try (Connection conn = isExternalConn() ? null : getConnection();
				PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setString(1, stripeSessionId);
			ps.setInt(2, bookingId);
			ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public int markPaidReturnRows(int bookingId, String stripeSessionId, String paymentIntentId) {
		String sql = "UPDATE bookings " + "SET payment_status=1, stripe_session_id=?, stripe_payment_intent_id=? "
				+ "WHERE booking_id=? AND payment_status=0";

		try (Connection conn = isExternalConn() ? null : getConnection();
				PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setString(1, stripeSessionId);
			ps.setString(2, paymentIntentId);
			ps.setInt(3, bookingId);
			return ps.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	// =============================
	// Draft -> booking_details (used by webhook)
	// =============================
	public int countBookingDetails(int bookingId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM booking_details WHERE booking_id=?";
		try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				rs.next();
				return rs.getInt(1);
			}
		} catch (Exception e) {
			if (e instanceof SQLException)
				throw (SQLException) e;
			throw new SQLException(e);
		}
	}

	public int findDraftId(int bookingId, int customerId) throws SQLException {
		String sql = "SELECT draft_id FROM booking_drafts WHERE booking_id=? AND customer_id=? LIMIT 1";
		try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			ps.setInt(2, customerId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return -1;
				return rs.getInt("draft_id");
			}
		} catch (Exception e) {
			if (e instanceof SQLException)
				throw (SQLException) e;
			throw new SQLException(e);
		}
	}

	public int countDraftItems(int draftId) throws SQLException {
		String sql = "SELECT COUNT(*) FROM booking_draft_items WHERE draft_id=?";
		try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, draftId);
			try (ResultSet rs = ps.executeQuery()) {
				rs.next();
				return rs.getInt(1);
			}
		} catch (Exception e) {
			if (e instanceof SQLException)
				throw (SQLException) e;
			throw new SQLException(e);
		}
	}

	public int copyDraftToBookingDetails(int bookingId, int draftId) throws SQLException {
		String sql = "INSERT INTO booking_details "
				+ "(booking_id, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status) "
				+ "SELECT ?, service_id, caregiver_id, quantity, start_time, end_time, subtotal, special_request, caregiver_status "
				+ "FROM booking_draft_items WHERE draft_id=?";

		try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			ps.setInt(2, draftId);
			return ps.executeUpdate();
		} catch (Exception e) {
			if (e instanceof SQLException)
				throw (SQLException) e;
			throw new SQLException(e);
		}
	}

	public void markDraftCopied(int draftId) throws SQLException {
		String sql = "UPDATE booking_drafts SET status=1 WHERE draft_id=?";
		try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, draftId);
			ps.executeUpdate();
		} catch (Exception e) {
			if (e instanceof SQLException)
				throw (SQLException) e;
			throw new SQLException(e);
		}
	}

	// =============================
	// Cart clearing (webhook)
	// =============================
	public int clearCartByCustomerId(int customerId) throws SQLException {
		String sql = "DELETE ci FROM cart_items ci " + "JOIN cart c ON c.cart_id = ci.cart_id "
				+ "WHERE c.customer_id = ?";

		try (PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, customerId);
			return ps.executeUpdate();
		} catch (Exception e) {
			if (e instanceof SQLException)
				throw (SQLException) e;
			throw new SQLException(e);
		}
	}

	// optional
	public Integer getCustomerIdByBookingId(int bookingId) {
		String sql = "SELECT customer_id FROM bookings WHERE booking_id=?";
		try (Connection conn = isExternalConn() ? null : getConnection();
				PreparedStatement ps = getConnection().prepareStatement(sql)) {
			ps.setInt(1, bookingId);
			try (ResultSet rs = ps.executeQuery()) {
				if (!rs.next())
					return null;
				return rs.getInt("customer_id");
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	public int deleteUnpaidBookingCascade(int bookingId, int customerId) {
		String sql = "DELETE FROM bookings WHERE booking_id=? AND customer_id=? AND payment_status=0";

		try (Connection conn = getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, bookingId);
			ps.setInt(2, customerId);
			return ps.executeUpdate(); // 1 = deleted, 0 = not deleted

		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

}
