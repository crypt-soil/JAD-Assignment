package controller;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;
import java.io.IOException;
import java.util.List;

import model.Notification.Notification;
import model.Notification.NotificationDAO;

/*
 * Lois Poh 
 * 2429478
 */

@WebServlet("/notifications")
public class CustomerNotificationsServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;

	private final NotificationDAO dao = new NotificationDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Reads customer identifier from session to determine authenticated user context
		Integer customerId = (Integer) request.getSession().getAttribute("customer_id");

		// Returns 401 Unauthorized when customer identifier not present in session
		if (customerId == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			return;
		}

		// Initializes last seen notification identifier for incremental fetching
		int lastId = 0;

		// Attempts to parse lastId query parameter; defaults to 0 when missing or invalid
		try {
			lastId = Integer.parseInt(request.getParameter("lastId"));
		} catch (Exception ignored) {
		}

		// Retrieves total unread notification count for badge display or UI indicator
		int unread = dao.getUnreadCount(customerId);

		// Retrieves latest N notifications for populating a notifications dropdown/list
		List<Notification> latest = dao.getLatest(customerId, 8);

		// Retrieves unread notifications created after lastId for incremental updates/polling
		List<Notification> newUnread = dao.getUnreadSince(customerId, lastId);

		response.setContentType("application/json");

		response.setCharacterEncoding("UTF-8");

		// Builds JSON manually to return unread count, latest list, and new unread list
		StringBuilder json = new StringBuilder();

		// Opens root JSON object
		json.append("{");

		// Adds unread count field
		json.append("\"unread\":").append(unread).append(",");

		// Opens latest notifications array
		json.append("\"latest\":[");

		// Iterates through latest notifications and appends each as a JSON object
		for (int i = 0; i < latest.size(); i++) {
			// Adds comma delimiter between array elements
			if (i > 0)
				json.append(",");

			// Reads current notification object
			Notification n = latest.get(i);

			// Appends notification fields with escaping for safe JSON string output
			json.append("{")
					.append("\"id\":").append(n.getNotificationId()).append(",")
					.append("\"title\":\"").append(escape(n.getTitle())).append("\",")
					.append("\"message\":\"").append(escape(n.getMessage())).append("\",")
					.append("\"isRead\":").append(n.isRead() ? "true" : "false")
					.append("}");
		}

		// Closes latest array and appends comma to continue root object fields
		json.append("],");

		// Opens newUnread notifications array
		json.append("\"newUnread\":[");

		// Iterates through new unread notifications and appends each as a JSON object
		for (int i = 0; i < newUnread.size(); i++) {
			// Adds comma delimiter between array elements
			if (i > 0)
				json.append(",");

			// Reads current notification object
			Notification n = newUnread.get(i);

			// Appends notification fields; excludes isRead field because list is specifically unread
			json.append("{")
					.append("\"id\":").append(n.getNotificationId()).append(",")
					.append("\"title\":\"").append(escape(n.getTitle())).append("\",")
					.append("\"message\":\"").append(escape(n.getMessage()))
					.append("\"")
					.append("}");
		}

		// Closes newUnread array
		json.append("]");

		// Closes root JSON object
		json.append("}");

		// Writes JSON payload to response body
		response.getWriter().write(json.toString());
	}

	// Escapes characters that would break JSON formatting when embedding raw text
	private String escape(String s) {
		// Returns empty string when input is null to avoid "null" output in JSON strings
		if (s == null)
			return "";

		// Escapes backslashes, double quotes, and newlines; removes carriage returns
		return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
	}
}
