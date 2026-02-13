package controller;
/*
 * Ong Jin Kai
 * 2429465
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.EmergencyContact.EmergencyContactDAO;

import java.io.IOException;

@WebServlet("/DeleteEmergencyContactServlet")
public class DeleteEmergencyContactServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("customer_id") == null) {
			response.sendRedirect(request.getContextPath() + "/categories");
			return;
		}

		int customerId = (int) session.getAttribute("customer_id");
		String idStr = request.getParameter("id");

		if (idStr == null) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=profile&success=No+contact+selected.");
			return;
		}

		try {
			int contactId = Integer.parseInt(idStr);

			EmergencyContactDAO dao = new EmergencyContactDAO();
			dao.deleteContact(contactId, customerId);

			response.sendRedirect(request.getContextPath() + "/profile?tab=profile&success=Emergency+contact+deleted!");
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=profile&success=Invalid+contact+id.");
		}
	}
}
