package controller;

import jakarta.websocket.OnOpen;
import jakarta.websocket.Session;
import jakarta.websocket.server.ServerEndpoint;

@ServerEndpoint("/game")
public class GameServlet {

    // how to associate sessioN comming fron login to this
    @OnOpen
    public void onOpen(Session session) {
        // Initially, no user is associated until they send their username
        //sessions.put()
        System.out.println("Im here");
    }

}
