<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script>
        $(document).ready(function() {
            var username = '<%= (String) session.getAttribute("username") %>';
            console.log(username)
            $.ajax({
                url: '/LearnSocket_war_exploded/profileServlet',
                type: 'GET',
                data: {username: username},
                success: function(joueur) {
                    $('#pseudo').val(joueur.pseudo);
                    $('#age').val(joueur.âge);
                    $('#genre').val(joueur.genre);
                    $('#nbrPart').val(joueur.nombrePartiesJouées);
                    $('#nbrVict').val(joueur.nombreVictoires);
                    $('#moy').val(joueur.scoreMoyen);
                    $('#clcReussi').val(joueur.ratioClicRéussi);
                    $('#clcRapide').val(joueur.ratioClicRapide);


                    console.log('Data loaded successfully');
                },
                error: function() {
                    alert('Error loading data');
                }
            });
        });
    </script>
    <!-- Ajoutez ici vos références CSS ou tout autre élément de tête nécessaire -->
</head>
<style>
    body {
        margin: 0;
        padding-top: 40px;
        color: #2e323c;
        background: #f5f6fa;
        position: relative;
        height: 100%;
    }

    .account-settings .user-profile {
        margin: 0 0 1rem 0;
        padding-bottom: 1rem;
        text-align: center;
    }

    .account-settings .user-profile .user-avatar {
        margin: 0 0 1rem 0;
    }

    .account-settings .user-profile .user-avatar img {
        width: 90px;
        height: 90px;
        -webkit-border-radius: 100px;
        -moz-border-radius: 100px;
        border-radius: 100px;
    }

    .account-settings .user-profile h5.user-name {
        margin: 0 0 0.5rem 0;
    }

    .account-settings .user-profile h6.user-email {
        margin: 0;
        font-size: 0.8rem;
        font-weight: 400;
        color: #9fa8b9;
    }

    .account-settings .about {
        margin: 2rem 0 0 0;
        text-align: center;
    }

    .account-settings .about h5 {
        margin: 0 0 15px 0;
        color: #007ae1;
    }

    .account-settings .about p {
        font-size: 0.825rem;
    }

    .form-control {
        border: 1px solid #cfd1d8;
        -webkit-border-radius: 2px;
        -moz-border-radius: 2px;
        border-radius: 2px;
        font-size: .825rem;
        background: #ffffff;
        color: #2e323c;
    }

    .card {
        background: #ffffff;
        -webkit-border-radius: 5px;
        -moz-border-radius: 5px;
        border-radius: 5px;
        border: 0;
        margin-bottom: 1rem;
    }
</style>
<body>

    <% String pseudo = (String) session.getAttribute("pseudo"); %>

    <div class="container">
    <%-- Success message display --%>
    <%
        String updateStatus = (String) session.getAttribute("updateStatus");
        if(updateStatus != null && !updateStatus.isEmpty()) {
            out.println("<div id='successMessage' class='alert alert-success' role='alert'>" + updateStatus + "</div>");
            session.removeAttribute("updateStatus"); // Remove attribute so it doesn't show again after refresh
        }
    %>
    <form action="profileServlet" method="POST">
        <div class="row gutters">
            <div class="col-xl-3 col-lg-3 col-md-12 col-sm-12 col-12">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="account-settings">
                            <div class="user-profile">
                                <div class="user-avatar">
                                    <img src="https://bootdey.com/img/Content/avatar/avatar7.png" alt="Maxwell Admin">
                                </div>
                                <h5 class="user-name"><%= pseudo %>
                                </h5>
                            </div>
                            <div class="about">
                                <h5>About</h5>
                                <p>Hey <%=pseudo%>, in the right side, you can see your profil's stats</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-xl-9 col-lg-9 col-md-12 col-sm-12 col-12">
                <div class="card h-100">
                    <div class="card-body">
                        <div class="row gutters">
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                                <h6 class="mb-2 text-primary">Personal Details</h6>
                            </div>

                            <!-- Personal Details Fields -->
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="pseudo">Pseudo</label>
                                    <input type="text" class="form-control" name="pseudo" readonly id="pseudo">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="age">Age</label>
                                    <input type="number" name="age" min="12" max="99" class="form-control" id="age">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="genre">Genre</label>
                                    <select class="form-control" name="genre" id="genre">
                                        <option value="Femme">Femme</option>
                                        <option value="Homme">Homme</option>
                                    </select>
                                </div>
                            </div>

                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <button type="button" id="changePW" name="changePassword" class="btn btn-secondary"
                                            data-bs-toggle="modal" data-bs-target="#passwordModal">
                                        Changer Mot de Passe
                                    </button>
                                </div>
                            </div>
                        </div>
                        <div class="row gutters">
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                                <h6 class="mt-3 mb-2 text-primary">Game Stats</h6>
                            </div>
                            <!-- Address Fields -->
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="nbrPart">Nombre de parties jouées</label>
                                    <input type="name" class="form-control"  readonly
                                           id="nbrPart">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="nbrVict">Nombre de victoires</label>
                                    <input type="name" class="form-control" readonly
                                           id="nbrVict">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="moy">Score Moyen</label>
                                    <input type="name" class="form-control"  readonly id="moy">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="clcReussi">RatioClicRéussi</label>
                                    <input type="name" class="form-control"  readonly
                                           id="clcReussi">
                                </div>
                            </div>
                            <div class="col-xl-6 col-lg-6 col-md-6 col-sm-6 col-12">
                                <div class="form-group">
                                    <label for="clcRapide">RatioClicRapide</label>
                                    <input type="name"  readonly class="form-control"
                                           id="clcRapide">
                                </div>
                            </div>
                        </div>
                        <div class="row gutters">
                            <div class="col-xl-12 col-lg-12 col-md-12 col-sm-12 col-12">
                                <div class="text-right">
                                    <button type="button" id="cancel" name="submit" class="btn btn-secondary" onclick="window.history.back();">Cancel</button>

                                    <button type="submit" id="submit" name="submit" class="btn btn-primary">Update
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </form>
        <div class="modal fade" id="passwordModal" tabindex="-1" aria-labelledby="passwordModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content bg-dark text-light">
                    <div class="modal-header">
                        <h5 class="modal-title" id="passwordModalLabel">Connexion</h5>

                    </div>
                    <div class="modal-body">
                        <!-- Login form -->
                        <form action="login" method="post" onsubmit="return validateModalPW()">
                            <%
                                String newPassword = request.getParameter("newPW");
                                String oldPWError = request.getParameter("oldPWError");
                            %>
                            <div class="mb-3">
                                <label for="oldPW" >mot de passe actuel</label>
                                <small id="oldPWError" class="text-danger">
                                      <%= (oldPWError != null) ? oldPWError: "" %>
                                </small>
                                <input type="text" id="oldPW" name="oldPW" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label for="newPW" class="form-label">Nouveau mot de passe</label>
                                <small id="newPWError" class="text-danger"></small>
                                <input type="text" id="newPW" name="newPW" class="form-control" required
                                       value="<%= (newPassword != null) ? newPassword: "" %>">
                            </div>
                            <div class="mb-3">
                                <label for="confNewPW" class="form-label">Confirmer mot de passe</label>
                                <small id="confNewPWError" class="text-danger"></small>
                                <input type="text" id="confNewPW" name="confNewPW" class="form-control" required
                                       value="<%= (newPassword!= null) ? newPassword: "" %>">
                            </div>
                            <button type="submit" class="btn btn-primary">Send</button>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close">Close</button>
                            <!-- Champ de formulaire caché pour transmettre l'action -->
                            <input type="hidden" name="action" value="verifyPassword">
                            <input type="hidden" name="psuedo" value="">
                        </form>
                    </div>
                </div>
            </div>
        </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.5.3/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx"
        crossorigin="anonymous"></script>
<%-- Vanilla JavaScript to hide the message after 3 seconds --%>
<script>

    function validateModalPW() {
        let formValidated = true;

        // Get the values of the old password, new password, and confirm new password fields
        var oldPW = document.getElementById("oldPW").value;
        var newPW = document.getElementById("newPW").value;
        var confNewPW = document.getElementById("confNewPW").value;

        // Reset error messages
        document.getElementById("oldPWError").innerText = "";
        document.getElementById("newPWError").innerText = "";
        document.getElementById("confNewPWError").innerText = "";

        // Perform validation checks
        switch (true) {
            case oldPW === newPW:
                document.getElementById("newPWError").innerText = "Le nouveau mot de passe doit être différent de l'ancien mot de passe.";
                formValidated = false;
                break;
            case !/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$/.test(newPW):
                document.getElementById("newPWError").innerText = "Le nouveau mot de passe doit contenir au moins 8 caractères, une lettre majuscule, une lettre minuscule et un chiffre.";
                formValidated = false;
                break;
            case newPW !== confNewPW:
                document.getElementById("confNewPWError").innerText = "Les nouveaux mots de passe ne correspondent pas.";
                formValidated = false;
                break;
            default:
                break;
        }

        // Return the overall validation status
        return formValidated;
    }


    document.addEventListener('DOMContentLoaded', function () {
        var urlParams = new URLSearchParams(window.location.search);
        var triggerModal = urlParams.get('triggerModal');
        var successMessageDiv = document.getElementById('successMessage');
        if (triggerModal === 'true') {
            document.getElementById('changePW').click();
        }

        if (successMessageDiv) {
            setTimeout(function () {
                successMessageDiv.style.display = 'none';
            }, 5000); // Hide the message after 5 seconds (5000 milliseconds)
        }
    });
</script>
</body>
</html>
