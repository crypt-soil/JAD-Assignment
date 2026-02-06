package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

import model.CartDAO;
import model.CartItem;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private final CartDAO cartDAO = new CartDAO();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		Integer customerId = (Integer) request.getSession().getAttribute("customer_id");
		if (customerId == null) {
			response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp");
			return;
		}

		List<CartItem> items = cartDAO.getCartItemsByCustomerId(customerId);

		double subtotal = 0.0;
		for (CartItem item : items)
			subtotal += item.getLineTotal();

		double gstRate = 0.09;
		double gstAmount = subtotal * gstRate;
		double total = subtotal + gstAmount;

		request.setAttribute("cartItems", items);
		request.setAttribute("subtotal", subtotal);
		request.setAttribute("gstRate", gstRate);
		request.setAttribute("gstAmount", gstAmount);
		request.setAttribute("total", total);

		request.getRequestDispatcher("/checkoutPage/checkout.jsp").forward(request, response);
	}
}
