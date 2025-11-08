package com.clinic.clinicapp.controller.docteur;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.service.DocteurService;
import com.clinic.clinicapp.service.impl.DocteurServiceImpl;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/docteur/dashboard")
public class DocteurDashboardServlet extends HttpServlet {
    
    private DocteurService docteurService;
    private ConsultationRepository consultationRepository;
    
    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepo = new ConsultationRepositoryImpl();
        DocteurRepository docteurRepo = new DocteurRepositoryImpl();
        this.docteurService = new DocteurServiceImpl(consultationRepo, docteurRepo);
        this.consultationRepository = consultationRepo;
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Vérifier si l'utilisateur est un docteur
        String role = (String) session.getAttribute("role");
        if (!"DOCTEUR".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        Docteur docteur = (Docteur) session.getAttribute("user");
        
        try {
            // Récupérer toutes les consultations du docteur
            List<Consultation> toutesConsultations = docteurService.consulterPlanning(docteur.getId());
            
            // Consultations d'aujourd'hui
            LocalDate today = LocalDate.now();
            List<Consultation> consultationsAujourdhui = toutesConsultations.stream()
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().toLocalDate().equals(today))
                .sorted(Comparator.comparing(Consultation::getDateHeure))
                .collect(Collectors.toList());
            
            // Consultations en attente (RESERVEE)
            List<Consultation> consultationsEnAttente = toutesConsultations.stream()
                .filter(c -> c.getStatut() == StatusConsultation.RESERVEE)
                .collect(Collectors.toList());
            
            // Consultations du mois en cours
            LocalDateTime debutMois = LocalDate.now().withDayOfMonth(1).atStartOfDay();
            LocalDateTime finMois = LocalDate.now().withDayOfMonth(LocalDate.now().lengthOfMonth()).atTime(23, 59, 59);
            List<Consultation> consultationsMois = toutesConsultations.stream()
                .filter(c -> c.getDateHeure() != null && 
                             !c.getDateHeure().isBefore(debutMois) && 
                             !c.getDateHeure().isAfter(finMois))
                .collect(Collectors.toList());
            
            // Nombre de patients uniques suivis
            long nombrePatientsUniques = toutesConsultations.stream()
                .filter(c -> c.getPatient() != null)
                .map(c -> c.getPatient().getId())
                .distinct()
                .count();
            
            // Prochaines consultations (les 5 prochaines)
            LocalDateTime maintenant = LocalDateTime.now();
            List<Consultation> prochainesConsultations = toutesConsultations.stream()
                .filter(c -> c.getDateHeure() != null && c.getDateHeure().isAfter(maintenant))
                .filter(c -> c.getStatut() == StatusConsultation.RESERVEE || c.getStatut() == StatusConsultation.VALIDEE)
                .sorted(Comparator.comparing(Consultation::getDateHeure))
                .limit(5)
                .collect(Collectors.toList());
            
            // Passer les données au JSP
            request.setAttribute("consultationsAujourdhui", consultationsAujourdhui);
            request.setAttribute("consultationsEnAttente", consultationsEnAttente);
            request.setAttribute("consultationsMois", consultationsMois);
            request.setAttribute("nombrePatientsUniques", nombrePatientsUniques);
            request.setAttribute("prochainesConsultations", prochainesConsultations);
            request.setAttribute("docteur", docteur);
            
            // Statistiques
            request.setAttribute("totalAujourdhui", consultationsAujourdhui.size());
            request.setAttribute("totalEnAttente", consultationsEnAttente.size());
            request.setAttribute("totalMois", consultationsMois.size());
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement du dashboard: " + e.getMessage());
        }
        
        // Transférer vers la page du dashboard docteur
        request.getRequestDispatcher("/views/docteur/dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
