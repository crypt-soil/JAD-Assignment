package model;

import java.sql.Timestamp;

public class BookingDetailStatus {
	private int detailId;
	private int caregiverStatus; // 0,1,2
	private Timestamp checkInTime;
	private Timestamp checkOutTime;
	private Timestamp updatedAt;

	public int getDetailId() {
		return detailId;
	}

	public void setDetailId(int detailId) {
		this.detailId = detailId;
	}

	public int getCaregiverStatus() {
		return caregiverStatus;
	}

	public void setCaregiverStatus(int caregiverStatus) {
		this.caregiverStatus = caregiverStatus;
	}

	public Timestamp getCheckInTime() {
		return checkInTime;
	}

	public void setCheckInTime(Timestamp checkInTime) {
		this.checkInTime = checkInTime;
	}

	public Timestamp getCheckOutTime() {
		return checkOutTime;
	}

	public void setCheckOutTime(Timestamp checkOutTime) {
		this.checkOutTime = checkOutTime;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}
}
