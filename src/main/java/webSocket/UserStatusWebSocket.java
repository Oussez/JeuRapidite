package webSocket;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;
import dao.JoueurDao;
import dao.ParticipationDAO;
import dao.PartieDao;
import dto.*;
import jakarta.servlet.http.HttpSession;
import jakarta.websocket.*;
import jakarta.websocket.server.ServerEndpoint;
import model.Joueur;
import model.Participation;
import model.Partie;

import java.io.IOException;
import java.lang.reflect.Type;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

@ServerEndpoint("/userStatus")
public class UserStatusWebSocket {
    // se sont les sessions de webSocket
    public static final Set<Session> sessions = Collections.synchronizedSet(new HashSet<>());
    public static Map<String, Set<String>> invitations = new ConcurrentHashMap<>();
    public static Map<String, Set<String>> acceptedInvitations = new ConcurrentHashMap<>();
    private static final char[] letters = {'A', 'B', 'C', 'D', 'E', 'F', 'H', 'I', 'J', 'K', 'L'};
    private static final String[] colors = {"red", "blue", "green"};
    private static final Random random = new Random();
    private static final Gson gson = new Gson();

    private static Set<String> players;

    private static int nbrTour = 0;
    private static int timer = 0;
    private static int combinaison = 0;

    private static int nbrUsers = 0;

    private static Set<String> processedUsers = new HashSet<>(); // To keep track of processed users

    @OnOpen
    public void onOpen(Session session, EndpointConfig config) {

        Map<String, List<String>> params = session.getRequestParameterMap();
        String username = params.get("username").get(0); // Be sure to handle potential nulls in production code
        System.out.println("the username is " + username);
        // new Session for the connected user ?
        session.getUserProperties().put("username", username);

        sessions.add(session);
    }

    @OnClose
    public void onClose(Session session) {
        sessions.remove(session);
    }


    @OnMessage
    public void onMessage(String message, Session session) throws IOException {
        Map<String, Object> data = gson.fromJson(message, new TypeToken<Map<String, Object>>() {
        }.getType());
        if (data != null && data.get("action") != null) {
            String action = (String) data.get("action");
            switch (action) {
                case "invite":
                    handleInvite(session, data);
                    break;
                case "response":
                    handleResponse(session, data);
                    break;
                case "updateScore":
                    System.out.println("On Update Score");
                    handleUpdateScore(data);
                    break;
                case "finTour":
                    System.out.println("FinTour");
                    handleUpdateScore(data);
                    handleFinTour(data);
                    break;
                case "finPartie":
                    System.out.println("FinPartie");
                    handleResult(data);
                    break;
                default:
                    System.out.println("Received an unhandled action type: " + action);
            }
        } else {
            System.out.println("Received malformed message: " + message);
        }
    }


//    public void handleResult(Map<String, Object> data) throws IOException {
//        // Assuming `resultat` is a JSON string of a Map where player names are keys and their scores are values
//        Gson gson = new Gson();
//        Type scoreType = new TypeToken<Map<String, Integer>>() {}.getType(); // Define the expected type of the scores map
//        Map<String, Integer> scores = gson.fromJson((String) data.get("resultat"), scoreType);
//
//        // Find the winner and loser based on scores
//        String winner = null;
//        String loser = null;
//        int maxScore = Integer.MIN_VALUE;
//        int minScore = Integer.MAX_VALUE;
//
//        for (Map.Entry<String, Integer> entry : scores.entrySet()) {
//            if (entry.getValue() > maxScore) {
//                maxScore = entry.getValue();
//                winner = entry.getKey();
//            }
//            if (entry.getValue() < minScore) {
//                minScore = entry.getValue();
//                loser = entry.getKey();
//            }
//        }
//
//        // Prepare the message to redirect to the winner page with winner and loser information
//        Map<String, String> gameInfo = new HashMap<>();
//        gameInfo.put("action", "redirect");
//        gameInfo.put("url", "WinnerPage.jsp");
//        gameInfo.put("winner", winner);
//        gameInfo.put("loser", loser);
//
//        String message = gson.toJson(gameInfo);
//
//        // Send the redirect message to all open sessions
//        System.out.println("Winner: " + winner + ", Loser: " + loser);
//        for (Session session : sessions) {
//            if (session.isOpen()) {
//                session.getBasicRemote().sendText(message);
//            }
//        }
//    }

    public void handleResult(Map<String, Object> data) throws IOException {
        Gson gson = new Gson();

        // Extracting the 'resultat' data which is expected to be a Map encoded as a JSON object.
        Object rawResultat = data.get("resultat");
        Object partieDetailsObject = data.get("partieDetails");
        String partieDetailsJson = gson.toJson(partieDetailsObject);  // Convert it back to JSON string if it's not.
        PartieDetails partieDetails = gson.fromJson(partieDetailsJson, PartieDetails.class);  // Convert JSON string to PartieDetails object

        System.out.println("***** Number Of tours:" + partieDetails.getNumberTours());
        String jsonResultat = gson.toJson(rawResultat);  // Convert it back to JSON string if it's not.
        Type scoreType = new TypeToken<Map<String, Double>>() {
        }.getType();
        Map<String, Double> scores = gson.fromJson(jsonResultat, scoreType);

        String winner = null, loser = null;
        double maxScore = Double.MIN_VALUE, minScore = Double.MAX_VALUE;
        String modeJeu = "Normal"; // Your mode of game
        // Saving partie
        Partie p = PartieManager.getPartie(partieDetails.getNumberTours(), timer, modeJeu);
        p.setDateHeure();

        PartieDao partieDao = new PartieDao();

        partieDao.save(p);

        ParticipationDAO participationDAO = new ParticipationDAO();
        JoueurDao joueurDao = new JoueurDao();


        // Iterate through the scores to find the winner and loser
        for (Map.Entry<String, Double> entry : scores.entrySet()) {
            String userPseudo = entry.getKey();
            double score=entry.getValue();
            if (entry.getValue() > maxScore) {
                maxScore = entry.getValue();
                winner = entry.getKey();

            }
            if (entry.getValue() < minScore) {
                minScore = entry.getValue();
                loser = entry.getKey();
            }
            // Saving pariticipation
            if (!processedUsers.contains(userPseudo) ) { // Check if the user has not been processed
                processedUsers.add(userPseudo); // Mark the user as processed

                Joueur j = joueurDao.findByPseudo(userPseudo);
                updatePlayerStats(j,score,userPseudo.equals(winner));
//                Integer nombrePartiesJouées = j.getNombrePartiesJouées();
//                if (nombrePartiesJouées == null) {
//                    System.out.println(userPseudo + "in null");
//                    j.setNombrePartiesJouées(1); // If null, initialize with the first game
//                } else {
//                    j.setNombrePartiesJouées(nombrePartiesJouées + 1);
//                }
//                j.setRatioClicRéussi(12.8);
//                Double scoreMoyenne=j.getScoreMoyen();
//                if(scoreMoyenne==0 ){
//                    System.out.println("Im here in scoreMoyene0"+userPseudo);
//                        j.setScoreMoyen(score);
//                }else{
//                    j.setScoreMoyen(scoreMoyenne*(nombrePartiesJouées)+score/(nombrePartiesJouées+1));
//                }
//                //j.setScoreMoyen(12.6);
//                //j.setNombreVictoires(20);
//                j.setRatioClicRapide(82.9);
//                System.out.println(winner+"===>"+userPseudo);
//                if(userPseudo.equals(winner)){
//                    System.out.println("Im the winner "+userPseudo);
//                    Integer nombreVictoires = j.getNombreVictoires();
//                    System.out.println("mY victory"+ nombreVictoires);
//                    if (nombreVictoires == null) {
//                        j.setNombreVictoires(1);  // Assuming the first victory if previously null
//                    } else {
//                        j.setNombreVictoires(nombreVictoires + 1);
//                    }
//                }
                joueurDao.save(j);



                if (j != null) {
                    Participation pa = new Participation();
                    pa.setJoueur(j);
                    pa.setPartie(p); // Assuming 'p' is your current game session object
                    pa.setScore((int) Math.round(entry.getValue()));
                    participationDAO.save(pa);
                } else {
                    System.err.println("User not found: " + userPseudo);
                }
            }
        }

        // Preparing the message to be sent back to the client
        Map<String, String> gameInfo = new HashMap<>();
        gameInfo.put("action", "redirect");
        gameInfo.put("url", "WinnerPage.jsp");
        gameInfo.put("winner", winner);
        gameInfo.put("loser", loser);
        System.out.println("Maaaaax Score : "+maxScore);
        gameInfo.put("winnerScore", String.valueOf(maxScore));
        gameInfo.put("loserScore", String.valueOf(minScore));



        String message = gson.toJson(gameInfo);
        System.out.println("Winner: " + winner + ", Loser: " + loser);

        // Broadcasting the result to all connected sessions
        for (Session session : sessions) {
            if (session.isOpen()) {
                session.getBasicRemote().sendText(message);
            }
        }
    }

    private void updatePlayerStats(Joueur joueur, double score, boolean isWinner) {
        Integer playedGames = joueur.getNombrePartiesJouées();
        joueur.setNombrePartiesJouées(playedGames == null ? 1 : playedGames + 1);
        joueur.setScoreMoyen((joueur.getScoreMoyen() * playedGames + score) / joueur.getNombrePartiesJouées());

        if (isWinner) {
            Integer victories = joueur.getNombreVictoires();
            joueur.setNombreVictoires(victories == null ? 1 : victories + 1);
        }
    }

    public void handleFinTour(Map<String, Object> data) throws IOException {

        double tourDouble = (Double) data.get("currentTour");
        int tour = (int) tourDouble; // Explicitly cast double to int
        System.out.println(tour);
        String message = gson.toJson(Map.of("action", "finTour", "tour", tour + 1));
        System.out.println(message);
        for (Session session : sessions) {
            if (session.isOpen()) {
                session.getBasicRemote().sendText(message);
            }
        }
    }

    private void handleInvite(Session session, Map<String, Object> data) throws IOException {
// Extract gameDetails as a Map
        Map<String, Object> gameDetails = (Map<String, Object>) data.get("gameDetails");

        if (gameDetails != null) {
            nbrTour = Integer.parseInt((String) gameDetails.get("nbrPartie"));
            timer = Integer.parseInt((String) gameDetails.get("timer"));
            combinaison = Integer.parseInt((String) gameDetails.get("combinaison"));

            // Debug output to check values
            System.out.println("Game Details - Number of Games: " + nbrTour + ", Timer: " + timer + ", Combinations: " + combinaison);
        }
        String senderUsername = (String) session.getUserProperties().get("username");
        System.out.println("Invite Par" + senderUsername);
        Set<String> currentInvitations = new HashSet<>();
        for (Session s : sessions) {
            String inviteeUsername = (String) s.getUserProperties().get("username");
            if (s != session && inviteeUsername != null) {
                currentInvitations.add(inviteeUsername);
                String textMessage = String.format("{\"action\": \"invitation\", \"message\": \"Invitation from %s: accept or reject?\", \"sender\": \"%s\"}", senderUsername, senderUsername);
                s.getBasicRemote().sendText(textMessage);
            }
        }
        invitations.put(senderUsername, currentInvitations);
        acceptedInvitations.put(senderUsername, new HashSet<>());

    }

    private void handleResponse(Session session, Map<String, Object> data) throws IOException {
        String responderUsername = (String) session.getUserProperties().get("username");
        String senderUsername = (String) data.get("sender");
        String response = (String) data.get("response");
        if ("accept".equals(response)) {
            Set<String> accepted = acceptedInvitations.get(senderUsername);
            if (accepted != null) {
                accepted.add(responderUsername);
                if (accepted.size() == invitations.get(senderUsername).size()) {
                    nbrUsers = accepted.size() + 1;
                    System.out.println("Nbr Users is " + nbrUsers);
                    beginGame(senderUsername, nbrTour, nbrUsers, timer);
                }
            }
        }
    }

    private void handleUpdateScore(Map<String, Object> data) throws IOException {
        Map<String, Integer> scoresUpdate = (Map<String, Integer>) data.get("scoresUpdate");
        System.out.println(scoresUpdate);
        broadcastUpdatedScores(scoresUpdate);
    }

    // change also the center card or Not
    private void broadcastUpdatedScores(Map<String, Integer> scores) throws IOException {
        // generate new cards for players, remember to chnage it to acceptedInvitation.length
        Pair<List<UserCard>, CenterCard> pairs = generateGameCards(players);
        CenterCard centerCard = pairs.getSecond();
        List<UserCard> userCards = pairs.getFirst();
        String message = gson.toJson(Map.of("action", "scoreUpdate", "scores", scores, "cartes", userCards, "centerCards", centerCard));
        System.out.println(message);
        for (Session session : sessions) {
            if (session.isOpen()) {
                session.getBasicRemote().sendText(message);
            }
        }
    }


    // Function to generate cards and return both tables
    public static CardTables generateCards(int nbrUsers) {
        // List of existing letters
        char[] letters = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M'};
        Random random = new Random();

        if (nbrUsers > letters.length) {
            throw new IllegalArgumentException("Number of users exceeds available unique cards");
        }

        // Select unique characters for each user
        char[] cartes = new char[nbrUsers];
        Set<Integer> usedIndices = new HashSet<>(); // Track indices that have been used

        for (int i = 0; i < cartes.length; i++) {
            int randomIndex;
            do {
                randomIndex = random.nextInt(letters.length);
            } while (usedIndices.contains(randomIndex)); // Ensure no duplicate cards
            cartes[i] = letters[randomIndex];
            usedIndices.add(randomIndex); // Mark this index as used
        }

        // Generate a center letter for each round, can be any including duplicates
        char[] centerCartes = new char[nbrUsers];
        for (int i = 0; i < nbrUsers; i++) {
            centerCartes[i] = cartes[random.nextInt(cartes.length)];
        }

        // Return the new object with both arrays
        return new CardTables(cartes, centerCartes);
    }

    // correct this for number of users
    public void beginGame(String senderUsername, int nbrTours, int nbrUsers, int timer) {
        // List Of Existing letters
        char[] letters = {'A', 'B', 'C', 'D', 'E', 'F', 'H', 'I', 'J', 'K', 'L'};
        String[] colors = {"red", "blue", "green"};
        Random random = new Random();

        players = acceptedInvitations.get(senderUsername);
        players.add(senderUsername);  // Include the inviter

        List<UserCard> userCards = new ArrayList<>();
        for (String player : players) {
            char playerCard = letters[random.nextInt(letters.length)];
            String playerColor = colors[random.nextInt(colors.length)];
            userCards.add(new UserCard(player, playerCard, playerColor));
        }

        // selectionner Le nombre de chars en fonction des nombre de joueur et a chaque partie les lettre s'echange

        // Generate a center letter for each tour
        // Generate a center card with random carte and color
        // Generate a center card by selecting a random carte and a random color from different user cards
        char randomCard = userCards.get(random.nextInt(userCards.size())).getCarte();
        String randomColor = userCards.get(random.nextInt(userCards.size())).getColor();
        CenterCard centerCard = new CenterCard(randomCard, randomColor);


        Gson gson = new Gson();
        Map<String, Object> gameInfo = new HashMap<>();
        gameInfo.put("action", "redirect");
        gameInfo.put("url", "game.jsp");
        gameInfo.put("nbrTours", nbrTours);
        gameInfo.put("playerCards", userCards);
        gameInfo.put("centreCard", centerCard);
        gameInfo.put("timer", timer);

        // Initialize scores to 0
        Map<String, Integer> initialScores = new HashMap<>();
        players.forEach(player -> initialScores.put(player, 0));
        gameInfo.put("scores", initialScores);

        String message = gson.toJson(gameInfo);
        System.out.println(message);
        // Send the message to all players' sessions
        sessions.forEach(session -> {
            String username = (String) session.getUserProperties().get("username");
            if (players.contains(username)) {
                try {
                    session.getBasicRemote().sendText(message);
                } catch (IOException e) {
                    System.err.println("Error sending game start message: " + e.getMessage());
                }
            }
        });
    }

    // cette fonction permet d'envoyer le message a tout les sessions connecte
    public static void broadcast(String userName, String sessionId, boolean isLoggedIn) {
        String actionType = isLoggedIn ? "login" : "logout";
        String message = "{\"username\": \"" + userName + "\", \"sessionId\": \"" + sessionId + "\", \"action\": \"" + actionType + "\"}";
        synchronized (sessions) {
            for (Session s : sessions) {
                if (s.isOpen()) {
                    try {
                        s.getBasicRemote().sendText(message);
                    } catch (IOException e) {
                        System.err.println("Error in sending message: " + e.getMessage());
                    }
                }
            }
        }
    }


    public Pair<List<UserCard>, CenterCard> generateGameCards(Set<String> players) {
        List<UserCard> userCards = new ArrayList<>();
        for (String player : players) {
            char playerCard = letters[random.nextInt(letters.length)];
            String playerColor = colors[random.nextInt(colors.length)];
            userCards.add(new UserCard(player, playerCard, playerColor));
        }

        // Selecting a random card and color from user cards for the center card
        char randomCard = userCards.get(random.nextInt(userCards.size())).getCarte();
        String randomColor = userCards.get(random.nextInt(userCards.size())).getColor();
        CenterCard centerCard = new CenterCard(randomCard, randomColor);

        return new Pair<>(userCards, centerCard);
    }
}
