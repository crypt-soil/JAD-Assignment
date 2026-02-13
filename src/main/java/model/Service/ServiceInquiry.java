package model.Service;
/*
 * Lois Poh
 * 2429478
 */
public class ServiceInquiry {

	private Integer inquiryId;
	private Integer customerId;
	private Integer serviceId;
	private Integer caregiverId;

	private String name;
	private String email;
	private String category;
	private String message;

	private String preferredContact; // EMAIL / PHONE
	private String phone;
	private String status;
	private java.sql.Timestamp createdAt;

	// for admin
	private String serviceName;

	private String caregiverName;

	// ===== Getters & Setters =====

	public Integer getInquiryId() {
		return inquiryId;
	}

	public void setInquiryId(Integer inquiryId) {
		this.inquiryId = inquiryId;
	}

	public Integer getCustomerId() {
		return customerId;
	}

	public void setCustomerId(Integer customerId) {
		this.customerId = customerId;
	}

	public Integer getServiceId() {
		return serviceId;
	}

	public void setServiceId(Integer serviceId) {
		this.serviceId = serviceId;
	}

	public Integer getCaregiverId() {
		return caregiverId;
	}

	public void setCaregiverId(Integer caregiverId) {
		this.caregiverId = caregiverId;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getCategory() {
		return category;
	}

	public void setCategory(String category) {
		this.category = category;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getPreferredContact() {
		return preferredContact;
	}

	public void setPreferredContact(String preferredContact) {
		this.preferredContact = preferredContact;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public java.sql.Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(java.sql.Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	public String getCaregiverName() {
		return caregiverName;
	}

	public void setCaregiverName(String caregiverName) {
		this.caregiverName = caregiverName;
	}

}
