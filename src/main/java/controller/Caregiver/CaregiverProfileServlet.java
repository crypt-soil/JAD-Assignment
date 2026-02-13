package controller.Caregiver;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;

import model.caregiver.Caregiver;
import model.caregiver.CaregiverDAO;

@WebServlet("/caregiverProfile")
@MultipartConfig(fileSizeThreshold = 1024 * 1024, // 1MB
		maxFileSize = 5 * 1024 * 1024, // 5MB
		maxRequestSize = 6 * 1024 * 1024 // 6MB
)
public class CaregiverProfileServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private CaregiverDAO dao = new CaregiverDAO();

	// ============================================================
	// Upload helper
	// input name MUST be: caregiverImage
	// saves to: /uploads/caregivers/
	// returns DB value: uploads/caregivers/<uuid>.<ext>
	// ============================================================
	private String handlePhotoUpload(HttpServletRequest req, HttpServletResponse resp)
			throws IOException, ServletException {

		Part part = req.getPart("caregiverImage");
		if (part == null || part.getSize() == 0)
			return null;

		String original = Paths.get(part.getSubmittedFileName()).getFileName().toString();

		String ext = "";
		int dot = original.lastIndexOf(".");
		if (dot >= 0)
			ext = original.substring(dot + 1).toLowerCase();

		if (!ext.equals("jpg") && !ext.equals("jpeg") && !ext.equals("png") && !ext.equals("webp")) {
			resp.sendError(400, "Only jpg/jpeg/png/webp images are allowed.");
			return null;
		}

		String newName = UUID.randomUUID().toString().replace("-", "") + "." + ext;

		String uploadDir = getServletContext().getRealPath("/uploads/caregivers");
		File dir = new File(uploadDir);
		if (!dir.exists())
			dir.mkdirs();

		part.write(uploadDir + File.separator + newName);

		return "uploads/caregivers/" + newName;
	}

	// ============================================================
	// GET: show profile page
	// expects caregiver_id stored in session
	// ============================================================
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		HttpSession session = req.getSession(false);
		if (session == null || session.getAttribute("caregiver_id") == null) {
			resp.sendRedirect(req.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
			return;
		}

		int caregiverId = (Integer) session.getAttribute("caregiver_id");

		Caregiver caregiver = dao.getCaregiverById(caregiverId);
		if (caregiver == null) {
			resp.sendRedirect(req.getContextPath() + "/homePage/homePage.jsp");
			return;
		}

		req.setAttribute("caregiver", caregiver);
		req.getRequestDispatcher("/caregiverPage/caregiverProfile.jsp").forward(req, resp);
	}

	// ============================================================
	// POST: update profile
	// Rules:
	// 1) upload overrides typed URL
	// 2) typed URL used if no upload
	// 3) if both empty -> keep old photo_url
	// ============================================================
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

		String action = req.getParameter("action");
		if (action == null)
			action = "update";

		if (!"update".equals(action)) {
			resp.sendRedirect(req.getContextPath() + "/caregiverProfile");
			return;
		}

		int id = Integer.parseInt(req.getParameter("id"));

		// typed url (optional)
		String typedUrl = req.getParameter("photoUrl");
		if (typedUrl != null)
			typedUrl = typedUrl.trim();

		// upload (optional)
		String uploadedPath = handlePhotoUpload(req, resp);
		if (resp.isCommitted())
			return;

		// final photo value
		String finalPhoto;
		if (uploadedPath != null) {
			finalPhoto = uploadedPath;
		} else if (typedUrl != null && !typedUrl.isEmpty()) {
			finalPhoto = typedUrl;
		} else {
			Caregiver existing = dao.getCaregiverById(id);
			finalPhoto = (existing != null) ? existing.getPhotoUrl() : null;
		}

		Caregiver c = new Caregiver();
		c.setId(id);
		c.setFullName(req.getParameter("fullName"));
		c.setGender(req.getParameter("gender"));
		c.setYearsExperience(Integer.parseInt(req.getParameter("yearsExperience")));
		c.setDescription(req.getParameter("description"));
		c.setPhotoUrl(finalPhoto);
		c.setEmail(req.getParameter("email"));
		c.setPhone(req.getParameter("phone"));


		dao.updateCaregiver(c);

		resp.sendRedirect(req.getContextPath() + "/caregiverProfile?success=true");
	}
}
