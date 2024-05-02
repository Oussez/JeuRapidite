package controller;

import dao.JoueurDao;
import model.Joueur;
import webSocket.UserStatusWebSocket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;


@WebServlet(name = "LoginServlet",urlPatterns = {"/login"})

public class LoginServlet extends HttpServlet {

    private JoueurDao joueurDao;


    public static Map<String, HttpSession> sessions = new ConcurrentHashMap<>();


    @Override
    public void init() {
        joueurDao = new JoueurDao();
        // Initialize your DAO here, perhaps with a connection or other setup if necessary.
    }
@Override
protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String actionOldPassword = req.getParameter("action");
        if(actionOldPassword!= null && actionOldPassword.equals("verifyPassword")){
            verifyPassword(req, resp);
            return;
        }
    for (Map.Entry<String, HttpSession> entry : sessions.entrySet()) {
        String userId = entry.getKey();
        HttpSession session = entry.getValue();
        System.out.println("User ID: " + userId + ", Session: " + session);
    }
    // Invalidate the existing session if any before creating a new one
    HttpSession oldSession = req.getSession(false);
    if (oldSession != null) {
        oldSession.invalidate();
    }
    HttpSession newSession = req.getSession(true);  // Create a new session for the user

    String userName= req.getParameter("username");
    String password= req.getParameter("password");
    List<Joueur> joueurs = joueurDao.findAll(); // Récupère tous les joueurs pour trouver une correspondance
    try {
        for (Joueur joueur : joueurs) {
            if (joueur.getPseudo().equals(userName) && joueur.getMotDePasse().equals(password)) {

                // Authentification réussie, redirection vers une page sécurisée (par ex. home.jsp)
                HttpSession session = req.getSession();
                session.setAttribute("currentJoueur",joueur);
                session.setAttribute("pseudo", joueur.getPseudo()); // Stocker l'utilisateur dans la session
                session.setAttribute("age",joueur.getÂge());
                session.setAttribute("nbrPartieJouées",joueur.getNombrePartiesJouées());
                session.setAttribute("genre",joueur.getGenre());
                session.setAttribute("nbrVictoire",joueur.getNombreVictoires());
                session.setAttribute("ratioClicRapide",joueur.getRatioClicRapide());
                session.setAttribute("ratioClicReussi",joueur.getRatioClicRéussi());
                session.setAttribute("scoreMoy",joueur.getScoreMoyen());
                sessions.put(userName,newSession);
                session.setAttribute("connectedUsers", sessions);
                session.setAttribute("username", userName);  // Set username in session for later retrieval
                UserStatusWebSocket.broadcast(userName ,session.getId(),true);
                resp.setStatus(HttpServletResponse.SC_OK);
                resp.setContentType("application/json");
                resp.sendRedirect("home.jsp");
                return;
            }

        }

    }catch (Exception e){
        System.out.println("Error Login Servlet "+e.getMessage());
    }
//    resp.sendRedirect("index.jsp?error=" + URLEncoder.encode("Invalid username or password", "UTF-8"));
// Authentification échouée, retour à la page de login avec un message d'erreur
    req.setAttribute("passwordError", "username ou password est invalide");
    req.setAttribute("usernameError", "username ou password est invalide");
    req.getRequestDispatcher("/login.jsp").forward(req,resp);


}

private void verifyPassword(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String pseudo = (String) req.getSession().getAttribute("pseudo"); ;
        Joueur joueur = joueurDao.findByPseudo(pseudo);
        if(joueur != null){
            if(!joueur.getMotDePasse().equals(req.getParameter("oldPW"))){
                resp.setStatus(HttpServletResponse.SC_CONFLICT);
                resp.setContentType("application/json");
                req.setAttribute("oldPWError", "Votre mot de passe actuel est invalide");

                resp.sendRedirect("/LearnSocket_war_exploded/profile.jsp?triggerModal=true&oldPWError=Votre mot de passe actuel est invalide");

            }
            else {
                // Change the password for the joueur
                joueur.setMotDePasse(req.getParameter("newPW"));
                joueurDao.save(joueur);
                // Set success message attribute
                HttpSession session = req.getSession();
                session.setAttribute("updateStatus","votre mot de passe est bien changé");
//                req.setAttribute("successMessage", "Votre mot de passe est bien changé.");
                System.out.println("---------------->> new password has been changed for player : "+joueur.getPseudo());
                req.getRequestDispatcher("/profile.jsp").forward(req, resp);
            }
        }


}

}
