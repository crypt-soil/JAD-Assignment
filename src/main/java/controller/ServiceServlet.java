package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import model.Service.Service;
import model.Service.ServiceDAO;
import model.category.Category;
import model.category.CategoryDAO;

/**
 * Handles CRUD operations for Service objects.
 *
 * URL Mapping: /service
 *
 * Supported Actions: GET: action=add → Show add-service form action=edit → Show
 * edit-service form action=confirmDelete → Show delete confirmation page
 *
 * POST: action=insert → Insert new service action=update → Update existing
 * service action=delete → Delete existing service
 *
 * Default behavior redirects to homepage.
 */
@WebServlet("/service")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
		maxFileSize = 5 * 1024 * 1024, // 5MB
		maxRequestSize = 6 * 1024 * 1024 // 6MB
)
public class ServiceServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private ServiceDAO serviceDAO = new ServiceDAO();
	private CategoryDAO categoryDAO = new CategoryDAO();

	// ============================================================
	// GET HANDLER (SHOW FORMS)
	// ============================================================
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");
		if (action == null)
			action = "list";

		switch (action) {

		// ------------------------------------------------------------
		// SHOW ADD SERVICE FORM (requires category ID)
		// ------------------------------------------------------------
		case "add": {
			int catId = Integer.parseInt(request.getParameter("catId"));
			Category category = categoryDAO.getCategoryById(catId);

			request.setAttribute("category", category);
			request.getRequestDispatcher("/service/serviceAdd.jsp").forward(request, response);
			break;
		}

		// ------------------------------------------------------------
		// SHOW EDIT SERVICE FORM
		// ------------------------------------------------------------
		case "edit": {
			int id = Integer.parseInt(request.getParameter("id"));
			Service service = serviceDAO.getServiceById(id);

			if (service == null) {
				response.sendRedirect("homePage/homePage.jsp");
				return;
			}

			request.setAttribute("service", service);
			request.getRequestDispatcher("/service/serviceEdit.jsp").forward(request, response);
			break;
		}

		// ------------------------------------------------------------
		// SHOW DELETE CONFIRMATION PAGE
		// ------------------------------------------------------------
		case "confirmDelete": {
			int deleteId = Integer.parseInt(request.getParameter("id"));
			Service s = serviceDAO.getServiceById(deleteId);

			if (s == null) {
				response.sendRedirect("homePage/homePage.jsp");
				return;
			}

			request.setAttribute("service", s);
			request.getRequestDispatcher("/service/serviceDelete.jsp").forward(request, response);
			break;
		}

		// ------------------------------------------------------------
		// DEFAULT → redirect home
		// ------------------------------------------------------------
		default:
			response.sendRedirect("homePage/homePage.jsp");
		}
	}

	// ============================================================
	// POST HANDLER (CRUD OPERATIONS)
	// ============================================================
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		if (action == null) {
			response.sendRedirect("homePage/homePage.jsp");
			return;
		}

		switch (action) {

		// INSERT NEW SERVICE
		case "insert":
			insertService(request, response);
			break;

		// UPDATE EXISTING SERVICE
		case "update":
			updateService(request, response);
			break;

		// DELETE SERVICE
		case "delete":
			performDelete(request, response);
			break;

		default:
			response.sendRedirect("homePage/homePage.jsp");
		}
	}

	// ============================================================
	// IMAGE UPLOAD HELPER
	// Priority logic (used by insert/update):
	// 1) if file uploaded -> store in /uploads/services and return relative path
	// 2) if no file uploaded -> return null (caller decides to use typed URL / keep
	// old)
	// ============================================================
	private String handleServiceImageUpload(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		Part imagePart = request.getPart("serviceImage"); // must match input name="serviceImage"
		if (imagePart == null || imagePart.getSize() == 0) {
			return null;
		}

		// Get original filename safely
		String submitted = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

		// Extract extension
		String ext = "";
		int dot = submitted.lastIndexOf(".");
		if (dot >= 0) {
			ext = submitted.substring(dot + 1).toLowerCase();
		}

		// Basic allow-list
		if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png") && !ext.equals("webp")) {
			response.sendError(400, "Only jpg/jpeg/png/webp images are allowed.");
			return null; // response committed
		}

		// Generate safe unique filename
		String newName = UUID.randomUUID().toString().replace("-", "") + "." + ext;

		// Save into webapp folder (publicly accessible)
		String uploadDir = getServletContext().getRealPath("/uploads/services");
		File dir = new File(uploadDir);
		if (!dir.exists()) {
			dir.mkdirs();
		}

		imagePart.write(uploadDir + File.separator + newName);

		// Store RELATIVE path in DB so JSP can do contextPath + "/" + imageUrl
		return "uploads/services/" + newName;
	}

	// ============================================================
	// INSERT SERVICE
	// Rules:
	// - if uploaded image exists -> use it
	// - else if typed URL exists -> use it
	// - else -> null (detail page fallback)
	// ============================================================
	private void insertService(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		int catId = Integer.parseInt(request.getParameter("catId"));

		String typedUrl = request.getParameter("imageUrl");
		if (typedUrl != null)
			typedUrl = typedUrl.trim();

		String uploadedPath = handleServiceImageUpload(request, response);
		if (response.isCommitted())
			return;

		String finalImageUrl = (uploadedPath != null) ? uploadedPath
				: ((typedUrl != null && !typedUrl.isEmpty()) ? typedUrl : null);

		Service s = new Service();
		s.setName(request.getParameter("name"));
		s.setDescription(request.getParameter("description"));
		s.setPrice(Double.parseDouble(request.getParameter("price")));
		s.setImageUrl(finalImageUrl);
		s.setCategoryId(catId);

		serviceDAO.insertService(s);

		// Redirect back to the parent category's detail page
		response.sendRedirect(request.getContextPath() + "/productDetail?id=" + catId);
	}

	// ============================================================
	// UPDATE SERVICE
	// Rules:
	// - if uploaded image exists -> use it
	// - else if typed URL exists -> use it
	// - else -> keep existing imageUrl from DB
	// ============================================================
	private void updateService(HttpServletRequest request, HttpServletResponse response)
			throws IOException, ServletException {

		int id = Integer.parseInt(request.getParameter("id"));
		int catId = Integer.parseInt(request.getParameter("catId"));

		String typedUrl = request.getParameter("imageUrl");
		if (typedUrl != null)
			typedUrl = typedUrl.trim();

		String uploadedPath = handleServiceImageUpload(request, response);
		if (response.isCommitted())
			return;

		String finalImageUrl;

		if (uploadedPath != null) {
			finalImageUrl = uploadedPath;
		} else if (typedUrl != null && !typedUrl.isEmpty()) {
			finalImageUrl = typedUrl;
		} else {
			// keep old if admin didn't provide anything
			Service existing = serviceDAO.getServiceById(id);
			finalImageUrl = (existing != null) ? existing.getImageUrl() : null;
		}

		Service s = new Service();
		s.setId(id);
		s.setName(request.getParameter("name"));
		s.setDescription(request.getParameter("description"));
		s.setPrice(Double.parseDouble(request.getParameter("price")));
		s.setImageUrl(finalImageUrl);
		s.setCategoryId(catId);

		serviceDAO.updateService(s);

		response.sendRedirect(request.getContextPath() + "/productDetail?id=" + catId);
	}

	// ============================================================
	// DELETE SERVICE (AFTER CONFIRMATION)
	// (Optional improvement: delete the old file from uploads folder too)
	// ============================================================
	private void performDelete(HttpServletRequest request, HttpServletResponse response) throws IOException {

		int id = Integer.parseInt(request.getParameter("id"));
		Service s = serviceDAO.getServiceById(id);

		if (s != null) {
			int catId = s.getCategoryId();

			serviceDAO.deleteService(id);

			// Redirect to the category page the service belonged to
			response.sendRedirect(request.getContextPath() + "/productDetail?id=" + catId);
			return;
		}

		response.sendRedirect("homePage/homePage.jsp");
	}
}
