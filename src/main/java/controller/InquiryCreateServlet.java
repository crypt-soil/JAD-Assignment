package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.net.URLEncoder;

import model.Service.ServiceInquiry;
import model.Service.ServiceInquiryDAO;
/*
 * Lois Poh
 * 2429478
 */
@WebServlet("/inquiry/create")
public class InquiryCreateServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        // =========================
        // 1. READ BASIC FIELDS
        // =========================
        String name = safe(req.getParameter("name"));
        String email = safe(req.getParameter("email"));
        String category = safe(req.getParameter("category"));
        String message = safe(req.getParameter("message"));
        String preferred = safe(req.getParameter("preferredContact"));
        String phone = safe(req.getParameter("phone"));

        // =========================
        // 2. BASIC VALIDATION
        // =========================
        if (name.isBlank() || email.isBlank() || category.isBlank() || message.isBlank()) {
            redirectError(req, resp, "Please fill in all required fields.");
            return;
        }

        if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            redirectError(req, resp, "Please enter a valid email address.");
            return;
        }

        if (!preferred.equals("EMAIL") && !preferred.equals("PHONE")) {
            preferred = "EMAIL";
        }

        if (preferred.equals("PHONE") && phone.isBlank()) {
            redirectError(req, resp, "Phone number is required when preferred contact is Phone.");
            return;
        }

        // =========================
        // 3. OPTIONAL RELATION FIELDS
        // =========================
        Integer caregiverId = parseIntOrNull(req.getParameter("caregiverId"));
        Integer serviceId   = parseIntOrNull(req.getParameter("serviceId"));

        // =========================
        // 4. CATEGORY-SPECIFIC RULES
        // =========================
        if (category.equals("Caregiver")) {

            if (caregiverId == null) {
                redirectError(req, resp, "Please select a caregiver you are inquiring about.");
                return;
            }

            serviceId = null; // ensure only caregiver is set
        }

        if (category.equals("Service")) {

            if (serviceId == null) {
                redirectError(req, resp, "Please select a service you are inquiring about.");
                return;
            }

            caregiverId = null; // ensure only service is set
        }

        // Other categories → no target
        if (!category.equals("Caregiver") && !category.equals("Service")) {
            caregiverId = null;
            serviceId = null;
        }

        // =========================
        // 5. CUSTOMER (OPTIONAL)
        // =========================
        Integer customerId = null;
        HttpSession session = req.getSession(false);
        if (session != null) {
            customerId = (Integer) session.getAttribute("customer_id");
        }

        // =========================
        // 6. BUILD MODEL
        // =========================
        ServiceInquiry si = new ServiceInquiry();
        si.setCustomerId(customerId);
        si.setServiceId(serviceId);
        si.setCaregiverId(caregiverId);
        si.setName(name);
        si.setEmail(email);
        si.setCategory(category);
        si.setMessage(message);
        si.setPreferredContact(preferred);
        si.setPhone(preferred.equals("PHONE") ? phone : null);

        // =========================
        // 7. INSERT
        // =========================
        ServiceInquiryDAO dao = new ServiceInquiryDAO();
        int rows = dao.insert(si);

        if (rows > 0) {
            resp.sendRedirect(req.getContextPath() + "/inquiry/new?success=true");
        } else {
            redirectError(req, resp, "Unable to submit inquiry. Please try again.");
        }
    }

    // =====================================================
    // HELPERS
    // =====================================================
    private static void redirectError(HttpServletRequest req, HttpServletResponse resp, String msg)
            throws IOException {
        resp.sendRedirect(
            req.getContextPath() +
            "/inquiry/new?error=" + URLEncoder.encode(msg, "UTF-8")
        );
    }

    private static String safe(String s) {
        return s == null ? "" : s.trim();
    }

    private static Integer parseIntOrNull(String s) {
        try {
            if (s == null || s.isBlank()) return null;
            return Integer.parseInt(s.trim());
        } catch (Exception e) {
            return null;
        }
    }
}
