package com.clinic.clinicapp.repository.impl;

import com.clinic.clinicapp.entity.Salle;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class SalleRepositoryImpl implements SalleRepository {

    @Override
    public Salle save(Salle salle) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(salle);
            em.getTransaction().commit();
            return salle;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de la salle", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Salle update(Salle salle) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Salle updated = em.merge(salle);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de la salle", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Salle> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Salle salle = em.find(Salle.class, id);
            return Optional.ofNullable(salle);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Salle> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s ORDER BY s.nomSalle", 
                Salle.class
            );
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public void deleteById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Salle salle = em.find(Salle.class, id);
            if (salle != null) {
                em.remove(salle);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de la salle", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Salle salle) {
        if (salle != null && salle.getId() != null) {
            deleteById(salle.getId());
        }
    }

    @Override
    public Optional<Salle> findByNomSalle(String nomSalle) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s WHERE s.nomSalle = :nomSalle",
                Salle.class
            );
            query.setParameter("nomSalle", nomSalle);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Salle> findByCapaciteGreaterThanEqual(Integer capacite) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s WHERE s.capacite >= :capacite ORDER BY s.capacite, s.nomSalle",
                Salle.class
            );
            query.setParameter("capacite", capacite);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Salle> searchByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Salle> query = em.createQuery(
                "SELECT s FROM Salle s WHERE LOWER(s.nomSalle) LIKE LOWER(:nom) ORDER BY s.nomSalle",
                Salle.class
            );
            query.setParameter("nom", "%" + nom + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Long count() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(s) FROM Salle s",
                Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByNomSalle(String nomSalle) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(s) FROM Salle s WHERE s.nomSalle = :nomSalle",
                Long.class
            );
            query.setParameter("nomSalle", nomSalle);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
}
