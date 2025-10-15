package com.clinic.clinicapp.service.impl;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.PatientRepository;
import com.clinic.clinicapp.service.PatientService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Implémentation du service Patient
 */
public class PatientServiceImpl implements PatientService {

    private final PatientRepository patientRepository;
    private final DocteurRepository docteurRepository;
    private final ConsultationRepository consultationRepository;

    public PatientServiceImpl(PatientRepository patientRepository, DocteurRepository docteurRepository, 
                             ConsultationRepository consultationRepository) {
        this.patientRepository = patientRepository;
        this.docteurRepository = docteurRepository;
        this.consultationRepository = consultationRepository;
    }

    @Override
    public Patient mettreAJourPatient(Patient patient) {
        if (patient == null || patient.getId() == null) {
            throw new IllegalArgumentException("Le patient ou son ID ne peut pas être null");
        }
        
        Optional<Patient> existant = patientRepository.findById(patient.getId());
        if (!existant.isPresent()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + patient.getId() + " n'existe pas");
        }
        
        if (patient.getEmail() != null && !patient.getEmail().equals(existant.get().getEmail())) {
            if (patientRepository.existsByEmail(patient.getEmail())) {
                throw new IllegalArgumentException("Un patient avec cet email existe déjà");
            }
        }
        
        return patientRepository.update(patient);
    }

    @Override
    public Patient getPatientById(Long patientId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        
        Optional<Patient> opt = patientRepository.findById(patientId);
        return opt.orElse(null);
    }

    @Override
    public Patient getPatientByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            throw new IllegalArgumentException("L'email ne peut pas être vide");
        }
        
        Optional<Patient> opt = patientRepository.findByEmail(email);
        return opt.orElse(null);
    }

    @Override
    public List<Docteur> consulterTousLesDocteurs() {
        return docteurRepository.findAll();
    }

    @Override
    public List<Docteur> consulterDocteursByDepartement(Long departementId) {
        if (departementId == null) {
            throw new IllegalArgumentException("L'ID du département ne peut pas être null");
        }
        return docteurRepository.findByDepartementId(departementId);
    }

    @Override
    public List<Docteur> consulterDocteursBySpecialite(String specialite) {
        if (specialite == null || specialite.trim().isEmpty()) {
            throw new IllegalArgumentException("La spécialité ne peut pas être vide");
        }
        return docteurRepository.findBySpecialite(specialite);
    }

    @Override
    public Consultation reserverRendezVous(Long patientId, Long docteurId, LocalDateTime dateHeure, String motif) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date/heure ne peut pas être null");
        }
        
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (!patientOpt.isPresent()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + patientId + " n'existe pas");
        }
        
        Optional<Docteur> docteurOpt = docteurRepository.findById(docteurId);
        if (!docteurOpt.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }
        
        Docteur docteur = docteurOpt.get();
        if (docteur.getSalle() == null) {
            throw new IllegalStateException("Le docteur doit avoir une salle associée");
        }
        
        List<Consultation> consultationsDocteur = consultationRepository.findByDocteurId(docteurId);
        LocalDateTime fin = dateHeure.plusMinutes(30);
        for (Consultation c : consultationsDocteur) {
            if (c == null || c.getDateHeure() == null) continue;
            if (StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
            LocalDateTime s = c.getDateHeure();
            LocalDateTime e = s.plusMinutes(30);
            boolean overlap = !(fin.isBefore(s) || fin.isEqual(s) || dateHeure.isAfter(e) || dateHeure.isEqual(e));
            if (overlap) {
                throw new IllegalStateException("Le docteur n'est pas disponible pour ce créneau");
            }
        }
        
        Consultation consultation = new Consultation();
        consultation.setPatient(patientOpt.get());
        consultation.setDocteur(docteur);
        consultation.setSalle(docteur.getSalle());
        consultation.setDateHeure(dateHeure);
        consultation.setMotif(motif);
        consultation.setStatut(StatusConsultation.RESERVEE);
        
        return consultationRepository.save(consultation);
    }

    @Override
    public boolean annulerReservation(Long consultationId) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        
        Optional<Consultation> opt = consultationRepository.findById(consultationId);
        if (!opt.isPresent()) {
            return false;
        }
        
        Consultation consultation = opt.get();
        
        if (StatusConsultation.TERMINEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Une consultation terminée ne peut pas être annulée");
        }
        
        if (StatusConsultation.ANNULEE.equals(consultation.getStatut())) {
            return false;
        }
        
        consultation.setStatut(StatusConsultation.ANNULEE);
        consultationRepository.update(consultation);
        return true;
    }

    @Override
    public Consultation modifierReservation(Long consultationId, LocalDateTime nouvelleDate, String nouveauMotif) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        
        Optional<Consultation> opt = consultationRepository.findById(consultationId);
        if (!opt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }
        
        Consultation consultation = opt.get();
        
        if (StatusConsultation.TERMINEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Une consultation terminée ne peut pas être modifiée");
        }
        
        if (StatusConsultation.ANNULEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Une consultation annulée ne peut pas être modifiée");
        }
        
        if (nouvelleDate != null && !nouvelleDate.equals(consultation.getDateHeure())) {
            if (consultation.getDocteur() == null || consultation.getDocteur().getId() == null) {
                throw new IllegalStateException("La consultation doit avoir un docteur associé");
            }
            
            List<Consultation> consultationsDocteur = consultationRepository.findByDocteurId(consultation.getDocteur().getId());
            LocalDateTime fin = nouvelleDate.plusMinutes(30);
            for (Consultation c : consultationsDocteur) {
                if (c == null || c.getDateHeure() == null) continue;
                if (c.getId() != null && c.getId().equals(consultationId)) continue;
                if (StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
                LocalDateTime s = c.getDateHeure();
                LocalDateTime e = s.plusMinutes(30);
                boolean overlap = !(fin.isBefore(s) || fin.isEqual(s) || nouvelleDate.isAfter(e) || nouvelleDate.isEqual(e));
                if (overlap) {
                    throw new IllegalStateException("Le docteur n'est pas disponible pour ce nouveau créneau");
                }
            }
            
            consultation.setDateHeure(nouvelleDate);
        }
        
        if (nouveauMotif != null && !nouveauMotif.trim().isEmpty()) {
            consultation.setMotif(nouveauMotif);
        }
        
        return consultationRepository.update(consultation);
    }

    @Override
    public List<Consultation> consulterHistoriqueConsultations(Long patientId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (!patientOpt.isPresent()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + patientId + " n'existe pas");
        }
        
        List<Consultation> consultations = consultationRepository.findByPatientId(patientId);
        return consultations.stream()
                .sorted((a, b) -> {
                    if (a.getDateHeure() == null && b.getDateHeure() == null) return 0;
                    if (a.getDateHeure() == null) return 1;
                    if (b.getDateHeure() == null) return -1;
                    return b.getDateHeure().compareTo(a.getDateHeure());
                })
                .collect(Collectors.toList());
    }

    @Override
    public List<Consultation> consulterConsultationsAVenir(Long patientId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (!patientOpt.isPresent()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + patientId + " n'existe pas");
        }
        
        LocalDateTime maintenant = LocalDateTime.now();
        List<Consultation> consultations = consultationRepository.findByPatientId(patientId);
        return consultations.stream()
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().isAfter(maintenant))
                .filter(c -> !StatusConsultation.ANNULEE.equals(c.getStatut()))
                .sorted((a, b) -> a.getDateHeure().compareTo(b.getDateHeure()))
                .collect(Collectors.toList());
    }

    @Override
    public List<Consultation> consulterConsultationsPassees(Long patientId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (!patientOpt.isPresent()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + patientId + " n'existe pas");
        }
        
        LocalDateTime maintenant = LocalDateTime.now();
        List<Consultation> consultations = consultationRepository.findByPatientId(patientId);
        return consultations.stream()
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().isBefore(maintenant))
                .sorted((a, b) -> b.getDateHeure().compareTo(a.getDateHeure()))
                .collect(Collectors.toList());
    }

    @Override
    public Consultation consulterDetailConsultation(Long consultationId) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        
        Optional<Consultation> opt = consultationRepository.findById(consultationId);
        return opt.orElse(null);
    }

    @Override
    public boolean peutReserverCreneau(Long patientId, LocalDateTime dateHeure) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date/heure ne peut pas être null");
        }
        
        Optional<Patient> patientOpt = patientRepository.findById(patientId);
        if (!patientOpt.isPresent()) {
            throw new IllegalArgumentException("Le patient avec l'ID " + patientId + " n'existe pas");
        }
        
        List<Consultation> consultationsPatient = consultationRepository.findByPatientId(patientId);
        LocalDateTime fin = dateHeure.plusMinutes(30);
        
        for (Consultation c : consultationsPatient) {
            if (c == null || c.getDateHeure() == null) continue;
            if (StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
            
            LocalDateTime s = c.getDateHeure();
            LocalDateTime e = s.plusMinutes(30);
            boolean overlap = !(fin.isBefore(s) || fin.isEqual(s) || dateHeure.isAfter(e) || dateHeure.isEqual(e));
            
            if (overlap) {
                return false;
            }
        }
        
        return true;
    }
}
