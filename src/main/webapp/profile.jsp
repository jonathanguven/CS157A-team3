<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="header.jsp"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Profile</title>
<style>
body {
	font-family: Arial, sans-serif;
	margin: 0;
	padding: 0;
	background-color: #f0f0f0;
	min-height: 100vh;
	display: flex;
	flex-direction: column;
}

.content {
	flex: 1;
	display: flex;
	justify-content: center;
	align-items: center;
	padding: 2rem;
}

.profile-container {
	background-color: white;
	padding: 2rem;
	border-radius: 5px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
	width: 100%;
	max-width: 600px;
	text-align: center;
}

.button-container {
	display: flex;
	justify-content: space-around;
	margin-top: 1rem; /* Space above the buttons */
}

.icon-button {
	width: 120px;
	height: 120px;
	background-color: #4CAF50;
	border: none;
	border-radius: 10px;
	display: flex;
	flex-direction: column;
	justify-content: center;
	align-items: center;
	color: white;
	font-weight: bold;
	cursor: pointer;
	transition: background-color 0.3s ease;
}

.icon-button:hover {
	background-color: #45a049;
}

.icon-button:focus {
	outline: none;
}

.plus-icon, .permission-icon {
	font-size: 3rem;
}

.button-text {
	font-size: 1rem;
	margin-top: 5px; /* Small space between the icon and text */
}
</style>
</head>
<body>
	<div class="content">
		<div class="profile-container">
			<h2>
				<%
				String username = null;
				String sellerId = null;
				Cookie[] cookies = request.getCookies();
				if (cookies != null) {
					for (Cookie cookie : cookies) {
						if (cookie.getName().equals("username")) {
					username = cookie.getValue();
						} else if (cookie.getName().equals("idseller")) {
					sellerId = cookie.getValue();
						}
					}
				}

				if (username != null) {
					// If there is a seller ID, include it in the greeting
					if (sellerId != null) {
						out.print("Welcome, " + username + "! Your Seller ID is: " + sellerId);
					} else {
						out.print("Welcome, " + username + "! No Seller ID assigned, Please request one");
					}
				} else {
					out.print("Welcome to your Profile!");
				}
				%>
			</h2>

			<div class="button-container">
				<!-- Add New Product Icon with Text Inside the Button -->
				<button class="icon-button" onclick="location.href='addProduct.jsp'">
					<div class="plus-icon">+</div>
					<div class="button-text">Add New Product</div>
				</button>

				<!-- Request Selling Permission Icon with Text Inside the Button -->
				<button class="icon-button" onclick="requestPermission()">
					<div class="permission-icon">&#9881;</div>
					<!-- Wrench icon for permissions -->
					<div class="button-text">Request Selling Permission</div>
				</button>

				<!-- New Seller's Request Icon -->
				<button class="icon-button"
					onclick="location.href='sellersRequest.jsp'">
					<div class="permission-icon">&#128221;</div>
					<!-- Document icon for Seller's Request -->
					<div class="button-text">Seller's Request</div>
				</button>

				<script>
					function requestPermission() {
						var xhr = new XMLHttpRequest();
						xhr.open("POST", "SellRequest", true);
						xhr.onreadystatechange = function() {
							if (xhr.readyState == 4 && xhr.status == 200) {
								alert(xhr.responseText);
							}
						};
						xhr.send();
					}
				</script>

			</div>
		</div>
	</div>
</body>
</html>
