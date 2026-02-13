package model.Bookings;
/*
 * Ong Jin Kai
 * 2429465
 */
import java.sql.Timestamp;

public class BookingDetailAppointment {
	private int detailId;
	private int bookingId;

	private int customerId;
	private String customerName;
	private String customerPhone;

	private String serviceName;
	private int quantity;
	private double subtotal;

	private Integer caregiverId;
	private String caregiverName;
	private String caregiverContact;

	private Timestamp startTime;
	private Timestamp endTime;
	private String specialRequest;

	private int caregiverStatus;
	private Timestamp checkInAt;
	private Timestamp checkOutAt;

	private int bookingStatus;
	private Timestamp bookingDate;

	public BookingDetailAppointment(int detailId, int bookingId, int customerId, String customerName,
			String customerPhone, String serviceName, int quantity, double subtotal, Integer caregiverId,
			String caregiverName, String caregiverContact, Timestamp startTime, Timestamp endTime,
			String specialRequest, int caregiverStatus, Timestamp checkInAt, Timestamp checkOutAt, int bookingStatus,
			Timestamp bookingDate) {

		this.detailId = detailId;
		this.bookingId = bookingId;
		this.customerId = customerId;
		this.customerName = customerName;
		this.customerPhone = customerPhone;
		this.serviceName = serviceName;
		this.quantity = quantity;
		this.subtotal = subtotal;
		this.caregiverId = caregiverId;
		this.caregiverName = caregiverName;
		this.caregiverContact = caregiverContact;
		this.startTime = startTime;
		this.endTime = endTime;
		this.specialRequest = specialRequest;
		this.caregiverStatus = caregiverStatus;
		this.checkInAt = checkInAt;
		this.checkOutAt = checkOutAt;
		this.bookingStatus = bookingStatus;
		this.bookingDate = bookingDate;
	}

	public int getDetailId() {
		return detailId;
	}

	public int getBookingId() {
		return bookingId;
	}

	public int getCustomerId() {
		return customerId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public String getCustomerPhone() {
		return customerPhone;
	}

	public String getServiceName() {
		return serviceName;
	}

	public int getQuantity() {
		return quantity;
	}

	public double getSubtotal() {
		return subtotal;
	}

	public Integer getCaregiverId() {
		return caregiverId;
	}

	public String getCaregiverName() {
		return caregiverName;
	}

	public String getCaregiverContact() {
		return caregiverContact;
	}

	public Timestamp getStartTime() {
		return startTime;
	}

	public Timestamp getEndTime() {
		return endTime;
	}

	public String getSpecialRequest() {
		return specialRequest;
	}

	public int getCaregiverStatus() {
		return caregiverStatus;
	}

	public Timestamp getCheckInAt() {
		return checkInAt;
	}

	public Timestamp getCheckOutAt() {
		return checkOutAt;
	}

	public int getBookingStatus() {
		return bookingStatus;
	}

	public Timestamp getBookingDate() {
		return bookingDate;
	}
}
