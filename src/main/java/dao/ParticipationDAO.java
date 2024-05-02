package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import model.Participation;

import java.util.List;

public class ParticipationDAO implements IDao<Participation,Long> {

    private EntityManagerFactory emf;

    public ParticipationDAO() {
        emf = Persistence.createEntityManagerFactory("gamePersistance");
    }

    @Override
    public Participation findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Participation.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Participation> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Participation> query = em.createQuery("SELECT p FROM Participation p", Participation.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void save(Participation participation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (participation.getParticipationId() == null) { // Assuming getId() method exists and returns null for a new entity
                em.persist(participation);
            } else {
                em.merge(participation);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void update(Participation participation) {
        save(participation); // The save method handles both save and update
    }

    @Override
    public void delete(Participation participation) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(participation)) {
                participation = em.merge(participation);
            }
            em.remove(participation);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
