package com.clinic.clinicapp.repository.impl;

import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.repository.PatientRepository;
import com.clinic.clinicapp.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.NoResultException;
import jakarta.persistence.TypedQuery;

import java.util.List;
import java.util.Optional;

public class PatientRepositoryImpl implements PatientRepository {

    @Override
    public Patient save(Patient patient) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(patient);
            em.getTransaction().commit();
            return patient;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde du patient", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Patient update(Patient patient) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Patient updated = em.merge(patient);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour du patient", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Patient> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Patient patient = em.find(Patient.class, id);
            return Optional.ofNullable(patient);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Patient> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p ORDER BY p.nom, p.prenom", 
                Patient.class
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
            Patient patient = em.find(Patient.class, id);
            if (patient != null) {
                em.remove(patient);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression du patient", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Patient patient) {
        if (patient != null && patient.getId() != null) {
            deleteById(patient.getId());
        }
    }

    @Override
    public Optional<Patient> findByEmail(String email) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p WHERE p.email = :email",
                Patient.class
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
    public List<Patient> findByNom(String nom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p WHERE LOWER(p.nom) LIKE LOWER(:nom) ORDER BY p.nom, p.prenom",
                Patient.class
            );
            query.setParameter("nom", "%" + nom + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Patient> findByPrenom(String prenom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p WHERE LOWER(p.prenom) LIKE LOWER(:prenom) ORDER BY p.nom, p.prenom",
                Patient.class
            );
            query.setParameter("prenom", "%" + prenom + "%");
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Patient> findByNomOrPrenom(String nom, String prenom) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Patient> query = em.createQuery(
                "SELECT p FROM Patient p WHERE LOWER(p.nom) LIKE LOWER(:nom) " +
                "OR LOWER(p.prenom) LIKE LOWER(:prenom) ORDER BY p.nom, p.prenom",
                Patient.class
            );
            query.setParameter("nom", "%" + nom + "%");
            query.setParameter("prenom", "%" + prenom + "%");
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
                "SELECT COUNT(p) FROM Patient p",
                Long.class
            );
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
                "SELECT COUNT(p) FROM Patient p WHERE p.email = :email",
                Long.class
            );
            query.setParameter("email", email);
            return query.getSingleResult() > 0;
        } finally {
            em.close();
        }
    }
}
