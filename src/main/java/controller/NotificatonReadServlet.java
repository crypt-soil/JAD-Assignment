package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;

import model.NotificationDAO;

@WebServlet("/notifications/read")
public class NotificatonReadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final NotificationDAO dao = new NotificationDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Integer customerId = (Integer) request.getSession().getAttribute("customer_id");
        if (customerId == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int id = Integer.parseInt(request.getParameter("id"));
        boolean ok = dao.markRead(id, customerId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"ok\":" + (ok ? "true" : "false") + "}");
    }
}
