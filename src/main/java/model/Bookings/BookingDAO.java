package model.Bookings;
import java.sql.*;
import java.time.LocalDateTime;
import java.util.*;

import model.DBConnection;

public class BookingDAO {

	// =========================
	// GET BOOKINGS (WITH ITEM TIMES)
	// =========================
	public List<Booking> getBookingsByCustomerId(int customerId) {
		List<Booking> bookings = new ArrayList<>();

		String sql = "SELECT b.booking_id, b.booking_date, b.status, "
				+ "       bd.service_id, s.name AS service_name, bd.quantity, bd.subtotal, bd.caregiver_status, "
				+ "       bd.special_request, bd.start_time, bd.end_time, "
				+ "       c.full_name AS caregiver_name, c.phone AS caregiver_phone " + "FROM bookings b "
				+ "JOIN booking_details bd ON b.booking_id = bd.booking_id "
				+ "JOIN service s ON bd.service_id = s.service_id "
				+ "LEFT JOIN caregiver c ON bd.caregiver_id = c.caregiver_id " + "WHERE b.customer_id = ? "
				+ "ORDER BY b.booking_date DESC, b.booking_id DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, customerId);
			try (ResultSet rs = ps.executeQuery()) {

				Map<Integer, List<BookingItem>> itemsByBooking = new LinkedHashMap<>();
				Map<Integer, BookingMeta> metaByBooking = new LinkedHashMap<>();

				while (rs.next()) {
					int bookingId = rs.getInt("booking_id");

					if (!metaByBooking.containsKey(bookingId)) {
						BookingMeta meta = new BookingMeta(rs.getTimestamp("booking_date"), rs.getInt("status"));
						metaByBooking.put(bookingId, meta);
					}

					int serviceId = rs.getInt("service_id");
					String serviceName = rs.getString("service_name");
					int qty = rs.getInt("quantity");
					double subtotal = rs.getDouble("subtotal");
					int caregiverStatus = rs.getInt("caregiver_status");

					String caregiverName = rs.getString("caregiver_name");
					String caregiverPhone = rs.getString("caregiver_phone");

					String specialRequest = rs.getString("special_request");
					Timestamp startTime = rs.getTimestamp("start_time");
					Timestamp endTime = rs.getTimestamp("end_time");

					// ✅ requires BookingItem to support startTime/endTime
					BookingItem item = new BookingItem(serviceId, serviceName, qty, subtotal, caregiverStatus,
							caregiverName, caregiverPhone, specialRequest, startTime, endTime);

					itemsByBooking.computeIfAbsent(bookingId, k -> new ArrayList<>()).add(item);
				}

				for (Integer bookingId : itemsByBooking.keySet()) {
					BookingMeta meta = metaByBooking.get(bookingId);
					List<BookingItem> items = itemsByBooking.get(bookingId);

					bookings.add(new Booking(bookingId, meta.getBookingDate(), meta.getStatus(), items));
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}

		return bookings;
	}

	private static class BookingMeta {
		private final Timestamp bookingDate;
		private final int status;

		BookingMeta(Timestamp bookingDate, int status) {
			this.bookingDate = bookingDate;
			this.status = status;
		}

		public Timestamp getBookingDate() {
			return bookingDate;
		}

		public int getStatus() {
			return status;
		}
	}

	// =========================
	// SECURITY CHECK
	// =========================
	public boolean bookingBelongsToCustomer(int bookingId, int customerId) {
		String sql = "SELECT 1 FROM bookings WHERE booking_id = ? AND customer_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, bookingId);
			ps.setInt(2, customerId);

			try (ResultSet rs = ps.executeQuery()) {
				return rs.next();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// =========================
	// CANCEL SERVICE (ONLY IF NOT ASSIGNED)
	// =========================
	public boolean cancelServiceIfNotAssigned(int bookingId, int serviceId) {
		String sql = "UPDATE booking_details " + "SET caregiver_status = 4, check_in_at = NULL, check_out_at = NULL "
				+ "WHERE booking_id = ? AND service_id = ? " + "  AND caregiver_status = 0 AND caregiver_id IS NULL";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, bookingId);
			ps.setInt(2, serviceId);

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// =========================
	// ✅ RESCHEDULE SERVICE ITEM (ONLY IF NOT ASSIGNED)
	// Updates:
	// - special_request (optional)
	// - start_time / end_time (keeps existing duration)
	// DOES NOT change price/subtotal/quantity (because already paid)
	// =========================
	public boolean rescheduleServiceIfNotAssigned(int bookingId, int serviceId, String specialRequest,
			LocalDateTime newStartDateTime) {

		String selectTimesSql = "SELECT start_time, end_time " + "FROM booking_details "
				+ "WHERE booking_id = ? AND service_id = ? " + "  AND caregiver_status = 0 AND caregiver_id IS NULL";

		String updateSql = "UPDATE booking_details " + "SET start_time = ?, end_time = ?, special_request = ? "
				+ "WHERE booking_id = ? AND service_id = ? " + "  AND caregiver_status = 0 AND caregiver_id IS NULL";

		try (Connection conn = DBConnection.getConnection()) {
			conn.setAutoCommit(false);

			Timestamp oldStart;
			Timestamp oldEnd;

			// 1) read existing duration
			try (PreparedStatement ps = conn.prepareStatement(selectTimesSql)) {
				ps.setInt(1, bookingId);
				ps.setInt(2, serviceId);

				try (ResultSet rs = ps.executeQuery()) {
					if (!rs.next()) {
						conn.rollback();
						return false; // not found OR already assigned
					}
					oldStart = rs.getTimestamp("start_time");
					oldEnd = rs.getTimestamp("end_time");
				}
			}

			if (oldStart == null || oldEnd == null) {
				conn.rollback();
				return false;
			}

			long diffMs = oldEnd.getTime() - oldStart.getTime();
			if (diffMs <= 0)
				diffMs = 60L * 60L * 1000L; // fallback 1 hour

			Timestamp newStart = Timestamp.valueOf(newStartDateTime);
			Timestamp newEnd = new Timestamp(newStart.getTime() + diffMs);

			// 2) update (no subtotal/qty changes)
			int rows;
			try (PreparedStatement ps = conn.prepareStatement(updateSql)) {
				ps.setTimestamp(1, newStart);
				ps.setTimestamp(2, newEnd);
				ps.setString(3,
						(specialRequest == null || specialRequest.trim().isEmpty()) ? null : specialRequest.trim());
				ps.setInt(4, bookingId);
				ps.setInt(5, serviceId);
				rows = ps.executeUpdate();
			}

			if (rows <= 0) {
				conn.rollback();
				return false;
			}

			conn.commit();
			return true;

		} catch (Exception e) {
			e.printStackTrace();
		}

		return false;
	}

	private double getServicePrice(int serviceId) {
		String sql = "SELECT price FROM service WHERE service_id = ?";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, serviceId);
			try (ResultSet rs = ps.executeQuery()) {
				if (rs.next())
					return rs.getDouble("price");
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
}
