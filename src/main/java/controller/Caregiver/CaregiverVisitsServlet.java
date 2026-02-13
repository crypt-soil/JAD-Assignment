package controller.Caregiver;
/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;
import java.util.List;

import model.caregiver.CaregiverDAO;
import model.caregiver.CaregiverVisit;
import model.caregiver.CaregiverVisitDAO;

@WebServlet("/caregiver/visits")
public class CaregiverVisitsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CaregiverVisitDAO visitDAO = new CaregiverVisitDAO();
	private final CaregiverDAO caregiverDAO = new CaregiverDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
		if (caregiverId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		String filter = request.getParameter("filter");
		if (filter == null || filter.isBlank())
			filter = "today";

		List<CaregiverVisit> visits = visitDAO.getVisits(caregiverId, filter);

		request.setAttribute("filter", filter);
		request.setAttribute("visits", visits);
		request.setAttribute("caregiverName", caregiverDAO.getCaregiverNameById(caregiverId));

		request.getRequestDispatcher("/caregiverPage/caregiverVisits.jsp").forward(request, response);
	}
}
