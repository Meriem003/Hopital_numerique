package com.clinic.clinicapp.controller.admin;

import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Departement;
import com.clinic.clinicapp.entity.Salle;
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

@WebServlet("/admin/docteurs")
public class DocteurServlet extends HttpServlet {
    
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
                // Lister tous les docteurs
                listerDocteurs(request, response);
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
                    listerDocteurs(request, response);
                }
            } else if ("supprimer".equals(action)) {
                // Supprimer un docteur
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    supprimerDocteur(request, response, id);
                } else {
                    listerDocteurs(request, response);
                }
            } else if ("rechercher".equals(action)) {
                // Rechercher des docteurs
                String critere = request.getParameter("critere");
                rechercherDocteurs(request, response, critere);
            } else if ("filtrer".equals(action)) {
                // Filtrer par département
                String departementIdStr = request.getParameter("departementId");
                if (departementIdStr != null && !departementIdStr.isEmpty()) {
                    Long departementId = Long.parseLong(departementIdStr);
                    filtrerParDepartement(request, response, departementId);
                } else {
                    listerDocteurs(request, response);
                }
            } else {
                listerDocteurs(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listerDocteurs(request, response);
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
                // Créer un nouveau docteur
                creerDocteur(request, response);
            } else if ("modifier".equals(action)) {
                // Mettre à jour un docteur
                String idStr = request.getParameter("id");
                if (idStr != null) {
                    Long id = Long.parseLong(idStr);
                    modifierDocteur(request, response, id);
                } else {
                    listerDocteurs(request, response);
                }
            } else {
                listerDocteurs(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", "Erreur: " + e.getMessage());
            listerDocteurs(request, response);
        }
    }
    
    /**
     * Vérifie si l'utilisateur a les droits d'administrateur
     */
    private boolean checkAdminAccess(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
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
     * Liste tous les docteurs
     */
    private void listerDocteurs(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        List<Docteur> docteurs = adminService.listerTousLesDocteurs();
        List<Departement> departements = adminService.listerTousLesDepartements();
        
        request.setAttribute("docteurs", docteurs);
        request.setAttribute("departements", departements);
        request.getRequestDispatcher("/views/admin/docteurs.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de création d'un docteur
     */
    private void afficherFormulaireCreation(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Charger la liste des départements et salles pour le formulaire
        List<Departement> departements = adminService.listerTousLesDepartements();
        List<Salle> salles = adminService.listerToutesLesSalles();
        
        request.setAttribute("departements", departements);
        request.setAttribute("salles", salles);
        request.setAttribute("isEdit", false);
        request.getRequestDispatcher("/views/admin/docteur-form.jsp").forward(request, response);
    }
    
    /**
     * Affiche le formulaire de modification d'un docteur
     */
    private void afficherFormulaireModification(HttpServletRequest request, HttpServletResponse response, Long docteurId) 
            throws ServletException, IOException {
        Docteur docteur = adminService.listerTousLesDocteurs().stream()
                .filter(d -> d.getId().equals(docteurId))
                .findFirst()
                .orElse(null);
        
        if (docteur == null) {
            request.getSession().setAttribute("errorMessage", "Docteur introuvable");
            listerDocteurs(request, response);
            return;
        }
        
        // Charger la liste des départements et salles pour le formulaire
        List<Departement> departements = adminService.listerTousLesDepartements();
        List<Salle> salles = adminService.listerToutesLesSalles();
        
        request.setAttribute("departements", departements);
        request.setAttribute("salles", salles);
        request.setAttribute("docteur", docteur);
        request.setAttribute("isEdit", true);
        request.getRequestDispatcher("/views/admin/docteur-form.jsp").forward(request, response);
    }
    
    /**
     * Crée un nouveau docteur
     */
    private void creerDocteur(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String specialite = request.getParameter("specialite");
        String departementIdStr = request.getParameter("departementId");
        String salleIdStr = request.getParameter("salleId");
        
        // Validation
        if (nom == null || nom.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le nom est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        if (prenom == null || prenom.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le prénom est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "L'email est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        if (motDePasse == null || motDePasse.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le mot de passe est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        if (specialite == null || specialite.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "La spécialité est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        if (departementIdStr == null || departementIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le département est obligatoire");
            afficherFormulaireCreation(request, response);
            return;
        }
        
        try {
            Long departementId = Long.parseLong(departementIdStr);
            Long salleId = (salleIdStr != null && !salleIdStr.trim().isEmpty()) ? 
                           Long.parseLong(salleIdStr) : null;
            
            // Créer le docteur
            Docteur docteur = adminService.creerDocteur(
                nom.trim(), 
                prenom.trim(), 
                email.trim(), 
                motDePasse.trim(), 
                specialite.trim(), 
                departementId,
                salleId
            );
            
            if (docteur != null) {
                request.getSession().setAttribute("successMessage", 
                    "Docteur " + docteur.getPrenom() + " " + docteur.getNom() + " créé avec succès !");
            } else {
                request.getSession().setAttribute("errorMessage", 
                    "Erreur lors de la création du docteur");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", 
                "Erreur lors de la création: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/docteurs");
    }
    
    /**
     * Modifie un docteur existant
     */
    private void modifierDocteur(HttpServletRequest request, HttpServletResponse response, Long docteurId) 
            throws ServletException, IOException {
        
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String specialite = request.getParameter("specialite");
        String departementIdStr = request.getParameter("departementId");
        String salleIdStr = request.getParameter("salleId");
        
        // Validation
        if (nom == null || nom.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le nom est obligatoire");
            afficherFormulaireModification(request, response, docteurId);
            return;
        }
        
        if (prenom == null || prenom.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le prénom est obligatoire");
            afficherFormulaireModification(request, response, docteurId);
            return;
        }
        
        if (email == null || email.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "L'email est obligatoire");
            afficherFormulaireModification(request, response, docteurId);
            return;
        }
        
        if (specialite == null || specialite.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "La spécialité est obligatoire");
            afficherFormulaireModification(request, response, docteurId);
            return;
        }
        
        if (departementIdStr == null || departementIdStr.trim().isEmpty()) {
            request.getSession().setAttribute("errorMessage", "Le département est obligatoire");
            afficherFormulaireModification(request, response, docteurId);
            return;
        }
        
        try {
            // Récupérer le docteur existant
            Docteur docteur = adminService.listerTousLesDocteurs().stream()
                    .filter(d -> d.getId().equals(docteurId))
                    .findFirst()
                    .orElse(null);
            
            if (docteur == null) {
                request.getSession().setAttribute("errorMessage", "Docteur introuvable");
                response.sendRedirect(request.getContextPath() + "/admin/docteurs");
                return;
            }
            
            // Mettre à jour les informations
            docteur.setNom(nom.trim());
            docteur.setPrenom(prenom.trim());
            docteur.setEmail(email.trim());
            docteur.setSpecialite(specialite.trim());
            
            // Mettre à jour le département
            Long departementId = Long.parseLong(departementIdStr);
            Departement departement = adminService.getDepartementById(departementId);
            docteur.setDepartement(departement);
            
            // Mettre à jour la salle (optionnel)
            if (salleIdStr != null && !salleIdStr.trim().isEmpty()) {
                Long salleId = Long.parseLong(salleIdStr);
                Salle salle = adminService.getSalleById(salleId);
                docteur.setSalle(salle);
            } else {
                docteur.setSalle(null);
            }
            
            // Sauvegarder les modifications
            Docteur docteurModifie = adminService.modifierDocteur(docteur);
            
            if (docteurModifie != null) {
                request.getSession().setAttribute("successMessage", 
                    "Docteur " + docteurModifie.getPrenom() + " " + docteurModifie.getNom() + " modifié avec succès !");
            } else {
                request.getSession().setAttribute("errorMessage", 
                    "Erreur lors de la modification du docteur");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", 
                "Erreur lors de la modification: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/docteurs");
    }
    
    /**
     * Supprime un docteur
     */
    private void supprimerDocteur(HttpServletRequest request, HttpServletResponse response, Long docteurId) 
            throws ServletException, IOException {
        
        try {
            boolean supprime = adminService.supprimerDocteur(docteurId);
            
            if (supprime) {
                request.getSession().setAttribute("successMessage", 
                    "Docteur supprimé avec succès !");
            } else {
                request.getSession().setAttribute("errorMessage", 
                    "Erreur lors de la suppression du docteur");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("errorMessage", 
                "Erreur lors de la suppression: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/admin/docteurs");
    }
    
    /**
     * Recherche des docteurs par critère
     */
    private void rechercherDocteurs(HttpServletRequest request, HttpServletResponse response, String critere) 
            throws ServletException, IOException {
        
        List<Docteur> docteurs;
        List<Departement> departements = adminService.listerTousLesDepartements();
        
        if (critere != null && !critere.trim().isEmpty()) {
            docteurs = adminService.rechercherDocteurs(critere.trim());
            request.setAttribute("critereRecherche", critere.trim());
        } else {
            docteurs = adminService.listerTousLesDocteurs();
        }
        
        request.setAttribute("docteurs", docteurs);
        request.setAttribute("departements", departements);
        request.getRequestDispatcher("/views/admin/docteurs.jsp").forward(request, response);
    }
    
    /**
     * Filtre les docteurs par département
     */
    private void filtrerParDepartement(HttpServletRequest request, HttpServletResponse response, Long departementId) 
            throws ServletException, IOException {
        
        List<Docteur> docteurs = adminService.listerDocteursByDepartement(departementId);
        List<Departement> departements = adminService.listerTousLesDepartements();
        
        request.setAttribute("docteurs", docteurs);
        request.setAttribute("departements", departements);
        request.setAttribute("departementIdFiltre", departementId);
        request.getRequestDispatcher("/views/admin/docteurs.jsp").forward(request, response);
    }
}
