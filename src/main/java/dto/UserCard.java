package dto;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserCard {
    private String username;
    private char carte;
    private String color;

    public UserCard(String username, char carte, String color) {
        this.username = username;
        this.carte = carte;
        this.color = color;
    }

    // Getters and setters here
    // toString method as well for easy debugging
}
