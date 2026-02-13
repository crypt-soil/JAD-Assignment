package controller.Admin;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.HexFormat;
import java.util.List;

import model.EmergencyContact.EmergencyContact;
import model.EmergencyContact.EmergencyContactDAO;
import model.MedicalInfo.MedicalInfo;
import model.MedicalInfo.MedicalInfoDAO;
import model.customer.Customer;
import model.customer.CustomerDAO;

/*
 * Ong Jin Kai
 * 2429465
 */
@WebServlet("/admin/*")
public class AdminCustomerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CustomerDAO dao = new CustomerDAO();

	// --------- admin guard ----------
	private boolean ensureAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
		HttpSession session = request.getSession(false);
		if (session == null || !"admin".equals(session.getAttribute("role"))) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
			return false;
		}
		return true;
	}

	// --------- SHA-256 (no DatatypeConverter) ----------
	private String sha256Hex(String raw) throws ServletException {
		try {
			MessageDigest md = MessageDigest.getInstance("SHA-256");
			byte[] hashed = md.digest(raw.getBytes(StandardCharsets.UTF_8));
			return HexFormat.of().formatHex(hashed); // lowercase hex
		} catch (Exception e) {
			throw new ServletException("Error hashing password", e);
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!ensureAdmin(request, response))
			return;

		String action = request.getPathInfo();
		// management list + inquiry (search & filter)
		if (action == null || action.equals("/") || action.equals("/management")) {

			String q = request.getParameter("q");
			String zipcode = request.getParameter("zipcode");

			q = (q == null || q.trim().isEmpty()) ? null : q.trim();
			zipcode = (zipcode == null || zipcode.trim().isEmpty()) ? null : zipcode.trim();

			List<Customer> list;
			if (q == null && zipcode == null) {
				list = dao.getAllCustomers();
			} else {
				list = dao.searchCustomers(q, zipcode); // ✅ new DAO method
			}

			request.setAttribute("clientList", list);
			request.setAttribute("q", q);
			request.setAttribute("zipcode", zipcode);

			request.getRequestDispatcher("/adminPage/managementOverview.jsp").forward(request, response);
			return;
		}

		// edit customer basic fields
		if (action.equals("/clients/edit")) {
			int id = Integer.parseInt(request.getParameter("id"));
			Customer c = dao.getCustomerById(id);
			request.setAttribute("customer", c);
			request.getRequestDispatcher("/adminPage/editCustomer.jsp").forward(request, response);
			return;
		}

		// add customer form
		if (action.equals("/clients/add")) {
			request.getRequestDispatcher("/adminPage/addCustomer.jsp").forward(request, response);
			return;
		}

		// ✅ NEW: view/manage a customer's full profile (medical + emergency contacts)
		if (action.equals("/clients/profile")) {
			int id = Integer.parseInt(request.getParameter("id"));

			Customer c = dao.getCustomerById(id);
			request.setAttribute("customer", c);

			MedicalInfoDAO medicalDAO = new MedicalInfoDAO();
			MedicalInfo mi = medicalDAO.getByCustomerId(id);
			request.setAttribute("medicalInfo", mi);

			EmergencyContactDAO ecDAO = new EmergencyContactDAO();
			List<EmergencyContact> ecs = ecDAO.getByCustomerId(id);
			request.setAttribute("emergencyContacts", ecs);

			request.getRequestDispatcher("/adminPage/viewCustomerProfile.jsp").forward(request, response);
			return;
		}

		// ✅ NEW: delete emergency contact (GET is fine here since it redirects back)
		// /admin/clients/emergency/delete?customer_id=1&id=10
		if (action.equals("/clients/emergency/delete")) {
			int customerId = Integer.parseInt(request.getParameter("customer_id"));
			int contactId = Integer.parseInt(request.getParameter("id"));

			EmergencyContactDAO ecDAO = new EmergencyContactDAO();
			ecDAO.deleteContact(contactId, customerId);

			response.sendRedirect(request.getContextPath() + "/admin/clients/profile?id=" + customerId);
			return;
		}

		// fallback
		response.sendRedirect(request.getContextPath() + "/admin/management");
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		if (!ensureAdmin(request, response))
			return;

		String action = request.getPathInfo();
		if (action == null) {
			response.sendRedirect(request.getContextPath() + "/admin/management");
			return;
		}

		// update customer basic fields
		if (action.equals("/clients/update")) {
			Customer c = new Customer();
			int id = Integer.parseInt(request.getParameter("id"));

			c.setCustomer_id(id);
			c.setUsername(request.getParameter("username"));
			c.setFull_name(request.getParameter("fullname"));
			c.setEmail(request.getParameter("email"));
			c.setPhone(request.getParameter("phone"));
			c.setAddress(request.getParameter("address"));
			c.setZipcode(request.getParameter("zipcode"));

			// ✅ only hash & update password if admin typed a new one
			String pw = request.getParameter("password");
			if (pw != null && !pw.trim().isEmpty()) {
				c.setPassword(sha256Hex(pw.trim()));
			} else {
				// keep existing password
				Customer existing = dao.getCustomerById(id);
				c.setPassword(existing.getPassword());
			}

			dao.updateCustomerWithPassword(c);

			response.sendRedirect(request.getContextPath() + "/admin/management");
			return;
		}

		// add customer
		if (action.equals("/clients/add")) {
			String rawPassword = request.getParameter("password");
			if (rawPassword == null || rawPassword.trim().isEmpty()) {
				// you can redirect with error msg if you want
				response.sendRedirect(request.getContextPath() + "/admin/clients/add");
				return;
			}

			Customer c = new Customer();
			c.setUsername(request.getParameter("username"));
			c.setPassword(sha256Hex(rawPassword.trim()));
			c.setFull_name(request.getParameter("fullname"));
			c.setEmail(request.getParameter("email"));
			c.setPhone(request.getParameter("phone"));
			c.setAddress(request.getParameter("address"));
			c.setZipcode(request.getParameter("zipcode"));

			dao.addCustomer(c);
			response.sendRedirect(request.getContextPath() + "/admin/management");
			return;
		}

		// delete customer
		if (action.equals("/clients/delete")) {
			int id = Integer.parseInt(request.getParameter("id"));
			dao.deleteCustomer(id);
			response.sendRedirect(request.getContextPath() + "/admin/management");
			return;
		}

		// ✅ NEW: update medical info
		// form action: /admin/clients/medical/update
		if (action.equals("/clients/medical/update")) {
			int customerId = Integer.parseInt(request.getParameter("customer_id"));

			String[] conditionsArr = request.getParameterValues("conditions");
			String allergies = request.getParameter("allergies");

			if (allergies == null)
				allergies = "";
			allergies = allergies.trim();

			String conditionsCsv = "";
			if (conditionsArr != null && conditionsArr.length > 0) {
				conditionsCsv = String.join(",", conditionsArr).trim();
			}

			MedicalInfoDAO medicalDAO = new MedicalInfoDAO();
			medicalDAO.saveOrUpdate(customerId, conditionsCsv, allergies);

			response.sendRedirect(request.getContextPath() + "/admin/clients/profile?id=" + customerId);
			return;
		}

		// ✅ NEW: add/edit emergency contact (same endpoint)
		// form action: /admin/clients/emergency/save
		if (action.equals("/clients/emergency/save")) {
			int customerId = Integer.parseInt(request.getParameter("customer_id"));
			String contactIdStr = request.getParameter("contact_id"); // blank => add

			String name = request.getParameter("contact_name");
			String relationship = request.getParameter("relationship");
			String phone = request.getParameter("phone");
			String email = request.getParameter("email");

			if (name != null)
				name = name.trim();
			if (relationship != null)
				relationship = relationship.trim();
			if (phone != null)
				phone = phone.trim();
			if (email != null)
				email = email.trim();

			if (relationship != null && relationship.isEmpty())
				relationship = null;
			if (email != null && email.isEmpty())
				email = null;

			EmergencyContactDAO ecDAO = new EmergencyContactDAO();

			if (contactIdStr == null || contactIdStr.trim().isEmpty()) {
				ecDAO.addContact(customerId, name, relationship, phone, email);
			} else {
				int contactId = Integer.parseInt(contactIdStr);
				ecDAO.updateContact(contactId, customerId, name, relationship, phone, email);
			}

			response.sendRedirect(request.getContextPath() + "/admin/clients/profile?id=" + customerId);
			return;
		}

		// fallback
		response.sendRedirect(request.getContextPath() + "/admin/management");
	}
}
