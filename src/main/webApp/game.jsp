<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Game Page</title>
    <style>
        .player-score {
            margin: 10px;
            padding: 10px;
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        #centerLetter {
            font-size: 24px;
            text-align: center;
            margin: 20px;
            font-weight: bold;
        }
        .player-card {
            padding: 5px;
            margin-left: 10px;
            font-weight: bold;
            color: #333;
            background-color: #fff;
            border: 1px solid #ddd;
        }
        #playerLetters div {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        #scoreButton {
            display: block;
            margin: 20px auto;
        }


    </style>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">Card Game</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav ms-auto">
                <li class="nav-item">
                    <a class="nav-link active" aria-current="page" href="#">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#">Profile</a>
                </li>
            </ul>
        </div>
    </div>
</nav>
<div class="container mt-5">
    <h1 class="text-center mb-4">Game has started!</h1>
    <div class="game-info d-flex justify-content-around align-items-center mb-4">
        <h2>Tour <span id="tour">1</span></h2>
        <h3>Im the user: <span id="current-user">Username</span></h3>
        <div id="timerDisplay">Time left: <span id="time">10</span> seconds</div>
    </div>

    <div id="centerLetter" class="center-letter mb-3"></div>

    <div id="playerScores" class="player-scores mb-3"></div>
    <div id="playerLetters" class="player-letters mb-3"></div>

    <div class="text-center">
        <button id="sameColor" onclick="handleSameColorButton(localStorage.getItem('username'))" class="btn btn-primary">The Same Color</button>
        <button id="sameFormat" onclick="handleSameFormatButton(localStorage.getItem('username'))" class="btn btn-primary">The Same Format</button>
        <button id="both" onclick="handleboth(localStorage.getItem('username'))" class="btn btn-primary">The Two</button>
    </div>

    <div id="notification" style="display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); background-color: black; color: white; padding: 20px; border-radius: 10px; z-index: 1000;">Notification</div>
</div>
<button id="scoreButton">card</button>

<script>
    let socket;
    let userResults = {};
    let currentTour = 0;
    let currentCarte=0;
    let centerCarte;
    let timerDuration =0 ; // Timer duration in seconds
    let countdown; // Variable to hold the countdown interval
    let playerscores={};
    let playerCards=[];
    let numberTours=0;
    window.onload = function() {
        console.log("everything is loaded")
        initializeGame();
        startTimer();

    };

    function initializeGame(){
        let username=localStorage.getItem('username');
        document.querySelector("h3").textContent=username
        let tour=document.getElementById("tour");
        currentTour++;
        tour.innerText=currentTour;
        playerscores = JSON.parse(localStorage.getItem('playersScore') || '{}');
        playerCards = JSON.parse(localStorage.getItem('playerCards') || '[]');
        centerCarte=JSON.parse(localStorage.getItem('centreCard'))
        numberTours=JSON.parse(localStorage.getItem('nbrTours'))
        timerDuration=JSON.parse(localStorage.getItem('timer') || 0);

        setCenterCarte(centerCarte);
        //tour.innerText = currentTour + 1; // Display current tour, human-readable (starting from 1)
        updateScores(playerscores, playerCards);// Display initial scores

        socket = new WebSocket('ws://localhost:8080/LearnSocket_war_exploded/userStatus?username=' + encodeURIComponent(username));

        socket.onmessage = function(event) {
            const data = JSON.parse(event.data);
            switch (data.action) {
                case 'stateUpdate':
                    //currentTour++; // Move to the next tour on state update
                    //tour.innerText = currentTour + 1; // Update the tour display
                    setCenterCarte(centerCartes);
                    updateScores(data.scores, data.cartes);
                    break;
                case 'scoreUpdate':
                    localStorage.setItem('playersScore', JSON.stringify(data.scores));
                    localStorage.setItem('cartes', JSON.stringify(data.cartes));
                    localStorage.setItem('carterCard', JSON.stringify(data.centerCards));
                    console.log(data)
                    console.log(data.scores)
                    playerscores=data.scores
                    playerCards=data.cartes
                    centerCarte=data.centerCards
                    updateScores(playerscores,playerCards) // data.cartes pour chaque user ca nouvelle carte
                    setCenterCarte(centerCarte);
                    break;
                case 'finTour':
                    showNotification("Time's up! Moving to the next round.");
                    // currentTour++;
                    console.log(data.tour)
                    currentTour=data.tour
                    document.getElementById("tour").innerText = currentTour;
                    resetTimer();
                    break;
                case 'redirect':
                    //alert("the game is finished")
                    console.log(JSON.stringify(data.winner))
                    localStorage.setItem('winner', JSON.stringify(data.winner));
                    localStorage.setItem('loser', JSON.stringify(data.loser));
                    localStorage.setItem('loserScore', JSON.stringify(data.loserScore));
                    localStorage.setItem('winnerScore', JSON.stringify(data.winnerScore));

                    window.location.href = data.url;
                    break;
            }
        };

        document.getElementById('scoreButton').addEventListener('click', function() {
            let username = localStorage.getItem('username'); // Get the username from localStorage
            let userCard = cartes[Object.keys(playerscores).indexOf(username)]; // Get the card of the user
            let centerCard = this.textContent;
            if (userCard === centerCard) {
                playerscores[username] = playerscores[username] + 1 || 1;  // Increment score or initialize if undefined
                console.log(username+"Wins")
                console.log(cartes)
                socket.send(JSON.stringify({ action: 'updateScore', scoresUpdate: playerscores }));
            }
        });
    }
    function showNotification(message) {
        const notification = document.getElementById('notification');
        notification.textContent = message;
        notification.style.display = 'block';
        notification.style.opacity = '1';

        setTimeout(() => {
            notification.style.opacity = '0';
            setTimeout(() => {
                notification.style.display = 'none';
            }, 500); // Wait for the opacity transition to finish
        }, 3000); // Display the message for 3 seconds
    }
    function startTimer() {
        let timeLeft = timerDuration;
        document.getElementById('time').innerText = timeLeft;
        countdown = setInterval(function() {
            timeLeft--;
            document.getElementById('time').innerText = timeLeft;
            if (timeLeft <= 0) {
                clearInterval(countdown);
                if (currentTour < numberTours) {
                    socket.send(JSON.stringify({ action: 'finTour', scoresUpdate: playerscores,playerCards:playerCards,currentTour:currentTour }));
                   // Reset the timer as we move to the next round
                } else {
                    const partieDetails={numberTours,timerDuration}
                    socket.send(JSON.stringify({action:'finPartie',resultat:playerscores,partieDetails:partieDetails}))
                    //alert("Game Over. Final scores: " + JSON.stringify(playerscores));
                }
            }
        }, 1000);
    }

    function resetTimer() {
        clearInterval(countdown); // Stop the current timer
        startTimer(); // Start a new timer
    }

    function setCenterCarte(centerCarte) {
        // currentCarte++;
        // Generate a random index based on the length of centerCartes
        const scoreButton = document.getElementById('scoreButton');
        scoreButton.textContent = centerCarte.carte; // Display random card on button
        scoreButton.setAttribute('data-color', centerCarte.color); // Store color in attribute
        scoreButton.style.backgroundColor = centerCarte.color; // Assign random color
    }




    function updateScores(scores, playerCards) {
        console.log(playerCards)
        const scoresDiv = document.getElementById('playerScores');
        scoresDiv.innerHTML = '';
        Object.entries(scores).forEach(([player, score], index) => {
            const playerDiv = document.createElement("div");
            playerDiv.textContent = player + " : " + score + " : ";
            playerDiv.className = 'player-score';

            const cardSpan = document.createElement("span");
            cardSpan.className = 'player-card';
            cardSpan.id=player
            const foundCard = playerCards.find(card => card.username === player);
            if (foundCard) {
                cardSpan.textContent = foundCard.carte || "No card"; // Show the card information
                cardSpan.setAttribute('data-color', foundCard.color); // Set the color data attribute
                cardSpan.style.backgroundColor = foundCard.color; // Set the background color
                console.log(foundCard.color)
                console.log(foundCard.carte)
            } else {
                cardSpan.textContent = "No card"; // Default text if no card is found
                cardSpan.style.backgroundColor = "gray"; // Default color if no card is found
            }
            playerDiv.appendChild(cardSpan);

            scoresDiv.appendChild(playerDiv);
        });
    }

function handleSameColorButton(playerName){
    // Add event listeners to buttons
        const scoreButton = document.getElementById('scoreButton');
        const playerCard = document.querySelector('#'+playerName); // Simplified; should select based on actual user interaction
        if (playerCard.getAttribute('data-color') === scoreButton.getAttribute('data-color')) {
            if (playerscores.hasOwnProperty(playerName)) {
                playerscores[playerName] += 1; // Increment the score
                socket.send(JSON.stringify({ action: 'updateScore', scoresUpdate: playerscores,playerCards:playerCards }));
               // alert("Correct! The colors match. Score for " + playerName + " is now " + playerscores[playerName]);
            } else {
                //alert("Player not found in score tracking.");
                console.log("n9ess Score")
            }
        } else {
           // alert("Incorrect! The colors do not match.");
            console.log("n9ess Score")

        }
}
    function handleSameFormatButton(playerName){
            const scoreButton = document.getElementById('scoreButton');
            const playerCard = document.querySelector('#'+playerName); // Simplified; should select based on actual user interaction
            if (playerCard.textContent === scoreButton.textContent) {
                if (playerscores.hasOwnProperty(playerName)) {

                    playerscores[playerName] += 1; // Increment the score
                    socket.send(JSON.stringify({ action: 'updateScore', scoresUpdate: playerscores }));
                    //alert("Correct! The formats match. Score for " + playerName + " is now " + playerscores[playerName]);
                } else {
                    //alert("Player not found in score tracking.");
                    console.log("n9ess Score")

                }
            } else {
                //alert("Incorrect! The formats do not match.");
                console.log("n9ess Score")

            }
    }

    function handleboth(playerName){
        const scoreButton = document.getElementById('scoreButton');
        const playerCard = document.querySelector('#'+playerName); // Simplified; should select based on actual user interaction
        if (playerCard.textContent === scoreButton.textContent &&
            playerCard.getAttribute('data-color') === scoreButton.getAttribute('data-color')) {
            if (playerscores.hasOwnProperty(playerName)) {

                playerscores[playerName] += 1; // Increment the score
                socket.send(JSON.stringify({ action: 'updateScore', scoresUpdate: playerscores }));
                //alert("Correct! Both color and format match.. Score for " + playerName + " is now " + playerscores[playerName]);
            } else {
                //alert("Player not found in score tracking.");
                console.log("n9ess Score")

            }
        } else {
            //alert("Incorrect! Both color and format do not match.");
            console.log("n9ess Score")

        }
    }




</script>
</body>
</html>



</script>


</body>
</html>
