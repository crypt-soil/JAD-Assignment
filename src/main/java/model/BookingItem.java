package model;

public class BookingItem {
	private int serviceId; 
	private String serviceName;
	private int quantity;
	private double subtotal;
	private int caregiverStatus;
	private String caregiverName;
	private String caregiverContact;

	public BookingItem(int serviceId, String serviceName, int quantity, double subtotal, int caregiverStatus,
			String caregiverName, String caregiverContact) {
		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.quantity = quantity;
		this.subtotal = subtotal;
		this.caregiverStatus = caregiverStatus;
		this.caregiverName = caregiverName;
		this.caregiverContact = caregiverContact;
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
}
