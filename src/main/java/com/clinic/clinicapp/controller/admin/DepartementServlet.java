package com.clinic.clinicapp.controller.admin;

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

@WebServlet("/admin/departements")
public class DepartementServlet extends HttpServlet {
    
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
                // Lister tous les départements
                listerDepartements(request, response);
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
                    listerDepartements(request, response);
                }
            } else if ("supprimer".equals(action)) {
                // Supprimer un département
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    supprimerDepartement(request, response, id);
                } else {
                    listerDepartements(request, response);
                }
            } else {
                listerDepartements(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listerDepartements(request, response);
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
                // Créer un nouveau département
                creerDepartement(request, response);
            } else if ("modifier".equals(action)) {
                // Mettre à jour un département
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    modifierDepartement(request, response, id);
                } else {
                    listerDepartements(request, response);
                }
            } else {
                listerDepartements(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listerDepartements(request, response);
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
     * Liste tous les départements
     */
    private void listerDepartements(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Departement> departements = adminService.listerTousLesDepartements();
        request.setAttribute("departements", departements);
        request.getRequestDispatcher("/views/admin/departements.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de création d'un département
     */
    private void afficherFormulaireCreation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.setAttribute("action", "creer");
        request.getRequestDispatcher("/views/admin/departement-form.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de modification d'un département
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        Departement departement = adminService.getDepartementById(id);
        
        if (departement == null) {
            request.setAttribute("errorMessage", "Département non trouvé");
            listerDepartements(request, response);
            return;
        }
        
        request.setAttribute("departement", departement);
        request.setAttribute("action", "modifier");
        request.getRequestDispatcher("/views/admin/departement-form.jsp").forward(request, response);
    }
    
    /**
     * Crée un nouveau département
     */
    private void creerDepartement(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        String icone = request.getParameter("icone");
        String actifStr = request.getParameter("actif");
        
        // Validation
        if (nom == null || nom.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Le nom du département est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        Departement departement = new Departement();
        departement.setNom(nom.trim());
        departement.setDescription(description != null ? description.trim() : null);
        departement.setIcone(icone != null ? icone.trim() : null);
        departement.setActif(actifStr != null && actifStr.equals("true"));
        
        try {
            adminService.creerDepartement(departement);
            request.getSession().setAttribute("successMessage", "Département créé avec succès");
            response.sendRedirect(request.getContextPath() + "/admin/departements");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors de la création: " + e.getMessage());
            request.setAttribute("departement", departement);
            afficherFormulaireCreation(request, response);
        }
    }
    
    /**
     * Modifie un département existant
     */
    private void modifierDepartement(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String description = request.getParameter("description");
        String icone = request.getParameter("icone");
        String actifStr = request.getParameter("actif");
        
        // Validation
        if (nom == null || nom.trim().isEmpty()) {
            request.setAttribute("errorMessage", "Le nom du département est obligatoire");
            afficherFormulaireModification(request, response, id);
            return;
        }
        
        Departement departement = adminService.getDepartementById(id);
        if (departement == null) {
            request.setAttribute("errorMessage", "Département non trouvé");
            listerDepartements(request, response);
            return;
        }
        
        departement.setNom(nom.trim());
        departement.setDescription(description != null ? description.trim() : null);
        departement.setIcone(icone != null ? icone.trim() : null);
        departement.setActif(actifStr != null && actifStr.equals("true"));
        
        try {
            adminService.modifierDepartement(departement);
            request.getSession().setAttribute("successMessage", "Département modifié avec succès");
            response.sendRedirect(request.getContextPath() + "/admin/departements");
        } catch (Exception e) {
            request.setAttribute("errorMessage", "Erreur lors de la modification: " + e.getMessage());
            request.setAttribute("departement", departement);
            afficherFormulaireModification(request, response, id);
        }
    }
    
    /**
     * Supprime un département
     */
    private void supprimerDepartement(HttpServletRequest request, HttpServletResponse response, Long id) 
            throws ServletException, IOException {
        try {
            boolean success = adminService.supprimerDepartement(id);
            
            if (success) {
                request.getSession().setAttribute("successMessage", "Département supprimé avec succès");
            } else {
                request.getSession().setAttribute("errorMessage", "Impossible de supprimer le département");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("errorMessage", "Erreur lors de la suppression: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/departements");
    }
}
