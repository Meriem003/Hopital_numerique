package com.clinic.clinicapp.service.impl;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Departement;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.entity.Salle;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.DepartementRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.PatientRepository;
import com.clinic.clinicapp.service.AdminService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.ArrayList;

public class AdminServiceImpl implements AdminService {

    private final DepartementRepository departementRepository;
    private final DocteurRepository docteurRepository;
    private final SalleRepository salleRepository;
    private final ConsultationRepository consultationRepository;
    private final PatientRepository patientRepository;

    public AdminServiceImpl(DepartementRepository departementRepository, DocteurRepository docteurRepository, SalleRepository salleRepository, ConsultationRepository consultationRepository, PatientRepository patientRepository) {
        this.departementRepository = departementRepository;
        this.docteurRepository = docteurRepository;
        this.salleRepository = salleRepository;
        this.consultationRepository = consultationRepository;
        this.patientRepository = patientRepository;
    }

    @Override
    public Departement creerDepartement(Departement departement) {
        if (departement == null) {
            throw new IllegalArgumentException("Le département ne peut pas être null");
        }
        if (departement.getNom() == null || departement.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du département est obligatoire");
        }
        if (departementRepository.existsByNom(departement.getNom())) {
            throw new IllegalArgumentException("Un département avec ce nom existe déjà");
        }
        return departementRepository.save(departement);
    }

    @Override
    public Departement modifierDepartement(Departement departement) {
        if (departement == null) {
            throw new IllegalArgumentException("Le département ne peut pas être null");
        }
        if (departement.getId() == null) {
            throw new IllegalArgumentException("L'ID du département est obligatoire pour la modification");
        }
        Optional<Departement> existant = departementRepository.findById(departement.getId());
        if (!existant.isPresent()) {
            throw new IllegalArgumentException("Département non trouvé avec l'ID: " + departement.getId());
        }
        if (departement.getNom() == null || departement.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du département est obligatoire");
        }
        return departementRepository.update(departement);
    }

    @Override
    public boolean supprimerDepartement(Long departementId) {
        if (departementId == null) {
            throw new IllegalArgumentException("L'ID du département ne peut pas être null");
        }
        Optional<Departement> departement = departementRepository.findById(departementId);
        if (!departement.isPresent()) {
            return false;
        }
        departementRepository.deleteById(departementId);
        return true;
    }

    @Override
    public Departement getDepartementById(Long departementId) {
        if (departementId == null) {
            throw new IllegalArgumentException("L'ID du département ne peut pas être null");
        }
        return departementRepository.findById(departementId).orElse(null);
    }

    @Override
    public List<Departement> listerTousLesDepartements() {
        return departementRepository.findAll();
    }

    @Override
    public List<Departement> rechercherDepartementsByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return departementRepository.findAll();
        }
        return departementRepository.searchByNom(nom);
    }

    @Override
    public Docteur creerDocteur(String nom, String prenom, String email, String motDePasse, String specialite, Long departementId, Long salleId) {
        if (nom == null || nom.trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du docteur est obligatoire");
        }
        if (prenom == null || prenom.trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom du docteur est obligatoire");
        }
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("L'email du docteur est obligatoire");
        }
        if (docteurRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Un docteur avec cet email existe déjà");
        }
        if (specialite == null || specialite.trim().isEmpty()) {
            throw new IllegalArgumentException("La spécialité du docteur est obligatoire");
        }
        if (departementId == null) {
            throw new IllegalArgumentException("L'ID du département est obligatoire");
        }
        
        Optional<Departement> departement = departementRepository.findById(departementId);
        if (!departement.isPresent()) {
            throw new IllegalArgumentException("Le département avec l'ID " + departementId + " n'existe pas");
        }
        
        // La salle est optionnelle
        Salle salle = null;
        if (salleId != null) {
            Optional<Salle> salleOpt = salleRepository.findById(salleId);
            if (!salleOpt.isPresent()) {
                throw new IllegalArgumentException("La salle avec l'ID " + salleId + " n'existe pas");
            }
            salle = salleOpt.get();
        }
        
        Docteur docteur;
        if (salle != null) {
            docteur = new Docteur(nom, prenom, email, motDePasse, specialite, departement.get(), salle);
        } else {
            docteur = new Docteur(nom, prenom, email, motDePasse, specialite, departement.get());
        }
        
        return docteurRepository.save(docteur);
    }

    @Override
    public Docteur modifierDocteur(Docteur docteur) {
        if (docteur == null) {
            throw new IllegalArgumentException("Le docteur ne peut pas être null");
        }
        if (docteur.getId() == null) {
            throw new IllegalArgumentException("L'ID du docteur est obligatoire pour la modification");
        }
        Optional<Docteur> existant = docteurRepository.findById(docteur.getId());
        if (!existant.isPresent()) {
            throw new IllegalArgumentException("Docteur non trouvé avec l'ID: " + docteur.getId());
        }
        if (docteur.getNom() == null || docteur.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du docteur est obligatoire");
        }
        if (docteur.getPrenom() == null || docteur.getPrenom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom du docteur est obligatoire");
        }
        if (docteur.getEmail() == null || docteur.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("L'email du docteur est obligatoire");
        }
        if (docteur.getSpecialite() == null || docteur.getSpecialite().trim().isEmpty()) {
            throw new IllegalArgumentException("La spécialité du docteur est obligatoire");
        }
        return docteurRepository.update(docteur);
    }

    @Override
    public boolean supprimerDocteur(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        Optional<Docteur> docteur = docteurRepository.findById(docteurId);
        if (!docteur.isPresent()) {
            return false;
        }
        docteurRepository.deleteById(docteurId);
        return true;
    }

    @Override
    public Docteur rattacherDocteurADepartement(Long docteurId, Long departementId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        if (departementId == null) {
            throw new IllegalArgumentException("L'ID du département ne peut pas être null");
        }
        
        Optional<Docteur> docteurOpt = docteurRepository.findById(docteurId);
        if (!docteurOpt.isPresent()) {
            throw new IllegalArgumentException("Docteur non trouvé avec l'ID: " + docteurId);
        }
        
        Optional<Departement> departementOpt = departementRepository.findById(departementId);
        if (!departementOpt.isPresent()) {
            throw new IllegalArgumentException("Département non trouvé avec l'ID: " + departementId);
        }
        
        Docteur docteur = docteurOpt.get();
        Departement departement = departementOpt.get();
        docteur.setDepartement(departement);
        
        return docteurRepository.update(docteur);
    }

    @Override
    public List<Docteur> listerTousLesDocteurs() {
        return docteurRepository.findAll();
    }

    @Override
    public List<Docteur> listerDocteursByDepartement(Long departementId) {
        if (departementId == null) {
            throw new IllegalArgumentException("L'ID du département ne peut pas être null");
        }
        return docteurRepository.findByDepartementId(departementId);
    }

    @Override
    public List<Docteur> rechercherDocteurs(String critere) {
        if (critere == null || critere.trim().isEmpty()) {
            return docteurRepository.findAll();
        }
        List<Docteur> resultats = docteurRepository.findByNom(critere);
        List<Docteur> parSpecialite = docteurRepository.findBySpecialite(critere);
        for (Docteur d : parSpecialite) {
            if (!resultats.contains(d)) {
                resultats.add(d);
            }
        }
        return resultats;
    }

    @Override
    public Salle creerSalle(Salle salle) {
        if (salle == null) {
            throw new IllegalArgumentException("La salle ne peut pas être null");
        }
        if (salle.getNomSalle() == null || salle.getNomSalle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom de la salle est obligatoire");
        }
        if (salleRepository.existsByNomSalle(salle.getNomSalle())) {
            throw new IllegalArgumentException("Une salle avec ce nom existe déjà");
        }
        // Validation de la capacité uniquement si elle est fournie
        if (salle.getCapacite() != null && salle.getCapacite() <= 0) {
            throw new IllegalArgumentException("La capacité de la salle doit être supérieure à 0");
        }
        // Validation du département
        if (salle.getDepartement() == null) {
            throw new IllegalArgumentException("Le département est obligatoire");
        }
        return salleRepository.save(salle);
    }

    @Override
    public Salle modifierSalle(Salle salle) {
        if (salle == null) {
            throw new IllegalArgumentException("La salle ne peut pas être null");
        }
        if (salle.getId() == null) {
            throw new IllegalArgumentException("L'ID de la salle est obligatoire pour la modification");
        }
        Optional<Salle> existante = salleRepository.findById(salle.getId());
        if (!existante.isPresent()) {
            throw new IllegalArgumentException("Salle non trouvée avec l'ID: " + salle.getId());
        }
        if (salle.getNomSalle() == null || salle.getNomSalle().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom de la salle est obligatoire");
        }
        // Validation de la capacité uniquement si elle est fournie
        if (salle.getCapacite() != null && salle.getCapacite() <= 0) {
            throw new IllegalArgumentException("La capacité de la salle doit être supérieure à 0");
        }
        // Validation du département
        if (salle.getDepartement() == null) {
            throw new IllegalArgumentException("Le département est obligatoire");
        }
        return salleRepository.update(salle);
    }

    @Override
    public boolean supprimerSalle(Long salleId) {
        if (salleId == null) {
            throw new IllegalArgumentException("L'ID de la salle ne peut pas être null");
        }
        Optional<Salle> salle = salleRepository.findById(salleId);
        if (!salle.isPresent()) {
            return false;
        }
        salleRepository.deleteById(salleId);
        return true;
    }

    @Override
    public Salle getSalleById(Long salleId) {
        if (salleId == null) {
            throw new IllegalArgumentException("L'ID de la salle ne peut pas être null");
        }
        return salleRepository.findById(salleId).orElse(null);
    }

    @Override
    public List<Salle> listerToutesLesSalles() {
        return salleRepository.findAll();
    }

    @Override
    public List<Salle> listerSallesByDepartement(Long departementId) {
        if (departementId == null) {
            throw new IllegalArgumentException("L'ID du département ne peut pas être null");
        }
        return salleRepository.findByDepartementId(departementId);
    }

    @Override
    public boolean verifierDisponibiliteSalle(Long salleId, LocalDateTime dateHeure) {
        if (salleId == null) {
            throw new IllegalArgumentException("L'ID de la salle ne peut pas être null");
        }
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date et heure ne peuvent pas être null");
        }
        
        Optional<Salle> salle = salleRepository.findById(salleId);
        if (!salle.isPresent()) {
            throw new IllegalArgumentException("Salle non trouvée avec l'ID: " + salleId);
        }
        
        List<Consultation> consultations = consultationRepository.findBySalleId(salleId);
        for (Consultation consultation : consultations) {
            if (consultation.getDateHeure().equals(dateHeure) &&
                (consultation.getStatut() == com.clinic.clinicapp.enums.StatusConsultation.RESERVEE ||
                 consultation.getStatut() == com.clinic.clinicapp.enums.StatusConsultation.VALIDEE)) {
                return false;
            }
        }
        return true;
    }

    @Override
    public Salle trouverSalleDisponible(LocalDateTime dateHeure) {
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date et heure ne peuvent pas être null");
        }
        
        List<Salle> salles = salleRepository.findAll();
        for (Salle salle : salles) {
            if (verifierDisponibiliteSalle(salle.getId(), dateHeure)) {
                return salle;
            }
        }
        return null;
    }

    @Override
    public List<Consultation> consulterOccupationSalle(Long salleId, LocalDateTime dateDebut, LocalDateTime dateFin) {
        if (salleId == null) {
            throw new IllegalArgumentException("L'ID de la salle ne peut pas être null");
        }
        if (dateDebut == null || dateFin == null) {
            throw new IllegalArgumentException("Les dates de début et de fin ne peuvent pas être null");
        }
        if (dateDebut.isAfter(dateFin)) {
            throw new IllegalArgumentException("La date de début doit être antérieure à la date de fin");
        }
        
        List<Consultation> toutesConsultations = consultationRepository.findBySalleId(salleId);
        List<Consultation> consultationsPeriode = new ArrayList<>();
        
        for (Consultation consultation : toutesConsultations) {
            LocalDateTime dateConsultation = consultation.getDateHeure();
            if (!dateConsultation.isBefore(dateDebut) && !dateConsultation.isAfter(dateFin)) {
                consultationsPeriode.add(consultation);
            }
        }
        
        return consultationsPeriode;
    }

    @Override
    public Map<Long, Double> optimiserOccupationSalles(LocalDateTime dateDebut, LocalDateTime dateFin) {
        if (dateDebut == null || dateFin == null) {
            throw new IllegalArgumentException("Les dates de début et de fin ne peuvent pas être null");
        }
        if (dateDebut.isAfter(dateFin)) {
            throw new IllegalArgumentException("La date de début doit être antérieure à la date de fin");
        }
        
        Map<Long, Double> tauxOccupation = new HashMap<>();
        List<Salle> salles = salleRepository.findAll();
        
        long heuresTotal = java.time.Duration.between(dateDebut, dateFin).toHours();
        if (heuresTotal == 0) {
            heuresTotal = 1;
        }
        
        for (Salle salle : salles) {
            List<Consultation> consultations = consulterOccupationSalle(salle.getId(), dateDebut, dateFin);
            long heuresOccupees = consultations.size();
            double taux = (heuresOccupees * 100.0) / heuresTotal;
            tauxOccupation.put(salle.getId(), taux);
        }
        
        return tauxOccupation;
    }

    @Override
    public List<Consultation> superviserToutesLesConsultations() {
        return consultationRepository.findAll();
    }

    @Override
    public List<Consultation> consulterConsultationsByStatut(String statut) {
        if (statut == null || statut.trim().isEmpty()) {
            throw new IllegalArgumentException("Le statut ne peut pas être null ou vide");
        }
        
        try {
            StatusConsultation statusConsultation = StatusConsultation.valueOf(statut.toUpperCase());
            return consultationRepository.findByStatut(statusConsultation);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Statut invalide: " + statut + ". Valeurs acceptées: RESERVEE, VALIDEE, ANNULEE, TERMINEE");
        }
    }

    @Override
    public List<Consultation> consulterConsultationsByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin) {
        if (dateDebut == null || dateFin == null) {
            throw new IllegalArgumentException("Les dates de début et de fin ne peuvent pas être null");
        }
        if (dateDebut.isAfter(dateFin)) {
            throw new IllegalArgumentException("La date de début doit être antérieure à la date de fin");
        }
        return consultationRepository.findByDateBetween(dateDebut, dateFin);
    }

    @Override
    public List<Consultation> consulterConsultationsByPatient(Long patientId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        return consultationRepository.findByPatientId(patientId);
    }

    @Override
    public List<Consultation> consulterConsultationsByDocteur(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        return consultationRepository.findByDocteurId(docteurId);
    }

    @Override
    public Consultation annulerConsultation(Long consultationId, String motifAnnulation) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        if (!consultationOpt.isPresent()) {
            throw new IllegalArgumentException("Consultation non trouvée avec l'ID: " + consultationId);
        }
        
        Consultation consultation = consultationOpt.get();
        
        if (consultation.getStatut() == StatusConsultation.ANNULEE) {
            throw new IllegalArgumentException("Cette consultation est déjà annulée");
        }
        if (consultation.getStatut() == StatusConsultation.TERMINEE) {
            throw new IllegalArgumentException("Impossible d'annuler une consultation terminée");
        }
        
        consultation.setStatut(StatusConsultation.ANNULEE);
        
        if (motifAnnulation != null && !motifAnnulation.trim().isEmpty()) {
            String compteRenduActuel = consultation.getCompteRendu() != null ? consultation.getCompteRendu() : "";
            consultation.setCompteRendu(compteRenduActuel + "\nMOTIF D'ANNULATION: " + motifAnnulation);
        }
        
        consultation.setDateModification(LocalDateTime.now());
        
        return consultationRepository.update(consultation);
    }

    @Override
    public List<Patient> listerTousLesPatients() {
        return patientRepository.findAll();
    }

    @Override
    public List<Patient> rechercherPatientsByNom(String nom) {
        if (nom == null || nom.trim().isEmpty()) {
            return patientRepository.findAll();
        }
        return patientRepository.findByNom(nom);
    }

    @Override
    public Patient modifierPatient(Patient patient) {
        if (patient == null) {
            throw new IllegalArgumentException("Le patient ne peut pas être null");
        }
        if (patient.getId() == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        
        Optional<Patient> patientExistant = patientRepository.findById(patient.getId());
        if (!patientExistant.isPresent()) {
            throw new IllegalArgumentException("Patient non trouvé avec l'ID: " + patient.getId());
        }
        
        // Validation des données
        if (patient.getNom() == null || patient.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom du patient est obligatoire");
        }
        if (patient.getPrenom() == null || patient.getPrenom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom du patient est obligatoire");
        }
        if (patient.getEmail() == null || patient.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("L'email du patient est obligatoire");
        }
        
        return patientRepository.update(patient);
    }

    @Override
    public boolean supprimerPatient(Long patientId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        Optional<Patient> patient = patientRepository.findById(patientId);
        if (!patient.isPresent()) {
            return false;
        }
        patientRepository.deleteById(patientId);
        return true;
    }

    @Override
    public long obtenirNombreTotalPatients() {
        return 0;
    }

    @Override
    public long obtenirNombreTotalDocteurs() {
        return 0;
    }

    @Override
    public long obtenirNombreTotalConsultations() {
        return 0;
    }

    @Override
    public Map<String, Long> obtenirNombreConsultationsByStatut() {
        return null;
    }

    @Override
    public double calculerTauxOccupationGlobalSalles(LocalDateTime dateDebut, LocalDateTime dateFin) {
        return 0.0;
    }

    @Override
    public Map<Long, Long> obtenirConsultationsByDepartement(LocalDateTime dateDebut, LocalDateTime dateFin) {
        return null;
    }

    @Override
    public Map<Docteur, Long> obtenirDocteursPlusConsultes(int limite, LocalDateTime dateDebut, LocalDateTime dateFin) {
        return null;
    }

    @Override
    public Map<String, Object> genererRapportStatistique(LocalDateTime dateDebut, LocalDateTime dateFin) {
        return null;
    }
}
