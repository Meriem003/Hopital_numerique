package com.clinic.clinicapp.repository;

import com.clinic.clinicapp.entity.Patient;
import java.util.List;
import java.util.Optional;

public interface PatientRepository {
    
    Patient save(Patient patient);
    Patient update(Patient patient);
    Optional<Patient> findById(Long id);
    List<Patient> findAll();
    void deleteById(Long id);
    void delete(Patient patient);
    Optional<Patient> findByEmail(String email);
    List<Patient> findByNom(String nom);
    List<Patient> findByPrenom(String prenom);
    List<Patient> findByNomOrPrenom(String nom, String prenom);
    Long count();
    boolean existsByEmail(String email);
}
