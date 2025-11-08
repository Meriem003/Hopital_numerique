package com.clinic.clinicapp.controller.patient;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.service.ConsultationService;
import com.clinic.clinicapp.service.impl.ConsultationServiceImpl;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.repository.impl.SalleRepositoryImpl;
import com.clinic.clinicapp.enums.StatusConsultation;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/patient/consultations")
public class MesConsultationsServlet extends HttpServlet {
    
    private ConsultationService consultationService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepository = new ConsultationRepositoryImpl();
        SalleRepository salleRepository = new SalleRepositoryImpl();
        consultationService = new ConsultationServiceImpl(consultationRepository, salleRepository);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String role = (String) session.getAttribute("role");
        if (!"PATIENT".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Patient patient = (Patient) session.getAttribute("user");
        
        try {
            // Récupérer toutes les consultations du patient
            List<Consultation> consultations = consultationService.getConsultationsByPatient(patient.getId());
            
            // Filtrer les consultations à venir (RESERVEE ou VALIDEE)
            LocalDateTime maintenant = LocalDateTime.now();
            List<Consultation> consultationsAVenir = consultations.stream()
                    .filter(c -> c.getDateHeure().isAfter(maintenant) && 
                                 (c.getStatut() == StatusConsultation.RESERVEE || 
                                  c.getStatut() == StatusConsultation.VALIDEE))
                    .sorted((c1, c2) -> c1.getDateHeure().compareTo(c2.getDateHeure()))
                    .collect(Collectors.toList());
            
            // Filtrer les consultations passées (TERMINEE)
            List<Consultation> consultationsPassees = consultations.stream()
                    .filter(c -> c.getStatut() == StatusConsultation.TERMINEE)
                    .sorted((c1, c2) -> c2.getDateHeure().compareTo(c1.getDateHeure()))
                    .collect(Collectors.toList());
            
            // Filtrer les consultations annulées
            List<Consultation> consultationsAnnulees = consultations.stream()
                    .filter(c -> c.getStatut() == StatusConsultation.ANNULEE)
                    .sorted((c1, c2) -> c2.getDateHeure().compareTo(c1.getDateHeure()))
                    .collect(Collectors.toList());
            
            request.setAttribute("consultationsAVenir", consultationsAVenir);
            request.setAttribute("consultationsPassees", consultationsPassees);
            request.setAttribute("consultationsAnnulees", consultationsAnnulees);
            
            // Vérifier s'il y a un message de succès
            String success = (String) session.getAttribute("success");
            if (success != null) {
                request.setAttribute("success", success);
                session.removeAttribute("success");
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des consultations: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/views/patient/consultations.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String action = request.getParameter("action");
        String consultationIdStr = request.getParameter("consultationId");
        
        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            session.setAttribute("error", "ID de consultation manquant");
            response.sendRedirect(request.getContextPath() + "/patient/consultations");
            return;
        }
        
        try {
            Long consultationId = Long.parseLong(consultationIdStr);
            
            if ("annuler".equals(action)) {
                // Annuler la consultation
                Consultation consultation = consultationService.getConsultationById(consultationId);
                
                if (consultation == null) {
                    session.setAttribute("error", "Consultation introuvable");
                } else if (consultation.getStatut() == StatusConsultation.TERMINEE) {
                    session.setAttribute("error", "Impossible d'annuler une consultation terminée");
                } else {
                    consultationService.changerStatut(consultationId, StatusConsultation.ANNULEE);
                    session.setAttribute("success", "Consultation annulée avec succès");
                }
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("error", "Format d'ID invalide");
        } catch (Exception e) {
            session.setAttribute("error", "Erreur lors de l'opération: " + e.getMessage());
            e.printStackTrace();
        }
        
        response.sendRedirect(request.getContextPath() + "/patient/consultations");
    }
}
