package controller.Caregiver;
/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.BookingDetailsStatusDAO;
import model.NotificationDAO;

@WebServlet("/caregiver/checkout")
public class CaregiverCheckOutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final BookingDetailsStatusDAO dao = new BookingDetailsStatusDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
		if (caregiverId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		int detailId = Integer.parseInt(request.getParameter("detailId"));
		boolean ok = dao.checkOut(detailId, caregiverId);

		if (ok) {
			Integer customerId = dao.getCustomerIdByDetailId(detailId);
			if (customerId != null) {

				String[] info = dao.getBookingInfoByDetailId(detailId);
				String bookingIdStr = (info != null) ? info[0] : null;
				String serviceName = (info != null) ? info[1] : null;

				String title = "Caregiver checked out!";
				String message;

				if (bookingIdStr != null && serviceName != null) {
					message = "Caregiver has checked out for " + serviceName + " (Booking #" + bookingIdStr + "). "
							+ "If this is not right please contact us at 97735798.";
				} else {
					message = "Caregiver has checked out! If this is not right please contact us at 97735798.";
				}

				Integer bookingId = null;
				if (bookingIdStr != null) {
					try {
						bookingId = Integer.parseInt(bookingIdStr);
					} catch (Exception ignore) {
					}
				}

				new NotificationDAO().create(customerId, bookingId, detailId, title, message);
			}
		}

		response.sendRedirect(request.getContextPath() + "/caregiver/visits?filter=today");
	}
}
