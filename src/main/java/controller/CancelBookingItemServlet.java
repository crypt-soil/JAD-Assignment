package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import model.BookingDAO;

@WebServlet("/CancelBookingItemServlet")
public class CancelBookingItemServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer customerId = (Integer) request.getSession().getAttribute("customer_id");

		if (customerId == null) {
			response.sendRedirect(request.getContextPath() + "/login.jsp");
			return;
		}

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

			boolean ok = dao.cancelServiceIfNotAssigned(bookingId, serviceId);

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
