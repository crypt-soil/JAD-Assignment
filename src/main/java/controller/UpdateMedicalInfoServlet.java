package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.MedicalInfoDAO;

@WebServlet("/UpdateMedicalInfoServlet")
public class UpdateMedicalInfoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("customer_id") == null) {
			response.sendRedirect(request.getContextPath() + "/categories");
			return;
		}

		int customerId = (int) session.getAttribute("customer_id");

		// ✅ Checkboxes (multiple values)
		String[] conditionsArr = request.getParameterValues("conditions");

		// ✅ Allergies text
		String allergies = request.getParameter("allergies");
		if (allergies == null)
			allergies = "";
		allergies = allergies.trim();

		// ✅ Convert conditions array -> CSV (store the label values)
		String conditionsCsv = "";
		if (conditionsArr != null && conditionsArr.length > 0) {
			// keep original labels; join with comma
			conditionsCsv = String.join(",", conditionsArr).trim();
		}

		MedicalInfoDAO dao = new MedicalInfoDAO();
		dao.saveOrUpdate(customerId, conditionsCsv, allergies);

		response.sendRedirect(request.getContextPath() + "/profile?tab=profile&success=Medical+information+saved!");
	}
}
