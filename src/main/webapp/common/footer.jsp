<footer class="silver-footer">
    <div class="footer-container">

        <h5 class="footer-title">Silver Care</h5>
        <p class="footer-subtitle">Compassion  Dignity  Support</p>

        <div class="footer-links mt-2">
            <a href="<%=request.getContextPath()%>/categories">Home</a>
            <a href="<%=request.getContextPath()%>/registerPage/registerPage.jsp">Register</a>
            <a href="<%=request.getContextPath()%>/loginPage/login.jsp">Login</a>
        </div>

        <p class="footer-copy mt-3"> 2025 Silver Care Bringing comfort to every home</p>
    </div>
</footer>

<style>
.silver-footer {
    background: #ece6ff;
    padding: 40px 0;
    margin-top: 60px;
}

.footer-container {
    text-align: center;
    font-family: "Poppins", sans-serif;
}

.footer-title {
    font-weight: 700;
    font-size: 1.4rem;
    color: #4b37b8;
    margin-bottom: 5px;
}

.footer-subtitle {
    font-size: 0.95rem;
    color: #6e6e6e;
}

.footer-links a {
    text-decoration: none;
    color: #6b4cd8;
    margin: 0 12px;
    font-weight: 600;
    font-size: 0.95rem;
}

.footer-links a:hover {
    color: #5936cf;
    text-decoration: underline;
}

.footer-copy {
    font-size: 0.85rem;
    color: #4b4b4b;
}
</style>
