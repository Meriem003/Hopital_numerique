package com.clinic.clinicapp.repository;

import com.clinic.clinicapp.entity.Docteur;
import java.util.List;
import java.util.Optional;

public interface DocteurRepository {
    
    Docteur save(Docteur docteur);
    Docteur update(Docteur docteur);
    Optional<Docteur> findById(Long id);
    List<Docteur> findAll();
    void deleteById(Long id);
    void delete(Docteur docteur);
    Optional<Docteur> findByEmail(String email);
    List<Docteur> findBySpecialite(String specialite);
    List<Docteur> findByDepartementId(Long departementId);
    List<Docteur> findByNom(String nom);
    Long count();
    Long countBySpecialite(String specialite);
    boolean existsByEmail(String email);
}
