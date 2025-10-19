package com.clinic.clinicapp.controller.admin;

import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.service.AdminService;
import com.clinic.clinicapp.service.impl.AdminServiceImpl;
import com.clinic.clinicapp.repository.impl.DepartementRepositoryImpl;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;
import com.clinic.clinicapp.repository.impl.SalleRepositoryImpl;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.repository.impl.PatientRepositoryImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/admin/patients")
public class PatientServlet extends HttpServlet {
    
    private AdminService adminService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        this.adminService = new AdminServiceImpl(
            new DepartementRepositoryImpl(),
            new DocteurRepositoryImpl(),
            new SalleRepositoryImpl(),
            new ConsultationRepositoryImpl(),
            new PatientRepositoryImpl()
        );
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérification de la session et des droits d'accès
        if (!checkAdminAccess(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if (action == null) {
                // Lister tous les patients
                listerPatients(request, response);
            } else if ("modifier".equals(action)) {
                // Afficher le formulaire de modification
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    afficherFormulaireModification(request, response, id);
                } else {
                    listerPatients(request, response);
                }
            } else if ("supprimer".equals(action)) {
                // Supprimer un patient
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    supprimerPatient(request, response, id);
                } else {
                    listerPatients(request, response);
                }
            } else if ("rechercher".equals(action)) {
                // Rechercher des patients
                rechercherPatients(request, response);
            } else if ("filtrer".equals(action)) {
                // Filtrer par IMC
                filtrerParIMC(request, response);
            } else {
                listerPatients(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listerPatients(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Vérification de la session et des droits d'accès
        if (!checkAdminAccess(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        
        try {
            if ("modifier".equals(action)) {
                // Modifier un patient existant
                modifierPatient(request, response);
            } else {
                listerPatients(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Erreur lors de l'opération: " + e.getMessage());
            listerPatients(request, response);
        }
    }
    
    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null || 
            !"ADMIN".equals(session.getAttribute("role"))) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        return true;
    }
    
    private void listerPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        List<Patient> patients = adminService.listerTousLesPatients();
        
        request.setAttribute("patients", patients);
        request.setAttribute("totalPatients", patients.size());
        
        // Note: Ne pas accéder aux collections lazy ici pour éviter LazyInitializationException
        // Les statistiques sur les consultations peuvent être calculées dans le service si nécessaire
        
        request.getRequestDispatcher("/views/admin/patients.jsp").forward(request, response);
    }
    
    private void rechercherPatients(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String critere = request.getParameter("critere");
        
        List<Patient> patients;
        if (critere != null && !critere.trim().isEmpty()) {
            patients = adminService.rechercherPatientsByNom(critere.trim());
            request.setAttribute("critereRecherche", critere);
        } else {
            patients = adminService.listerTousLesPatients();
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("totalPatients", patients.size());
        
        request.getRequestDispatcher("/views/admin/patients.jsp").forward(request, response);
    }
    
    private void filtrerParIMC(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String imcFilter = request.getParameter("imcFilter");
        List<Patient> patients = adminService.listerTousLesPatients();
        
        if (imcFilter != null && !imcFilter.isEmpty()) {
            patients = patients.stream()
                .filter(p -> {
                    BigDecimal imc = p.getIMC();
                    if (imc == null) return false;
                    
                    switch (imcFilter) {
                        case "underweight":
                            return imc.compareTo(new BigDecimal("18.5")) < 0;
                        case "normal":
                            return imc.compareTo(new BigDecimal("18.5")) >= 0 && 
                                   imc.compareTo(new BigDecimal("25")) < 0;
                        case "overweight":
                            return imc.compareTo(new BigDecimal("25")) >= 0 && 
                                   imc.compareTo(new BigDecimal("30")) < 0;
                        case "obese":
                            return imc.compareTo(new BigDecimal("30")) >= 0;
                        default:
                            return true;
                    }
                })
                .collect(Collectors.toList());
            
            request.setAttribute("imcFilter", imcFilter);
        }
        
        request.setAttribute("patients", patients);
        request.setAttribute("totalPatients", patients.size());
        
        request.getRequestDispatcher("/views/admin/patients.jsp").forward(request, response);
    }
    
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response, Long patientId) 
            throws ServletException, IOException {
        
        List<Patient> patients = adminService.listerTousLesPatients();
        Patient patient = patients.stream()
            .filter(p -> p.getId().equals(patientId))
            .findFirst()
            .orElse(null);
        
        if (patient != null) {
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/views/admin/patient-form.jsp").forward(request, response);
        } else {
            request.getSession().setAttribute("errorMessage", "Patient non trouvé");
            listerPatients(request, response);
        }
    }
    
    private void modifierPatient(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        try {
            Long patientId = Long.parseLong(request.getParameter("id"));
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String poidsStr = request.getParameter("poids");
            String tailleStr = request.getParameter("taille");
            
            // Validation des données
            if (nom == null || nom.trim().isEmpty() || 
                prenom == null || prenom.trim().isEmpty() || 
                email == null || email.trim().isEmpty()) {
                request.getSession().setAttribute("errorMessage", "Tous les champs obligatoires doivent être remplis");
                afficherFormulaireModification(request, response, patientId);
                return;
            }
            
            // Récupérer le patient existant
            List<Patient> patients = adminService.listerTousLesPatients();
            Patient patient = patients.stream()
                .filter(p -> p.getId().equals(patientId))
                .findFirst()
                .orElse(null);
            
            if (patient == null) {
                request.getSession().setAttribute("errorMessage", "Patient non trouvé");
                listerPatients(request, response);
                return;
            }
            
            // Mettre à jour les informations
            patient.setNom(nom.trim());
            patient.setPrenom(prenom.trim());
            patient.setEmail(email.trim());
            
            if (poidsStr != null && !poidsStr.trim().isEmpty()) {
                patient.setPoids(new BigDecimal(poidsStr));
            }
            
            if (tailleStr != null && !tailleStr.trim().isEmpty()) {
                patient.setTaille(Integer.parseInt(tailleStr));
            }
            
            // Persister les modifications dans la base de données
            adminService.modifierPatient(patient);
            
            request.getSession().setAttribute("successMessage", "Patient modifié avec succès");
            response.sendRedirect(request.getContextPath() + "/admin/patients");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Format de données invalide");
            listerPatients(request, response);
        }
    }
    
    private void supprimerPatient(HttpServletRequest request, HttpServletResponse response, Long patientId) 
            throws ServletException, IOException {
        
        try {
            boolean success = adminService.supprimerPatient(patientId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Patient supprimé avec succès");
            } else {
                request.getSession().setAttribute("errorMessage", "Impossible de supprimer le patient");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur lors de la suppression: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/patients");
    }
}
