package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.BookingDetailsStatusDAO;
import model.CaregiverRequestDAO;
import model.NotificationDAO;

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
//        System.out.println("acceptRequest detailId=" + detailId + " caregiverId=" + caregiverId);
        
        boolean ok;
        try {
           ok = requestDAO.acceptRequest(detailId, caregiverId);
        } catch (Exception e) {
           response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=db");
           return;
        }
        if (!ok) {
           response.sendRedirect(request.getContextPath() + "/caregiver/requests?error=clash");
           return;
        }

        
        Integer customerId = new BookingDetailsStatusDAO().getCustomerIdByDetailId(detailId);
        if (customerId != null) {
            new NotificationDAO().create(
                customerId,
                null,
                detailId,
                "Request accepted",
                "A caregiver has accepted your booking request! You can view the booking details in your profile."
            );
        }

        response.sendRedirect(request.getContextPath() + "/caregiver/requests?filter=future");
    }
}
