package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.Service.Service;
import model.Service.ServiceDAO;

/**
 * Handles displaying an individual service's details.
 *
 * URL Mapping: /serviceDetail
 *
 * Expected Request Parameter: id - (int) ID of the service to display.
 *
 * This servlet retrieves a single service using the given ID and forwards the
 * data to the service detail JSP page.
 */
@WebServlet("/serviceDetail")
public class ServiceDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// DAO used to load service data
	private ServiceDAO serviceDAO = new ServiceDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			// ============================================================
			// 1. PARSE SERVICE ID
			// ============================================================
			String idParam = request.getParameter("id");

			// Missing or invalid ID → redirect to error
			if (idParam == null || idParam.isEmpty()) {
				response.sendRedirect("error.jsp");
				return;
			}

			int id = Integer.parseInt(idParam);

			// ============================================================
			// 2. LOAD SERVICE FROM DATABASE
			// ============================================================
			Service service = serviceDAO.getServiceById(id);

			// If no such service exists, redirect to a generic error page
			if (service == null) {
				response.sendRedirect("error.jsp");
				return;
			}

			// ============================================================
			// 3. SEND SERVICE DATA TO JSP
			// ============================================================
			request.setAttribute("service", service);

			request.getRequestDispatcher("/serviceDetail/serviceDetail.jsp").forward(request, response);

		} catch (Exception e) {
			// Any parsing or DAO error → redirect to error page
			e.printStackTrace();
			response.sendRedirect("error.jsp");
		}
	}
}
