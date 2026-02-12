package controller.Caregiver;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.caregiver.CaregiverUser;
import model.caregiver.CaregiverUserDAO;

import java.io.IOException;

/**
 * Servlet implementation class CaregiverLoginServlet
 */
@WebServlet("/CaregiverLoginServlet")
public class CaregiverLoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final CaregiverUserDAO caregiverUserDAO = new CaregiverUserDAO();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CaregiverLoginServlet() {
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
		response.sendRedirect(request.getContextPath() + "/caregiverPage/caregiverHomePage.jsp");
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String username = request.getParameter("username");
		String password = request.getParameter("password");

		CaregiverUser user = caregiverUserDAO.login(username, password);

		if (user == null) {
			request.setAttribute("errorMsg", "Invalid caregiver username or password.");
			request.getRequestDispatcher("/loginPage/login.jsp").forward(request, response);
			return;
		}

		HttpSession session = request.getSession();
		session.setAttribute("caregiver_id", user.getCaregiverId());
		session.setAttribute("caregiver_username", user.getUsername());

		response.sendRedirect(request.getContextPath() + "/caregiverPage/caregiverHomePage.jsp");
	}

}
