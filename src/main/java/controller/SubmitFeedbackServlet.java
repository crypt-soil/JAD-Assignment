package controller;

import java.io.IOException;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.FeedbackDAO;

@WebServlet("/SubmitFeedbackServlet")
public class SubmitFeedbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final FeedbackDAO feedbackDAO = new FeedbackDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		String bookingIdStr = request.getParameter("booking_id");
		String serviceIdStr = request.getParameter("service_id");

		String caregiverRatingStr = request.getParameter("caregiver_rating");
		String serviceRatingStr = request.getParameter("service_rating");

		String caregiverRemarks = request.getParameter("caregiver_remarks");
		String serviceRemarks = request.getParameter("service_remarks");

		// Required checks
		if (isBlank(bookingIdStr) || isBlank(serviceIdStr) || isBlank(caregiverRatingStr) || isBlank(serviceRatingStr)
				|| isBlank(caregiverRemarks) || isBlank(serviceRemarks)) {

			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=Please+fill+in+all+fields");
			return;
		}

		int bookingId, serviceId, caregiverRating, serviceRating;

		try {
			bookingId = Integer.parseInt(bookingIdStr);
			serviceId = Integer.parseInt(serviceIdStr);
			caregiverRating = Integer.parseInt(caregiverRatingStr);
			serviceRating = Integer.parseInt(serviceRatingStr);
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=Invalid+input");
			return;
		}

		// rating range check
		if (!inRange1to5(caregiverRating) || !inRange1to5(serviceRating)) {
			response.sendRedirect(
					request.getContextPath() + "/profile?tab=bookings&error=Ratings+must+be+between+1+and+5");
			return;
		}

		try {
			feedbackDAO.insertFeedbackAndUpdateRatings(bookingId, serviceId, caregiverRating, serviceRating,
					caregiverRemarks.trim(), serviceRemarks.trim());

			response.sendRedirect(
					request.getContextPath() + "/profile?tab=bookings&success=Feedback+submitted+successfully");

		} catch (SQLException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&error=Database+error");
		}
	}

	private boolean isBlank(String s) {
		return s == null || s.trim().isEmpty();
	}

	private boolean inRange1to5(int x) {
		return x >= 1 && x <= 5;
	}
}
