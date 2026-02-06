package model;

import java.sql.Timestamp;
import java.util.List;

public class Booking {
	private int bookingId;
	private Timestamp bookingDate;
	private int status;
	private List<BookingItem> items;

	public Booking(int bookingId, Timestamp bookingDate, int status, List<BookingItem> items) {
		this.bookingId = bookingId;
		this.bookingDate = bookingDate;
		this.status = status;
		this.items = items;
	}

	public int getBookingId() {
		return bookingId;
	}

	public Timestamp getBookingDate() {
		return bookingDate;
	}

	public int getStatus() {
		return status;
	}

	public List<BookingItem> getItems() {
		return items;
	}

	public double getTotalAmount() {
		double total = 0;
		if (items != null) {
			for (BookingItem item : items) {
				total += item.getSubtotal();
			}
		}
		return total;
	}
}
