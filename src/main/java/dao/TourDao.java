package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.TypedQuery;
import model.Tour;

import java.util.List;

public class TourDao implements IDao<Tour,Long>{
    private EntityManagerFactory emf;

    @Override
    public Tour findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Tour.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Tour> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Tour> query = em.createQuery("SELECT t FROM Tour t", Tour.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void save(Tour tour) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (tour.getTourId() == null) { // Assuming getId() method exists and returns null for a new entity
                em.persist(tour);
            } else {
                em.merge(tour);
            }
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }

    @Override
    public void update(Tour tour) {
        save(tour);
    }

    @Override
    public void delete(Tour tour) {
        EntityManager em=emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(tour)) {
                tour = em.merge(tour);
            }
            em.remove(tour);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}
