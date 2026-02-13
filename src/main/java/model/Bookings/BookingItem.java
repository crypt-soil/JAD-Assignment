package model.Bookings;
import java.sql.Timestamp;

public class BookingItem {
	private int serviceId;
	private String serviceName;
	private int quantity;
	private double subtotal;
	private int caregiverStatus;
	private String caregiverName;
	private String caregiverContact;
	private String specialRequest;

	// ✅ NEW: service-level timing
	private Timestamp startTime;
	private Timestamp endTime;

	// ✅ old style constructor (keeps old DAOs working)
	public BookingItem(int serviceId, String serviceName, int quantity, double subtotal, int caregiverStatus,
			String caregiverName, String caregiverContact) {
		this(serviceId, serviceName, quantity, subtotal, caregiverStatus, caregiverName, caregiverContact, null, null,
				null);
	}

	// ✅ old "new style" constructor (keeps your current DAO call working)
	public BookingItem(int serviceId, String serviceName, int quantity, double subtotal, int caregiverStatus,
			String caregiverName, String caregiverContact, String specialRequest) {
		this(serviceId, serviceName, quantity, subtotal, caregiverStatus, caregiverName, caregiverContact,
				specialRequest, null, null);
	}

	// ✅ NEW: full constructor with time fields
	public BookingItem(int serviceId, String serviceName, int quantity, double subtotal, int caregiverStatus,
			String caregiverName, String caregiverContact, String specialRequest, Timestamp startTime,
			Timestamp endTime) {

		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.quantity = quantity;
		this.subtotal = subtotal;
		this.caregiverStatus = caregiverStatus;
		this.caregiverName = caregiverName;
		this.caregiverContact = caregiverContact;
		this.specialRequest = specialRequest;
		this.startTime = startTime;
		this.endTime = endTime;
	}

	public int getServiceId() {
		return serviceId;
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

	public int getCaregiverStatus() {
		return caregiverStatus;
	}

	public String getCaregiverName() {
		return caregiverName;
	}

	public String getCaregiverContact() {
		return caregiverContact;
	}

	public String getSpecialRequest() {
		return specialRequest;
	}

	// ✅ NEW getters
	public Timestamp getStartTime() {
		return startTime;
	}

	public Timestamp getEndTime() {
		return endTime;
	}
}
