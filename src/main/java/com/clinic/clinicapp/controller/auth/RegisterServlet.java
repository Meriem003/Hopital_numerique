package com.clinic.clinicapp.controller.auth;

import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.service.AuthService;
import com.clinic.clinicapp.service.impl.AuthServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    private AuthService authService;
    
    @Override
    public void init() throws ServletException {
        authService = new AuthServiceImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Récupérer le paramètre mode (login ou signup)
        String mode = request.getParameter("mode");
        
        // Passer le mode à la JSP pour afficher le bon formulaire
        if (mode != null) {
            request.setAttribute("mode", mode);
        }
        
        request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String nom = request.getParameter("nom");
        String prenom = request.getParameter("prenom");
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        String confirmPassword = request.getParameter("confirmPassword");
        String poidsStr = request.getParameter("poids");
        String tailleStr = request.getParameter("taille");
        
        if (nom == null || nom.trim().isEmpty() ||
            prenom == null || prenom.trim().isEmpty() ||
            email == null || email.trim().isEmpty() ||
            motDePasse == null || motDePasse.trim().isEmpty()) {
            request.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
            request.setAttribute("mode", "signup"); // Rester sur le formulaire d'inscription
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (!motDePasse.equals(confirmPassword)) {
            request.setAttribute("error", "Les mots de passe ne correspondent pas");
            request.setAttribute("mode", "signup"); // Rester sur le formulaire d'inscription
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        if (authService.emailExiste(email)) {
            request.setAttribute("error", "Cet email est déjà utilisé");
            request.setAttribute("mode", "signup"); // Rester sur le formulaire d'inscription
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
            return;
        }
        
        try {
            Patient patient = new Patient();
            patient.setNom(nom);
            patient.setPrenom(prenom);
            patient.setEmail(email);
            patient.setMotDePasse(motDePasse);
            
            if (poidsStr != null && !poidsStr.trim().isEmpty()) {
                patient.setPoids(new BigDecimal(poidsStr));
            }
            if (tailleStr != null && !tailleStr.trim().isEmpty()) {
                patient.setTaille(Integer.parseInt(tailleStr));
            }
            
            authService.inscrirePatient(patient);
            
            // Rediriger vers la page register avec le mode login et message de succès
            response.sendRedirect(request.getContextPath() + "/register?mode=login&register=success");
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format invalide pour le poids ou la taille");
            request.setAttribute("mode", "signup"); // Rester sur le formulaire d'inscription
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de l'inscription: " + e.getMessage());
            request.setAttribute("mode", "signup"); // Rester sur le formulaire d'inscription
            request.getRequestDispatcher("/views/auth/register.jsp").forward(request, response);
        }
    }
}
