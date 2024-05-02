package dto;

import java.util.*;

// Mock session and acceptedInvitations setup
public class MockData {
    public static Map<String, Set<String>> createMockAcceptedInvitations() {
        Map<String, Set<String>> invitations = new HashMap<>();
        Set<String> invitedUsers = new HashSet<>();
        invitedUsers.add("user1");
        invitedUsers.add("user2");
        invitations.put("sender", invitedUsers);
        return invitations;
    }

    public static List<Object> createMockSessions() {
        // This is very simplified; you'll need to make this match whatever object your real sessions are
        List<Object> sessions = new ArrayList<>();
        sessions.add(new Object()); // Add mock session objects as needed
        return sessions;
    }
}
