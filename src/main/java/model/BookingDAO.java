package model;

import java.sql.*;
import java.util.*;

public class BookingDAO {

	public List<Booking> getBookingsByCustomerId(int customerId) {
		List<Booking> bookings = new ArrayList<>();

		String sql = "SELECT b.booking_id, b.booking_date, b.status, "
				+ "       bd.service_id, s.name AS service_name, bd.quantity, bd.subtotal, bd.caregiver_status, "
				+ "       c.full_name AS caregiver_name, c.phone AS caregiver_phone " + "FROM bookings b "
				+ "JOIN booking_details bd ON b.booking_id = bd.booking_id "
				+ "JOIN service s ON bd.service_id = s.service_id "
				+ "LEFT JOIN caregiver c ON bd.caregiver_id = c.caregiver_id " + "WHERE b.customer_id = ? "
				+ "ORDER BY b.booking_date DESC, b.booking_id DESC";

		try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, customerId);
			ResultSet rs = ps.executeQuery();

			Map<Integer, List<BookingItem>> itemsByBooking = new LinkedHashMap<>();
			Map<Integer, BookingMeta> metaByBooking = new LinkedHashMap<>();

			while (rs.next()) {

				int bookingId = rs.getInt("booking_id");

				// meta (date & status) – only set once per booking
				if (!metaByBooking.containsKey(bookingId)) {
					BookingMeta meta = new BookingMeta(rs.getTimestamp("booking_date"), rs.getInt("status"));
					metaByBooking.put(bookingId, meta);
				}

				// ✅ collect items (NOW includes serviceId)
				int serviceId = rs.getInt("service_id"); // ✅ NEW
				String serviceName = rs.getString("service_name");
				int qty = rs.getInt("quantity");
				double subtotal = rs.getDouble("subtotal");
				int caregiverStatus = rs.getInt("caregiver_status");

				String caregiverName = rs.getString("caregiver_name");
				String caregiverPhone = rs.getString("caregiver_phone");

				// ✅ NEW constructor (serviceId first)
				BookingItem item = new BookingItem(serviceId, serviceName, qty, subtotal, caregiverStatus,
						caregiverName, caregiverPhone);

				itemsByBooking.computeIfAbsent(bookingId, k -> new ArrayList<>()).add(item);
			}

			// build Booking objects
			for (Integer bookingId : itemsByBooking.keySet()) {
				BookingMeta meta = metaByBooking.get(bookingId);
				List<BookingItem> items = itemsByBooking.get(bookingId);

				Booking booking = new Booking(bookingId, meta.getBookingDate(), meta.getStatus(), items);
				bookings.add(booking);
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
}
