package controller;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.servlet.*;

import java.io.IOException;
import java.util.List;

import model.Notification;
import model.NotificationDAO;

@WebServlet("/notifications")
public class CustomerNotificationsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private final NotificationDAO dao = new NotificationDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer customerId = (Integer) request.getSession().getAttribute("customer_id");
		if (customerId == null) {
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			return;
		}

		int lastId = 0;
		try {
			lastId = Integer.parseInt(request.getParameter("lastId"));
		} catch (Exception ignored) {
		}

		int unread = dao.getUnreadCount(customerId);
		List<Notification> latest = dao.getLatest(customerId, 8);
		List<Notification> newUnread = dao.getUnreadSince(customerId, lastId);

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		StringBuilder json = new StringBuilder();
		json.append("{");
		json.append("\"unread\":").append(unread).append(",");
		json.append("\"latest\":[");
		for (int i = 0; i < latest.size(); i++) {
			if (i > 0)
				json.append(",");
			Notification n = latest.get(i);
			json.append("{").append("\"id\":").append(n.getNotificationId()).append(",").append("\"title\":\"")
					.append(escape(n.getTitle())).append("\",").append("\"message\":\"").append(escape(n.getMessage()))
					.append("\",").append("\"isRead\":").append(n.isRead() ? "true" : "false").append("}");
		}
		json.append("],");

		json.append("\"newUnread\":[");
		for (int i = 0; i < newUnread.size(); i++) {
			if (i > 0)
				json.append(",");
			Notification n = newUnread.get(i);
			json.append("{").append("\"id\":").append(n.getNotificationId()).append(",").append("\"title\":\"")
					.append(escape(n.getTitle())).append("\",").append("\"message\":\"").append(escape(n.getMessage()))
					.append("\"").append("}");
		}
		json.append("]");

		json.append("}");
		response.getWriter().write(json.toString());
	}

	private String escape(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "");
	}
}
