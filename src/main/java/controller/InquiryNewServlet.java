package controller;
/*
 * Lois Poh
 * 2429478
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.List;

import model.Service.Service;
import model.Service.ServiceDAO;
import model.caregiver.Caregiver;
import model.caregiver.CaregiverDAO;
import model.category.Category;
import model.category.CategoryDAO;

@WebServlet("/inquiry/new")
public class InquiryNewServlet extends HttpServlet {

  @Override
  protected void doGet(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    CaregiverDAO caregiverDAO = new CaregiverDAO();
    CategoryDAO categoryDAO = new CategoryDAO();
    ServiceDAO serviceDAO = new ServiceDAO();

    List<Caregiver> caregivers = caregiverDAO.getAllCaregivers();
    List<Category> categories = categoryDAO.getAllCategories();
    List<Service> services = serviceDAO.getAllServices(); 
    
    System.out.println("Caregivers loaded: " + (caregivers == null ? "null" : caregivers.size()));
    System.out.println("Services loaded: " + (services == null ? "null" : services.size()));


    request.setAttribute("caregivers", caregivers);
    request.setAttribute("categories", categories);
    request.setAttribute("services", services);

    // Preselect via query params
    request.setAttribute("presetCategory", request.getParameter("category")); // "Service" or "Caregiver"
    request.setAttribute("presetCaregiverId", request.getParameter("caregiverId"));
    request.setAttribute("presetServiceId", request.getParameter("serviceId"));
    request.setAttribute("presetCatId", request.getParameter("catId"));

    request.getRequestDispatcher("/serviceInquiry/serviceInquiry.jsp")
           .forward(request, response);
  }
}
