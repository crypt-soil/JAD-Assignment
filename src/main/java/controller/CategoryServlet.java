package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import model.Category;
import model.CategoryDAO;

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CategoryDAO dao = new CategoryDAO();
        List<Category> categories = dao.getAllCategories();

        request.setAttribute("categories", categories);

        // ✔ Correct path
        RequestDispatcher rd = request.getRequestDispatcher("homePage/homePage.jsp");
        rd.forward(request, response);
    }
}