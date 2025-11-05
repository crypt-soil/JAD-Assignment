package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.registerModel; // or adjust to your actual model class
import java.io.IOException;

@WebServlet("/VerifyRegister")
public class VerifyRegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1️⃣ Retrieve form values
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String address = request.getParameter("address");
        String zipcode = request.getParameter("zipcode");
        String password = request.getParameter("password");
        String password2 = request.getParameter("password2");

        // 2️⃣ Basic validation
        if (!password.equals(password2)) {
            response.sendRedirect(request.getContextPath() + "/registerPage/registerPage.jsp?message=error&reason=Password+do+not+match!");
            return;
        }

        // 3️⃣ Interact with your Model (example)
        registerModel dao = new registerModel();
        boolean success = dao.registerUser(username, email, fullName, phoneNumber, address, zipcode, password);

        // 4️⃣ Redirect back with message
        if (success) {
            response.sendRedirect(request.getContextPath() + "/registerPage/registerPage.jsp?message=success");
        } else {
            response.sendRedirect(request.getContextPath() + "/registerPage/registerPage.jsp?message=error&reason=Database+error");
        }
    }
}
