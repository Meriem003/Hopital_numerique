package com.clinic.clinicapp.controller.patient;

import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.repository.PatientRepository;
import com.clinic.clinicapp.repository.impl.PatientRepositoryImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/patient/profil")
public class ProfilPatientServlet extends HttpServlet {
    
    private PatientRepository patientRepository;
    
    @Override
    public void init() throws ServletException {
        patientRepository = new PatientRepositoryImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("user");
        
        // Recharger les données du patient depuis la base de données pour avoir les infos à jour
        Patient patientActuel = patientRepository.findById(patient.getId()).orElse(patient);
        session.setAttribute("user", patientActuel);
        request.setAttribute("patient", patientActuel);
        
        request.getRequestDispatcher("/views/patient/profil.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("user");
        
        try {
            // Récupérer les données du formulaire
            String nom = request.getParameter("nom");
            String prenom = request.getParameter("prenom");
            String email = request.getParameter("email");
            String poidsStr = request.getParameter("poids");
            String tailleStr = request.getParameter("taille");
            
            // Mettre à jour le patient
            if (nom != null && !nom.trim().isEmpty()) {
                patient.setNom(nom.trim());
            }
            if (prenom != null && !prenom.trim().isEmpty()) {
                patient.setPrenom(prenom.trim());
            }
            if (email != null && !email.trim().isEmpty()) {
                patient.setEmail(email.trim());
            }
            if (poidsStr != null && !poidsStr.trim().isEmpty()) {
                try {
                    java.math.BigDecimal poids = new java.math.BigDecimal(poidsStr);
                    patient.setPoids(poids);
                } catch (NumberFormatException e) {
                    // Ignorer si la valeur n'est pas valide
                }
            }
            if (tailleStr != null && !tailleStr.trim().isEmpty()) {
                try {
                    Integer taille = Integer.parseInt(tailleStr);
                    patient.setTaille(taille);
                } catch (NumberFormatException e) {
                    // Ignorer si la valeur n'est pas valide
                }
            }
            
            // Sauvegarder les modifications
            patientRepository.update(patient);
            
            // Mettre à jour la session
            session.setAttribute("user", patient);
            
            // Message de succès
            session.setAttribute("successMessage", "Profil mis à jour avec succès !");
            response.sendRedirect(request.getContextPath() + "/patient/profil");
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la mise à jour du profil : " + e.getMessage());
            request.setAttribute("patient", patient);
            request.getRequestDispatcher("/views/patient/profil.jsp").forward(request, response);
        }
    }
}
