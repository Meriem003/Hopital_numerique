package com.clinic.clinicapp.repository;

import com.clinic.clinicapp.entity.Departement;
import java.util.List;
import java.util.Optional;

public interface DepartementRepository {
    
    Departement save(Departement departement);
    Departement update(Departement departement);
    Optional<Departement> findById(Long id);
    List<Departement> findAll();
    void deleteById(Long id);
    void delete(Departement departement);
    Optional<Departement> findByNom(String nom);
    List<Departement> searchByNom(String nom);
    Long count();
    boolean existsByNom(String nom);
}
