package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get the existing session (do not create a new one)
		HttpSession session = request.getSession(false);

		if (session != null) {
			// remove all attributes
			session.removeAttribute("role");
			session.removeAttribute("username");
			session.removeAttribute("customer_id");
			session.invalidate(); // destroys session completely
		}

		// Redirect user back to home page
		response.sendRedirect(request.getContextPath() + "/categories");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}
