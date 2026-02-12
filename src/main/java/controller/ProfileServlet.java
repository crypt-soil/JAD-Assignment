package controller;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.util.List;

import model.Bookings.Booking;
import model.Bookings.BookingDAO;
import model.EmergencyContact.EmergencyContact;
import model.EmergencyContact.EmergencyContactDAO;
import model.MedicalInfo.MedicalInfo;
import model.MedicalInfo.MedicalInfoDAO;
import model.Profile.Profile;
import model.Profile.ProfileDAO;

@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        Integer customerId = (session != null) ? (Integer) session.getAttribute("customer_id") : null;

        // redirect if not logged in
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

        // medical info
        MedicalInfoDAO medicalDAO = new MedicalInfoDAO();
        MedicalInfo medicalInfo = medicalDAO.getByCustomerId(customerId);
        request.setAttribute("medicalInfo", medicalInfo);

        // emergency contacts
        EmergencyContactDAO ecDAO = new EmergencyContactDAO();
        List<EmergencyContact> emergencyContacts = ecDAO.getByCustomerId(customerId);
        request.setAttribute("emergencyContacts", emergencyContacts);

        RequestDispatcher rd = request.getRequestDispatcher("/profilePage/profilePage.jsp");
        rd.forward(request, response);
    }
}
