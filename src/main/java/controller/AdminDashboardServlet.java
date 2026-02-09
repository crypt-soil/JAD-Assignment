package controller;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.AdminDashboardDAO;

@WebServlet("/admin/analytics")
public class AdminDashboardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final AdminDashboardDAO dao = new AdminDashboardDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// ✅ ADMIN GUARD
		HttpSession session = request.getSession(false);
		String role = (session != null) ? (String) session.getAttribute("role") : null;

		if (!"admin".equals(role)) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
			return;
		}

		// ✅ filter param (sanitize)
		String range = request.getParameter("range");
		if (range == null)
			range = "year";
		if (!range.equals("week") && !range.equals("month") && !range.equals("year")) {
			range = "year";
		}

		int limit = 5;

		try {
			// metrics
			request.setAttribute("totalUsers", dao.getTotalUsers());
			request.setAttribute("popularService", dao.getPopularService());
			request.setAttribute("revenue", dao.getRevenue(range));
			request.setAttribute("range", range);

			// rankings
			request.setAttribute("topCaregivers", dao.getTopCaregivers(limit));
			request.setAttribute("worstCaregivers", dao.getWorstCaregivers(limit));
			request.setAttribute("topServices", dao.getTopServicesByFeedback(limit));
			request.setAttribute("worstServices", dao.getWorstServicesByFeedback(limit));

			// ✅ NEW: demand/availability lists
			request.setAttribute("highDemandServices", dao.getHighDemandServices(range, limit));
			request.setAttribute("lowAvailabilityServices", dao.getLowAvailabilityServices(range, limit));

			request.getRequestDispatcher("/adminPage/analyticsDashboard.jsp").forward(request, response);

		} catch (Exception e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/admin/analytics?error=Database+error");
		}
	}
}
