package com.clinic.clinicapp.service.impl;

import com.clinic.clinicapp.service.AuthService;
import com.clinic.clinicapp.entity.Personne;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Admin;
import com.clinic.clinicapp.repository.PatientRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.AdminRepository;
import com.clinic.clinicapp.repository.impl.PatientRepositoryImpl;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;
import com.clinic.clinicapp.repository.impl.AdminRepositoryImpl;

import java.util.Optional;

public class AuthServiceImpl implements AuthService {
    
    private final PatientRepository patientRepository;
    private final DocteurRepository docteurRepository;
    private final AdminRepository adminRepository;
    
    public AuthServiceImpl() {
        this.patientRepository = new PatientRepositoryImpl();
        this.docteurRepository = new DocteurRepositoryImpl();
        this.adminRepository = new AdminRepositoryImpl();
    }
    
    @Override
    public Personne authentifier(String email, String motDePasse) {
        if (email == null || email.trim().isEmpty() || 
            motDePasse == null || motDePasse.trim().isEmpty()) {
            return null;
        }        
        
        // Vérifier si c'est un Admin
        Optional<Admin> admin = adminRepository.findByEmail(email);
        if (admin.isPresent() && admin.get().getMotDePasse().equals(motDePasse)) {
            return admin.get();
        }
        
        // Vérifier si c'est un Patient
        Optional<Patient> patient = patientRepository.findByEmail(email);
        if (patient.isPresent() && patient.get().getMotDePasse().equals(motDePasse)) {
            return patient.get();
        }        
        
        // Vérifier si c'est un Docteur
        Optional<Docteur> docteur = docteurRepository.findByEmail(email);
        if (docteur.isPresent() && docteur.get().getMotDePasse().equals(motDePasse)) {
            return docteur.get();
        }
        
        return null;
    }
    
    @Override
    public Patient inscrirePatient(Patient patient) {
        if (patient == null) {
            throw new IllegalArgumentException("Le patient ne peut pas être null");
        }
        if (emailExiste(patient.getEmail())) {
            throw new IllegalArgumentException("Cet email est déjà utilisé");
        }        
        if (patient.getNom() == null || patient.getNom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le nom est obligatoire");
        }
        if (patient.getPrenom() == null || patient.getPrenom().trim().isEmpty()) {
            throw new IllegalArgumentException("Le prénom est obligatoire");
        }
        if (patient.getEmail() == null || patient.getEmail().trim().isEmpty()) {
            throw new IllegalArgumentException("L'email est obligatoire");
        }
        
        if (patient.getMotDePasse() == null || patient.getMotDePasse().trim().isEmpty()) {
            throw new IllegalArgumentException("Le mot de passe est obligatoire");
        }
        
        return patientRepository.save(patient);
    }
    
    @Override
    public boolean emailExiste(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }        
        return adminRepository.existsByEmail(email) ||
               patientRepository.existsByEmail(email) || 
               docteurRepository.existsByEmail(email);
    }
    
    @Override
    public boolean modifierMotDePasse(Long utilisateurId, String ancienMotDePasse, String nouveauMotDePasse) {
        if (utilisateurId == null || ancienMotDePasse == null || nouveauMotDePasse == null) {
            return false;
        }        
        
        // Vérifier si c'est un Admin
        Optional<Admin> admin = adminRepository.findById(utilisateurId);
        if (admin.isPresent()) {
            if (admin.get().getMotDePasse().equals(ancienMotDePasse)) {
                admin.get().setMotDePasse(nouveauMotDePasse);
                adminRepository.update(admin.get());
                return true;
            }
            return false;
        }
        
        // Vérifier si c'est un Patient
        Optional<Patient> patient = patientRepository.findById(utilisateurId);
        if (patient.isPresent()) {
            if (patient.get().getMotDePasse().equals(ancienMotDePasse)) {
                patient.get().setMotDePasse(nouveauMotDePasse);
                patientRepository.update(patient.get());
                return true;
            }
            return false;
        }        
        
        // Vérifier si c'est un Docteur
        Optional<Docteur> docteur = docteurRepository.findById(utilisateurId);
        if (docteur.isPresent()) {
            if (docteur.get().getMotDePasse().equals(ancienMotDePasse)) {
                docteur.get().setMotDePasse(nouveauMotDePasse);
                docteurRepository.update(docteur.get());
                return true;
            }
            return false;
        }
        
        return false;
    }
    
    @Override
    public void deconnecter(Long utilisateurId) {
        if (utilisateurId == null) {
            System.out.println("Tentative de déconnexion avec un ID utilisateur null");
            return;
        }        
        
        Optional<Admin> admin = adminRepository.findById(utilisateurId);
        Optional<Patient> patient = patientRepository.findById(utilisateurId);
        Optional<Docteur> docteur = docteurRepository.findById(utilisateurId);
        
        if (admin.isPresent()) {
            System.out.println("Déconnexion de l'admin: " + admin.get().getEmail() + 
                             " à " + java.time.LocalDateTime.now());
        } else if (patient.isPresent()) {
            System.out.println("Déconnexion du patient: " + patient.get().getEmail() + 
                             " à " + java.time.LocalDateTime.now());
        } else if (docteur.isPresent()) {
            System.out.println("Déconnexion du docteur: " + docteur.get().getEmail() + 
                             " à " + java.time.LocalDateTime.now());
        } else {
            System.out.println("Tentative de déconnexion d'un utilisateur inexistant (ID: " + 
                             utilisateurId + ")");
        }
    }
}
