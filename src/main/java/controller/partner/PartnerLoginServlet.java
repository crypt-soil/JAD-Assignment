package controller.partner;
/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import model.partner.PartnerAuthDAO;
import model.partner.PartnerInfo;

@WebServlet("/api/partner/login")
public class PartnerLoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        System.out.println("email=" + email);
        System.out.println("password=" + request.getParameter("password"));

        if (email == null || password == null || email.isBlank() || password.isBlank()) {
            response.setStatus(400);
            response.getWriter().write("{\"error\":\"Missing email or password\"}");
            return;
        }

        PartnerAuthDAO dao = new PartnerAuthDAO();
        PartnerInfo p = dao.validateLogin(email, password);

        if (p == null) {
            response.setStatus(401);
            response.getWriter().write("{\"error\":\"Invalid credentials\"}");
            return;
        }

        String token = dao.createToken(p.partnerId, 60); // 60 min
        if (token == null) {
            response.setStatus(500);
            response.getWriter().write("{\"error\":\"Token creation failed\"}");
            return;
        }

        response.setContentType("application/json");
        response.getWriter().write(
            "{"
            + "\"partnerId\":" + p.partnerId + ","
            + "\"companyName\":\"" + escape(p.companyName) + "\","
            + "\"token\":\"" + token + "\","
            + "\"expiresInMinutes\":60"
            + "}"
        );
    }

    private String escape(String s) {
        if (s == null) return "";
        return s.replace("\\", "\\\\").replace("\"", "\\\"");
    }
}
