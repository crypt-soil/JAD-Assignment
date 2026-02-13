package model.Feedback;
/*
 * Ong Jin Kai
 * 2429465
 */
public class FeedbackView {
	private int feedbackId;
	private int bookingId;
	private int serviceId;

	private String serviceName;
	private String caregiverName;

	private int serviceRating;
	private int caregiverRating;

	private String serviceRemarks;
	private String caregiverRemarks;

	public FeedbackView(int feedbackId, int bookingId, int serviceId, String serviceName, String caregiverName,
			int serviceRating, int caregiverRating, String serviceRemarks, String caregiverRemarks) {
		this.feedbackId = feedbackId;
		this.bookingId = bookingId;
		this.serviceId = serviceId;
		this.serviceName = serviceName;
		this.caregiverName = caregiverName;
		this.serviceRating = serviceRating;
		this.caregiverRating = caregiverRating;
		this.serviceRemarks = serviceRemarks;
		this.caregiverRemarks = caregiverRemarks;
	}

	public int getFeedbackId() {
		return feedbackId;
	}

	public int getBookingId() {
		return bookingId;
	}

	public int getServiceId() {
		return serviceId;
	}

	public String getServiceName() {
		return serviceName;
	}

	public String getCaregiverName() {
		return caregiverName;
	}

	public int getServiceRating() {
		return serviceRating;
	}

	public int getCaregiverRating() {
		return caregiverRating;
	}

	public String getServiceRemarks() {
		return serviceRemarks;
	}

	public String getCaregiverRemarks() {
		return caregiverRemarks;
	}
}
