package com.clinic.clinicapp.repository.impl;

import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class DocteurRepositoryImpl implements DocteurRepository {

    @Override
    public Docteur save(Docteur docteur) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(docteur);
            em.getTransaction().commit();
            return docteur;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde du docteur", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Docteur update(Docteur docteur) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Docteur updated = em.merge(docteur);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour du docteur", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Docteur> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Docteur docteur = em.find(Docteur.class, id);
            return Optional.ofNullable(docteur);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Docteur> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                "SELECT d FROM Docteur d ORDER BY d.nom, d.prenom", 
                Docteur.class
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
            Docteur docteur = em.find(Docteur.class, id);
            if (docteur != null) {
                em.remove(docteur);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression du docteur", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Docteur docteur) {
        if (docteur != null && docteur.getId() != null) {
            deleteById(docteur.getId());
        }
    }

    @Override
    public Optional<Docteur> findByEmail(String email) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                "SELECT d FROM Docteur d WHERE d.email = :email",
                Docteur.class
            );
            query.setParameter("email", email);
            return Optional.ofNullable(query.getSingleResult());
        } catch (NoResultException e) {
            return Optional.empty();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Docteur> findBySpecialite(String specialite) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                "SELECT d FROM Docteur d WHERE LOWER(d.specialite) LIKE LOWER(:specialite) ORDER BY d.nom, d.prenom",
                Docteur.class
            );
            query.setParameter("specialite", "%" + specialite + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Docteur> findByDepartementId(Long departementId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                "SELECT d FROM Docteur d WHERE d.departement.id = :departementId ORDER BY d.nom, d.prenom",
                Docteur.class
            );
            query.setParameter("departementId", departementId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Docteur> findByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Docteur> query = em.createQuery(
                "SELECT d FROM Docteur d WHERE LOWER(d.nom) LIKE LOWER(:nom) ORDER BY d.nom, d.prenom",
                Docteur.class
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
                "SELECT COUNT(d) FROM Docteur d",
                Long.class
            );
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public Long countBySpecialite(String specialite) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(d) FROM Docteur d WHERE LOWER(d.specialite) = LOWER(:specialite)",
                Long.class
            );
            query.setParameter("specialite", specialite);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(d) FROM Docteur d WHERE d.email = :email",
                Long.class
            );
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
}
