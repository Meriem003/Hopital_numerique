package com.clinic.clinicapp.service;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.enums.StatusConsultation;

import java.time.LocalDateTime;
import java.util.List;

public interface DocteurService {
    
    List<Consultation> consulterPlanning(Long docteurId);
    
    List<Consultation> consulterConsultationsAVenir(Long docteurId);
    
    List<Consultation> consulterConsultationsDuJour(Long docteurId, LocalDateTime date);
    
    List<Consultation> consulterReservationsEnAttente(Long docteurId);
    
    Consultation validerReservation(Long consultationId);
    
    Consultation refuserReservation(Long consultationId, String motifRefus);
    
    Consultation realiserConsultation(Long consultationId, String compteRendu, String diagnostic, String traitement);
    
    Consultation mettreAJourStatutConsultation(Long consultationId, StatusConsultation nouveauStatut);
    
    Consultation terminerConsultation(Long consultationId);
    
    List<Consultation> consulterHistoriqueMedicalPatient(Long docteurId, Long patientId);
    
    List<Patient> consulterPatientssSuivis(Long docteurId);
    
    List<Consultation> consulterConsultationsPassees(Long docteurId);
    
    boolean estDisponible(Long docteurId, LocalDateTime dateHeure);    
}
