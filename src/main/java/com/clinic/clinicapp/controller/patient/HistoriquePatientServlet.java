package com.clinic.clinicapp.controller.patient;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/patient/historique")
public class HistoriquePatientServlet extends HttpServlet {
    
    private ConsultationRepository consultationRepository;
    
    @Override
    public void init() throws ServletException {
        consultationRepository = new ConsultationRepositoryImpl();
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
        
        try {
            // Récupérer toutes les consultations du patient
            List<Consultation> toutesConsultations = consultationRepository.findByPatientId(patient.getId());
            
            // Filtrer les consultations terminées (historique)
            List<Consultation> consultationsTerminees = toutesConsultations.stream()
                .filter(c -> c.getStatut() == StatusConsultation.TERMINEE)
                .sorted((c1, c2) -> c2.getDateHeure().compareTo(c1.getDateHeure())) // Plus récent en premier
                .collect(Collectors.toList());
            
            // Filtrer par année si demandé
            String anneeParam = request.getParameter("annee");
            if (anneeParam != null && !anneeParam.isEmpty()) {
                try {
                    int annee = Integer.parseInt(anneeParam);
                    consultationsTerminees = consultationsTerminees.stream()
                        .filter(c -> c.getDateHeure().getYear() == annee)
                        .collect(Collectors.toList());
                    request.setAttribute("anneeSelectionnee", annee);
                } catch (NumberFormatException e) {
                    // Ignorer si l'année n'est pas valide
                }
            }
            
            // Filtrer par spécialité si demandé
            String specialiteParam = request.getParameter("specialite");
            if (specialiteParam != null && !specialiteParam.isEmpty()) {
                consultationsTerminees = consultationsTerminees.stream()
                    .filter(c -> c.getDocteur() != null && 
                                specialiteParam.equals(c.getDocteur().getSpecialite()))
                    .collect(Collectors.toList());
                request.setAttribute("specialiteSelectionnee", specialiteParam);
            }
            
            // Récupérer les années disponibles pour le filtre
            List<Integer> anneesDisponibles = toutesConsultations.stream()
                .map(c -> c.getDateHeure().getYear())
                .distinct()
                .sorted((a1, a2) -> a2.compareTo(a1)) // Plus récent en premier
                .collect(Collectors.toList());
            
            // Récupérer les spécialités disponibles pour le filtre
            List<String> specialitesDisponibles = toutesConsultations.stream()
                .filter(c -> c.getDocteur() != null && c.getDocteur().getSpecialite() != null)
                .map(c -> c.getDocteur().getSpecialite())
                .distinct()
                .sorted()
                .collect(Collectors.toList());
            
            // Statistiques
            long nombreConsultationsTotal = consultationsTerminees.size();
            long nombreDifferentsDocteurs = consultationsTerminees.stream()
                .filter(c -> c.getDocteur() != null)
                .map(c -> c.getDocteur().getId())
                .distinct()
                .count();
            
            request.setAttribute("consultations", consultationsTerminees);
            request.setAttribute("nombreConsultationsTotal", nombreConsultationsTotal);
            request.setAttribute("nombreDifferentsDocteurs", nombreDifferentsDocteurs);
            request.setAttribute("anneesDisponibles", anneesDisponibles);
            request.setAttribute("specialitesDisponibles", specialitesDisponibles);
            
            request.getRequestDispatcher("/views/patient/historique.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement de l'historique : " + e.getMessage());
            request.getRequestDispatcher("/views/patient/historique.jsp").forward(request, response);
        }
    }
}
