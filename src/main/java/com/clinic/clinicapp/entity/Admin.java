package com.clinic.clinicapp.entity;

import jakarta.persistence.*;
import com.clinic.clinicapp.enums.TypeUtilisateur;

@Entity
@Table(name = "admins")
public class Admin extends Personne {
    
    @Column(name = "poste")
    private String poste;
    
    @Column(name = "niveau_acces")
    private Integer niveauAcces;
    
    public Admin() {
        super();
    }
    
    public Admin(String nom, String prenom, String email, String motDePasse) {
        super(nom, prenom, email, motDePasse, TypeUtilisateur.ADMIN);
        this.poste = "Administrateur";
        this.niveauAcces = 1;
    }
    
    public Admin(String nom, String prenom, String email, String motDePasse, String poste, Integer niveauAcces) {
        super(nom, prenom, email, motDePasse, TypeUtilisateur.ADMIN);
        this.poste = poste;
        this.niveauAcces = niveauAcces;
    }
    
    // Getters et Setters
    public String getPoste() {
        return poste;
    }
    
    public void setPoste(String poste) {
        this.poste = poste;
    }
    
    public Integer getNiveauAcces() {
        return niveauAcces;
    }
    
    public void setNiveauAcces(Integer niveauAcces) {
        this.niveauAcces = niveauAcces;
    }
    
    @Override
    public String toString() {
        return "Admin{" +
                "id=" + getId() +
                ", nom='" + getNom() + '\'' +
                ", prenom='" + getPrenom() + '\'' +
                ", email='" + getEmail() + '\'' +
                ", poste='" + poste + '\'' +
                ", niveauAcces=" + niveauAcces +
                '}';
    }
}
