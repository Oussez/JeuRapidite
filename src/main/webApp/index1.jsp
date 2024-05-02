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
    <link rel=”stylesheet” href=”https://cdn.jsdelivr.net/npm/bootstrap-icons@1.3.0/font/bootstrap-icons.css” />
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

    </style>


    <!-- Custom styles for this template -->
    <link href="cover.css" rel="stylesheet">
</head>
<body class="d-flex h-100 text-center text-white bg-dark">

<div class="cover-container d-flex w-100 h-100 p-3 mx-auto flex-column">
    <header class="mb-auto">
        <div>
            <h3 class="float-md-start mb-0">GameApp</h3>
            <!-- Lien Sign up qui ouvre la modale -->
            <nav class="nav nav-masthead justify-content-center float-md-end">
                <a class="nav-link active" aria-current="page" href="#">Home</a>
                <a class="nav-link" href="login.jsp">Sign in</a>

                <!-- Utilisez data-bs-toggle et data-bs-target pour ouvrir la modale -->
                <a id="signupLink" class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#signupModal">Sign up</a>
            </nav>

            <!-- Modale Bootstrap pour le formulaire de création de compte -->
            <div class="modal fade" id="signupModal" tabindex="-1" aria-labelledby="signupModalLabel"
                 aria-hidden="true">
                <div class="modal-dialog">
                    <div class="modal-content bg-dark">
                        <div class="modal-header">
                            <h5 class="modal-title" id="signupModalLabel">Créer un compte</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                        </div>
                        <div class="modal-body">
                            <!-- Votre formulaire de création de compte -->
                            <div class="card-body p-5 ">
                                    <% if (request.getAttribute("successMessage") != null) { %>
                                <div class="success-message">
                                    <%= request.getAttribute("successMessage") %>
                                </div>
                                    <% } %>
                                <form action="register" method="post" onsubmit="return validateForm()">


                                    <div class="form-outline mb-4">
                                        <input type="text" id="form3Example1cg" name="username"
                                               class="form-control form-control-lg" required
                                               oninput="validateUserName(this);"/>
                                        <label class="form-label" for="form3Example1cg">Pseudo</label>
                                        <small id="usernameError" class="text-danger">
                                            <% //from registerServlet if username exists in database
                                                 String usernameError = request.getParameter("usernameError");
                                                if (usernameError != null) {
                                                    out.print(usernameError);
                                                } %>
                                        </small>
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
                                               class="form-control form-control-lg" required min="1" max="99"
                                               oninput="validateAge(this);"/>
                                        <small id="ageError" class="text-danger"></small>
                                        <label class="form-label" for="form3Example33cg">Age</label>

                                    </div>

                                    <div class="form-outline mb-4">
                                        <input type="password" id="form3Example4cg" name="password"
                                               class="form-control form-control-lg" required
                                               oninput="validateMdp(this);validateMdpConf(document.getElementById('form3Example4cdg'))"/>
                                        <span class="password-toggle" onclick="togglePasswordVisibility()"><i class="bi bi-eye-slash"></i>
                                        </span>
                                        <small id="mdp1Error" class="text-danger"></small>
                                        <label class="form-label" for="form3Example4cg">Mot de passe <span style="color:red"><b>*</b></span></label>
                                    </div>



                                    <div class="form-outline mb-4">
                                        <input type="password" id="form3Example4cdg" name="confirm_password"
                                               class="form-control form-control-lg" required
                                               oninput="validateMdpConf(this)"/>
                                        <small id="mdp2Error" class="text-danger"></small>
                                        <label class="form-label" for="form3Example4cdg">Confirmez le mot de passe <span style="color:red"><b>*</b></span></label>
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

    </header>

    <main class="px-3">
        <h1 class="display-4 fw-bold">Speedest Game</h1>
        <!-- Utilisez "display-1" à "display-4" pour des tailles variées -->
        <p class="lead fw-bold">Bienvenue dans le jeu de carte de rapidité, Inscrivez-vous et lancez votre partie</p>
        <p class="lead">
            <a href="login.jsp" class="btn btn-lg btn-dark fw-bold border-white">Jouer</a>
        </p>
    </main>


    <footer class="mt-auto text-white-50">
        <p>Cover template for <b class="text-white">UPPA</b>, by <b
                 class="text-white">Oussama & Salah</b>.</p>
    </footer>
</div>
<script>
    let formAge, formMdp, formMdpConf, formUserName;
    function validateForm() {
        if (!formAge || !formMdp || !formMdpConf || !formUserName) {
            return false;
        }
        return true;
    }

    function validateAge(input) {
        formAge= true;
        document.getElementById('ageError').innerText = '';
        if (isNaN(input.value) || input.value <12) {
            formAge=false;
            document.getElementById('ageError').innerText = 'Votre age doit etre >=12';
        }
    }

    function validateUserName(input) {
        formUserName = true;
        document.getElementById('usernameError').innerText = '';
        if (input.value.trim() === "") {
            formUserName = false;
            document.getElementById('usernameError').innerText = 'Veuillez saisir un username sans espace';
        }
    }

    function validateMdp(input) {
        var mdp = input.value;
        var majusculeRegex = /[A-Z]/;
        var minusculeRegex = /[a-z]/;
        var chiffreRegex = /[0-9]/;
        var errorElement = document.getElementById("mdp1Error"); // Récupérer l'élément pour afficher les erreurs
        let errorMessages="le mot de passe doit contenir au moins ";
        formMdp = false;
        if (mdp.length < 8) {
            errorMessages += "8 caractères, ";
        }

        if (!majusculeRegex.test(mdp)) {
            errorMessages += "une lettre majuscule, ";
        }

        if (!minusculeRegex.test(mdp)) {
            errorMessages += "une lettre minuscule, ";
        }

        if (!chiffreRegex.test(mdp)) {
            errorMessages += "un chiffre, ";
        }

        if (errorMessages.endsWith(", ")) {
            errorMessages = errorMessages.slice(0, -2);
        }

        // Afficher les messages d'erreur
        if (mdp.length >= 8 && majusculeRegex.test(mdp) && minusculeRegex.test(mdp) && chiffreRegex.test(mdp)) {
            errorElement.textContent = ""; // Effacer le message d'erreur
            formMdp = true;
        } else {
            errorElement.textContent = errorMessages; // Afficher les messages d'erreur
        }


    }

    function validateMdpConf(input){
        var motDePasse = document.getElementById("form3Example4cg").value;
        var errorElement = document.getElementById("mdp2Error"); // Récupérer l'élément pour afficher les erreurs
        formMdpConf =false;
        if(motDePasse ==="" || motDePasse !==input.value) {
            if (motDePasse === "") {
                errorElement.textContent = "Merci de remplir le champ de Mot de Passe."
            }
            if (motDePasse !== input.value) {
                errorElement.textContent = "Les mots de passe ne correspondent pas."
            }
        }
        else{
            errorElement.textContent="";
            formMdpConf=true;
        }
    }

//Liason entre le bouton 'register' dans la page login.jsp et le formulaire register de la page index.jsp
        document.addEventListener('DOMContentLoaded', function () {
            var urlParams = new URLSearchParams(window.location.search);
            var triggerModal = urlParams.get('triggerModal');

            if (triggerModal === 'true') {
                document.getElementById('signupLink').click();
            }
        });

</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
        crossorigin="anonymous"></script>

</body>
</html>