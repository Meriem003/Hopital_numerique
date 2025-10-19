package com.clinic.clinicapp.entity;

import jakarta.persistence.*;
import com.clinic.clinicapp.enums.StatusConsultation;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;

@Entity
@Table(name = "consultations")
public class Consultation {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "date_heure", nullable = false)
    private LocalDateTime dateHeure;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "statut", nullable = false)
    private StatusConsultation statut = StatusConsultation.RESERVEE;
    
    @Column(name = "motif")
    private String motif;
    
    @Column(name = "compte_rendu")
    private String compteRendu;
    
    @Column(name = "diagnostic", length = 1000)
    private String diagnostic;
    
    @Column(name = "traitement", length = 1000)
    private String traitement;
    
    @Column(name = "date_creation")
    private LocalDateTime dateCreation;
    
    @Column(name = "date_modification")
    private LocalDateTime dateModification;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "patient_id", referencedColumnName = "id", nullable = false)
    private Patient patient;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "docteur_id", referencedColumnName = "id", nullable = false)
    private Docteur docteur;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "salle_id", referencedColumnName = "id", nullable = false)
    private Salle salle;
    
    public Consultation() {
        this.dateCreation = LocalDateTime.now();
        this.statut = StatusConsultation.RESERVEE;
    }
    
    public Consultation(LocalDateTime dateHeure, String motif, Patient patient, Docteur docteur, Salle salle) {
        this();
        this.dateHeure = dateHeure;
        this.motif = motif;
        this.patient = patient;
        this.docteur = docteur;
        this.salle = salle;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public LocalDateTime getDateHeure() {
        return dateHeure;
    }
    
    // Méthode pour compatibilité JSP avec fmt:formatDate
    public Date getDate() {
        if (dateHeure == null) {
            return null;
        }
        return Date.from(dateHeure.atZone(ZoneId.systemDefault()).toInstant());
    }

    public void setDateHeure(LocalDateTime dateHeure) {
        this.dateHeure = dateHeure;
        this.dateModification = LocalDateTime.now();
    }
    
    public StatusConsultation getStatut() {
        return statut;
    }
    
    public void setStatut(StatusConsultation statut) {
        this.statut = statut;
        this.dateModification = LocalDateTime.now();
    }
    
    public String getMotif() {
        return motif;
    }
    
    public void setMotif(String motif) {
        this.motif = motif;
        this.dateModification = LocalDateTime.now();
    }
    
    public String getCompteRendu() {
        return compteRendu;
    }
    
    public void setCompteRendu(String compteRendu) {
        this.compteRendu = compteRendu;
        this.dateModification = LocalDateTime.now();
    }
    
    public String getDiagnostic() {
        return diagnostic;
    }
    
    public void setDiagnostic(String diagnostic) {
        this.diagnostic = diagnostic;
        this.dateModification = LocalDateTime.now();
    }
    
    public String getTraitement() {
        return traitement;
    }
    
    public void setTraitement(String traitement) {
        this.traitement = traitement;
        this.dateModification = LocalDateTime.now();
    }
    
    public LocalDateTime getDateCreation() {
        return dateCreation;
    }
    
    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }
    
    public LocalDateTime getDateModification() {
        return dateModification;
    }
    
    public void setDateModification(LocalDateTime dateModification) {
        this.dateModification = dateModification;
    }
    
    public Patient getPatient() {
        return patient;
    }
    
    public void setPatient(Patient patient) {
        this.patient = patient;
    }
    
    public Docteur getDocteur() {
        return docteur;
    }
    
    public void setDocteur(Docteur docteur) {
        this.docteur = docteur;
    }
    
    public Salle getSalle() {
        return salle;
    }
    
    public void setSalle(Salle salle) {
        this.salle = salle;
    }
    
    // Méthodes utilitaires
    public boolean peutEtreModifiee() {
        return statut == StatusConsultation.RESERVEE || statut == StatusConsultation.VALIDEE;
    }
    
    public boolean estTerminee() {
        return statut == StatusConsultation.TERMINEE;
    }
    
    public boolean estAnnulee() {
        return statut == StatusConsultation.ANNULEE;
    }
    
    public void valider() {
        if (statut == StatusConsultation.RESERVEE) {
            setStatut(StatusConsultation.VALIDEE);
        }
    }
    
    public void annuler() {
        if (peutEtreModifiee()) {
            setStatut(StatusConsultation.ANNULEE);
        }
    }
    
    public void terminer(String compteRendu, String diagnostic, String traitement) {
        if (statut == StatusConsultation.VALIDEE) {
            setCompteRendu(compteRendu);
            setDiagnostic(diagnostic);
            setTraitement(traitement);
            setStatut(StatusConsultation.TERMINEE);
        }
    }
    
    @Override
    public String toString() {
        return "Consultation{" +
                "id=" + id +
                ", dateHeure=" + dateHeure +
                ", statut=" + statut +
                ", motif='" + motif + '\'' +
                ", patient=" + (patient != null ? patient.getNomComplet() : "Non assigné") +
                ", docteur=" + (docteur != null ? docteur.getNomComplet() : "Non assigné") +
                ", salle=" + (salle != null ? salle.getNomSalle() : "Non assignée") +
                '}';
    }
}