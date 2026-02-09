package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.FeedbackDAO;
import model.FeedbackView;

@WebServlet("/viewFeedback")
public class ViewFeedbackServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final FeedbackDAO feedbackDAO = new FeedbackDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		String role = (session != null) ? (String) session.getAttribute("role") : null;

		// ✅ ADMIN ONLY
		if (!"admin".equals(role)) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
			return;
		}

		try {
			// ✅ Admin should see ALL feedback
			List<FeedbackView> feedbackList = feedbackDAO.getAllFeedback();
			request.setAttribute("feedbackList", feedbackList);
			request.getRequestDispatcher("/adminPage/viewFeedback.jsp").forward(request, response);

		} catch (SQLException e) {
			e.printStackTrace();
			response.sendRedirect(request.getContextPath() + "/viewFeedback?error=Database+error");
		}
	}
}
