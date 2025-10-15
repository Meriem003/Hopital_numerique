package com.clinic.clinicapp.repository;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.enums.StatusConsultation;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

public interface ConsultationRepository {
    
    Consultation save(Consultation consultation);
    Consultation update(Consultation consultation);
    Optional<Consultation> findById(Long id);
    List<Consultation> findAll();
    void deleteById(Long id);
    void delete(Consultation consultation);
    List<Consultation> findByPatientId(Long patientId);
    List<Consultation> findByDocteurId(Long docteurId);
    List<Consultation> findByStatut(StatusConsultation statut);
    List<Consultation> findByDateBetween(LocalDateTime debut, LocalDateTime fin);
    List<Consultation> findByDocteurAndDate(Long docteurId, LocalDateTime date);
    List<Consultation> findBySalleId(Long salleId);
    Long countByStatut(StatusConsultation statut);
}
