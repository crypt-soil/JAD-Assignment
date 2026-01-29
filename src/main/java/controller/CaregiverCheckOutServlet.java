package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.BookingDetailsStatusDAO;

@WebServlet("/caregiver/checkout")
public class CaregiverCheckOutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final BookingDetailsStatusDAO dao = new BookingDetailsStatusDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer caregiverId = (Integer) request.getSession().getAttribute("caregiver_id");
        if (caregiverId == null) {
            response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
            return;
        }

        int detailId = Integer.parseInt(request.getParameter("detailId"));
        dao.checkOut(detailId, caregiverId);

        response.sendRedirect(request.getContextPath() + "/caregiver/visits?filter=today");
    }
}
