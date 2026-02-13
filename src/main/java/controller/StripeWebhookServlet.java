package controller;
/*
 * Ong Jin Kai
 * 2429465
 */
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.stripe.model.Event;
import com.stripe.net.Webhook;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;
import java.util.stream.Collectors;

import model.DBConnection;
import model.Bookings.BookingPaymentDAO;

@WebServlet("/stripe/webhook")
public class StripeWebhookServlet extends HttpServlet {

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
		System.out.println("======== [STRIPE WEBHOOK HIT] ========");

		String payload = request.getReader().lines().collect(Collectors.joining("\n"));
		String sigHeader = request.getHeader("Stripe-Signature");

		String webhookSecret = System.getenv("STRIPE_WEBHOOK_SECRET");
		if (webhookSecret == null || webhookSecret.isBlank()) {
			response.setStatus(500);
			response.getWriter().write("STRIPE_WEBHOOK_SECRET not set");
			return;
		}

		Event event;
		try {
			event = Webhook.constructEvent(payload, sigHeader, webhookSecret);
		} catch (Exception e) {
			response.setStatus(400);
			response.getWriter().write("Invalid signature");
			return;
		}

		// ✅ handle only successful checkout completion
		if (!"checkout.session.completed".equals(event.getType())) {
			response.setStatus(200);
			response.getWriter().write("ignored");
			return;
		}

		Connection conn = null;

		try {
			JsonObject root = JsonParser.parseString(payload).getAsJsonObject();
			JsonObject sessionObj = root.getAsJsonObject("data").getAsJsonObject("object");

			int bookingId = parseIntSafe(getMetadata(sessionObj, "bookingId"));
			int customerId = parseIntSafe(getMetadata(sessionObj, "customerId"));

			String sessionId = sessionObj.has("id") ? sessionObj.get("id").getAsString() : null;

			String paymentIntentId = null;
			if (sessionObj.has("payment_intent") && !sessionObj.get("payment_intent").isJsonNull()) {
				paymentIntentId = sessionObj.get("payment_intent").getAsString();
			}

			System.out.println("[STRIPE WEBHOOK] bookingId=" + bookingId + ", customerId=" + customerId + ", sessionId="
					+ sessionId + ", paymentIntentId=" + paymentIntentId);

			if (bookingId <= 0 || customerId <= 0) {
				System.out.println("[STRIPE WEBHOOK] Missing bookingId/customerId in metadata");
				response.setStatus(200);
				response.getWriter().write("ok");
				return;
			}

			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			BookingPaymentDAO dao = new BookingPaymentDAO(conn);

			// 1) mark booking paid (only once)
			int updatedRows = dao.markPaidReturnRows(bookingId, sessionId, paymentIntentId);
			System.out.println("[STRIPE WEBHOOK] markPaid updatedRows=" + updatedRows);

			// If updatedRows == 0, it might already be paid or booking not found.
			// Still continue safely (idempotent webhook).

			// 2) If booking_details empty, copy from draft -> booking_details
			int detailsCount = dao.countBookingDetails(bookingId);
			System.out.println("[STRIPE WEBHOOK] booking_details count=" + detailsCount);

			if (detailsCount == 0) {
				int draftId = dao.findDraftId(bookingId, customerId);
				System.out.println("[STRIPE WEBHOOK] draftId=" + draftId);

				if (draftId > 0) {
					int draftItems = dao.countDraftItems(draftId);
					System.out.println("[STRIPE WEBHOOK] draft_items count=" + draftItems);

					if (draftItems > 0) {
						int inserted = dao.copyDraftToBookingDetails(bookingId, draftId);
						dao.markDraftCopied(draftId);
						System.out.println("[STRIPE WEBHOOK] copied draft -> booking_details insertedRows=" + inserted);
					} else {
						System.out.println("[STRIPE WEBHOOK] Draft has no items, skipping copy.");
					}
				} else {
					System.out.println("[STRIPE WEBHOOK] No draft found for this booking/customer.");
				}
			} else {
				System.out.println("[STRIPE WEBHOOK] booking_details already exists, skip copy.");
			}

			// 3) clear cart after success payment (in SAME transaction)
			int deletedCartRows = dao.clearCartByCustomerId(customerId);
			System.out.println("[STRIPE WEBHOOK] cleared cart rows=" + deletedCartRows);

			conn.commit();

			response.setStatus(200);
			response.getWriter().write("ok");

		} catch (Exception ex) {
			ex.printStackTrace();
			try {
				if (conn != null)
					conn.rollback();
			} catch (Exception ignore) {
			}
			response.setStatus(500);
			response.getWriter().write("webhook error");
		} finally {
			try {
				if (conn != null)
					conn.close();
			} catch (Exception ignore) {
			}
		}
	}

	private String getMetadata(JsonObject sessionObj, String key) {
		if (sessionObj.has("metadata") && sessionObj.get("metadata").isJsonObject()) {
			JsonObject metadata = sessionObj.getAsJsonObject("metadata");
			if (metadata.has(key) && !metadata.get(key).isJsonNull()) {
				return metadata.get(key).getAsString();
			}
		}
		return null;
	}

	private int parseIntSafe(String s) {
		try {
			return Integer.parseInt(s);
		} catch (Exception e) {
			return -1;
		}
	}
}
