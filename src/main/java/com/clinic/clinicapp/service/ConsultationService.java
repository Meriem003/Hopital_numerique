package com.clinic.clinicapp.service;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Salle;
import com.clinic.clinicapp.enums.StatusConsultation;

import java.time.LocalDateTime;
import java.util.List;

public interface ConsultationService {
    
    Consultation creerConsultation(Consultation consultation);
    
    Consultation mettreAJourConsultation(Consultation consultation);
    
    Consultation getConsultationById(Long consultationId);
    
    boolean supprimerConsultation(Long consultationId);
    
    List<Consultation> listerToutesLesConsultations();
    
    List<Consultation> getConsultationsByPatient(Long patientId);
    
    List<Consultation> getConsultationsByDocteur(Long docteurId);
    
    List<Consultation> getConsultationsBySalle(Long salleId);
    
    List<Consultation> getConsultationsByStatut(StatusConsultation statut);
    
    List<Consultation> getConsultationsByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin);
    
    List<Consultation> getConsultationsByPatientAndDocteur(Long patientId, Long docteurId);
    
    boolean existeConsultationPourCreneau(LocalDateTime dateHeure, Long salleId);
    
    Consultation changerStatut(Long consultationId, StatusConsultation nouveauStatut);
    
    Consultation ajouterCompteRendu(Long consultationId, String compteRendu, String diagnostic, String traitement);
    
    boolean verifierDisponibiliteCreneau(Long docteurId, LocalDateTime dateHeure);
    
    Salle trouverSalleDisponible(LocalDateTime dateHeure);
    
    LocalDateTime calculerFinCreneau(LocalDateTime dateHeureDebut);
    
    boolean creneauxSeChevauchent(LocalDateTime debut1, LocalDateTime debut2);
    
    long compterConsultationsByStatut(StatusConsultation statut);
    
    boolean validerConsultation(Consultation consultation);
}
