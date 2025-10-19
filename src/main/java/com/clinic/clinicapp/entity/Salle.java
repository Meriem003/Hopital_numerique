package com.clinic.clinicapp.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "salles")
public class Salle {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "id")
    private Long id;
    
    @Column(name = "nom_salle", nullable = false, unique = true)
    private String nomSalle;
    
    @Column(name = "capacite")
    private Integer capacite;
    
    @Column(name = "description")
    private String description;
    
    @ManyToOne(fetch = FetchType.EAGER, optional = false)
    @JoinColumn(name = "departement_id", nullable = false)
    private Departement departement;
    
    @OneToMany(mappedBy = "salle", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Consultation> consultations = new ArrayList<>();
    
    public Salle() {}
    
    public Salle(String nomSalle, Integer capacite) {
        this.nomSalle = nomSalle;
        this.capacite = capacite;
    }
    
    public Salle(String nomSalle, Integer capacite, String description) {
        this.nomSalle = nomSalle;
        this.capacite = capacite;
        this.description = description;
    }
    
    public Long getId() {
        return id;
    }
    
    public void setId(Long id) {
        this.id = id;
    }
    
    public String getNomSalle() {
        return nomSalle;
    }
    
    public void setNomSalle(String nomSalle) {
        this.nomSalle = nomSalle;
    }
    
    public Integer getCapacite() {
        return capacite;
    }
    
    public void setCapacite(Integer capacite) {
        this.capacite = capacite;
    }
    
    public String getDescription() {
        return description;
    }
    
    public void setDescription(String description) {
        this.description = description;
    }
    
    public Departement getDepartement() {
        return departement;
    }
    
    public void setDepartement(Departement departement) {
        this.departement = departement;
    }
    
    public List<Consultation> getConsultations() {
        return consultations;
    }
    
    public void setConsultations(List<Consultation> consultations) {
        this.consultations = consultations;
    }
    
    public void addConsultation(Consultation consultation) {
        consultations.add(consultation);
        consultation.setSalle(this);
    }
    
    public void removeConsultation(Consultation consultation) {
        consultations.remove(consultation);
        consultation.setSalle(null);
    }
    
    public boolean isDisponible(LocalDateTime dateHeure) {
        LocalDateTime finCreneau = dateHeure.plusMinutes(30);
        
        return consultations.stream()
                .noneMatch(consultation -> {
                    LocalDateTime debutConsult = consultation.getDateHeure();
                    LocalDateTime finConsult = debutConsult.plusMinutes(30);                    
                    return !(finCreneau.isBefore(debutConsult) || dateHeure.isAfter(finConsult));
                });
    }
    
    public List<LocalDateTime> getCreneauxOccupes() {
        return consultations.stream()
                .map(Consultation::getDateHeure)
                .sorted()
                .toList();
    }
    
    @Override
    public String toString() {
        return "Salle{" +
                "id=" + id +
                ", nomSalle='" + nomSalle + '\'' +
                ", capacite=" + capacite +
                ", description='" + description + '\'' +
                ", nombreConsultations=" + consultations.size() +
                '}';
    }
}