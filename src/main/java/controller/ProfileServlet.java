package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

import model.ProfileDAO;
import model.Booking;
import model.BookingDAO;
import model.Profile;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customer_id") : null;
        System.out.println(customerId);
        // redirect to home page if not logged in
        if (customerId == null) {
            response.sendRedirect(request.getContextPath() + "/categories");
            return;	
        }
        
        // profile info
        ProfileDAO dao = new ProfileDAO();
        Profile profile = dao.getProfileById(customerId);
        
        request.setAttribute("profile", profile);
        
        // bookings info
        BookingDAO bookingDAO = new BookingDAO();
        List<Booking> bookings = bookingDAO.getBookingsByCustomerId(customerId);
        request.setAttribute("bookings", bookings);
        
        RequestDispatcher rd = request.getRequestDispatcher("/profilePage/profilePage.jsp");
        rd.forward(request, response);
    }
}
