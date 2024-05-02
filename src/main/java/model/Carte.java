package model;

import enums.Couleur;
import enums.Forme;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "carte")
@Getter @Setter // add getters and setters automatically
public class Carte {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "CarteID")
    private Long carteId;

    @Enumerated(EnumType.STRING)
    @Column(name = "Forme")

    private Forme forme;

    @Enumerated(EnumType.STRING)
    @Column(name = "Couleur")
    private Couleur couleur;

}
