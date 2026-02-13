package controller.Caregiver;

/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.Bookings.BookingDetailsStatusDAO;
import model.Notification.NotificationDAO;

@WebServlet("/caregiver/checkin")
public class CaregiverCheckInServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final BookingDetailsStatusDAO dao = new BookingDetailsStatusDAO();

	// Processes POST requests to record a caregiver's check-in for a specific
	// booking detail
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Retrieves the authenticated caregiver ID from the session
		Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
		if (caregiverId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		int detailId = Integer.parseInt(request.getParameter("detailId"));
		boolean ok = dao.checkIn(detailId, caregiverId);
		if (ok) {
			// Retrieves customer information to send a notification upon successful
			// check-in
			Integer customerId = dao.getCustomerIdByDetailId(detailId);
			if (customerId != null) {
				String[] info = dao.getBookingInfoByDetailId(detailId);
				String bookingIdStr = (info != null) ? info[0] : null;
				String serviceName = (info != null) ? info[1] : null;
				String title = "Caregiver checked in!";
				String message;
				if (bookingIdStr != null && serviceName != null) {
					message = "Caregiver has checked in for " + serviceName + " (Booking #" + bookingIdStr + "). "
							+ "If this is not right please contact us at 97735798.";
				} else {
					message = "Caregiver has checked in! If this is not right please contact us at 97735798.";
				}

				Integer bookingId = null;
				if (bookingIdStr != null) {
					try {
						bookingId = Integer.parseInt(bookingIdStr);
					} catch (Exception ignore) {
					}
				}

				// Creates a notification for the customer to inform them of the check-in
				new NotificationDAO().create(customerId, bookingId, detailId, title, message);
			}
		}

		// Redirects to today's visits page after processing the check-in
		response.sendRedirect(request.getContextPath() + "/caregiver/visits?filter=today");
	}
}
