package controller.partner;

/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

import model.partner.PartnerAuthDAO;
import model.partner.PartnerBookingDAO;

@WebServlet("/api/partner/bookings")
public class PartnerBookingsServlet extends HttpServlet {
	// Handles HTTP GET requests to retrieve all bookings associated with an
	// authenticated partner
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Extracts Bearer token from the Authorization header
		String token = readBearerToken(request);
		if (token == null) {
			response.setStatus(401);
			response.getWriter().write("{\"error\":\"Missing token\"}");
			return;
		}

		PartnerAuthDAO authDAO = new PartnerAuthDAO();
		Integer partnerId = authDAO.validateToken(token);

		// Terminates request if token validation fails
		if (partnerId == null) {
			response.setStatus(401);
			response.getWriter().write("{\"error\":\"Invalid or expired token\"}");
			return;
		}

		PartnerBookingDAO bookingDAO = new PartnerBookingDAO();
		List<Map<String, Object>> bookings = bookingDAO.getPartnerBookings(partnerId);

		// Returns booking data as JSON response
		response.setContentType("application/json");
		response.getWriter().write(toJson(bookings));
	}

	// Parses the Bearer token from the HTTP Authorization header
	private String readBearerToken(HttpServletRequest request) {
		String auth = request.getHeader("Authorization");
		if (auth == null)
			return null;
		auth = auth.trim();
		if (!auth.startsWith("Bearer "))
			return null;
		return auth.substring("Bearer ".length()).trim();
	}

	// Converts a list of maps into a JSON array string representation
	private String toJson(List<Map<String, Object>> list) {

		StringBuilder sb = new StringBuilder();
		sb.append("[");

		for (int i = 0; i < list.size(); i++) {

			Map<String, Object> row = list.get(i);

			sb.append("{");

			int fieldCount = 0;

			for (Map.Entry<String, Object> entry : row.entrySet()) {

				if (fieldCount > 0)
					sb.append(",");

				sb.append("\"").append(entry.getKey()).append("\":");

				Object value = entry.getValue();

				// Handles different data types for proper JSON formatting
				if (value == null) {
					sb.append("null");
				} else if (value instanceof Number) {
					sb.append(value);
				} else {
					sb.append("\"").append(escape(value.toString())).append("\"");
				}

				fieldCount++;
			}

			sb.append("}");

			if (i < list.size() - 1)
				sb.append(",");
		}

		sb.append("]");
		return sb.toString();
	}

	// Escapes backslash and double quote characters for safe JSON string inclusion
	private String escape(String s) {
		return s.replace("\\", "\\\\").replace("\"", "\\\"");
	}
}
