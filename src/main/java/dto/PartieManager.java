package dto;

import model.Partie;

public class PartieManager {
    private static Partie uniqueInstance;

    // Synchronized method to ensure thread safety
    public static synchronized Partie getPartie(int nombreTours, int timer, String modeJeu) {
        if (uniqueInstance == null) {
            uniqueInstance = new Partie();
            uniqueInstance.setNombreTours(nombreTours);
            uniqueInstance.setValeurTimer(timer);
            uniqueInstance.setDateHeure(); // Set current date and time
            uniqueInstance.setModeJeu(modeJeu);
        }
        return uniqueInstance;
    }
}