<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Payment Cancelled</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
body {
	background: #f6f4ff;
	font-family: "Poppins", sans-serif;
	min-height: 100vh;
}

.cardish {
	background: #fff;
	border-radius: 16px;
	box-shadow: 0 12px 30px rgba(0, 0, 0, 0.08);
}

.title {
	font-weight: 800;
	color: #4b37b8;
}

.muted {
	color: #6b7280;
}

.badge-soft {
	background: rgba(220, 53, 69, 0.10);
	color: #dc3545;
	border: 1px solid rgba(220, 53, 69, 0.18);
	font-weight: 600;
}

.icon-circle {
	width: 62px;
	height: 62px;
	border-radius: 50%;
	display: grid;
	place-items: center;
	background: rgba(220, 53, 69, 0.12);
	border: 1px solid rgba(220, 53, 69, 0.18);
	margin: 0 auto;
	font-size: 28px;
}
</style>
</head>

<body>

	<%@ include file="../common/navbar.jsp"%>

	<%
	String bookingId = request.getParameter("bookingId");
	if (bookingId == null)
		bookingId = "-";
	%>

	<div class="container py-5">
		<div class="row justify-content-center">
			<div class="col-12 col-md-8 col-lg-6">
				<div class="cardish p-4 p-md-5 text-center">

					<div class="icon-circle mb-3">❌</div>

					<h2 class="title mb-2">Payment Cancelled</h2>
					<p class="muted mb-4">No worries — your booking has not been
						charged. You can try again anytime.</p>


					<div class="d-grid gap-2">
						<a class="btn btn-dark"
							href="<%=request.getContextPath()%>/stripe/create-checkout-session?bookingId=<%=bookingId%>">
							Try Payment Again </a> <a class="btn btn-outline-secondary"
							href="<%=request.getContextPath()%>/profile?tab=bookings">
							Back to Bookings </a>
					</div>

					<hr class="my-4">

					<div class="small muted">If you experienced an issue during
						payment, please check your card details or try another method.</div>

				</div>
			</div>
		</div>
	</div>

	<%@ include file="../common/footer.jsp"%>

</body>
</html>
