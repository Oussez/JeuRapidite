package model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "joueur")
@Getter @Setter
public class Joueur {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "JoueurID")
    private Long joueurId;

    @Column(name = "Pseudo")
    private String pseudo;

    @Column(name = "MotDePasse")
    private String motDePasse;

    @Column(name = "Âge")
    private Integer âge;

    @Column(name = "Genre")
    private String genre;

    @Column(name = "NombrePartiesJouées")
    private Integer nombrePartiesJouées;

    @Column(name = "NombreVictoires")
    private Integer nombreVictoires;

    @Column(name = "ScoreMoyen")
    private Double scoreMoyen;

    @Column(name = "RatioClicRéussi")
    private Double ratioClicRéussi;

    @Column(name = "RatioClicRapide")
    private Double ratioClicRapide;

}
