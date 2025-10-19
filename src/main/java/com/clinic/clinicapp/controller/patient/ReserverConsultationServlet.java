package com.clinic.clinicapp.controller.patient;

import com.clinic.clinicapp.entity.*;
import com.clinic.clinicapp.service.ConsultationService;
import com.clinic.clinicapp.service.impl.ConsultationServiceImpl;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.repository.impl.SalleRepositoryImpl;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;
import com.clinic.clinicapp.enums.StatusConsultation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@WebServlet("/patient/reserver")
public class ReserverConsultationServlet extends HttpServlet {
    
    private ConsultationService consultationService;
    private DocteurRepository docteurRepository;
    
    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepository = new ConsultationRepositoryImpl();
        SalleRepository salleRepository = new SalleRepositoryImpl();
        consultationService = new ConsultationServiceImpl(consultationRepository, salleRepository);
        docteurRepository = new DocteurRepositoryImpl();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"PATIENT".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        
        // Charger la liste des docteurs pour le formulaire
        try {
            List<Docteur> docteurs = docteurRepository.findAll();
            request.setAttribute("docteurs", docteurs);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des docteurs: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/views/patient/reserver-rdv.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("user");
        
        try {
            // Récupération des paramètres du formulaire
            String dateStr = request.getParameter("date");
            String heureStr = request.getParameter("heure");
            String docteurIdStr = request.getParameter("docteurId");
            String motif = request.getParameter("motif");
            
            // Validation des paramètres
            if (dateStr == null || dateStr.isEmpty() || 
                heureStr == null || heureStr.isEmpty() || 
                docteurIdStr == null || docteurIdStr.isEmpty()) {
                request.setAttribute("error", "Tous les champs obligatoires doivent être remplis");
                doGet(request, response);
                return;
            }
            
            // Parsing de la date et de l'heure
            LocalDate date = LocalDate.parse(dateStr);
            LocalTime heure = LocalTime.parse(heureStr);
            LocalDateTime dateHeure = LocalDateTime.of(date, heure);
            Long docteurId = Long.parseLong(docteurIdStr);
            
            // Vérification que la date n'est pas dans le passé
            if (dateHeure.isBefore(LocalDateTime.now())) {
                request.setAttribute("error", "Impossible de réserver un rendez-vous dans le passé");
                doGet(request, response);
                return;
            }
            
            // Vérification de la disponibilité du docteur
            if (!consultationService.verifierDisponibiliteCreneau(docteurId, dateHeure)) {
                request.setAttribute("error", "Le créneau sélectionné n'est pas disponible pour ce docteur");
                doGet(request, response);
                return;
            }
            
            // Trouver une salle disponible
            Salle salleDisponible = consultationService.trouverSalleDisponible(dateHeure);
            if (salleDisponible == null) {
                request.setAttribute("error", "Aucune salle disponible pour ce créneau");
                doGet(request, response);
                return;
            }
            
            // Récupérer le docteur
            Docteur docteur = docteurRepository.findById(docteurId).orElse(null);
            if (docteur == null) {
                request.setAttribute("error", "Docteur introuvable");
                doGet(request, response);
                return;
            }
            
            // Créer la consultation
            Consultation consultation = new Consultation();
            consultation.setDateHeure(dateHeure);
            consultation.setMotif(motif);
            consultation.setPatient(patient);
            consultation.setDocteur(docteur);
            consultation.setSalle(salleDisponible);
            consultation.setStatut(StatusConsultation.RESERVEE);
            
            // Sauvegarder la consultation
            Consultation consultationCreee = consultationService.creerConsultation(consultation);
            
            if (consultationCreee != null) {
                session.setAttribute("success", "Rendez-vous réservé avec succès! En attente de validation du docteur.");
                response.sendRedirect(request.getContextPath() + "/patient/consultations");
            } else {
                request.setAttribute("error", "Erreur lors de la création du rendez-vous");
                doGet(request, response);
            }
            
        } catch (NumberFormatException e) {
            request.setAttribute("error", "Format de données invalide");
            doGet(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors de la réservation: " + e.getMessage());
            e.printStackTrace();
            doGet(request, response);
        }
    }
}
