package com.clinic.clinicapp.repository.impl;

import com.clinic.clinicapp.entity.Departement;
import com.clinic.clinicapp.repository.DepartementRepository;
import com.clinic.clinicapp.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class DepartementRepositoryImpl implements DepartementRepository {

    @Override
    public Departement save(Departement departement) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(departement);
            em.getTransaction().commit();
            return departement;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde du département", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Departement update(Departement departement) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Departement updated = em.merge(departement);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour du département", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Departement> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Departement departement = em.find(Departement.class, id);
            return Optional.ofNullable(departement);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Departement> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                "SELECT d FROM Departement d ORDER BY d.nom", 
                Departement.class
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
            Departement departement = em.find(Departement.class, id);
            if (departement != null) {
                em.remove(departement);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression du département", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Departement departement) {
        if (departement != null && departement.getId() != null) {
            deleteById(departement.getId());
        }
    }

    @Override
    public Optional<Departement> findByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                "SELECT d FROM Departement d WHERE d.nom = :nom",
                Departement.class
            );
            query.setParameter("nom", nom);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Departement> searchByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Departement> query = em.createQuery(
                "SELECT d FROM Departement d WHERE LOWER(d.nom) LIKE LOWER(:nom) ORDER BY d.nom",
                Departement.class
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
                "SELECT COUNT(d) FROM Departement d",
                Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(d) FROM Departement d WHERE d.nom = :nom",
                Long.class
            );
            query.setParameter("nom", nom);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
}
