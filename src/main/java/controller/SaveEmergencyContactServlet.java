package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.EmergencyContact.EmergencyContactDAO;

import java.io.IOException;

@WebServlet("/SaveEmergencyContactServlet")
public class SaveEmergencyContactServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("customer_id") == null) {
			response.sendRedirect(request.getContextPath() + "/categories");
			return;
		}

		int customerId = (int) session.getAttribute("customer_id");

		String contactIdStr = request.getParameter("contact_id"); // empty => add
		String name = request.getParameter("contact_name");
		String relationship = request.getParameter("relationship");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");

		// basic sanitize
		if (name != null)
			name = name.trim();
		if (relationship != null)
			relationship = relationship.trim();
		if (phone != null)
			phone = phone.trim();
		if (email != null)
			email = email.trim();

		// minimal validation
		if (name == null || name.isEmpty() || phone == null || phone.isEmpty()) {
			response.sendRedirect(
					request.getContextPath() + "/profile?tab=profile&success=Please+fill+in+name+and+phone.");
			return;
		}

		// convert empty optional fields to null
		if (relationship != null && relationship.isEmpty())
			relationship = null;
		if (email != null && email.isEmpty())
			email = null;

		EmergencyContactDAO dao = new EmergencyContactDAO();

		// ADD
		if (contactIdStr == null || contactIdStr.trim().isEmpty()) {
			dao.addContact(customerId, name, relationship, phone, email);

			response.sendRedirect(request.getContextPath() + "/profile?tab=profile&success=Emergency+contact+added!");
			return;
		}

		// UPDATE
		try {
			int contactId = Integer.parseInt(contactIdStr);

			// IMPORTANT: update must check customerId (so cannot edit others)
			dao.updateContact(contactId, customerId, name, relationship, phone, email);

			response.sendRedirect(request.getContextPath() + "/profile?tab=profile&success=Emergency+contact+updated!");
		} catch (NumberFormatException e) {
			response.sendRedirect(request.getContextPath() + "/profile?tab=profile&success=Invalid+contact+id.");
		}
	}
}
