package controller.Caregiver;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;
import java.util.List;

import model.caregiver.CaregiverDAO;
import model.caregiver.CaregiverRequestDAO;
import model.caregiver.CaregiverVisit;

@WebServlet("/caregiver/requests")
public class CaregiverRequestsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CaregiverRequestDAO requestDAO = new CaregiverRequestDAO();
	private final CaregiverDAO caregiverDAO = new CaregiverDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
		if (caregiverId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		List<CaregiverVisit> requests = requestDAO.getOpenRequests(caregiverId);

		request.setAttribute("requests", requests);
		request.setAttribute("caregiverName", caregiverDAO.getCaregiverNameById(caregiverId));

		request.getRequestDispatcher("/caregiverPage/caregiverRequests.jsp").forward(request, response);
	}
}
