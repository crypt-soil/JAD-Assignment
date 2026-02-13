package controller;
/*
 * Ong Jin Kai
 * 2429465
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import model.category.Category;
import model.category.CategoryDAO;

/**
 * Handles displaying a single category and all of its associated services.
 *
 * URL Mapping: /productDetail
 *
 * Expected Request Parameters: id - (int) The category ID to be displayed.
 *
 * This servlet retrieves a category (plus the list of services belonging to it)
 * and forwards the data to the product detail JSP for viewing.
 */
@WebServlet("/productDetail")
public class ProductDetailsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// ================================================================
		// 1. VALIDATE & PARSE CATEGORY ID FROM REQUEST
		// ================================================================
		String idParam = request.getParameter("id");

		// If no ID is provided → redirect user to homepage
		if (idParam == null || idParam.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/homePage/homePage.jsp");
			return;
		}

		int id = Integer.parseInt(idParam);

		// ================================================================
		// 2. RETRIEVE CATEGORY (INCLUDING ITS RELATED SERVICES)
		// ================================================================
		CategoryDAO dao = new CategoryDAO();

		// Returns a Category object with its services populated
		Category category = dao.getCategoryWithServices(id);

		// If no such category exists → redirect back with an error flag
		if (category == null) {
			response.sendRedirect(request.getContextPath() + "/homePage/homePage.jsp?error=notfound");
			return;
		}

		// ================================================================
		// 3. ATTACH CATEGORY TO REQUEST & FORWARD TO JSP
		// ================================================================
		request.setAttribute("category", category);

		// Forward to product detail JSP page for rendering
		request.getRequestDispatcher("/productDetail/productDetail.jsp").forward(request, response);
	}
}
