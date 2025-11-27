package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.CategoryDAO;
import model.ServiceDAO;
import model.Service;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// DAO for interacting with the Category table
	private CategoryDAO dao = new CategoryDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// ================================
		// SESSION CHECK & ROLE HANDLING
		// ================================
		HttpSession session = request.getSession(false);

		String role = "public"; // Default role
		Integer customerId = null; // Default no customer

		// If session exists, attempt to retrieve role + customer ID
		if (session != null) {
			String r = (String) session.getAttribute("role");
			if (r != null)
				role = r;

			customerId = (Integer) session.getAttribute("customer_id");
		}

		// ================================
		// READ ACTION PARAMETER
		// ================================
		String action = request.getParameter("action");

		// ---------- Add Category Page ----------
		if ("add".equals(action)) {
			RequestDispatcher rd = request.getRequestDispatcher("homePage/addCategory.jsp");
			rd.forward(request, response);
			return;
		}

		// ---------- Edit Category Page ----------
		if ("edit".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			Category category = dao.getCategoryById(id);

			request.setAttribute("category", category);

			RequestDispatcher rd = request.getRequestDispatcher("homePage/editCategory.jsp");
			rd.forward(request, response);
			return;
		}

		// ---------- Delete Category Page ----------
		if ("delete".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			Category category = dao.getCategoryById(id);

			request.setAttribute("category", category);

			RequestDispatcher rd = request.getRequestDispatcher("homePage/deleteCategory.jsp");
			rd.forward(request, response);
			return;
		}

		// ================================
		// DEFAULT: LIST ALL CATEGORIES
		// ================================
		List<Category> categories = dao.getAllCategories();

		// Load services for each category
		ServiceDAO serviceDao = new ServiceDAO();
		for (Category c : categories) {
			c.setServices(serviceDao.getServicesByCategory(c.getId()));
		}

		// ================================
		// SEARCH FEATURE (Category + Service)
		// ================================
		String search = request.getParameter("search");

		if (search != null && !search.trim().isEmpty()) {
			String term = search.toLowerCase();

			// 1️⃣ Filter out categories that do NOT match category name or any service name
			categories.removeIf(c -> !c.getName().toLowerCase().contains(term)
					&& c.getServices().stream().noneMatch(s -> s.getName().toLowerCase().contains(term)));

			// 2️⃣ Highlight matched services (for UI styling)
			for (Category c : categories) {
				for (Service s : c.getServices()) {
					if (s.getName().toLowerCase().contains(term)) {
						s.setHighlighted(true);
					}
				}
			}
		}

		// Pass the category list to JSP
		request.setAttribute("categories", categories);

		// Load homepage view
		RequestDispatcher rd = request.getRequestDispatcher("homePage/homePage.jsp");
		rd.forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Read action for CRUD
		String action = request.getParameter("action");

		// Optional redirect (useful for admin pages)
		String redirectUrl = request.getParameter("redirectUrl");

		// ---------- CREATE ----------
		if ("create".equals(action)) {
			Category c = new Category();
			c.setName(request.getParameter("name"));
			c.setDescription(request.getParameter("description"));
			c.setImageUrl(request.getParameter("imageUrl"));

			dao.insertCategory(c);
		}

		// ---------- UPDATE ----------
		if ("update".equals(action)) {
			Category c = new Category();
			c.setId(Integer.parseInt(request.getParameter("id")));
			c.setName(request.getParameter("name"));
			c.setDescription(request.getParameter("description"));
			c.setImageUrl(request.getParameter("imageUrl"));

			dao.updateCategory(c);
		}

		// ---------- DELETE ----------
		if ("delete".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));
			dao.deleteCategory(id);
		}

		// ================================
		// SMART REDIRECT
		// ================================
		if (redirectUrl != null && !redirectUrl.isEmpty()) {
			// Redirects to a page provided by the caller (admin pages etc.)
			response.sendRedirect(redirectUrl);
		} else {
			// Default redirect back to category list
			response.sendRedirect(request.getContextPath() + "/categories");
		}
	}
}
