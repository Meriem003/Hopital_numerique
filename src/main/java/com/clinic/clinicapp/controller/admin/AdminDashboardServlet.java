package com.clinic.clinicapp.controller.admin;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Patient;
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
import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    
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
        HttpSession session = request.getSession(false);        
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }        
        String role = (String) session.getAttribute("role");
        if (!"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Charger les statistiques
        long totalPatients = adminService.obtenirNombreTotalPatients();
        long totalDocteurs = adminService.obtenirNombreTotalDocteurs();
        long totalConsultations = adminService.obtenirNombreTotalConsultations();
        
        // Calculer le taux d'occupation des salles (sur les 7 derniers jours)
        LocalDateTime maintenant = LocalDateTime.now();
        LocalDateTime il7Jours = maintenant.minusDays(7);
        double tauxOccupation = adminService.calculerTauxOccupationGlobalSalles(il7Jours, maintenant);
        
        // Récupérer toutes les consultations (triées par date décroissante)
        List<Consultation> toutesConsultations = adminService.superviserToutesLesConsultations();
        List<Consultation> consultationsRecentes = toutesConsultations.stream()
                .sorted(Comparator.comparing(Consultation::getDateHeure).reversed())
                .collect(Collectors.toList());
        
        // Récupérer les 5 derniers patients inscrits
        List<Patient> tousPatients = adminService.listerTousLesPatients();
        List<Patient> patientsRecents = tousPatients.stream()
                .sorted(Comparator.comparing(Patient::getId).reversed())
                .limit(5)
                .collect(Collectors.toList());
        
        // Nombre de consultations par statut
        Map<String, Long> consultationsByStatut = adminService.obtenirNombreConsultationsByStatut();
        
        // Ajouter les attributs à la requête
        request.setAttribute("totalPatients", totalPatients);
        request.setAttribute("totalDocteurs", totalDocteurs);
        request.setAttribute("totalConsultations", totalConsultations);
        request.setAttribute("tauxOccupation", Math.round(tauxOccupation));
        request.setAttribute("consultationsRecentes", consultationsRecentes);
        request.setAttribute("patientsRecents", patientsRecents);
        request.setAttribute("consultationsByStatut", consultationsByStatut);
        
        request.getRequestDispatcher("/views/admin/dashboard.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}
