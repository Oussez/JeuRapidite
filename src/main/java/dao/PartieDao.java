package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import model.Partie;

import java.util.List;

public class PartieDao implements IDao<Partie,Long> {



    private EntityManagerFactory emf;

    public PartieDao() {
        emf = Persistence.createEntityManagerFactory("gamePersistance");
    }

    @Override
    public Partie findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Partie.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Partie> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Partie> query = em.createQuery("SELECT j FROM Partie j", Partie.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void save(Partie partie) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (partie.getPartieId() == null) { // Assuming getId() method exists and returns null for a new entity
                em.persist(partie);
            } else {
                em.merge(partie);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void update(Partie partie) {

        save(partie); // The save method handles both save and update
    }

    @Override
    public void delete(Partie partie) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(partie)) {
                partie = em.merge(partie);
            }
            em.remove(partie);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
