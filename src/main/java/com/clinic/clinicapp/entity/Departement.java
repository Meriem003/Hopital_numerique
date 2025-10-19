package com.clinic.clinicapp.entity;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "departements")
public class Departement {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "nom", nullable = false, unique = true)
    private String nom;
    
    @Column(name = "description")
    private String description;
    
    @Column(name = "icone")
    private String icone;
    
    @Column(name = "actif")
    private boolean actif = true;
    
    @OneToMany(mappedBy = "departement", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Docteur> docteurs = new ArrayList<>();
    
    @OneToMany(mappedBy = "departement", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Salle> salles = new ArrayList<>();
    
    public Departement() {}
    
    public Departement(String nom, String description) {
        this.nom = nom;
        this.description = description;
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
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public String getIcone() {
        return icone;
    }
    
    public void setIcone(String icone) {
        this.icone = icone;
    }
    
    public boolean isActif() {
        return actif;
    }
    
    public void setActif(boolean actif) {
        this.actif = actif;
    }
    
    public List<Docteur> getDocteurs() {
        return docteurs;
    }
    
    public void setDocteurs(List<Docteur> docteurs) {
        this.docteurs = docteurs;
    }
    
    public void addDocteur(Docteur docteur) {
        docteurs.add(docteur);
        docteur.setDepartement(this);
    }
    
    public void removeDocteur(Docteur docteur) {
        docteurs.remove(docteur);
        docteur.setDepartement(null);
    }
    
    public List<Salle> getSalles() {
        return salles;
    }
    
    public void setSalles(List<Salle> salles) {
        this.salles = salles;
    }
    
    public void addSalle(Salle salle) {
        salles.add(salle);
        salle.setDepartement(this);
    }
    
    public void removeSalle(Salle salle) {
        salles.remove(salle);
        salle.setDepartement(null);
    }
    
    @Override
    public String toString() {
        return "Departement{" +
                "id=" + id +
                ", nom='" + nom + '\'' +
                ", description='" + description + '\'' +
                ", nombreDocteurs=" + docteurs.size() +
                '}';
    }
}