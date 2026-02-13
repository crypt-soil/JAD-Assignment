package model.caregiver;
/*
 * Lois Poh 
 * 2429478
 */
import java.sql.Timestamp;

public class CaregiverVisit {
	private int detailId;
	private int bookingId;
	private String serviceName;
	private String customerName;
	private String customerAddress;
	private Timestamp startTime;
	private Timestamp endTime;
	private String specialRequest;
	private int caregiverStatus; // 0,1,2
	private Timestamp checkInAt;
	private Timestamp checkOutAt;

	public int getDetailId() {
		return detailId;
	}

	public void setDetailId(int detailId) {
		this.detailId = detailId;
	}

	public int getBookingId() {
		return bookingId;
	}

	public void setBookingId(int bookingId) {
		this.bookingId = bookingId;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getCustomerAddress() {
		return customerAddress;
	}

	public void setCustomerAddress(String customerAddress) {
		this.customerAddress = customerAddress;
	}

	public Timestamp getStartTime() {
		return startTime;
	}

	public void setStartTime(Timestamp startTime) {
		this.startTime = startTime;
	}

	public Timestamp getEndTime() {
		return endTime;
	}

	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}

	public String getSpecialRequest() {
		return specialRequest;
	}

	public void setSpecialRequest(String specialRequest) {
		this.specialRequest = specialRequest;
	}

	public int getCaregiverStatus() {
		return caregiverStatus;
	}

	public void setCaregiverStatus(int caregiverStatus) {
		this.caregiverStatus = caregiverStatus;
	}

	public Timestamp getCheckInAt() {
		return checkInAt;
	}

	public void setCheckInAt(Timestamp checkInAt) {
		this.checkInAt = checkInAt;
	}

	public Timestamp getCheckOutAt() {
		return checkOutAt;
	}

	public void setCheckOutAt(Timestamp checkOutAt) {
		this.checkOutAt = checkOutAt;
	}
}
