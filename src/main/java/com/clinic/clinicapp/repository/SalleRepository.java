package com.clinic.clinicapp.repository;

import com.clinic.clinicapp.entity.Salle;
import java.util.List;
import java.util.Optional;

public interface SalleRepository {
    
    Salle save(Salle salle);
    Salle update(Salle salle);
    Optional<Salle> findById(Long id);
    List<Salle> findAll();
    void deleteById(Long id);
    void delete(Salle salle);
    Optional<Salle> findByNomSalle(String nomSalle);
    List<Salle> findByCapaciteGreaterThanEqual(Integer capacite);
    List<Salle> searchByNom(String nom);
    Long count();
    boolean existsByNomSalle(String nomSalle);
}
