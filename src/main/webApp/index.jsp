<%@ page contentType="text/html;charset=UTF-8" language="java" %>



<!doctype html>
<html lang="en" class="h-100">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="Mark Otto, Jacob Thornton, and Bootstrap contributors">
    <meta name="generator" content="Hugo 0.84.0">
    <title>Cover Template · Bootstrap v5.0</title>

    <link rel="canonical" href="https://getbootstrap.com/docs/5.0/examples/cover/">


    <!-- Bootstrap core CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <!-- Favicons -->
    <link rel="apple-touch-icon" href="/docs/5.0/assets/img/favicons/apple-touch-icon.png" sizes="180x180">
    <link rel="icon" href="/docs/5.0/assets/img/favicons/favicon-32x32.png" sizes="32x32" type="image/png">
    <link rel="icon" href="/docs/5.0/assets/img/favicons/favicon-16x16.png" sizes="16x16" type="image/png">
    <link rel="manifest" href="/docs/5.0/assets/img/favicons/manifest.json">
    <link rel="mask-icon" href="/docs/5.0/assets/img/favicons/safari-pinned-tab.svg" color="#7952b3">
    <link rel="icon" href="/docs/5.0/assets/img/favicons/favicon.ico">
    <meta name="theme-color" content="#7952b3">


    <style>
        .bd-placeholder-img {
            font-size: 1.125rem;
            text-anchor: middle;
            -webkit-user-select: none;
            -moz-user-select: none;
            user-select: none;
        }

        @media (min-width: 768px) {
            .bd-placeholder-img-lg {
                font-size: 3.5rem;
            }
        }

        body {
            background-image: url('./images/Bg.jpg');
        }

        .alert-custom {
            position: fixed; /* or absolute */
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            z-index: 1000;
        }
    </style>


    <!-- Custom styles for this template -->
    <link href="cover.css" rel="stylesheet">
</head>
<body class="d-flex h-100 text-center text-white bg-dark">
<%
    String error = request.getParameter("error");
    if (error != null && !error.isEmpty()) {
%>
<div class="alert alert-danger alert-custom" id="errorAlert">
    <%= error %>
</div>
<script>
    setTimeout(function() {
        var errorAlert = document.getElementById("errorAlert");
        if (errorAlert) {
            errorAlert.style.display = "none"; // Hide the alert after 3 seconds
        }
    }, 3000); // 3000 milliseconds = 3 seconds
</script>
<% } %>

<%
    String successMessage = request.getParameter("successMessage");
    if (successMessage != null && !successMessage.isEmpty()) {
%>
<div class="alert alert-success alert-custom" id="successAlert">
    <%= successMessage %>
</div>
<script>
    setTimeout(function() {
        var successAlert = document.getElementById("successAlert");
        if (successAlert) {
            successAlert.style.display = "none"; // Hide the alert after 3 seconds
        }
    }, 3000); // 3000 milliseconds = 3 seconds
</script>
<%
    }
%>
<div class="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
    <header class="mb-auto">
        <div>
            <h3 class="float-md-start mb-0">GameApp</h3>
            <nav class="nav nav-masthead justify-content-center float-md-end">
                <a class="nav-link active" aria-current="page" href="#">Home</a>
                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#loginModal">Sign in</a>
                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#signupModal">Sign up</a>
            </nav>
        </div>
    </header>

    <!-- Signup Modal -->
    <div class="modal fade" id="signupModal" tabindex="-1" aria-labelledby="signupModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark">
                <div class="modal-header">
                    <h5 class="modal-title" id="signupModalLabel">Créer un compte</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Signup form -->
                    <form action="register" method="post" onsubmit="return validateForm()">
                        <div class="form-outline mb-4">
                            <input type="text" id="form3Example1cg" name="username"
                                   class="form-control form-control-lg" required/>
                            <label class="form-label" for="form3Example1cg">Pseudo</label>
                        </div>

                        <div class="form-outline mb-4">
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="genre" id="homme"
                                       value="Homme" required>
                                <label class="form-check-label" for="homme">Homme</label>
                            </div>
                            <div class="form-check form-check-inline">
                                <input class="form-check-input" type="radio" name="genre" id="femme"
                                       value="Femme">
                                <label class="form-check-label" for="femme">Femme</label>
                            </div>
                            <%--                                                <label class="form-label d-block">Genre</label>--%>

                        </div>

                        <div class="form-outline mb-4">
                            <input type="number" id="form3Example33cg" name="age"
                                   class="form-control form-control-lg" required min="1"
                                   oninput="validateAge(this)"/>
                            <small id="ageError" class="text-danger"></small>
                            <label class="form-label" for="form3Example33cg">Age</label>

                        </div>

                        <div class="form-outline mb-4">
                            <input type="password" id="form3Example4cg" name="password"
                                   class="form-control form-control-lg" required/>
                            <label class="form-label" for="form3Example4cg">Password</label>
                        </div>

                        <div class="form-outline mb-4">
                            <input type="password" id="form3Example4cdg" name="confirm_password"
                                   class="form-control form-control-lg" required/>
                            <label class="form-label" for="form3Example4cdg">Repeat your password</label>
                        </div>

                        <div class="form-check d-flex justify-content-center mb-5">
                            <input class="form-check-input me-2" type="checkbox" value=""
                                   id="form2Example3cg" required/>
                            <label class="form-check-label" for="form2Example3cg">
                                I agree all statements in <a href="#!" class="text-body"><u>Terms of
                                service</u></a>
                            </label>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block btn-lg">Register</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Login Modal -->
    <div class="modal fade" id="loginModal" tabindex="-1" aria-labelledby="loginModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content bg-dark">
                <div class="modal-header">
                    <h5 class="modal-title" id="loginModalLabel">Connexion</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <!-- Login form -->
                    <form action="login" method="post">
                        <div class="mb-3">
                            <label for="username" class="form-label">Username</label>
                            <input type="text" id="username" name="username" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label for="password" class="form-label">Password</label>
                            <input type="password" id="password" name="password" class="form-control" required>
                        </div>
                        <button type="submit" class="btn btn-primary">Send</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <main class="px-3">
        <h1 class="display-4 fw-bold">Speedest Game</h1>
        <p class="lead fw-bold">Bienvenue dans le jeu de carte de rapidité, Inscrivez-vous et lancez votre partie</p>
        <p class="lead">
            <a data-bs-toggle="modal" data-bs-target="#loginModal" class="btn btn-lg btn-dark fw-bold border-white bg-dark">Jouer</a>
        </p>
    </main>

    <footer class="mt-auto text-white-50">
        <p>Cover template for <a href="https://getbootstrap.com/" class="text-white">Bootstrap</a>, by <a
                href="https://twitter.com/mdo" class="text-white">@mdo</a>.</p>
    </footer>
</div>
<script>
    function validateModalPW(){

    }

    function validateForm() {
        var ageInput = document.getElementById('form3Example33cg');
        if (isNaN(ageInput.value) || ageInput.value < 1) {
            document.getElementById('ageError').innerText = 'Please enter a valid age.';
            return false;
        }
        return true;
    }

    function validateAge(input) {
        document.getElementById('ageError').innerText = '';
        if (isNaN(input.value) || input.value < 1) {
            document.getElementById('ageError').innerText = 'Age must be a number.';
        }
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>