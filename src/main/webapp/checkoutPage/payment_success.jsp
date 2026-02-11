<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Payment Success</title>

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
	letter-spacing: 0.2px;
}

.muted {
	color: #6b7280;
}

.badge-soft {
	background: rgba(75, 55, 184, 0.10);
	color: #4b37b8;
	border: 1px solid rgba(75, 55, 184, 0.18);
	font-weight: 600;
}

.icon-circle {
	width: 62px;
	height: 62px;
	border-radius: 50%;
	display: grid;
	place-items: center;
	background: rgba(25, 135, 84, 0.12);
	border: 1px solid rgba(25, 135, 84, 0.18);
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
					<div class="icon-circle mb-3">✅</div>

					<h2 class="title mb-2">Payment Confirmed</h2>
					<p class="muted mb-4">Thank you! Your payment was successful
						and your booking will be processed shortly.</p>

					<div class="d-inline-flex align-items-center gap-2 mb-4">
						<span class="muted">Booking ID:</span> <span
							class="badge badge-soft px-3 py-2">#<%=bookingId%></span>
					</div>

					<div class="d-grid gap-2">
						<a class="btn btn-dark"
							href="<%=request.getContextPath()%>/profile?tab=bookings">
							Back to Bookings </a> <a class="btn btn-outline-secondary"
							href="<%=request.getContextPath()%>/categories"> Book Another
							Service </a>
					</div>

					<hr class="my-4">

					<div class="small muted">If your booking status doesn’t
						update immediately, refresh your bookings page in a few seconds.</div>
				</div>
			</div>
		</div>
	</div>

	<%@ include file="../common/footer.jsp"%>
</body>
</html>
