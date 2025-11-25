<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession, java.util.*, model.Customer" %>

<%
    if (session == null || !"admin".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/loginPage/login.jsp?unauthorized=true");
        return;
    }

    @SuppressWarnings("unchecked")
    List<Customer> clientList = (List<Customer>) request.getAttribute("clientList");
%>

<!DOCTYPE html>
<html>
<head>	
<meta charset="UTF-8">
<title>Silver Care - Management Overview</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
    body {
        background: #f2f0ff;
        font-family: "Poppins", sans-serif;
    }

    .dashboard-wrapper {
        max-width: 1100px;
        margin: 40px auto;
    }

    .section-title {
        font-weight: 700;
        font-size: 1.8rem;
        color: #4b37b8;
        margin-bottom: 15px;
    }

    .add-btn {
        background: #ede3ff;
        color: #4b37b8;
        border-radius: 10px;
        padding: 8px 20px;
        font-weight: 600;
        border: none;
        transition: 0.2s;
    }
    .add-btn:hover {
        background: #d9c7ff;
    }

    .user-card {
        background: white;
        border-radius: 14px;
        padding: 20px 24px;
        margin-bottom: 20px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.10);
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .username-label {
        font-weight: 600;
        font-size: 1.1rem;
        color: #333;
    }

    .btn-edit {
        background: #6a4bc7;
        color: white;
        border-radius: 8px;
        padding: 6px 20px;
        border: none;
        font-weight: 500;
        transition: 0.2s;
    }
    .btn-edit:hover {
        background: #5a3ab1;
        color: white;
    }

    .btn-delete-icon {
        background: transparent;
        border: none;
        color: #e63946;
        font-size: 1.4rem;
        cursor: pointer;
    }
    .btn-delete-icon:hover {
        color: #b0232f;
    }

    /* layout spacing */
    .user-row-top {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 18px;
    }

</style>
</head>

<body>

<%@ include file="../common/navbar.jsp" %>

<div class="dashboard-wrapper">

    <!-- TITLE + ADD BUTTON -->
    <div class="user-row-top">
        <h2 class="section-title">User List</h2>

        <form action="<%= request.getContextPath() %>/admin/clients/add" method="get">
            <button type="submit" class="add-btn">Add</button>
        </form>
    </div>

    <!-- USER CARDS -->
    <%
        if (clientList != null && !clientList.isEmpty()) {
            for (Customer c : clientList) {
    %>

        <div class="user-card">
            <div class="username-label"><%= c.getUsername() %></div>

            <div style="display: flex; gap: 12px;">
                <!-- EDIT BUTTON -->
                <form action="<%= request.getContextPath() %>/admin/clients/edit" method="get" class="m-0">
                    <input type="hidden" name="id" value="<%= c.getCustomer_id() %>">
                    <button type="submit" class="btn-edit">Edit</button>
                </form>

                <!-- DELETE BUTTON -->
                <form action="<%= request.getContextPath() %>/admin/clients/delete" 
                      method="post" class="m-0"
                      onsubmit="return confirm('Are you sure you want to delete this user?');">
                    <input type="hidden" name="id" value="<%= c.getCustomer_id() %>">
                    <button type="submit" class="btn-delete-icon">🗑</button>
                </form>
            </div>
        </div>

    <%
            }
        } else {
    %>

        <p class="text-muted mt-4">No registered users found.</p>

    <%
        }
    %>

</div>

</body>
</html>
