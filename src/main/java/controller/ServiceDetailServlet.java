package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import model.Service;
import model.ServiceDAO;   // adjust package if needed

@WebServlet("/serviceDetail")
public class ServiceDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private ServiceDAO serviceDAO = new ServiceDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int id = Integer.parseInt(request.getParameter("id"));

            // Fetch service by ID
            Service service = serviceDAO.getServiceById(id);

            if (service == null) {
                response.sendRedirect("error.jsp"); 
                return;
            }

            // Pass service to JSP
            request.setAttribute("service", service);

            request.getRequestDispatcher("/serviceDetail/serviceDetail.jsp")
                    .forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
