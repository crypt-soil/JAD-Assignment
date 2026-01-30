package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.CaregiverRequestDAO;

@WebServlet("/caregiver/accept")
public class CaregiverAcceptServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final CaregiverRequestDAO requestDAO = new CaregiverRequestDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
        if (caregiverId == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
            return;
        }

        int detailId = Integer.parseInt(request.getParameter("detailId"));

        requestDAO.acceptRequest(detailId, caregiverId);

        response.sendRedirect(request.getContextPath() + "/caregiver/requests?filter=future");
    }
}
