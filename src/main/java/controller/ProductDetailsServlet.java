package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import model.CategoryDAO;
import model.Category;

/**
 * Servlet implementation class ProductDetailsServlet
 */
@WebServlet("/productDetail")
public class ProductDetailsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Validate & parse ID
		String idParam = request.getParameter("id");
		if (idParam == null || idParam.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/homePage/homePage.jsp");
			return;
		}

		int id = Integer.parseInt(idParam);

		// Retrieve category WITH its services
		CategoryDAO dao = new CategoryDAO();
		Category category = dao.getCategoryWithServices(id);

		if (category == null) {
			// Category not found → redirect back
			response.sendRedirect(request.getContextPath() + "/homePage/homePage.jsp?error=notfound");
			return;
		}

		// Pass category to JSP
		request.setAttribute("category", category);

		// Load product detail JSP
		request.getRequestDispatcher("/productDetail/productDetail.jsp").forward(request, response);
	}
}
