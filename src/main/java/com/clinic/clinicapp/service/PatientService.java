package com.clinic.clinicapp.service;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Patient;

import java.time.LocalDateTime;
import java.util.List;

public interface PatientService {
    
    Patient mettreAJourPatient(Patient patient);
    
    Patient getPatientById(Long patientId);
    
    Patient getPatientByEmail(String email);
    
    List<Docteur> consulterTousLesDocteurs();
    
    List<Docteur> consulterDocteursByDepartement(Long departementId);
    
    List<Docteur> consulterDocteursBySpecialite(String specialite);
    
    Consultation reserverRendezVous(Long patientId, Long docteurId, LocalDateTime dateHeure, String motif);
    
    boolean annulerReservation(Long consultationId);
    
    Consultation modifierReservation(Long consultationId, LocalDateTime nouvelleDate, String nouveauMotif);
    
    List<Consultation> consulterHistoriqueConsultations(Long patientId);
    
    List<Consultation> consulterConsultationsAVenir(Long patientId);
    
    List<Consultation> consulterConsultationsPassees(Long patientId);
    
    Consultation consulterDetailConsultation(Long consultationId);
    
    boolean peutReserverCreneau(Long patientId, LocalDateTime dateHeure);    
}
