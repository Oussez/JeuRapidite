<%--
  Created by IntelliJ IDEA.
  User: acer swift 3
  Date: 26/04/2024
  Time: 23:52
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Winner Announcement</title>
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff;
            margin: 0;
            text-align: center;
        }
        .announcement {
            display: none;
            padding: 40px;
            border-radius: 15px;
            background: rgba(255, 255, 255, 0.8);
            backdrop-filter: blur(10px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.2);
            transition: all 0.5s ease-in-out;
            opacity: 0;
            transform: scale(0.8);
        }
        .announcement.visible {
            opacity: 1;
            transform: scale(1);
            display: block;
        }
        .results {
            font-size: 1.2em;
            margin: 10px 0;
            color: #003366; /* Dark blue color */

        }
        .button {
            font-size: 1em;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            background-color: #4CAF50;
            color: white;
            cursor: pointer;
            margin-top: 20px;
        }
        .winner {
            color: #4CAF50; /* Green color for the winner */
        }
        .loser {
            color: #FF5722; /* Red color for the loser */
        }
    </style>
</head>
<body>
<div id="announcement" class="announcement">
    <p class="results" >Gagnant : <span id="winnerName" class="winner"></span></p>
    <p class="results">Perdant : <span id="loserName" class="loser"></span></p>
    <a href="/LearnSocket_war_exploded/home.jsp" class="button">Rejouer</a>
</div>
<script>
    // Function to display the winner and loser
    function displayWinnerAndLoser() {
        const winner = JSON.parse(localStorage.getItem('winner'));
        const loser = JSON.parse(localStorage.getItem('loser')); // Retrieve the loser from local storage
        const loserScore = JSON.parse(localStorage.getItem('loserScore')); // Convert to float
        const winnerScore = JSON.parse(localStorage.getItem('winnerScore')); // Convert to float

        // Format the scores to remove any unnecessary decimal places if they are whole numbers
        // const formattedWinnerScore = (winnerScore % 1 === 0) ? Math.floor(winnerScore) : winnerScore.toFixed(1);
        // const formattedLoserScore = (loserScore % 1 === 0) ? Math.floor(loserScore) : loserScore.toFixed(1);

        // Set the text content for winner and loser
        document.getElementById('winnerName').textContent = winner+"(Score: "+winnerScore + " ) ";
        document.getElementById('loserName').textContent = loser + "(Score: "+loserScore+" ) ";

        // Make the announcement visible with an animation
        const announcementDiv = document.getElementById('announcement');
        announcementDiv.classList.add('visible');
    }

    // Set a timeout to delay the announcement for 3 seconds
    setTimeout(displayWinnerAndLoser, 2000);
</script>
</body>
</html>
