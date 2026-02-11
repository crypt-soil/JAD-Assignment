package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import model.BookingPaymentDAO;

@WebServlet("/stripe/cancel")
public class StripeCancelServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {

    HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("customer_id") == null) {
      response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
      return;
    }

    int customerId = (int) session.getAttribute("customer_id");
    int bookingId = parseIntSafe(request.getParameter("bookingId"));

    if (bookingId > 0) {
      BookingPaymentDAO dao = new BookingPaymentDAO();

      // extra safety: ensure booking belongs to this user
      if (dao.bookingBelongsToCustomer(bookingId, customerId)) {
        int deleted = dao.deleteUnpaidBookingCascade(bookingId, customerId);
        System.out.println("[STRIPE CANCEL] deletedRows=" + deleted + " bookingId=" + bookingId);
      }
    }

    response.sendRedirect(request.getContextPath() + "/checkoutPage/payment_cancel.jsp");
  }

  private int parseIntSafe(String s) {
    try { return Integer.parseInt(s); } catch (Exception e) { return -1; }
  }
}
