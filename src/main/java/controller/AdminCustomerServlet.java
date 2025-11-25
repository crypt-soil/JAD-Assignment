package controller;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import jakarta.xml.bind.DatatypeConverter;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.util.List;
import model.Customer;
import model.CustomerDAO;

@WebServlet("/admin/*")
public class AdminCustomerServlet extends HttpServlet {

    private CustomerDAO dao = new CustomerDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo(); 

        if (action == null || action.equals("/management")) {
            List<Customer> list = dao.getAllCustomers();
            request.setAttribute("clientList", list);
            request.getRequestDispatcher("/adminPage/managementOverview.jsp").forward(request, response);
        }

        else if (action.equals("/clients/edit")) {
            int id = Integer.parseInt(request.getParameter("id"));
            Customer c = dao.getCustomerById(id);
            request.setAttribute("customer", c);
            request.getRequestDispatcher("/adminPage/editCustomer.jsp").forward(request, response);
        }

        else if (action.equals("/clients/add")) {
            request.getRequestDispatcher("/adminPage/addCustomer.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getPathInfo();

        if (action.equals("/clients/update")) {
            Customer c = new Customer();
            c.setCustomer_id(Integer.parseInt(request.getParameter("id")));
            c.setUsername(request.getParameter("username"));
            c.setPassword(request.getParameter("password"));
            c.setFull_name(request.getParameter("fullname"));
            c.setEmail(request.getParameter("email"));
            c.setPhone(request.getParameter("phone"));
            c.setAddress(request.getParameter("address"));
            c.setZipcode(request.getParameter("zipcode"));

            dao.updateCustomer(c);
            response.sendRedirect(request.getContextPath() + "/admin/management");
        }

        else if (action.equals("/clients/add")) {

            String rawPassword = request.getParameter("password");
            String hashedPassword = null;

            try {
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashed = md.digest(rawPassword.getBytes(StandardCharsets.UTF_8));
                hashedPassword = DatatypeConverter.printHexBinary(hashed).toLowerCase();
            } catch (Exception e) {
                throw new ServletException("Error hashing password", e);
            }

            Customer c = new Customer();
            c.setUsername(request.getParameter("username"));
            c.setPassword(hashedPassword);
            c.setFull_name(request.getParameter("fullname"));
            c.setEmail(request.getParameter("email"));
            c.setPhone(request.getParameter("phone"));
            c.setAddress(request.getParameter("address"));
            c.setZipcode(request.getParameter("zipcode"));

            dao.addCustomer(c);
            response.sendRedirect(request.getContextPath() + "/admin/management");
        } else if (action.equals("/clients/delete")) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteCustomer(id);
            response.sendRedirect(request.getContextPath() + "/admin/management");
        }
    }
}
