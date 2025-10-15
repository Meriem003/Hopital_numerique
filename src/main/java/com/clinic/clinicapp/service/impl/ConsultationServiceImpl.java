package com.clinic.clinicapp.service.impl;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Salle;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.service.ConsultationService;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * Impl�mentation du service Consultation
 */
public class ConsultationServiceImpl implements ConsultationService {

    private final ConsultationRepository consultationRepository;
    private final SalleRepository salleRepository;

    public ConsultationServiceImpl(ConsultationRepository consultationRepository, SalleRepository salleRepository) {
        this.consultationRepository = consultationRepository;
        this.salleRepository = salleRepository;
    }
    @Override
    public Consultation creerConsultation(Consultation consultation) {
        if (consultation == null) {
            throw new IllegalArgumentException("La consultation ne peut pas être null");
        }
        if (consultation.getDateHeure() == null) {
            throw new IllegalArgumentException("La date/heure de la consultation est requise");
        }
        if (consultation.getDocteur() == null) {
            throw new IllegalArgumentException("Un docteur doit être associé à la consultation");
        }
        if (consultation.getPatient() == null) {
            throw new IllegalArgumentException("Un patient doit être associé à la consultation");
        }

        consultation.setStatut(StatusConsultation.RESERVEE);
        return consultationRepository.save(consultation);
    }

    @Override
    public Consultation mettreAJourConsultation(Consultation consultation) {
        if (consultation == null || consultation.getId() == null) {
            throw new IllegalArgumentException("La consultation ou son ID ne peut pas être null");
        }
        Optional<Consultation> exist = consultationRepository.findById(consultation.getId());
        if (!exist.isPresent()) {
            throw new IllegalArgumentException("La consultation à mettre à jour n'existe pas");
        }

        // Ne pas autoriser la modification d'une consultation terminée
        if (StatusConsultation.TERMINEE.equals(exist.get().getStatut())) {
            throw new IllegalStateException("Une consultation terminée ne peut pas être modifiée");
        }

        return consultationRepository.update(consultation);
    }

    @Override
    public Consultation getConsultationById(Long consultationId) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        Optional<Consultation> opt = consultationRepository.findById(consultationId);
        return opt.orElse(null);
    }

    @Override
    public boolean supprimerConsultation(Long consultationId) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        Optional<Consultation> opt = consultationRepository.findById(consultationId);
        if (!opt.isPresent()) {
            return false;
        }
    consultationRepository.deleteById(consultationId);
        return true;
    }

    @Override
    public List<Consultation> listerToutesLesConsultations() {
        return consultationRepository.findAll();
    }

    @Override
    public List<Consultation> getConsultationsByPatient(Long patientId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        return consultationRepository.findByPatientId(patientId);
    }

    @Override
    public List<Consultation> getConsultationsByDocteur(Long docteurId) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        return consultationRepository.findByDocteurId(docteurId);
    }

    @Override
    public List<Consultation> getConsultationsBySalle(Long salleId) {
        if (salleId == null) {
            throw new IllegalArgumentException("L'ID de la salle ne peut pas être null");
        }
        return consultationRepository.findBySalleId(salleId);
    }

    @Override
    public List<Consultation> getConsultationsByStatut(StatusConsultation statut) {
        if (statut == null) {
            throw new IllegalArgumentException("Le statut ne peut pas être null");
        }
        return consultationRepository.findByStatut(statut);
    }

    @Override
    public List<Consultation> getConsultationsByPeriode(LocalDateTime dateDebut, LocalDateTime dateFin) {
        if (dateDebut == null || dateFin == null) {
            throw new IllegalArgumentException("Les dates de début et de fin sont requises");
        }
        if (dateFin.isBefore(dateDebut)) {
            throw new IllegalArgumentException("La date de fin doit être après la date de début");
        }
        return consultationRepository.findByDateBetween(dateDebut, dateFin);
    }

    @Override
    public List<Consultation> getConsultationsByPatientAndDocteur(Long patientId, Long docteurId) {
        if (patientId == null) {
            throw new IllegalArgumentException("L'ID du patient ne peut pas être null");
        }
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        List<Consultation> byPatient = consultationRepository.findByPatientId(patientId);
        return byPatient.stream()
                .filter(c -> c.getDocteur() != null && docteurId.equals(c.getDocteur().getId()))
                .collect(Collectors.toList());
    }

    @Override
    public boolean existeConsultationPourCreneau(LocalDateTime dateHeure, Long salleId) {
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date/heure du créneau ne peut pas être null");
        }
        if (salleId == null) {
            throw new IllegalArgumentException("L'ID de la salle ne peut pas être null");
        }

        List<Consultation> consultations = consultationRepository.findBySalleId(salleId);
        if (consultations == null || consultations.isEmpty()) {
            return false;
        }

        for (Consultation c : consultations) {
            if (c == null || c.getDateHeure() == null) continue;
            // ignore cancelled consultations
            if (c.getStatut() != null && StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
            if (creneauxSeChevauchent(c.getDateHeure(), dateHeure)) {
                return true;
            }
        }

        return false;
    }

    @Override
    public Consultation changerStatut(Long consultationId, StatusConsultation nouveauStatut) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        if (nouveauStatut == null) {
            throw new IllegalArgumentException("Le nouveau statut ne peut pas être null");
        }

        Optional<Consultation> opt = consultationRepository.findById(consultationId);
        if (!opt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }

        Consultation consultation = opt.get();
        StatusConsultation ancien = consultation.getStatut();

        if (StatusConsultation.TERMINEE.equals(ancien)) {
            throw new IllegalStateException("Une consultation terminée ne peut pas changer de statut");
        }

        if (StatusConsultation.ANNULEE.equals(ancien) && !StatusConsultation.RESERVEE.equals(nouveauStatut)) {
            throw new IllegalStateException("Une consultation annulée ne peut être modifiée qu'en RESERVEE");
        }

        consultation.setStatut(nouveauStatut);
        consultationRepository.update(consultation);
        return consultation;
    }

    @Override
    public Consultation ajouterCompteRendu(Long consultationId, String compteRendu, String diagnostic, String traitement) {
        if (consultationId == null) {
            throw new IllegalArgumentException("L'ID de la consultation ne peut pas être null");
        }
        if (compteRendu == null || compteRendu.trim().isEmpty()) {
            throw new IllegalArgumentException("Le compte-rendu ne peut pas être vide");
        }

        Optional<Consultation> opt = consultationRepository.findById(consultationId);
        if (!opt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultationId + " n'existe pas");
        }

        Consultation consultation = opt.get();

        if (StatusConsultation.ANNULEE.equals(consultation.getStatut())) {
            throw new IllegalStateException("Une consultation annulée ne peut pas recevoir de compte-rendu");
        }

        // Ajouter/mettre à jour le compte-rendu médical
        consultation.setCompteRendu(compteRendu);
        if (diagnostic != null && !diagnostic.trim().isEmpty()) {
            consultation.setDiagnostic(diagnostic);
        }
        if (traitement != null && !traitement.trim().isEmpty()) {
            consultation.setTraitement(traitement);
        }

        // Si la consultation est validée, on peut la marquer comme terminée automatiquement
        if (StatusConsultation.VALIDEE.equals(consultation.getStatut())) {
            consultation.setStatut(StatusConsultation.TERMINEE);
        }

        consultationRepository.update(consultation);
        return consultation;
    }

    @Override
    public boolean verifierDisponibiliteCreneau(Long docteurId, LocalDateTime dateHeure) {
        if (docteurId == null) {
            throw new IllegalArgumentException("L'ID du docteur ne peut pas être null");
        }
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date/heure du créneau ne peut pas être null");
        }

        List<Consultation> consultations = consultationRepository.findByDocteurId(docteurId);
        if (consultations == null || consultations.isEmpty()) {
            return true;
        }

        for (Consultation c : consultations) {
            if (c == null || c.getDateHeure() == null) continue;
            if (c.getStatut() != null && StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
            if (creneauxSeChevauchent(c.getDateHeure(), dateHeure)) {
                return false;
            }
        }

        return true;
    }

    @Override
    public Salle trouverSalleDisponible(LocalDateTime dateHeure) {
        if (dateHeure == null) {
            throw new IllegalArgumentException("La date/heure du créneau ne peut pas être null");
        }

        List<Salle> salles = salleRepository.findAll();
        if (salles == null || salles.isEmpty()) {
            return null;
        }

        for (Salle s : salles) {
            if (s == null || s.getId() == null) continue;
            boolean occupe = existeConsultationPourCreneau(dateHeure, s.getId());
            if (!occupe) {
                return s;
            }
        }

        return null;
    }

    @Override
    public LocalDateTime calculerFinCreneau(LocalDateTime dateHeureDebut) {
        if (dateHeureDebut == null) {
            throw new IllegalArgumentException("La date/heure de début ne peut pas être null");
        }
        return dateHeureDebut.plusMinutes(30);
    }

    @Override
    public boolean creneauxSeChevauchent(LocalDateTime debut1, LocalDateTime debut2) {
        if (debut1 == null || debut2 == null) {
            throw new IllegalArgumentException("Les dates de début ne peuvent pas être null");
        }

        LocalDateTime fin1 = calculerFinCreneau(debut1);
        LocalDateTime fin2 = calculerFinCreneau(debut2);

        // No overlap if fin1 <= debut2 OR fin2 <= debut1
        boolean fin1AvantOuEgaleDebut2 = fin1.isBefore(debut2) || fin1.isEqual(debut2);
        boolean fin2AvantOuEgaleDebut1 = fin2.isBefore(debut1) || fin2.isEqual(debut1);

        return !(fin1AvantOuEgaleDebut2 || fin2AvantOuEgaleDebut1);
    }

    @Override
    public long compterConsultationsByStatut(StatusConsultation statut) {
        return 0;
    }

    @Override
    public boolean validerConsultation(Consultation consultation) {
        if (consultation == null) {
            throw new IllegalArgumentException("La consultation ne peut pas être null");
        }
        if (consultation.getId() == null) {
            throw new IllegalArgumentException("L'ID de la consultation est requis pour validation");
        }

        Optional<Consultation> opt = consultationRepository.findById(consultation.getId());
        if (!opt.isPresent()) {
            throw new IllegalArgumentException("La consultation avec l'ID " + consultation.getId() + " n'existe pas");
        }

        Consultation existing = opt.get();

        if (StatusConsultation.ANNULEE.equals(existing.getStatut())) {
            throw new IllegalStateException("Une consultation annulée ne peut pas être validée");
        }
        if (StatusConsultation.TERMINEE.equals(existing.getStatut())) {
            throw new IllegalStateException("Une consultation terminée ne peut pas être validée");
        }

        if (existing.getDateHeure() == null) {
            throw new IllegalArgumentException("La date/heure de la consultation est requise");
        }
        if (existing.getDocteur() == null || existing.getDocteur().getId() == null) {
            throw new IllegalArgumentException("La consultation doit avoir un docteur associé");
        }
        if (existing.getSalle() == null || existing.getSalle().getId() == null) {
            throw new IllegalArgumentException("La consultation doit avoir une salle associée");
        }

        // Vérifier disponibilité du docteur en ignorant la consultation courante
        List<Consultation> byDocteur = consultationRepository.findByDocteurId(existing.getDocteur().getId());
        for (Consultation c : byDocteur) {
            if (c == null || c.getDateHeure() == null) continue;
            if (c.getId() != null && c.getId().equals(existing.getId())) continue; // ignore self
            if (c.getStatut() != null && StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
            if (creneauxSeChevauchent(c.getDateHeure(), existing.getDateHeure())) {
                throw new IllegalStateException("Le docteur n'est pas disponible pour ce créneau");
            }
        }

        // Vérifier disponibilité de la salle en ignorant la consultation courante
        List<Consultation> bySalle = consultationRepository.findBySalleId(existing.getSalle().getId());
        for (Consultation c : bySalle) {
            if (c == null || c.getDateHeure() == null) continue;
            if (c.getId() != null && c.getId().equals(existing.getId())) continue; // ignore self
            if (c.getStatut() != null && StatusConsultation.ANNULEE.equals(c.getStatut())) continue;
            if (creneauxSeChevauchent(c.getDateHeure(), existing.getDateHeure())) {
                throw new IllegalStateException("La salle est occupée pour ce créneau");
            }
        }

        existing.setStatut(StatusConsultation.VALIDEE);
        consultationRepository.update(existing);
        return true;
    }
}
