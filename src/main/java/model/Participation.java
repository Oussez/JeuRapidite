package model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "participation")
@Getter @Setter
public class Participation {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "ParticipationID")
    private Long participationId;

    @OneToOne
    @JoinColumn(name = "JoueurID")
    private Joueur joueur;

    @OneToOne
    @JoinColumn(name = "PartieID")
    private Partie partie;
    @Basic
    @Column(name = "Score")
    private Integer score;
    @Basic
    @Column(name = "NombreClicRéussi")
    private Integer nombreClicRéussi;
    @Basic
    @Column(name = "NombreClicRapide")
    private Integer nombreClicRapide;


}
