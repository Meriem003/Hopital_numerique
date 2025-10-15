package com.clinic.clinicapp.enums;

public enum StatusConsultation {
    RESERVEE("Réservée"),
    VALIDEE("Validée"),
    ANNULEE("Annulée"),
    TERMINEE("Terminée");
    
    private final String libelle;
    
    StatusConsultation(String libelle) {
        this.libelle = libelle;
    }
    
    public String getLibelle() {
        return libelle;
    }
    
    @Override
    public String toString() {
        return libelle;
    }
}