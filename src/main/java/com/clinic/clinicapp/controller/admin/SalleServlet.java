package com.clinic.clinicapp.controller.admin;

import com.clinic.clinicapp.entity.Salle;
import com.clinic.clinicapp.entity.Departement;
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
import java.util.List;

@WebServlet("/admin/salles")
public class SalleServlet extends HttpServlet {
    
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
                // Lister toutes les salles
                listerSalles(request, response);
            } else if ("nouveau".equals(action)) {
                // Afficher le formulaire de création
                afficherFormulaireCreation(request, response);
            } else if ("modifier".equals(action)) {
                // Afficher le formulaire de modification
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    afficherFormulaireModification(request, response, id);
                } else {
                    listerSalles(request, response);
                }
            } else if ("supprimer".equals(action)) {
                // Supprimer une salle
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    supprimerSalle(request, response, id);
                } else {
                    listerSalles(request, response);
                }
            } else {
                listerSalles(request, response);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listerSalles(request, response);
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
            if ("creer".equals(action)) {
                // Créer une nouvelle salle
                creerSalle(request, response);
            } else if ("modifier".equals(action)) {
                // Mettre à jour une salle
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    modifierSalle(request, response, id);
                } else {
                    listerSalles(request, response);
                }
            } else {
                listerSalles(request, response);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listerSalles(request, response);
        }
    }
    
    /**
     * Vérifie si l'utilisateur a les droits d'administrateur
     */
    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return false;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Accès refusé");
            return false;
        }
        
        return true;
    }
    
    /**
     * Liste toutes les salles
     */
    private void listerSalles(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Salle> salles = adminService.listerToutesLesSalles();
        request.setAttribute("salles", salles);
        request.getRequestDispatcher("/views/admin/salles.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de création d'une salle
     */
    private void afficherFormulaireCreation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Charger la liste des départements pour le formulaire
        List<Departement> departements = adminService.listerTousLesDepartements();
        request.setAttribute("departements", departements);
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/views/admin/salle-form.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de modification d'une salle
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response, Long salleId) 
            throws ServletException, IOException {
        Salle salle = adminService.getSalleById(salleId);
        
        if (salle == null) {
            request.getSession().setAttribute("errorMessage", "Salle introuvable");
            listerSalles(request, response);
            return;
        }
        
        // Charger la liste des départements pour le formulaire
        List<Departement> departements = adminService.listerTousLesDepartements();
        request.setAttribute("departements", departements);
        request.setAttribute("salle", salle);
        request.setAttribute("isEdit", true);
        request.getRequestDispatcher("/views/admin/salle-form.jsp").forward(request, response);
    }
    
    /**
     * Crée une nouvelle salle
     */
    private void creerSalle(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nomSalle = request.getParameter("nomSalle");
        String capaciteStr = request.getParameter("capacite");
        String description = request.getParameter("description");
        String departementIdStr = request.getParameter("departementId");
        
        // Validation
        if (nomSalle == null || nomSalle.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le nom de la salle est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        if (departementIdStr == null || departementIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le département est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        try {
            Integer capacite = capaciteStr != null && !capaciteStr.trim().isEmpty() 
                ? Integer.parseInt(capaciteStr) 
                : null;
            
            Long departementId = Long.parseLong(departementIdStr);
            
            // Récupérer le département
            Departement departement = adminService.getDepartementById(departementId);
            if (departement == null) {
                request.getSession().setAttribute("errorMessage", "Département introuvable");
                afficherFormulaireCreation(request, response);
                return;
            }
            
            // Créer la salle
            Salle salle = new Salle(nomSalle, capacite, description);
            salle.setDepartement(departement);
            
            adminService.creerSalle(salle);
            
            request.getSession().setAttribute("successMessage", "Salle créée avec succès");
            response.sendRedirect(request.getContextPath() + "/admin/salles");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Format numérique invalide");
            afficherFormulaireCreation(request, response);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur lors de la création: " + e.getMessage());
            afficherFormulaireCreation(request, response);
        }
    }
    
    /**
     * Modifie une salle existante
     */
    private void modifierSalle(HttpServletRequest request, HttpServletResponse response, Long salleId) 
            throws ServletException, IOException {
        
        Salle salle = adminService.getSalleById(salleId);
        
        if (salle == null) {
            request.getSession().setAttribute("errorMessage", "Salle introuvable");
            listerSalles(request, response);
            return;
        }
        
        String nomSalle = request.getParameter("nomSalle");
        String capaciteStr = request.getParameter("capacite");
        String description = request.getParameter("description");
        String departementIdStr = request.getParameter("departementId");
        
        // Validation
        if (nomSalle == null || nomSalle.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le nom de la salle est obligatoire");
            afficherFormulaireModification(request, response, salleId);
            return;
        }
        
        if (departementIdStr == null || departementIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le département est obligatoire");
            afficherFormulaireModification(request, response, salleId);
            return;
        }
        
        try {
            Integer capacite = capaciteStr != null && !capaciteStr.trim().isEmpty() 
                ? Integer.parseInt(capaciteStr) 
                : null;
            
            Long departementId = Long.parseLong(departementIdStr);
            
            // Récupérer le département
            Departement departement = adminService.getDepartementById(departementId);
            if (departement == null) {
                request.getSession().setAttribute("errorMessage", "Département introuvable");
                afficherFormulaireModification(request, response, salleId);
                return;
            }
            
            // Mettre à jour la salle
            salle.setNomSalle(nomSalle);
            salle.setCapacite(capacite);
            salle.setDescription(description);
            salle.setDepartement(departement);
            
            adminService.modifierSalle(salle);
            
            request.getSession().setAttribute("successMessage", "Salle modifiée avec succès");
            response.sendRedirect(request.getContextPath() + "/admin/salles");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("errorMessage", "Format numérique invalide");
            afficherFormulaireModification(request, response, salleId);
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur lors de la modification: " + e.getMessage());
            afficherFormulaireModification(request, response, salleId);
        }
    }
    
    /**
     * Supprime une salle
     */
    private void supprimerSalle(HttpServletRequest request, HttpServletResponse response, Long salleId) 
            throws ServletException, IOException {
        
        try {
            boolean success = adminService.supprimerSalle(salleId);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Salle supprimée avec succès");
            } else {
                request.getSession().setAttribute("errorMessage", "Impossible de supprimer la salle");
            }
            
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur lors de la suppression: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/salles");
    }
}
