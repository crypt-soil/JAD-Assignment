package controller.Caregiver;

/*
 * Ong Jin Kai
 * 2429465
 */
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Bookings.BookingDAO;

@WebServlet("/CancelBookingItemServlet")
public class CancelBookingItemServlet extends HttpServlet {

	// Processes GET requests to cancel a specific service within a customer's
	// booking
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Retrieves the authenticated customer ID from the session
		Integer customerId = (Integer) request.getSession().getAttribute("customer_id");

		// Redirects to login if no valid session is found
		if (customerId == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

		// Extracts booking ID and service ID from request parameters
		String bookingIdStr = request.getParameter("bookingId");
		String serviceIdStr = request.getParameter("serviceId");

		try {
			int bookingId = Integer.parseInt(bookingIdStr);
			int serviceId = Integer.parseInt(serviceIdStr);

			BookingDAO dao = new BookingDAO();

			// Security: only allow cancel if booking belongs to customer
			if (!dao.bookingBelongsToCustomer(bookingId, customerId)) {
				response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=Unauthorized");
				return;
			}

			// Attempts to cancel the service only if no caregiver has been assigned
			boolean ok = dao.cancelServiceIfNotAssigned(bookingId, serviceId);

			// Redirects with appropriate status message based on cancellation outcome
			if (ok) {
				response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=Service cancelled");
			} else {
				response.sendRedirect(request.getContextPath()
						+ "/profile?tab=bookings&success=Cannot cancel (already assigned or started)");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=Error cancelling service");
		}
	}
}
