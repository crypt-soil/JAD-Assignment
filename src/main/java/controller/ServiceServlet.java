package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.ServiceDAO;
import model.Service;
import model.CategoryDAO;
import model.Category;

@WebServlet("/service")
public class ServiceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ServiceDAO serviceDAO = new ServiceDAO();
	private CategoryDAO categoryDAO = new CategoryDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null)
			action = "list";

		switch (action) {

		// ============================
		// ADD SERVICE FORM
		// ============================
		case "add":
			int catId = Integer.parseInt(request.getParameter("catId"));
			Category category = categoryDAO.getCategoryById(catId);

			request.setAttribute("category", category);
			request.getRequestDispatcher("/service/serviceAdd.jsp").forward(request, response);
			break;

		// ============================
		// EDIT SERVICE FORM
		// ============================
		case "edit":
			int id = Integer.parseInt(request.getParameter("id"));
			Service service = serviceDAO.getServiceById(id);

			if (service == null) {
				response.sendRedirect("homePage/homePage.jsp");
				return;
			}

			request.setAttribute("service", service);
			request.getRequestDispatcher("/service/serviceEdit.jsp").forward(request, response);
			break;

		// ============================
		// SHOW CONFIRM DELETE PAGE
		// ============================
		case "confirmDelete":
			int deleteId = Integer.parseInt(request.getParameter("id"));
			Service s = serviceDAO.getServiceById(deleteId);

			if (s == null) {
				response.sendRedirect("homePage/homePage.jsp");
				return;
			}

			request.setAttribute("service", s);
			request.getRequestDispatcher("/service/serviceDelete.jsp").forward(request, response);
			break;

		// ============================
		// DEFAULT
		// ============================
		default:
			response.sendRedirect("homePage/homePage.jsp");
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		switch (action) {

		// ============================
		// INSERT SERVICE
		// ============================
		case "insert":
			insertService(request, response);
			break;

		// ============================
		// UPDATE SERVICE
		// ============================
		case "update":
			updateService(request, response);
			break;

		// ============================
		// DELETE SERVICE
		// ============================
		case "delete":
			performDelete(request, response);
			break;

		default:
			response.sendRedirect("homePage/homePage.jsp");
		}
	}

	// ============================================================
	// INSERT
	// ============================================================
	private void insertService(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int catId = Integer.parseInt(request.getParameter("catId"));

		Service s = new Service();
		s.setName(request.getParameter("name"));
		s.setDescription(request.getParameter("description"));
		s.setPrice(Double.parseDouble(request.getParameter("price")));
		s.setImageUrl(request.getParameter("imageUrl"));
		s.setCategoryId(catId);

		serviceDAO.insertService(s);

		response.sendRedirect(request.getContextPath() + "/productDetail?id=" + catId);
	}

	// ============================================================
	// UPDATE
	// ============================================================
	private void updateService(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int id = Integer.parseInt(request.getParameter("id"));
		int catId = Integer.parseInt(request.getParameter("catId"));

		Service s = new Service();
		s.setId(id);
		s.setName(request.getParameter("name"));
		s.setDescription(request.getParameter("description"));
		s.setPrice(Double.parseDouble(request.getParameter("price")));
		s.setImageUrl(request.getParameter("imageUrl"));
		s.setCategoryId(catId);

		serviceDAO.updateService(s);

		response.sendRedirect(request.getContextPath() + "/productDetail?id=" + catId);
	}

	// ============================================================
	// DELETE (after confirmation)
	// ============================================================
	private void performDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int id = Integer.parseInt(request.getParameter("id"));
		Service s = serviceDAO.getServiceById(id);

		if (s != null) {
			int catId = s.getCategoryId();
			serviceDAO.deleteService(id);
			response.sendRedirect(request.getContextPath() + "/productDetail?id=" + catId);
			return;
		}

		response.sendRedirect("homePage/homePage.jsp");
	}
}
