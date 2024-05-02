<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<title>Sign Up Form by Colorlib</title>
<%--	reCAPTCHA script by google--%>
	<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<!-- Font Icon -->
<link rel="stylesheet"
	href="fonts/material-icon/css/material-design-iconic-font.min.css">

<!-- Main css -->
<link rel="stylesheet" href="css/style.css">
</head>
<body style="background-image: url('images/login_section_1.jpg'); background-size: contain;">




		<!-- Sing in  Form -->
		<section class="sign-in" >
			<div class="container">
				<div class="signin-content">
					<div class="signin-image">
						<figure>
							<img src="images/login_figure.jpg" alt="sing up image">
						</figure>
<%--						<a href="registration.jsp" class="signup-image-link">Create an--%>
<%--							account</a>--%>
<%--						<p class="inline-text">Pas encore de compte ? <a class="signup-image-link" href="index.jsp?triggerModal=true">Créez-le maintenant !</a></p>--%>
							<p style="display: inline">Pas encore de compte ?
								<a class="signup-image-link" href="index1.jsp?triggerModal=true" style="display: inline">Créez-le maintenant !</a>
							</p>

					</div>

					<div class="signin-form">
						<h2 class="form-title">Sign up</h2>
						<form method="post" action="login" onsubmit="return validateForm()" id="login-form">
							<%
								String username = request.getParameter("username");
								String password = request.getParameter("password");
							%>
							<div class="form-group">
								<label for="username"><i
									class="zmdi zmdi-account material-icons-name"></i></label>
								<input
									type="text" name="username" id="username" value="<%= (username != null) ? username : "" %>"
									placeholder="Your Name" />
								<small style="color:orangered" id="usernameError" class="text-danger">${requestScope.usernameError}</small>
							</div>
							<div class="form-group">
								<label for="password"><i class="zmdi zmdi-lock"></i></label>
								<input
									type="password" name="password" id="password" value="<%= (password != null) ? password : "" %>"
									placeholder="Password" />
								<small  style="color:orangered" id="passwordError" class="text-danger">${requestScope.passwordError}</small>
							</div>


							<div class="form-group">
								<input type="checkbox" name="remember-me" id="remember-me"
									class="agree-term" /> <label for="remember-me"
									class="label-agree-term"><span><span></span></span>Remember
									me</label>
							</div>
							<div class="g-recaptcha" data-sitekey="6LfeE8wpAAAAACPvUMPvrDF26ui4T2SkxLxUkS61">
							</div>
							<small style="color:orangered" id="recaptchaError"></small>
							<div class="form-group form-button">
								<input type="submit" name="signin" id="signin"
									class="form-submit" value="Log in" />
							</div>
						</form>

					</div>
				</div>
			</div>
		</section>



	<!-- JS -->

		<script>
			// Check if username and password are stored in localStorage
			window.onload = function() {
				if(localStorage.getItem('username') && localStorage.getItem('password')) {
					document.getElementById('username').value = localStorage.getItem('username');
					document.getElementById('password').value = localStorage.getItem('password');
					document.getElementById('remember-me').checked = true;
				}
			};

			// Function to validate form and handle remember me
			function validateForm() {
				var username = document.getElementById("username").value;
				var password = document.getElementById("password").value;
				var rememberMe = document.getElementById("remember-me").checked;

				// If remember me is checked, store username and password in localStorage
				if (rememberMe) {
					localStorage.setItem('username', username);
					localStorage.setItem('password', password);
				} else {
					// If remember me is unchecked, remove username and password from localStorage
					localStorage.removeItem('username');
					localStorage.removeItem('password');
				}
				// Check if reCAPTCHA is completed
				var response = grecaptcha.getResponse();
				if (!response) {
					document.getElementById('recaptchaError').innerText="Captcha non valide"
					return false; // Prevent form submission if reCAPTCHA is not validated
				}
				// Check the username and password validation
				if (username.trim() === "" || password.trim() === "") {
					if(username.trim() === ""){
						document.getElementById('usernameError').textContent = 'Veuillez saisir votre username';
					}
					if(password.trim() === ""){
						document.getElementById('passwordError').textContent='Veuillez saisir votre mot de passe'
					}
					//Cleaning the msgError
					if(username.trim() !== ""){document.getElementById('usernameError').textContent = '';}
					if(password.trim() !== ""){document.getElementById('passwordError').textContent='';}
					return false; // Prevent form submission
				}

				return true; // Allow form submission
			}
		</script>

</body>
</html>