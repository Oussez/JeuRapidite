package model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;
import java.util.Set;

@Entity
@Table(name = "partie")
@Getter @Setter
public class Partie {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "PartieID")
    private Long partieId;

    @Column(name = "DateHeure",nullable = false)
    private Timestamp dateHeure;

    @Column(name = "NombreTours")
    private int nombreTours;

    @Column(name = "ValeurTimer")
    private int valeurTimer;

    @Column(name = "NombreCombinaisons")
    private int nombreCombinaisons;

    @Column(name = "ModeJeu",nullable = false)
    private String modeJeu;

    @OneToMany(mappedBy = "partie", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.LAZY)
    private Set<Tour> tours; // The list of tours associated with this partie

    public void setDateHeure() {
        this.dateHeure = new Timestamp(System.currentTimeMillis());
    }



}
