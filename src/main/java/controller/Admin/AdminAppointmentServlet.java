package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import model.BookingDetailAppointment;
import model.BookingDetailAppointmentDAO;

@WebServlet("/admin/appointments")
public class AdminAppointmentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final BookingDetailAppointmentDAO dao = new BookingDetailAppointmentDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// OPTIONAL: simple admin guard (only enable if you have admin session
		// attribute)
		// HttpSession session = request.getSession(false);
		// if (session == null || session.getAttribute("admin") == null) {
		// response.sendRedirect(request.getContextPath() + "/adminLogin.jsp");
		// return;
		// }

		try {
			List<BookingDetailAppointment> items = dao.getAllAppointments();
			request.setAttribute("items", items);
			request.getRequestDispatcher("/appointmentManage/appointmentManagement.jsp").forward(request, response);
		} catch (SQLException e) {
			throw new ServletException(e);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null || action.isBlank()) {
			response.sendRedirect(request.getContextPath() + "/admin/appointments");
			return;
		}

		try {
			if ("status".equals(action)) {
				// from JSP: detailId + caregiverStatus
				int detailId = Integer.parseInt(request.getParameter("detailId"));
				int caregiverStatus = Integer.parseInt(request.getParameter("caregiverStatus"));

				dao.updateCaregiverStatus(detailId, caregiverStatus);

			} else if ("assign".equals(action)) {
				// from JSP: detailId + caregiverId
				int detailId = Integer.parseInt(request.getParameter("detailId"));
				int caregiverId = Integer.parseInt(request.getParameter("caregiverId"));

				dao.assignCaregiver(detailId, caregiverId);

			} else if ("cancel".equals(action)) {
				// from JSP: detailId
				int detailId = Integer.parseInt(request.getParameter("detailId"));

				dao.cancelAppointment(detailId);

			} else {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
				return;
			}

			// refresh list after update
			response.sendRedirect(request.getContextPath() + "/admin/appointments");

		} catch (SQLException | NumberFormatException e) {
			throw new ServletException(e);
		}
	}
}
