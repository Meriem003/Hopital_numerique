package com.clinic.clinicapp.entity;

import jakarta.persistence.*;
import com.clinic.clinicapp.enums.TypeUtilisateur;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "docteurs")
public class Docteur extends Personne {
    
    @Column(name = "specialite", nullable = false)
    private String specialite;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "departement_id", referencedColumnName = "id")
    private Departement departement;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "salle_id", referencedColumnName = "id")
    private Salle salle;
    
    @OneToMany(mappedBy = "docteur", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();
    
    public Docteur() {
        super();
        // Le type DOCTEUR est déterminé automatiquement par instanceof
    }
    
    public Docteur(String nom, String prenom, String email, String motDePasse, String specialite) {
        super(nom, prenom, email, motDePasse, TypeUtilisateur.DOCTEUR);
        this.specialite = specialite;
    }
    
    public Docteur(String nom, String prenom, String email, String motDePasse, String specialite, Departement departement) {
        super(nom, prenom, email, motDePasse, TypeUtilisateur.DOCTEUR);
        this.specialite = specialite;
        this.departement = departement;
    }
    
    public Docteur(String nom, String prenom, String email, String motDePasse, String specialite, Departement departement, Salle salle) {
        super(nom, prenom, email, motDePasse, TypeUtilisateur.DOCTEUR);
        this.specialite = specialite;
        this.departement = departement;
        this.salle = salle;
    }
    
    public String getSpecialite() {
        return specialite;
    }
    
    public void setSpecialite(String specialite) {
        this.specialite = specialite;
    }
    
    public Departement getDepartement() {
        return departement;
    }
    
    public void setDepartement(Departement departement) {
        this.departement = departement;
    }
    
    public Salle getSalle() {
        return salle;
    }
    
    public void setSalle(Salle salle) {
        this.salle = salle;
    }
    
    public List<Consultation> getConsultations() {
        return consultations;
    }
    
    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }
    
    public void addConsultation(Consultation consultation) {
        consultations.add(consultation);
        consultation.setDocteur(this);
    }
    
    public void removeConsultation(Consultation consultation) {
        consultations.remove(consultation);
        consultation.setDocteur(null);
    }

    public List<Consultation> getPlanning() {
        return consultations;
    }
    
    public boolean isDisponible(java.time.LocalDateTime dateHeure) {
        return consultations.stream()
                .noneMatch(consultation -> 
                    consultation.getDateHeure().equals(dateHeure) &&
                    (consultation.getStatut() == com.clinic.clinicapp.enums.StatusConsultation.RESERVEE ||
                     consultation.getStatut() == com.clinic.clinicapp.enums.StatusConsultation.VALIDEE)
                );
    }
    
    @Override
    public String toString() {
        return "Docteur{" +
                "id=" + getId() +
                ", nom='" + getNom() + '\'' +
                ", prenom='" + getPrenom() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", specialite='" + specialite + '\'' +
                ", departement=" + (departement != null ? departement.getNom() : "Non assigné") +
                ", salle=" + (salle != null ? salle.getNomSalle() : "Non assignée") +
                ", nombreConsultations=" + consultations.size() +
                '}';
    }
}