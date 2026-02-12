package controller.Caregiver;
/*
 * Lois Poh 
 * 2429478
 */
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

import model.caregiver.Caregiver;
import model.caregiver.CaregiverDAO;

@WebServlet("/caregivers")
public class CaregiverListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        CaregiverDAO dao = new CaregiverDAO();
        List<Caregiver> caregivers = dao.getAllCaregivers();

        request.setAttribute("caregivers", caregivers);
        request.getRequestDispatcher("/caregiverInfoPage/caregiver.jsp")
               .forward(request, response);
    }
}
