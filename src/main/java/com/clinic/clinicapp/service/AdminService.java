package com.clinic.clinicapp.service;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Departement;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Salle;
import com.clinic.clinicapp.entity.Patient;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

public interface AdminService {
    
    Departement creerDepartement(Departement departement);
    
    Departement modifierDepartement(Departement departement);
    
    boolean supprimerDepartement(Long departementId);
    
    Departement getDepartementById(Long departementId);
    
    List<Departement> listerTousLesDepartements();
    
    List<Departement> rechercherDepartementsByNom(String nom);
    
    Docteur creerDocteur(String nom, String prenom, String email, String motDePasse, String specialite, Long departementId, Long salleId);
    
    Docteur modifierDocteur(Docteur docteur);
    
    boolean supprimerDocteur(Long docteurId);
    
    Docteur rattacherDocteurADepartement(Long docteurId, Long departementId);
    
    List<Docteur> listerTousLesDocteurs();
    
    List<Docteur> listerDocteursByDepartement(Long departementId);
    
    List<Docteur> rechercherDocteurs(String critere);
    
    Salle creerSalle(Salle salle);
    
    Salle modifierSalle(Salle salle);
    
    boolean supprimerSalle(Long salleId);
    
    Salle getSalleById(Long salleId);
    
    List<Salle> listerToutesLesSalles();
    
    boolean verifierDisponibiliteSalle(Long salleId, LocalDateTime dateHeure);
    
    Salle trouverSalleDisponible(LocalDateTime dateHeure);
    
    List<Consultation> consulterOccupationSalle(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin);
    
    Map<Long, Double> optimiserOccupationSalles(LocalDateTime dateDebut, LocalDateTime dateFin);
    
    List<Consultation> superviserToutesLesConsultations();
    
    List<Consultation> consulterConsultationsByStatut(String statut);
    
    List<Consultation> consulterConsultationsByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin);
    
    List<Consultation> consulterConsultationsByPatient(Long patientId);
    
    List<Consultation> consulterConsultationsByDocteur(Long docteurId);
    
    Consultation annulerConsultation(Long consultationId, String motifAnnulation);
    
    List<Patient> listerTousLesPatients();
    
    List<Patient> rechercherPatientsByNom(String nom);
    
    boolean supprimerPatient(Long patientId);
    
    long obtenirNombreTotalPatients();
    
    long obtenirNombreTotalDocteurs();
    
    long obtenirNombreTotalConsultations();
    
    Map<String, Long> obtenirNombreConsultationsByStatut();
    
    double calculerTauxOccupationGlobalSalles(LocalDateTime dateDebut, LocalDateTime dateFin);
    
    Map<Long, Long> obtenirConsultationsByDepartement(LocalDateTime dateDebut, LocalDateTime dateFin);
    
    Map<Docteur, Long> obtenirDocteursPlusConsultes(int limite, LocalDateTime dateDebut, LocalDateTime dateFin);
    
    Map<String, Object> genererRapportStatistique(LocalDateTime dateDebut, LocalDateTime dateFin);
}
