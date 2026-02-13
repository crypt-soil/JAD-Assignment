package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Profile.Profile;
import model.Profile.ProfileDAO;

import java.io.IOException;

/**
 * Servlet implementation class UpdateProfileServlet
 */
@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public UpdateProfileServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
//		doGet(request, response);
		HttpSession session = request.getSession(false);
		int id = (int) session.getAttribute("customer_id");

		ProfileDAO dao = new ProfileDAO();
		Profile old = dao.getProfileById(id); // get original values

		String full = request.getParameter("full_name");
		String phone = request.getParameter("phone");
		String addr = request.getParameter("address");
		String zip = request.getParameter("zipcode");

		// if a field is empty, keep old value
		if (full == null || full.trim().isEmpty())
			full = old.getFullName();
		if (phone == null || phone.trim().isEmpty())
			phone = old.getPhone();
		if (addr == null || addr.trim().isEmpty())
			addr = old.getAddress();
		if (zip == null || zip.trim().isEmpty())
			zip = old.getZipcode();

		dao.updateAllFields(id, full, phone, addr, zip);

		response.sendRedirect(request.getContextPath() + "/profile?success=Successfully+saved+profile+changes!");

	}

}
