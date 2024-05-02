package dto;

public class CardTables {
    public char[] cartes;
    public char[] centerCartes;

    public CardTables(char[] selectedChars, char[] centerCartes) {
        this.cartes = selectedChars;
        this.centerCartes = centerCartes;
    }
}
