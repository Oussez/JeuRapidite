package model;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

import java.sql.Timestamp;

@Entity
@Table(name = "tour")
@Getter @Setter
public class Tour {
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Id
    @Column(name = "TourID")
    private Long tourId;

    @ManyToOne
    @JoinColumn(name = "PartieID",nullable = false)
    private Partie partie;

    @OneToOne
    @JoinColumn(name = "CarteCentraleID")
    private Carte carteCentrale;

    @Column(name = "Timestamp")
    private Timestamp timestamp;


}
