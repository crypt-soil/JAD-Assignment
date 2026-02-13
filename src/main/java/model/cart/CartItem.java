package model.cart;

import java.sql.Timestamp;
import java.time.Duration;
import java.time.LocalDateTime;

/*
 * Lois Poh
 * 2429478
 */
public class CartItem {
	private int itemId;
	private int serviceId;
	private String serviceName;

	// Treat this as HOURLY RATE now
	private double price;

	private int quantity;

	private Timestamp startTime;
	private Timestamp endTime;

	private Integer caregiverId; // nullable
	private String specialRequest; // nullable

	public CartItem(int itemId, int serviceId, String serviceName, double price, int quantity, Timestamp startTime,
			Timestamp endTime, Integer caregiverId, String specialRequest) {
		this.itemId = itemId;
		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.price = price;
		this.quantity = quantity;
		this.startTime = startTime;
		this.endTime = endTime;
		this.caregiverId = caregiverId;
		this.specialRequest = specialRequest;
	}

	public int getItemId() {
		return itemId;
	}

	public int getServiceId() {
		return serviceId;
	}

	public String getServiceName() {
		return serviceName;
	}

	/** Hourly rate */
	public double getPrice() {
		return price;
	}

	public int getQuantity() {
		return quantity;
	}

	public Timestamp getStartTime() {
		return startTime;
	}

	public Timestamp getEndTime() {
		return endTime;
	}

	public Integer getCaregiverId() {
		return caregiverId;
	}

	public String getSpecialRequest() {
		return specialRequest;
	}

	/**
	 * NEW: Duration in whole hours (minimum 1 hour). Computed from end_time -
	 * start_time.
	 */
	public int getDurationHours() {
		if (startTime == null || endTime == null)
			return 1;

		LocalDateTime s = startTime.toLocalDateTime();
		LocalDateTime e = endTime.toLocalDateTime();

		long minutes = Duration.between(s, e).toMinutes();
		long hours = minutes / 60;

		if (hours < 1)
			hours = 1;

		return (int) hours;
	}

	/**
	 * UPDATED: Line total = hourly rate × duration(hours) × quantity
	 */
	public double getLineTotal() {
		return price * getDurationHours() * quantity;
	}
}
