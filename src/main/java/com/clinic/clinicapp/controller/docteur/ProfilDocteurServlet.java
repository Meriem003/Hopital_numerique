package com.clinic.clinicapp.controller.docteur;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Departement;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Salle;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.DepartementRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.repository.impl.DepartementRepositoryImpl;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;
import com.clinic.clinicapp.repository.impl.SalleRepositoryImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/docteur/profil")
public class ProfilDocteurServlet extends HttpServlet {
    
    private DocteurRepository docteurRepository;
    private DepartementRepository departementRepository;
    private SalleRepository salleRepository;
    private ConsultationRepository consultationRepository;
    
    @Override
    public void init() throws ServletException {
        docteurRepository = new DocteurRepositoryImpl();
        departementRepository = new DepartementRepositoryImpl();
        salleRepository = new SalleRepositoryImpl();
        consultationRepository = new ConsultationRepositoryImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Long docteurId = (Long) session.getAttribute("userId");
        
        try {
            // Récupérer les informations du docteur
            Optional<Docteur> optionalDocteur = docteurRepository.findById(docteurId);
            
            if (!optionalDocteur.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            Docteur docteur = optionalDocteur.get();
            
            // Récupérer les départements et salles pour les listes déroulantes
            List<Departement> departements = departementRepository.findAll();
            List<Salle> salles = salleRepository.findAll();
            
            // Récupérer les consultations du docteur pour éviter le lazy loading
            List<Consultation> consultations = consultationRepository.findByDocteurId(docteurId);
            
            // Calculer les statistiques à partir des consultations chargées
            int totalConsultations = consultations.size();
            long consultationsMoisActuel = consultations.stream()
                    .filter(c -> c.getDateHeure().getMonth() == java.time.LocalDateTime.now().getMonth())
                    .count();
            long patientsUniques = consultations.stream()
                    .map(c -> c.getPatient().getId())
                    .distinct()
                    .count();
            
            request.setAttribute("docteur", docteur);
            request.setAttribute("departements", departements);
            request.setAttribute("salles", salles);
            request.setAttribute("totalConsultations", totalConsultations);
            request.setAttribute("consultationsMoisActuel", consultationsMoisActuel);
            request.setAttribute("patientsUniques", patientsUniques);
            
            request.getRequestDispatcher("/views/docteur/profil.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                    "Erreur lors de la récupération du profil: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Long docteurId = (Long) session.getAttribute("userId");
        String action = request.getParameter("action");
        
        try {
            Optional<Docteur> optionalDocteur = docteurRepository.findById(docteurId);
            
            if (!optionalDocteur.isPresent()) {
                response.sendRedirect(request.getContextPath() + "/login");
                return;
            }
            
            Docteur docteur = optionalDocteur.get();
            
            if ("updateInfo".equals(action)) {
                // Mise à jour des informations personnelles
                String nom = request.getParameter("nom");
                String prenom = request.getParameter("prenom");
                String email = request.getParameter("email");
                String specialite = request.getParameter("specialite");
                String departementIdStr = request.getParameter("departementId");
                String salleIdStr = request.getParameter("salleId");
                
                if (nom != null && !nom.trim().isEmpty()) {
                    docteur.setNom(nom.trim());
                }
                if (prenom != null && !prenom.trim().isEmpty()) {
                    docteur.setPrenom(prenom.trim());
                }
                if (email != null && !email.trim().isEmpty()) {
                    docteur.setEmail(email.trim());
                }
                if (specialite != null && !specialite.trim().isEmpty()) {
                    docteur.setSpecialite(specialite.trim());
                }
                
                // Mise à jour du département
                if (departementIdStr != null && !departementIdStr.isEmpty()) {
                    Long departementId = Long.parseLong(departementIdStr);
                    Optional<Departement> optionalDepartement = departementRepository.findById(departementId);
                    if (optionalDepartement.isPresent()) {
                        docteur.setDepartement(optionalDepartement.get());
                    }
                }
                
                // Mise à jour de la salle
                if (salleIdStr != null && !salleIdStr.isEmpty()) {
                    Long salleId = Long.parseLong(salleIdStr);
                    Optional<Salle> optionalSalle = salleRepository.findById(salleId);
                    if (optionalSalle.isPresent()) {
                        docteur.setSalle(optionalSalle.get());
                    }
                }
                
                docteurRepository.update(docteur);
                session.setAttribute("successMessage", "Profil mis à jour avec succès");
                
            } else if ("changePassword".equals(action)) {
                // Changement de mot de passe
                String currentPassword = request.getParameter("currentPassword");
                String newPassword = request.getParameter("newPassword");
                String confirmPassword = request.getParameter("confirmPassword");
                
                if (currentPassword == null || newPassword == null || confirmPassword == null) {
                    session.setAttribute("errorMessage", "Tous les champs sont obligatoires");
                    response.sendRedirect(request.getContextPath() + "/docteur/profil");
                    return;
                }
                
                // Vérifier l'ancien mot de passe
                if (!docteur.getMotDePasse().equals(currentPassword)) {
                    session.setAttribute("errorMessage", "Mot de passe actuel incorrect");
                    response.sendRedirect(request.getContextPath() + "/docteur/profil");
                    return;
                }
                
                // Vérifier la confirmation
                if (!newPassword.equals(confirmPassword)) {
                    session.setAttribute("errorMessage", "Les mots de passe ne correspondent pas");
                    response.sendRedirect(request.getContextPath() + "/docteur/profil");
                    return;
                }
                
                // Vérifier la longueur minimale
                if (newPassword.length() < 6) {
                    session.setAttribute("errorMessage", "Le mot de passe doit contenir au moins 6 caractères");
                    response.sendRedirect(request.getContextPath() + "/docteur/profil");
                    return;
                }
                
                docteur.setMotDePasse(newPassword);
                docteurRepository.update(docteur);
                session.setAttribute("successMessage", "Mot de passe modifié avec succès");
            }
            
            response.sendRedirect(request.getContextPath() + "/docteur/profil");
            
        } catch (Exception e) {
            e.printStackTrace();
            HttpSession httpSession = request.getSession();
            httpSession.setAttribute("errorMessage", "Erreur lors de la mise à jour: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/docteur/profil");
        }
    }
    
    @Override
    public void destroy() {
        // Les repositories n'ont pas de méthode close()
    }
}
