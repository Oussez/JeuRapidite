package dao;

import jakarta.persistence.*;
import model.Joueur;

import java.util.List;

public class JoueurDao implements IDao<Joueur, Long> {

    private EntityManagerFactory emf;

    public JoueurDao() {
        emf = Persistence.createEntityManagerFactory("gamePersistance");
    }

    @Override
    public Joueur findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Joueur.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Joueur> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Joueur> query = em.createQuery("SELECT j FROM Joueur j", Joueur.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void save(Joueur joueur) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (joueur.getJoueurId() == null) { // Assuming getId() method exists and returns null for a new entity
                em.persist(joueur);
            } else {
                em.merge(joueur);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void update(Joueur joueur) {
        save(joueur); // The save method handles both save and update
    }

    @Override
    public void delete(Joueur joueur) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(joueur)) {
                joueur = em.merge(joueur);
            }
            em.remove(joueur);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    public Joueur findByPseudo(String pseudo) {
        EntityManager em = emf.createEntityManager();
        try {
            String jpql = "SELECT j FROM Joueur j WHERE j.pseudo = :pseudo";
            TypedQuery<Joueur> query = em.createQuery(jpql, Joueur.class);
            query.setParameter("pseudo", pseudo);
            return query.getSingleResult();
        } catch (NoResultException e) {
            return null;  // Ou gérer autrement si aucun résultat n'est trouvé
        } finally {
            em.close();
        }
    }

}
