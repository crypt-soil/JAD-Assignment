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

    private CategoryDAO dao = new CategoryDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            RequestDispatcher rd = request.getRequestDispatcher("homePage/addCategory.jsp");
            rd.forward(request, response);
            return;
        }

        if ("edit".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Category category = dao.getCategoryById(id);

            request.setAttribute("category", category);

            RequestDispatcher rd = request.getRequestDispatcher("homePage/editCategory.jsp");
            rd.forward(request, response);
            return;
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            Category category = dao.getCategoryById(id);

            request.setAttribute("category", category);

            RequestDispatcher rd = request.getRequestDispatcher("homePage/deleteCategory.jsp");
            rd.forward(request, response);
            return;
        }

        // ===============================
        // DEFAULT — LIST ALL
        // ===============================
        List<Category> categories = dao.getAllCategories();

        // Load services
        ServiceDAO serviceDao = new ServiceDAO();
        for (Category c : categories) {
            c.setServices(serviceDao.getServicesByCategory(c.getId()));
        }

        // ===============================
        // ⭐ SEARCH FEATURE
        // ===============================
        String search = request.getParameter("search");

        if (search != null && !search.trim().isEmpty()) {
            String term = search.toLowerCase();

            // 1️⃣ Filter categories if searching by CATEGORY NAME
            categories.removeIf(c ->
                !c.getName().toLowerCase().contains(term) &&
                c.getServices().stream().noneMatch(s -> s.getName().toLowerCase().contains(term))
            );

            // 2️⃣ Highlight matched SERVICES
            for (Category c : categories) {
                for (Service s : c.getServices()) {
                    if (s.getName().toLowerCase().contains(term)) {
                        s.setHighlighted(true);
                    }
                }
            }
        }

        request.setAttribute("categories", categories);

        RequestDispatcher rd = request.getRequestDispatcher("homePage/homePage.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        if ("create".equals(action)) {
            Category c = new Category();
            c.setName(request.getParameter("name"));
            c.setDescription(request.getParameter("description"));
            c.setImageUrl(request.getParameter("imageUrl"));

            dao.insertCategory(c);
        }

        if ("update".equals(action)) {
            Category c = new Category();
            c.setId(Integer.parseInt(request.getParameter("id")));
            c.setName(request.getParameter("name"));
            c.setDescription(request.getParameter("description"));
            c.setImageUrl(request.getParameter("imageUrl"));

            dao.updateCategory(c);
        }

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteCategory(id);
        }

        response.sendRedirect(request.getContextPath() + "/categories");
    }
}
