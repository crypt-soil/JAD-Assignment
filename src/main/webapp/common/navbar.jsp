<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">

<%
Integer caregiverId = (Integer) session.getAttribute("caregiver_id");
Integer customerId = (Integer) session.getAttribute("customer_id");
String role = (String) session.getAttribute("role");
if (role == null)
	role = "public";

String timedOut = request.getParameter("timeout");
%>

<%
if ("true".equals(timedOut)) {
%>
<div class="alert alert-warning text-center m-0">Your session has
	expired. Please log in again.</div>
<%
}
%>

<nav
	class="navbar navbar-custom d-flex justify-content-between align-items-center sticky-top">
	<div class="fw-semibold">Silver Care</div>

	<div>

		<%-- ================= ADMIN ================= --%>
		<%
		if ("admin".equals(role)) {
		%>

		<a href="<%=request.getContextPath()%>/admin/management"
			class="btn btn-white"> Management Overview </a> <a
			href="<%=request.getContextPath()%>/adminPage/analyticsDashboard.jsp"
			class="btn btn-white"> Analytics Dashboard </a> <a
			href="<%=request.getContextPath()%>/LogoutServlet"
			class="btn btn-purple"> Logout </a>

		<%-- ================= CAREGIVER ================= --%>
		<%
		} else if (caregiverId != null) {
		%>

		<a href="<%=request.getContextPath()%>/caregiver/home">Caregiver
			Home</a> <a href="<%=request.getContextPath()%>/caregiver/requests">Service
			Requests</a> <a
			href="<%=request.getContextPath()%>/caregiver/visits?filter=today"
			class="btn btn-purple"> My Schedule </a> <a
			href="<%=request.getContextPath()%>/CaregiverLogoutServlet"
			class="btn btn-white"> Logout </a>

		<%-- ================= MEMBER ================= --%>
		<%
		} else if (customerId != null && "member".equals(role)) {
		%>

		<a href="<%=request.getContextPath()%>/categories">Service
			Category</a> <a
			href="<%=request.getContextPath()%>/caregiverInfoPage/caregiver.jsp">Our
			Caregivers</a> <a href="<%=request.getContextPath()%>/profile"
			class="btn btn-white">Profile</a> <a
			href="<%=request.getContextPath()%>/cartPage/cartPage.jsp"
			class="btn btn-white">Cart</a>

		<!-- NOTIFICATION BELL -->
		<div class="dropdown d-inline-block">
			<a class="nav-link position-relative d-inline-block" href="#"
				role="button" data-bs-toggle="dropdown"> <i class="bi bi-bell"></i>
				<span id="notifBadge"
				class="position-absolute top-0 start-100 translate-middle
                                 badge rounded-pill bg-danger d-none">
					0 </span>
			</a>

			<ul class="dropdown-menu dropdown-menu-end p-2" style="width: 320px;">
				<li class="d-flex justify-content-between align-items-center px-2">
					<span class="fw-semibold">Notifications</span>
					<button type="button" class="btn-close" aria-label="Close"></button>
				</li>
				<li><hr class="dropdown-divider"></li>
				<li>
					<div id="notifList" style="max-height: 260px; overflow: auto;"></div>
				</li>
			</ul>
		</div>

		<a href="<%=request.getContextPath()%>/LogoutServlet"
			class="btn btn-purple"> Logout </a>

		<%-- ================= PUBLIC ================= --%>
		<%
		} else {
		%>

		<a href="<%=request.getContextPath()%>/categories">Service
			Category</a> <a
			href="<%=request.getContextPath()%>/caregiverInfoPage/caregiver.jsp">Our
			Caregivers</a> <a
			href="<%=request.getContextPath()%>/registerPage/registerPage.jsp"
			class="btn btn-white"> Sign Up </a> <a
			href="<%=request.getContextPath()%>/loginPage/login.jsp"
			class="btn btn-purple"> Login </a>

		<%
		}
		%>

	</div>
</nav>

<!-- ================= TOAST (MEMBER ONLY) ================= -->
<%
if (customerId != null && "member".equals(role)) {
%>
<div class="toast-container position-fixed top-0 end-0 p-3"
	style="z-index: 1080;">
	<div id="liveToast" class="toast text-bg-success border-0" role="alert"
		aria-live="assertive" aria-atomic="true">
		<div class="d-flex">
			<div class="toast-body" id="toastBody">New notification</div>
			<button type="button" class="btn-close btn-close-white me-2 m-auto"
				data-bs-dismiss="toast"></button>
		</div>
	</div>
</div>
<%
}
%>

<style>
.navbar-custom {
	background-color: #c5b2e6;
	padding: 30px 70px;
	box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
	z-index: 1030;
}

.navbar-custom a {
	color: #000;
	text-decoration: none;
	margin-right: 25px;
	font-weight: 500;
}

.navbar-custom a:hover {
	text-decoration: underline;
}

.btn-purple {
	background-color: #6d4a8d;
	color: white;
	border: none;
	border-radius: 6px;
	padding: 6px 18px;
	font-weight: 500;
}

.btn-white {
	background-color: white;
	color: #000;
	border: none;
	border-radius: 6px;
	padding: 6px 18px;
	font-weight: 500;
	margin-right: 10px;
}
</style>

<!-- ================= NOTIFICATION JS (MEMBER ONLY) ================= -->
<%
if (customerId != null && "member".equals(role)) {
%>
<script>
let lastId = 0;
const shownToast = {};

function getNotifId(n) {
  return (n && (n.notification_id || n.notificationId || n.id)) ? (n.notification_id || n.notificationId || n.id) : 0;
}

function getIsRead(n) {
  if (!n) return false;
  if (typeof n.is_read !== "undefined") return !!n.is_read;
  if (typeof n.isRead !== "undefined") return !!n.isRead;
  return false;
}

function safeText(v) {
  return (v === null || typeof v === "undefined") ? "" : String(v);
}

async function fetchNotifications() {
  try {
    const res = await fetch("<%=request.getContextPath()%>/notifications?lastId=" + lastId,
                            { cache: "no-store" });
    if (!res.ok) return;

    const data = await res.json();

    // badge
    const badge = document.getElementById("notifBadge");
    const unread = Number(data.unread || 0);
    if (unread > 0) {
      badge.textContent = unread;
      badge.classList.remove("d-none");
    } else {
      badge.classList.add("d-none");
    }

    // dropdown list
    const list = document.getElementById("notifList");
    list.innerHTML = "";

    const latest = Array.isArray(data.latest) ? data.latest : [];
    if (latest.length === 0) {
      list.innerHTML = `<div class="text-muted px-2 py-2">No notifications</div>`;
    } else {
      latest.forEach(n => {
        const id = getNotifId(n);
        const isRead = getIsRead(n);

        const box = document.createElement("div");
        box.className = "border rounded p-2 mb-2";
        box.innerHTML = `
          <div class="fw-semibold">\${safeText(n.title)}</div>
          <div class="small">\${safeText(n.message)}</div>
          <button class="btn btn-sm btn-outline-primary mt-2"
                  \${isRead ? "disabled" : ""}
                  onclick="markRead(\${id})">
            \${isRead ? "Read" : "Mark as read"}
          </button>
        `;
        list.appendChild(box);
      });
    }

    // advance lastId using latest
    for (const n of latest) {
      const id = getNotifId(n);
      if (id > lastId) lastId = id;
    }

    // toast for new notifications (show once)
    const newUnread = Array.isArray(data.newUnread) ? data.newUnread : [];
    for (const n of newUnread) {
      const id = getNotifId(n);
      if (!id) continue;

      if (!shownToast[id]) {
        shownToast[id] = true;

        document.getElementById("toastBody").textContent = safeText(n.message) || "New notification";
        bootstrap.Toast.getOrCreateInstance(document.getElementById("liveToast"), {
          autohide: true,
          delay: 4000
        }).show();
      }

      if (id > lastId) lastId = id;
    }
  } catch (e) {}
}

function markRead(id) {
  fetch("<%=request.getContextPath()%>/notifications/read", {
    method: "POST",
    headers: {"Content-Type":"application/x-www-form-urlencoded"},
    body: "id=" + encodeURIComponent(id)
  }).then(() => fetchNotifications());
}

document.addEventListener("DOMContentLoaded", () => {
  fetchNotifications();
  setInterval(fetchNotifications, 3000);
});

document.addEventListener("click", (e) => {
	  if (e.target && e.target.classList.contains("btn-close")) {
	    const menu = e.target.closest(".dropdown-menu");
	    if (menu) {
	      const toggle = menu.closest(".dropdown")?.querySelector('[data-bs-toggle="dropdown"]');
	      if (toggle) bootstrap.Dropdown.getOrCreateInstance(toggle).hide();
	    }
	  }
	});
</script>
<%
}
%>
