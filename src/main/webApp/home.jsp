<%@ page import="java.util.Map" %><%--
  Created by IntelliJ IDEA.
  User: acer swift 3
  Date: 20/04/2024
  Time: 20:24
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Connected Users</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script>
        var username = '<%= session.getAttribute("username") %>'; // Get username from HttpSession
    </script>
    <style>
        #sidebar {
            position: fixed;
            left: 0;
            top: 0;
            height: 100%;
            width: 250px;
            background-color: #f8f9fa;
            padding: 20px;
            box-shadow: 3px 0 5px rgba(0,0,0,0.1);
        }
        #userList {
            list-style: none;
            padding: 0;
        }
        #userList li {
            padding: 8px;
            border-bottom: 1px solid #ddd;
            color: #333;
        }
        #userList li:last-child {
            border-bottom: none;
        }
        .user-online {
            margin-right: 10px;
            height: 10px;
            width: 10px;
            background-color: #28a745;
            border-radius: 50%;
            display: inline-block;
        }
        #main-content {
            margin-left: 270px;
            padding: 20px;
        }
        body {
            background-color: #e9ecef;
            height: 100vh;
            margin: 0;
        }
        .navbar {
            background-color: rgba(0, 0, 0, 0.5);
            color: white;
        }
        .navbar a {
            color: white;
        }
    </style>
</head>
<body>

<div class="container mt-5 pt-5">
    <!-- Toast Container -->
    <div class="position-fixed bottom-0 end-0 p-3" style="z-index: 11">
        <div id="liveToast" class="toast" role="alert" aria-live="assertive" aria-atomic="true">
            <div class="toast-header">
                <strong class="me-auto">Notification</strong>
                <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
            </div>
            <div class="toast-body">
                <!-- Message will be set dynamically -->
            </div>
        </div>
    </div>
</div>
<div id="sidebar">
    <h1>Connected Users</h1>
    <ul id="userList">
        <%-- Server-side code to dynamically list users --%>
        <%
            String currentUsername = (String) session.getAttribute("username");

            Map<String, HttpSession> connectedUsers = (Map<String, HttpSession>) session.getAttribute("connectedUsers");
            if (connectedUsers != null) {
                for (Map.Entry<String, HttpSession> entry : connectedUsers.entrySet()) {
                    if (!entry.getKey().equals(currentUsername)) {
                        out.println("<li id='user-" + entry.getKey() + "'><span class='user-online'></span>" + entry.getKey() + "</li>");
                    }
                }
            }
        %>
    </ul>
</div>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark fixed-top">
    <div class="container-fluid">
        <!-- Navbar brand/logo can go here -->
        <a class="navbar-brand" href="#">GameApp</a>

        <!-- Toggler button for mobile view -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Navbar links and forms -->
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="#">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="profile.jsp">Profile</a>
                </li>
            </ul>
            <form class="d-flex" action="logout" method="post">
                <button type="submit" class="btn btn-outline-danger">Logout</button>
            </form>
        </div>
    </div>
</nav>

<div id="main-content">
    <div class="container mt-5 pt-5">
        <h2>Game Setup</h2>
        <form class="row g-3" id="gameForm">
            <div class="col-md-6">
                <label for="nbrTour" class="form-label">Number of Tours</label>
                <input type="number" class="form-control" id="nbrTour" name="nbrTour">
            </div>
            <div class="col-md-6">
                <label for="timer" class="form-label">Timer (minutes per game)</label>
                <input type="number" class="form-control" id="timer" name="timer">
            </div>
            <div class="col-md-6">
                <label for="combinaison" class="form-label">Number of Combinations</label>
                <input type="number" class="form-control" id="combinaison" name="combinaison">
            </div>
            <h3>Please Select users that you need to invite</h3>
            <input type="text" id="invitees" placeholder="Enter usernames, comma-separated" required>
<%--            <button type="button" onclick="sendInvitation()">Send Invitation</button>--%>
            <div class="col-12">
                <button type="submit" onclick="sendInvitation()" class="btn btn-primary" id="startGameButton">Start Game</button>
                <button type="reset" class="btn btn-secondary">Reset</button>
            </div>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz" crossorigin="anonymous"></script>

<script>

    window.onload = function () {
        const urlSearchParams = new URLSearchParams(window.location.search);
        const params = Object.fromEntries(urlSearchParams.entries());
        if (params.successMessage) {
            const toastElement = document.getElementById('liveToast');
            const toastBody = toastElement.querySelector('.toast-body');
            toastBody.textContent = params.successMessage; // Set the success message from URL parameter
            const toast = new bootstrap.Toast(toastElement);
            toast.show();
            setTimeout(() => {
                toast.hide();
            }, 5000); // Hide after 5 seconds
        }
    };
    document.getElementById('gameForm').addEventListener('submit', function(event) {
        var inviteesInput = document.getElementById('invitees').value;
        if (inviteesInput.trim() === '') {
            alert('Please enter at least one username to invite.');
            event.preventDefault(); // Prevent form submission
        }
    });
    var userName = '<%= session.getAttribute("username") %>'; // Get username from session--%>
    localStorage.setItem('username', userName);

    var wsUrl = 'ws://localhost:8080/LearnSocket_war_exploded/userStatus?username=' + encodeURIComponent(username);
    var ws = new WebSocket(wsUrl);

    ws.onmessage = function(event) {
        var data = JSON.parse(event.data);
        var userList = document.getElementById("userList");
        console.log(data)
        switch (data.action) {
            case "login":
                // Handle login by adding a new user to the list
                var userList = document.getElementById("userList"); // Ensure you have this element correctly referenced

                var newUserItem = document.createElement("li");
                newUserItem.id = 'user-' + data.username; // data.username should contain the username of the newly logged-in user

                // Create the span for the green dot indicator
                var span = document.createElement("span");
                span.className = 'user-online'; // Assign the online indicator class

                // Append the span to the list item
                newUserItem.appendChild(span);

                // Add text node for the username with a space after the green dot
                var textNode = document.createTextNode(" " + data.username);
                newUserItem.appendChild(textNode);

                // Append the new list item to the unordered list
                userList.appendChild(newUserItem);
                break;
            case "logout":
                // Handle logout by removing user from list
                var userItem = document.getElementById('user-' + data.username);
                if (userItem) {
                    userList.removeChild(userItem);
                }
                break;
            case "invitation":
                // Handle invitation prompt
                var sender = data.sender;
                console.log(sender)
                if (confirm("Invitation from " + sender + ": accept or reject?")) {
                    ws.send(JSON.stringify({action: "response", sender: sender, response: "accept"}));
                } else {
                    ws.send(JSON.stringify({action: "response", sender: sender, response: "reject"}));
                }
                break;
            case "redirect":
                // Handle redirection with game preparation
                console.log(JSON.stringify(data.playerCards))
                localStorage.setItem('playersScore', JSON.stringify(data.scores));
                localStorage.setItem('playerCards', JSON.stringify(data.playerCards));
                localStorage.setItem('nbrTours', JSON.stringify(data.nbrTours));
                localStorage.setItem('centreCard', JSON.stringify(data.centreCard));
                localStorage.setItem('timer', JSON.stringify(data.timer));

                window.location.href = data.url;
                break;
        }
    };

    function sendInvitation() {

        const invitees = document.getElementById('invitees').value.trim();
        if (invitees) {
            // Collecting additional form data
            const nbrTour = document.getElementById('nbrTour').value; // Number of games
            const timer = document.getElementById('timer').value; // Timer per game
            const combinaison = document.getElementById('combinaison').value; // Number of combinations
            // Constructing a data object to send
            const dataToSend = {
                action: "invite",
                invitees: invitees, // Sending invitees as an array
                gameDetails: {
                    nbrPartie: nbrTour,
                    timer: timer,
                    combinaison: combinaison
                }
            };
            ws.send(JSON.stringify(dataToSend));
           // ws.send(JSON.stringify({action: "invite", invitees: invitees}));
        } else {
            alert('Please enter at least one username');
        }
    }
</script>
</body>
</html>
