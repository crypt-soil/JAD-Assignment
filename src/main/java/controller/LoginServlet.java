package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import model.UserDAO;

import java.io.IOException;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userRepo = new UserDAO();
        
        if (userRepo.validateAdmin(username, password)) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", "admin");
            session.setAttribute("loginMessage", "Welcome back, Admin!");
            response.sendRedirect(request.getContextPath() + "/homePage/homePage.jsp");
            return;
        }
        
        if (userRepo.validateMember(username, password)) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            session.setAttribute("role", "member");
            session.setAttribute("loginMessage", "Login successful!");
            response.sendRedirect(request.getContextPath() + "/homePage/homePage.jsp");
            return;
        }



        request.setAttribute("errorMsg", "Invalid username or password.");
        request.getRequestDispatcher("/loginPage/login.jsp").forward(request, response);
    }
}
