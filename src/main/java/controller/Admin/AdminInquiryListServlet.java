package controller.Admin;
/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.ServiceInquiry;
import model.ServiceInquiryDAO;

import java.io.IOException;
import java.util.List;

/**	
 * Servlet implementation class AdminInquiryListServlet
 */
@WebServlet("/admin/inquiries")
public class AdminInquiryListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AdminInquiryListServlet() {
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

		// role guard
		HttpSession session = request.getSession(false);
		if (session == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
			return;
		}

		String status = request.getParameter("status"); // NEW/READ/ARCHIVED
		String q = request.getParameter("q"); // name/email search

		ServiceInquiryDAO dao = new ServiceInquiryDAO();
		List<ServiceInquiry> list = dao.getAll(status, q);

		request.setAttribute("inquiries", list);
		request.setAttribute("status", status);
		request.setAttribute("q", q);

		request.getRequestDispatcher("/adminPage/adminInquiries.jsp").forward(request, response);

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
