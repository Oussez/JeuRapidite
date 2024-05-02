package controller;

import webSocket.UserStatusWebSocket;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Map;

import static controller.LoginServlet.sessions;


@WebServlet(name = "LogoutServlet", urlPatterns = {"/logout"})
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session=req.getSession(false);
        if(session!=null){
            String username=(String) session.getAttribute("username");
            if(username !=null){
                System.out.println("is deleted");
                sessions.remove(username);
                UserStatusWebSocket.broadcast(username,session.getId(),false);
                for (Map.Entry<String, HttpSession> entry : sessions.entrySet()) {
                    String userId = entry.getKey();
                    HttpSession sessionn = entry.getValue();
                    System.out.println("User ID: " + userId + ", Session: " + sessionn+"is deleted from the list");
                }
            }
            session.invalidate();
        }

        resp.sendRedirect("index.jsp");

    }
}
