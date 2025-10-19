package com.clinic.clinicapp.entity;

import jakarta.persistence.*;
import com.clinic.clinicapp.enums.TypeUtilisateur;

@Entity
@Table(name = "personnes")
@Inheritance(strategy = InheritanceType.JOINED)
public abstract class Personne {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "nom", nullable = false)
    private String nom;
    
    @Column(name = "prenom", nullable = false)
    private String prenom;
    
    @Column(name = "email", nullable = false, unique = true)
    private String email;
    
    @Column(name = "mot_de_passe", nullable = false)
    private String motDePasse;
    
    public Personne() {}
    
    public Personne(String nom, String prenom, String email, String motDePasse, TypeUtilisateur typeUtilisateur) {
        this.nom = nom;
        this.prenom = prenom;
        this.email = email;
        this.motDePasse = motDePasse;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getNom() {
        return nom;
    }
    
    public void setNom(String nom) {
        this.nom = nom;
    }
    
    public String getPrenom() {
        return prenom;
    }
    
    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
    
    public String getEmail() {
        return email;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public String getMotDePasse() {
        return motDePasse;
    }
    
    public void setMotDePasse(String motDePasse) {
        this.motDePasse = motDePasse;
    }
    
    /**
     * Retourne le type d'utilisateur basé sur le type réel de l'instance.
     * Cette méthode remplace l'ancienne colonne type_utilisateur en base de données.
     * Le type est maintenant calculé dynamiquement à partir de la classe (instanceof).
     * 
     * @return TypeUtilisateur correspondant au type de l'instance
     */
    public TypeUtilisateur getTypeUtilisateur() {
        if (this instanceof Admin) {
            return TypeUtilisateur.ADMIN;
        } else if (this instanceof Docteur) {
            return TypeUtilisateur.DOCTEUR;
        } else if (this instanceof Patient) {
            return TypeUtilisateur.PATIENT;
        }
        return null;
    }
    
    /**
     * Méthode conservée pour compatibilité avec le code existant.
     * Le type d'utilisateur est maintenant déterminé automatiquement par la classe.
     * 
     * @param typeUtilisateur ignoré (le type est déterminé par instanceof)
     * @deprecated Le type est déterminé automatiquement par la classe elle-même
     */
    @Deprecated
    public void setTypeUtilisateur(TypeUtilisateur typeUtilisateur) {
        // Ne fait rien - le type est déterminé automatiquement par la classe
    }
    
    public String getNomComplet() {
        return prenom + " " + nom;
    }
    
    @Override
    public String toString() {
        return "Personne{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", prenom='" + prenom + '\'' +
                ", email='" + email + '\'' +
                ", typeUtilisateur=" + getTypeUtilisateur() +
                '}';
    }
}