package controller;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Bookings.BookingDAO;

@WebServlet("/UpdateBookingItemServlet")
public class UpdateBookingItemServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("customer_id") == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		int customerId = (int) session.getAttribute("customer_id");

		int bookingId = parseIntSafe(request.getParameter("bookingId"));
		int serviceId = parseIntSafe(request.getParameter("serviceId"));
		String specialRequest = request.getParameter("specialRequest");

		// ✅ Date + Hour (hour-only)
		String serviceDateStr = request.getParameter("serviceDate"); // yyyy-MM-dd
		int serviceHour = parseIntSafe(request.getParameter("serviceHour")); // 0..23

		if (bookingId <= 0 || serviceId <= 0) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=Invalid+input");
			return;
		}

		LocalDate serviceDate = parseLocalDateSafe(serviceDateStr);
		if (serviceDate == null) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=Invalid+date");
			return;
		}

		if (serviceHour < 0 || serviceHour > 23) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=Invalid+time");
			return;
		}

		// Force minutes = 00 (hour-only)
		LocalTime serviceTime = LocalTime.of(serviceHour, 0);
		LocalDateTime newStartDateTime = LocalDateTime.of(serviceDate, serviceTime);

		// Optional: prevent past scheduling
		if (newStartDateTime.isBefore(LocalDateTime.now())) {
			response.sendRedirect(
					request.getContextPath() + "/profile?tab=bookings&success=Date+time+cannot+be+in+the+past");
			return;
		}

		BookingDAO dao = new BookingDAO();

		// ✅ security check
		if (!dao.bookingBelongsToCustomer(bookingId, customerId)) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=bookings&success=Unauthorized");
			return;
		}

		// ✅ Reschedule ONLY (duration stays same, no qty/subtotal changes)
		boolean ok = dao.rescheduleServiceIfNotAssigned(bookingId, serviceId, specialRequest, newStartDateTime);

		if (ok) {
			response.sendRedirect(
					request.getContextPath() + "/profile?tab=bookings&success=Service+rescheduled+successfully");
		} else {
			response.sendRedirect(request.getContextPath()
					+ "/profile?tab=bookings&success=Update+failed+(service+may+already+be+assigned)");
		}
	}

	private int parseIntSafe(String s) {
		try {
			return Integer.parseInt(s);
		} catch (Exception e) {
			return -1;
		}
	}

	private LocalDate parseLocalDateSafe(String s) {
		try {
			return LocalDate.parse(s);
		} catch (Exception e) {
			return null;
		}
	}
}
