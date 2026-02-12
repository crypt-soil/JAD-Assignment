package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.BookingDetailsStatusDAO;
import model.CaregiverRequestDAO;
import model.NotificationDAO;

@WebServlet("/caregiver/accept")
public class CaregiverAcceptServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CaregiverRequestDAO requestDAO = new CaregiverRequestDAO();

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Caregiver guard
		Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
		if (caregiverId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		// Validate detailId
		int detailId;
		try {
			detailId = Integer.parseInt(request.getParameter("detailId"));
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=invalid_request");
			return;
		}

		// Attempt accept
		CaregiverRequestDAO.AcceptResult result;
		try {
			result = requestDAO.acceptRequest(detailId, caregiverId);
		} catch (Exception e) {
			response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=database_error");
			return;
		}

		// Route based on DAO result
		switch (result) {
		case OK: {
			// Create customer notification when accept succeeds
			Integer customerId = new BookingDetailsStatusDAO().getCustomerIdByDetailId(detailId);
			if (customerId != null) {
				new NotificationDAO().create(customerId, null, detailId, "Request accepted",
						"A caregiver has accepted your booking request! You can view the booking details in your profile.");
			}

			response.sendRedirect(request.getContextPath() + "/caregiver/requests?success=accepted");
			return;
		}

		case NOT_FOUND:
			response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=request_not_found");
			return;

		case ALREADY_TAKEN:
			response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=already_taken");
			return;

		case TIME_CONFLICT:
			response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=time_conflict");
			return;

		default:
			response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=unknown_error");
			return;
		}
	}
}
