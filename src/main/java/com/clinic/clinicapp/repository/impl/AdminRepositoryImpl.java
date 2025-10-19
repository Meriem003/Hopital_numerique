package com.clinic.clinicapp.repository.impl;

import com.clinic.clinicapp.entity.Admin;
import com.clinic.clinicapp.repository.AdminRepository;
import com.clinic.clinicapp.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class AdminRepositoryImpl implements AdminRepository {

    @Override
    public Admin save(Admin admin) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(admin);
            em.getTransaction().commit();
            return admin;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de l'admin", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Admin update(Admin admin) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Admin updated = em.merge(admin);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de l'admin", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Admin> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Admin admin = em.find(Admin.class, id);
            return Optional.ofNullable(admin);
        } finally {
            em.close();
        }
    }


    @Override
    public Optional<Admin> findByEmail(String email) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Admin> query = em.createQuery(
                "SELECT a FROM Admin a WHERE a.email = :email", 
                Admin.class
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
    public List<Admin> findByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Admin> query = em.createQuery(
                "SELECT a FROM Admin a WHERE LOWER(a.nom) LIKE LOWER(:nom)", 
                Admin.class
            );
            query.setParameter("nom", "%" + nom + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Admin> findByPrenom(String prenom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Admin> query = em.createQuery(
                "SELECT a FROM Admin a WHERE LOWER(a.prenom) LIKE LOWER(:prenom)", 
                Admin.class
            );
            query.setParameter("prenom", "%" + prenom + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Admin> findByNomOrPrenom(String nom, String prenom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Admin> query = em.createQuery(
                "SELECT a FROM Admin a WHERE LOWER(a.nom) LIKE LOWER(:nom) OR LOWER(a.prenom) LIKE LOWER(:prenom)", 
                Admin.class
            );
            query.setParameter("nom", "%" + nom + "%");
            query.setParameter("prenom", "%" + prenom + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public boolean existsByEmail(String email) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(a) FROM Admin a WHERE a.email = :email", 
                Long.class
            );
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
}
