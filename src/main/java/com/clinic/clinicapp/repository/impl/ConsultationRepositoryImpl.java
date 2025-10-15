package com.clinic.clinicapp.repository.impl;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.util.HibernateUtil;
import jakarta.persistence.EntityManager;
import jakarta.persistence.TypedQuery;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public class ConsultationRepositoryImpl implements ConsultationRepository {

    @Override
    public Consultation save(Consultation consultation) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            em.persist(consultation);
            em.getTransaction().commit();
            return consultation;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la sauvegarde de la consultation", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Consultation update(Consultation consultation) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            em.getTransaction().begin();
            Consultation updated = em.merge(consultation);
            em.getTransaction().commit();
            return updated;
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la mise à jour de la consultation", e);
        } finally {
            em.close();
        }
    }

    @Override
    public Optional<Consultation> findById(Long id) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            Consultation consultation = em.find(Consultation.class, id);
            return Optional.ofNullable(consultation);
        } finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findAll() {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c ORDER BY c.dateHeure DESC", 
                Consultation.class
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
            Consultation consultation = em.find(Consultation.class, id);
            if (consultation != null) {
                em.remove(consultation);
            }
            em.getTransaction().commit();
        } catch (Exception e) {
            if (em.getTransaction().isActive()) {
                em.getTransaction().rollback();
            }
            throw new RuntimeException("Erreur lors de la suppression de la consultation", e);
        } finally {
            em.close();
        }
    }

    @Override
    public void delete(Consultation consultation) {
        if (consultation != null && consultation.getId() != null) {
            deleteById(consultation.getId());
        }
    }

    @Override
    public List<Consultation> findByPatientId(Long patientId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c WHERE c.patient.id = :patientId ORDER BY c.dateHeure DESC",
                Consultation.class
            );
            query.setParameter("patientId", patientId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findByDocteurId(Long docteurId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c WHERE c.docteur.id = :docteurId ORDER BY c.dateHeure DESC",
                Consultation.class
            );
            query.setParameter("docteurId", docteurId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findByStatut(StatusConsultation statut) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c WHERE c.statut = :statut ORDER BY c.dateHeure",
                Consultation.class
            );
            query.setParameter("statut", statut);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findByDateBetween(LocalDateTime debut, LocalDateTime fin) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c WHERE c.dateHeure BETWEEN :debut AND :fin ORDER BY c.dateHeure",
                Consultation.class
            );
            query.setParameter("debut", debut);
            query.setParameter("fin", fin);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findByDocteurAndDate(Long docteurId, LocalDateTime date) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            LocalDateTime debutJournee = date.toLocalDate().atStartOfDay();
            LocalDateTime finJournee = date.toLocalDate().atTime(23, 59, 59);
            
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c WHERE c.docteur.id = :docteurId " +
                "AND c.dateHeure BETWEEN :debut AND :fin ORDER BY c.dateHeure",
                Consultation.class
            );
            query.setParameter("docteurId", docteurId);
            query.setParameter("debut", debutJournee);
            query.setParameter("fin", finJournee);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public List<Consultation> findBySalleId(Long salleId) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Consultation> query = em.createQuery(
                "SELECT c FROM Consultation c WHERE c.salle.id = :salleId ORDER BY c.dateHeure DESC",
                Consultation.class
            );
            query.setParameter("salleId", salleId);
            return query.getResultList();
        } finally {
            em.close();
        }
    }

    @Override
    public Long countByStatut(StatusConsultation statut) {
        EntityManager em = HibernateUtil.getEntityManager();
        try {
            TypedQuery<Long> query = em.createQuery(
                "SELECT COUNT(c) FROM Consultation c WHERE c.statut = :statut",
                Long.class
            );
            query.setParameter("statut", statut);
            return query.getSingleResult();
        } finally {
            em.close();
        }
    }
}
