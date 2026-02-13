package controller;
/*
 * Ong Jin Kai
 * 2429465
 */
import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

import model.Service.Service;
import model.Service.ServiceDAO;
import model.category.Category;
import model.category.CategoryDAO;

@WebServlet("/categories")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
		maxFileSize = 5 * 1024 * 1024, // 5MB
		maxRequestSize = 6 * 1024 * 1024 // 6MB
)
public class CategoryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// DAO for interacting with the Category table
	private CategoryDAO dao = new CategoryDAO();

	// ============================================================
	// IMAGE UPLOAD HELPER
	// - reads <input type="file" name="categoryImage">
	// - saves to /uploads/categories/
	// - returns relative path: uploads/categories/<uuid>.<ext>
	// ============================================================
	private String handleCategoryImageUpload(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		Part imagePart = request.getPart("categoryImage");
		if (imagePart == null || imagePart.getSize() == 0)
			return null;

		String submitted = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

		String ext = "";
		int dot = submitted.lastIndexOf(".");
		if (dot >= 0)
			ext = submitted.substring(dot + 1).toLowerCase();

		// allowlist
		if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png") && !ext.equals("webp")) {
			response.sendError(400, "Only jpg/jpeg/png/webp images are allowed.");
			return null;
		}

		String newName = UUID.randomUUID().toString().replace("-", "") + "." + ext;

		String uploadDir = getServletContext().getRealPath("/uploads/categories");
		File dir = new File(uploadDir);
		if (!dir.exists())
			dir.mkdirs();

		imagePart.write(uploadDir + File.separator + newName);

		return "uploads/categories/" + newName;
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// ================================
		// SESSION CHECK & ROLE HANDLING
		// ================================
		HttpSession session = request.getSession(false);

		String role = "public"; // Default role
		Integer customerId = null; // Default no customer

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

			// Filter out categories that do NOT match category name or any service name
			categories.removeIf(c -> !c.getName().toLowerCase().contains(term)
					&& c.getServices().stream().noneMatch(s -> s.getName().toLowerCase().contains(term)));

			// Highlight matched services
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

		// (Optional) pass role if your JSP expects it directly
		request.setAttribute("role", role);

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

		// Read typed URL (optional)
		String typedUrl = request.getParameter("imageUrl");
		if (typedUrl != null)
			typedUrl = typedUrl.trim();

		// Try upload (upload overrides typed URL)
		String uploadedPath = handleCategoryImageUpload(request, response);
		if (response.isCommitted())
			return;

		// ---------- CREATE ----------
		if ("create".equals(action)) {
			String finalImageUrl = (uploadedPath != null) ? uploadedPath
					: ((typedUrl != null && !typedUrl.isEmpty()) ? typedUrl : null);

			Category c = new Category();
			c.setName(request.getParameter("name"));
			c.setDescription(request.getParameter("description"));
			c.setImageUrl(finalImageUrl);

			dao.insertCategory(c);
		}

		// ---------- UPDATE ----------
		if ("update".equals(action)) {
			int id = Integer.parseInt(request.getParameter("id"));

			String finalImageUrl;
			if (uploadedPath != null) {
				finalImageUrl = uploadedPath;
			} else if (typedUrl != null && !typedUrl.isEmpty()) {
				finalImageUrl = typedUrl;
			} else {
				// keep existing image if admin didn't provide anything
				Category existing = dao.getCategoryById(id);
				finalImageUrl = (existing != null) ? existing.getImageUrl() : null;
			}

			Category c = new Category();
			c.setId(id);
			c.setName(request.getParameter("name"));
			c.setDescription(request.getParameter("description"));
			c.setImageUrl(finalImageUrl);

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
			response.sendRedirect(redirectUrl);
		} else {
			response.sendRedirect(request.getContextPath() + "/categories");
		}
	}
}
