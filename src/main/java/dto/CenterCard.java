package dto;

public class CenterCard {
    private char carte;
    private String color;

    // Constructor
    public CenterCard(char carte, String color) {
        this.carte = carte;
        this.color = color;
    }

    // Getters
    public char getCarte() {
        return carte;
    }

    public String getColor() {
        return color;
    }

    // toString method for easy debugging
    @Override
    public String toString() {
        return "CenterCard{" +
                "carte=" + carte +
                ", color='" + color + '\'' +
                '}';
    }
}
