package controller.Caregiver;
/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.caregiver.CaregiverDAO;

import java.io.IOException;

/**
 * Servlet implementation class CaregiverHomeServlet
 */
@WebServlet("/caregiver/home")
public class CaregiverHomeServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final CaregiverDAO caregiverDAO = new CaregiverDAO();

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CaregiverHomeServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
		if (caregiverId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		String caregiverName = caregiverDAO.getCaregiverNameById(caregiverId);
		request.setAttribute("caregiverName", caregiverName);

		request.getRequestDispatcher("/caregiverPage/caregiverHomePage.jsp").forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
