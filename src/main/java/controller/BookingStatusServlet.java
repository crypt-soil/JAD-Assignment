package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.BookingDetailStatusDAO;

import java.io.IOException;

/**
 * Servlet implementation class BookingStatusServlet
 */
@WebServlet("/BookingStatusServlet")
public class BookingStatusServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final BookingDetailStatusDAO statusDAO = new BookingDetailStatusDAO();
    /**
     * @see HttpServlet#HttpServlet()
     */
    public BookingStatusServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		Integer customerId = (Integer) request.getSession().getAttribute("customer_id");
        if (customerId == null) {
        	response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        int bookingId = Integer.parseInt(request.getParameter("bookingId"));

        var statuses = statusDAO.getStatusesByBookingId(bookingId, customerId);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        StringBuilder json = new StringBuilder();
        json.append("{\"statuses\":[");

        for (int i = 0; i < statuses.size(); i++) {
            var s = statuses.get(i);
            if (i > 0) json.append(",");
            json.append("{")
                .append("\"detailId\":").append(s.getDetailId()).append(",")
                .append("\"caregiverStatus\":").append(s.getCaregiverStatus())
                .append("}");
        }

        json.append("]}");
        response.getWriter().write(json.toString());
    }
	

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
