package controller;

import com.stripe.Stripe;
import com.stripe.model.checkout.Session;
import com.stripe.param.checkout.SessionCreateParams;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

import model.BookingPaymentDAO;

@WebServlet("/stripe/create-checkout-session")
public class StripeCreateCheckoutSessionServlet extends HttpServlet {

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		handle(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		handle(request, response);
	}

	private void handle(HttpServletRequest request, HttpServletResponse response) throws IOException {

		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("customer_id") == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		int customerId = (int) session.getAttribute("customer_id");
		int bookingId = parseIntSafe(request.getParameter("bookingId"));

		if (bookingId <= 0) {
			response.sendError(400, "Missing bookingId");
			return;
		}

		String secretKey = System.getenv("STRIPE_SECRET_KEY");
		if (secretKey == null || secretKey.isBlank()) {
			response.sendError(500, "STRIPE_SECRET_KEY not set");
			return;
		}
		Stripe.apiKey = secretKey;

		BookingPaymentDAO dao = new BookingPaymentDAO();

		if (!dao.bookingBelongsToCustomer(bookingId, customerId)) {
			response.sendError(403, "Booking not owned by user");
			return;
		}

		if (dao.isPaid(bookingId)) {
			response.sendError(400, "Booking already paid");
			return;
		}

		// ✅ OPTION A: subtotal must come from DRAFT snapshot (not booking_details)
		double subtotal = dao.sumDraftSubtotalByBookingId(bookingId);

		if (subtotal <= 0) {
			response.sendError(400, "No draft items found for this booking. Please checkout again.");
			return;
		}

		double gstRate = 0.09;
		double total = subtotal * (1.0 + gstRate);

		long totalCents = Math.round(total * 100.0);
		if (totalCents <= 0) {
			response.sendError(400, "Invalid amount");
			return;
		}

		// Build base URL for redirect
		String baseUrl = request.getScheme() + "://" + request.getServerName()
				+ ((request.getServerPort() == 80 || request.getServerPort() == 443) ? ""
						: ":" + request.getServerPort())
				+ request.getContextPath();

		SessionCreateParams params = SessionCreateParams.builder().setMode(SessionCreateParams.Mode.PAYMENT)

				// ✅ Better tracking
				.setClientReferenceId("booking_" + bookingId)

				// ✅ Redirect pages
				.setSuccessUrl(baseUrl + "/checkoutPage/payment_success.jsp?bookingId=" + bookingId)
				.setCancelUrl(baseUrl + "/stripe/cancel?bookingId=" + bookingId)


				// ✅ Single line item for total
				.addLineItem(SessionCreateParams.LineItem.builder().setQuantity(1L)
						.setPriceData(SessionCreateParams.LineItem.PriceData.builder().setCurrency("sgd")
								.setUnitAmount(totalCents)
								.setProductData(SessionCreateParams.LineItem.PriceData.ProductData.builder()
										.setName("SilverCare Booking #" + bookingId).build())
								.build())
						.build())

				// ✅ Metadata for webhook
				.putMetadata("bookingId", String.valueOf(bookingId))
				.putMetadata("customerId", String.valueOf(customerId))

				.build();

		try {
			Session stripeSession = Session.create(params);

			// Save Stripe session id for reference
			dao.saveStripeSessionId(bookingId, stripeSession.getId());

			// Redirect user to Stripe hosted checkout
			response.sendRedirect(stripeSession.getUrl());

		} catch (Exception e) {
			e.printStackTrace();
			response.sendError(500, "Stripe session creation failed");
		}
	}

	private int parseIntSafe(String s) {
		try {
			return Integer.parseInt(s);
		} catch (Exception e) {
			return -1;
		}
	}
}
