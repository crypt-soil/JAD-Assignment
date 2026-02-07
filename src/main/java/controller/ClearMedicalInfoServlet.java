package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.MedicalInfoDAO;

@WebServlet("/ClearMedicalInfoServlet")
public class ClearMedicalInfoServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customer_id") == null) {
            response.sendRedirect(request.getContextPath() + "/categories");
            return;
        }

        int customerId = (int) session.getAttribute("customer_id");

        MedicalInfoDAO dao = new MedicalInfoDAO();
        dao.saveOrUpdate(customerId, null); // clears it

        response.sendRedirect(request.getContextPath()
                + "/profile?success=Medical+information+cleared!");
    }
}
