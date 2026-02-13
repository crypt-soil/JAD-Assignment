package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.registerModel;
import java.io.IOException;

/**
 * Handles user registration validation and processing.
 *
 * URL Mapping: /VerifyRegister
 *
 * Responsibilities: - Retrieve registration form fields - Validate password
 * entries - Delegate user creation to the model - Redirect back to registration
 * page with status messages
 */
@WebServlet("/VerifyRegister")
public class VerifyRegisterServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// ============================================================
		// 1. RETRIEVE FORM INPUTS
		// ============================================================
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String fullName = request.getParameter("fullName");
		String phoneNumber = request.getParameter("phoneNumber");
		String address = request.getParameter("address");
		String zipcode = request.getParameter("zipcode");
		String password = request.getParameter("password");
		String password2 = request.getParameter("password2");

		// ============================================================
		// 2. BASIC VALIDATION (PASSWORD MATCH)
		// ============================================================
		if (!password.equals(password2)) {
			// Redirect back with error message
			response.sendRedirect(request.getContextPath()
					+ "/registerPage/registerPage.jsp?message=error&reason=Passwords+do+not+match!");
			return;
		}

		// ============================================================
		// 3. INTERACT WITH MODEL (REGISTER USER)
		// ============================================================
		registerModel dao = new registerModel();
		boolean success = dao.registerUser(username, email, fullName, phoneNumber, address, zipcode, password);

		// ============================================================
		// 4. HANDLE REGISTRATION RESULT
		// ============================================================
		if (success) {
			// Registration successful
			response.sendRedirect(request.getContextPath() + "/registerPage/registerPage.jsp?message=success");
		} else {
			// Registration failed (e.g., DB error, duplicate email)
			response.sendRedirect(
					request.getContextPath() + "/registerPage/registerPage.jsp?message=error&reason=Database+error");
		}
	}
}
