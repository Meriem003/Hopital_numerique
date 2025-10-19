package com.clinic.clinicapp.repository;

import com.clinic.clinicapp.entity.Admin;
import java.util.List;
import java.util.Optional;

public interface AdminRepository {
    
    Admin save(Admin admin);
    Admin update(Admin admin);
    Optional<Admin> findById(Long id);
    Optional<Admin> findByEmail(String email);
    List<Admin> findByNom(String nom);
    List<Admin> findByPrenom(String prenom);
    List<Admin> findByNomOrPrenom(String nom, String prenom);
    boolean existsByEmail(String email);
}
