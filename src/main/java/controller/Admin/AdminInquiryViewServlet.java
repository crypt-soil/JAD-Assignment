package controller.Admin;
/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.ServiceInquiry;
import model.ServiceInquiryDAO;

@WebServlet("/admin/inquiries/view")
public class AdminInquiryViewServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    HttpSession session = request.getSession(false);
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
      response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
      return;
    }

    int id;
    try {
      id = Integer.parseInt(request.getParameter("id"));
    } catch (Exception e) {
      response.sendRedirect(request.getContextPath() + "/admin/inquiries?error=BadId");
      return;
    }

    ServiceInquiryDAO dao = new ServiceInquiryDAO();
    ServiceInquiry inquiry = dao.getById(id);

    if (inquiry == null) {
      response.sendRedirect(request.getContextPath() + "/admin/inquiries?error=NotFound");
      return;
    }
    String auto = request.getParameter("auto");
    // auto mark NEW -> READ when admin views it
    if ("1".equals(auto) && "NEW".equals(inquiry.getStatus())) {
      dao.updateStatus(id, "READ");
      inquiry = dao.getById(id); // re-fetch updated status
    }

    request.setAttribute("inquiry", inquiry);
    request.getRequestDispatcher("/adminPage/adminInquiryDetail.jsp").forward(request, response);
  }
}
