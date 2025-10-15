package com.clinic.clinicapp.entity;

import jakarta.persistence.*;
import com.clinic.clinicapp.enums.TypeUtilisateur;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "patients")
@DiscriminatorValue("PATIENT")
public class Patient extends Personne {
    
    @Column(name = "poids")
    private BigDecimal poids;
    
    @Column(name = "taille")
    private Integer taille;
    
    @OneToMany(mappedBy = "patient", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();
    
    public Patient() {
        super();
        setTypeUtilisateur(TypeUtilisateur.PATIENT);
    }
    
    public Patient(String nom, String prenom, String email, String motDePasse) {
        super(nom, prenom, email, motDePasse, TypeUtilisateur.PATIENT);
    }
    
    public Patient(String nom, String prenom, String email, String motDePasse, BigDecimal poids, Integer taille) {
        super(nom, prenom, email, motDePasse, TypeUtilisateur.PATIENT);
        this.poids = poids;
        this.taille = taille;
    }
    
    public BigDecimal getPoids() {
        return poids;
    }
    
    public void setPoids(BigDecimal poids) {
        this.poids = poids;
    }
    
    public Integer getTaille() {
        return taille;
    }
    
    public void setTaille(Integer taille) {
        this.taille = taille;
    }
    
    public List<Consultation> getConsultations() {
        return consultations;
    }
    
    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }
    
    public void addConsultation(Consultation consultation) {
        consultations.add(consultation);
        consultation.setPatient(this);
    }
    
    public void removeConsultation(Consultation consultation) {
        consultations.remove(consultation);
        consultation.setPatient(null);
    }
    
    public BigDecimal getIMC() {
        if (poids != null && taille != null && taille > 0) {
            BigDecimal tailleEnMetres = BigDecimal.valueOf(taille).divide(BigDecimal.valueOf(100));
            return poids.divide(tailleEnMetres.multiply(tailleEnMetres), 2, java.math.RoundingMode.HALF_UP);
        }
        return null;
    }
    
    @Override
    public String toString() {
        return "Patient{" +
                "id=" + getId() +
                ", nom='" + getNom() + '\'' +
                ", prenom='" + getPrenom() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", poids=" + poids +
                ", taille=" + taille +
                ", nombreConsultations=" + consultations.size() +
                '}';
    }
}