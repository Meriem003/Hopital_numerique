package com.clinic.clinicapp.service;

import com.clinic.clinicapp.entity.Personne;
import com.clinic.clinicapp.entity.Patient;

public interface AuthService {
    
    Personne authentifier(String email, String motDePasse);
    
    Patient inscrirePatient(Patient patient);
    
    boolean emailExiste(String email);
    
    boolean modifierMotDePasse(Long utilisateurId, String ancienMotDePasse, String nouveauMotDePasse);
    
    void deconnecter(Long utilisateurId);
}
