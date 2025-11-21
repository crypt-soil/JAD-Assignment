package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;

import model.ProfileDAO;
import model.Profile;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customer_id") : null;
        System.out.println(customerId);
        // If not logged in → redirect to home page
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/categories");
            return;	
        }
        
        // Fetch profile info from DB
        ProfileDAO dao = new ProfileDAO();
        Profile profile = dao.getProfileById(customerId);

        // Send profile data to JSP
        request.setAttribute("profile", profile);

        RequestDispatcher rd = request.getRequestDispatcher("/profilePage/profilePage.jsp");
        rd.forward(request, response);
    }
}
