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
import model.Service.ServiceInquiryDAO;

import java.io.IOException;

/**
 * Servlet implementation class AdminInquiryStatusServlet
 */
@WebServlet("/admin/inquiries/status")
public class AdminInquiryStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AdminInquiryStatusServlet() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession(false);
		if (session == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendError(403);
			return;
		}

		int id = Integer.parseInt(request.getParameter("id"));
		String status = request.getParameter("status"); // READ/ARCHIVED

		if (!"READ".equals(status) && !"ARCHIVED".equals(status) && !"NEW".equals(status)) {
			status = "READ";
		}

		new ServiceInquiryDAO().updateStatus(id, status);
		String auto = "READ".equals(status) ? "&auto=1" : "";
		response.sendRedirect(request.getContextPath() + "/admin/inquiries/view?id=" + id + auto);
	}
}
