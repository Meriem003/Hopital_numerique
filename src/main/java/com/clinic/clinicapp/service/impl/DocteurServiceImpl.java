package com.clinic.clinicapp.service.impl;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.service.DocteurService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

public class DocteurServiceImpl implements DocteurService {

    private final ConsultationRepository consultationRepository;
    private final DocteurRepository docteurRepository;

    public DocteurServiceImpl(ConsultationRepository consultationRepository, DocteurRepository docteurRepository) {
        this.consultationRepository = consultationRepository;
        this.docteurRepository = docteurRepository;
    }

    @Override
    public List<Consultation> consulterPlanning(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        
        Optional<Docteur> docteur = docteurRepository.findById(docteurId);
        if (!docteur.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }
        
        List<Consultation> consultations = consultationRepository.findAll();
        return consultations.stream()
                .filter(c -> c.getDocteur() != null && c.getDocteur().getId().equals(docteurId))
                .collect(Collectors.toList());
    }

    @Override
    public List<Consultation> consulterConsultationsAVenir(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        
        Optional<Docteur> docteur = docteurRepository.findById(docteurId);
        if (!docteur.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }
        
        LocalDateTime maintenant = LocalDateTime.now();
        List<Consultation> consultations = consultationRepository.findAll();
        return consultations.stream()
                .filter(c -> c.getDocteur() != null && c.getDocteur().getId().equals(docteurId))
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().isAfter(maintenant))
                .collect(Collectors.toList());
    }

    @Override
    public List<Consultation> consulterConsultationsDuJour(Long docteurId, LocalDateTime date) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        if (date == null) {
            throw new IllegalArgumentException("La date ne peut pas être null");
        }
        
        Optional<Docteur> docteur = docteurRepository.findById(docteurId);
        if (!docteur.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }
        
        List<Consultation> consultations = consultationRepository.findAll();
        return consultations.stream()
                .filter(c -> c.getDocteur() != null && c.getDocteur().getId().equals(docteurId))
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().toLocalDate().equals(date.toLocalDate()))
                .collect(Collectors.toList());
    }

    @Override
    public List<Consultation> consulterReservationsEnAttente(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        
        Optional<Docteur> docteur = docteurRepository.findById(docteurId);
        if (!docteur.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }
        
        List<Consultation> consultations = consultationRepository.findAll();
        return consultations.stream()
                .filter(c -> c.getDocteur() != null && c.getDocteur().getId().equals(docteurId))
                .filter(c -> StatusConsultation.RESERVEE.equals(c.getStatut()))
                .collect(Collectors.toList());
    }

    @Override
    public Consultation validerReservation(Long consultationId) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        if (!consultationOpt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }
        
        Consultation consultation = consultationOpt.get();
        
        if (!StatusConsultation.RESERVEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Seules les consultations avec le statut RESERVEE peuvent être validées");
        }
        
        consultation.setStatut(StatusConsultation.VALIDEE);
        consultationRepository.update(consultation);
        
        return consultation;
    }

    @Override
    public Consultation refuserReservation(Long consultationId, String motifRefus) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        if (motifRefus == null || motifRefus.trim().isEmpty()) {
            throw new IllegalArgumentException("Le motif de refus ne peut pas être vide");
        }
        
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        if (!consultationOpt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }
        
        Consultation consultation = consultationOpt.get();
        
        if (!StatusConsultation.RESERVEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Seules les consultations avec le statut RESERVEE peuvent être refusées");
        }
        
        consultation.setStatut(StatusConsultation.ANNULEE);
        if (consultation.getCompteRendu() == null || consultation.getCompteRendu().isEmpty()) {
            consultation.setCompteRendu("Refusée: " + motifRefus);
        } else {
            consultation.setCompteRendu(consultation.getCompteRendu() + " | Refusée: " + motifRefus);
        }
        consultationRepository.update(consultation);
        
        return consultation;
    }

    @Override
    public Consultation realiserConsultation(Long consultationId, String compteRendu, String diagnostic, String traitement) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        if (compteRendu == null || compteRendu.trim().isEmpty()) {
            throw new IllegalArgumentException("Le compte-rendu ne peut pas être vide");
        }
        if (diagnostic == null || diagnostic.trim().isEmpty()) {
            throw new IllegalArgumentException("Le diagnostic ne peut pas être vide");
        }
        if (traitement == null || traitement.trim().isEmpty()) {
            throw new IllegalArgumentException("Le traitement ne peut pas être vide");
        }
        
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        if (!consultationOpt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }
        
        Consultation consultation = consultationOpt.get();
        
        if (!StatusConsultation.VALIDEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Seules les consultations avec le statut VALIDEE peuvent être réalisées");
        }
        
        consultation.setCompteRendu(compteRendu);
        consultation.setDiagnostic(diagnostic);
        consultation.setTraitement(traitement);
        consultation.setStatut(StatusConsultation.TERMINEE);
        consultationRepository.update(consultation);
        
        return consultation;
    }

    @Override
    public Consultation mettreAJourStatutConsultation(Long consultationId, StatusConsultation nouveauStatut) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        if (nouveauStatut == null) {
            throw new IllegalArgumentException("Le nouveau statut ne peut pas être null");
        }
        
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        if (!consultationOpt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }
        
        Consultation consultation = consultationOpt.get();
        StatusConsultation ancienStatut = consultation.getStatut();
        
        if (StatusConsultation.TERMINEE.equals(ancienStatut)) {
            throw new IllegalStateException("Une consultation terminée ne peut pas changer de statut");
        }
        
        if (StatusConsultation.ANNULEE.equals(ancienStatut) && !StatusConsultation.RESERVEE.equals(nouveauStatut)) {
            throw new IllegalStateException("Une consultation annulée ne peut être modifiée qu'en RESERVEE");
        }
        
        consultation.setStatut(nouveauStatut);
        consultationRepository.update(consultation);
        
        return consultation;
    }

    @Override
    public Consultation terminerConsultation(Long consultationId) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        
        Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
        if (!consultationOpt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }
        
        Consultation consultation = consultationOpt.get();
        
        if (StatusConsultation.TERMINEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("La consultation est déjà terminée");
        }
        
        if (StatusConsultation.ANNULEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Une consultation annulée ne peut pas être terminée");
        }
        
        if (consultation.getCompteRendu() == null || consultation.getCompteRendu().trim().isEmpty()) {
            throw new IllegalStateException("Le compte-rendu doit être rempli avant de terminer la consultation");
        }
        if (consultation.getDiagnostic() == null || consultation.getDiagnostic().trim().isEmpty()) {
            throw new IllegalStateException("Le diagnostic doit être rempli avant de terminer la consultation");
        }
        if (consultation.getTraitement() == null || consultation.getTraitement().trim().isEmpty()) {
            throw new IllegalStateException("Le traitement doit être rempli avant de terminer la consultation");
        }
        
        consultation.setStatut(StatusConsultation.TERMINEE);
        consultationRepository.update(consultation);
        
        return consultation;
    }

    @Override
    public List<Consultation> consulterHistoriqueMedicalPatient(Long docteurId, Long patientId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }

        Optional<Docteur> docOpt = docteurRepository.findById(docteurId);
        if (!docOpt.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }

        List<Consultation> byPatient = consultationRepository.findByPatientId(patientId);
        LocalDateTime now = LocalDateTime.now();
        return byPatient.stream()
                .filter(c -> c.getDocteur() != null && docteurId.equals(c.getDocteur().getId()))
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().isBefore(now))
                .sorted((a, b) -> b.getDateHeure().compareTo(a.getDateHeure()))
                .collect(Collectors.toList());
    }

    @Override
    public List<Patient> consulterPatientssSuivis(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }

        Optional<Docteur> docOpt = docteurRepository.findById(docteurId);
        if (!docOpt.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }

        List<Consultation> byDocteur = consultationRepository.findByDocteurId(docteurId);
        return byDocteur.stream()
                .map(Consultation::getPatient)
                .filter(p -> p != null)
                .distinct()
                .collect(Collectors.toList());
    }

    @Override
    public List<Consultation> consulterConsultationsPassees(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }

        Optional<Docteur> docOpt = docteurRepository.findById(docteurId);
        if (!docOpt.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }

        LocalDateTime now = LocalDateTime.now();
        List<Consultation> byDocteur = consultationRepository.findByDocteurId(docteurId);
        return byDocteur.stream()
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().isBefore(now))
                .sorted((a, b) -> b.getDateHeure().compareTo(a.getDateHeure()))
                .collect(Collectors.toList());
    }

    @Override
    public boolean estDisponible(Long docteurId, LocalDateTime dateHeure) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date/heure ne peut pas être null");
        }

        Optional<Docteur> docOpt = docteurRepository.findById(docteurId);
        if (!docOpt.isPresent()) {
            throw new IllegalArgumentException("Le docteur avec l'ID " + docteurId + " n'existe pas");
        }

        List<Consultation> byDocteur = consultationRepository.findByDocteurId(docteurId);
        if (byDocteur == null || byDocteur.isEmpty()) return true;

        LocalDateTime start = dateHeure;
        LocalDateTime end = dateHeure.plusMinutes(30);

        for (Consultation c : byDocteur) {
            if (c == null || c.getDateHeure() == null) continue;
            if (c.getStatut() != null && StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
            LocalDateTime s = c.getDateHeure();
            LocalDateTime e = s.plusMinutes(30);
            boolean noOverlap = e.isBefore(start) || e.isEqual(start) || end.isBefore(s) || end.isEqual(s);
            if (!noOverlap) {
                return false;
            }
        }

        return true;
    }

}
