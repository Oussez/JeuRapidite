package com.example.learnsocket;

import static org.mockito.Mockito.*;

import jakarta.websocket.Session;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import webSocket.UserStatusWebSocket;

import java.util.HashMap;
import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class UserStatusWebSocketTest {

//    @Test
//    void testBeginGame() throws Exception {
//        // Create a mock session object
//        Session mockSession = Mockito.mock(Session.class);
//        when(mockSession.getUserProperties()).thenReturn(new HashMap<String, Object>() {{
//            put("username", "testUser");
//        }});
//
//        // Mock the static maps (invitations, acceptedInvitations)
//        UserStatusWebSocket.acceptedInvitations = new ConcurrentHashMap<>();
//        Set<String> acceptedUsers = ConcurrentHashMap.newKeySet();
//        acceptedUsers.add("testUser");
//        acceptedUsers.add("salahUser");
//        acceptedUsers.add("nadaUser");
//        UserStatusWebSocket.acceptedInvitations.put("testUser", acceptedUsers);
//
//        // Assuming beginGame method is adjusted to be non-static for testing
//        UserStatusWebSocket userStatusWebSocket = new UserStatusWebSocket();
//        userStatusWebSocket.beginGame("testUser", 3, 2);
//
//        // Verify if the correct message is sent
//        verify(mockSession, times(1)).getBasicRemote().sendText(anyString()); // Adjust as necessary
//    }
    // Further tests for onClose, onMessage, etc.
}
