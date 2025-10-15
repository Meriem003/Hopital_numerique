package com.clinic.clinicapp.enums;

public enum TypeUtilisateur {
    PATIENT("Patient"),
    DOCTEUR("Docteur"),
    ADMIN("Administrateur");
    
    private final String libelle;
    
    TypeUtilisateur(String libelle) {
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