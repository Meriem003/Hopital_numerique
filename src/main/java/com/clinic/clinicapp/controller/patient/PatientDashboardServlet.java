package com.clinic.clinicapp.controller.patient;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.service.ConsultationService;
import com.clinic.clinicapp.service.impl.ConsultationServiceImpl;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.repository.impl.SalleRepositoryImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/patient/dashboard")
public class PatientDashboardServlet extends HttpServlet {
    
    private ConsultationService consultationService;
    
    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepo = new ConsultationRepositoryImpl();
        SalleRepository salleRepo = new SalleRepositoryImpl();
        this.consultationService = new ConsultationServiceImpl(consultationRepo, salleRepo);
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
            List<Consultation> toutesConsultations = consultationService.getConsultationsByPatient(patient.getId());
            
            // Consultations à venir (RESERVEE ou VALIDEE et date future)
            LocalDateTime maintenant = LocalDateTime.now();
            List<Consultation> consultationsAVenir = toutesConsultations.stream()
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().isAfter(maintenant))
                .filter(c -> c.getStatut() == StatusConsultation.RESERVEE || c.getStatut() == StatusConsultation.VALIDEE)
                .sorted(Comparator.comparing(Consultation::getDateHeure))
                .collect(Collectors.toList());
            
            // Historique des consultations (TERMINEE)
            List<Consultation> historique = toutesConsultations.stream()
                .filter(c -> c.getStatut() == StatusConsultation.TERMINEE)
                .sorted(Comparator.comparing(Consultation::getDateHeure).reversed())
                .collect(Collectors.toList());
            
            // Nombre de docteurs uniques consultés
            long nombreDocteursUniques = toutesConsultations.stream()
                .filter(c -> c.getDocteur() != null)
                .map(c -> c.getDocteur().getId())
                .distinct()
                .count();
            
            // Ajouter les attributs à la requête
            request.setAttribute("patient", patient);
            request.setAttribute("consultationsAVenir", consultationsAVenir);
            request.setAttribute("historique", historique);
            request.setAttribute("nombreDocteursUniques", nombreDocteursUniques);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du dashboard: " + e.getMessage());
        }
        
        // Transférer vers la page du dashboard patient
        request.getRequestDispatcher("/views/patient/dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
