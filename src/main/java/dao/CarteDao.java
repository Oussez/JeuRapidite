package dao;

import jakarta.persistence.EntityManager;
import jakarta.persistence.EntityManagerFactory;
import jakarta.persistence.Persistence;
import jakarta.persistence.TypedQuery;
import model.Carte;

import java.util.List;

public class CarteDao implements IDao<Carte,Long>{


    private EntityManagerFactory emf;

    public CarteDao() {
        emf = Persistence.createEntityManagerFactory("gamePersistance");
    }

    @Override
    public Carte findById(Long id) {
        EntityManager em = emf.createEntityManager();
        try {
            return em.find(Carte.class, id);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Carte> findAll() {
        EntityManager em = emf.createEntityManager();
        try {
            TypedQuery<Carte> query = em.createQuery("SELECT c FROM Carte c", Carte.class);
            return query.getResultList();
        } finally {
            em.close();
        }    }

    @Override
    public void save(Carte entity) {
        EntityManager em = emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (entity.getCarteId() == null) { // Assuming getId() method exists and returns null for a new entity
                em.persist(entity);
            } else {
                em.merge(entity); //attacher l'entité avec le manager de bdd
            }
            System.out.println(">> carte est bien ajouté");
            em.getTransaction().commit();
        }
        catch(Exception e){
            System.out.println(">> Error Saving : "+e.getMessage());
        } finally{
            em.close();}

}

    @Override
    public void update(Carte carte) {
        save(carte);
    }

    @Override
    public void delete(Carte carte) {
        EntityManager em=emf.createEntityManager();
        try {
            em.getTransaction().begin();
            if (!em.contains(carte)) {
                carte = em.merge(carte);
            }
            em.remove(carte);
            em.getTransaction().commit();
        } finally {
            em.close();
        }
    }
}