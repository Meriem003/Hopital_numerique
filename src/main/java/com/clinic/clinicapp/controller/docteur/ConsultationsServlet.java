package com.clinic.clinicapp.controller.docteur;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;
import com.clinic.clinicapp.service.DocteurService;
import com.clinic.clinicapp.service.impl.DocteurServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet(name = "ConsultationsServlet", urlPatterns = {"/docteur/consultations"})
public class ConsultationsServlet extends HttpServlet {

    private DocteurService docteurService;
    private ConsultationRepository consultationRepository;

    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepository = new ConsultationRepositoryImpl();
        DocteurRepository docteurRepository = new DocteurRepositoryImpl();
        this.docteurService = new DocteurServiceImpl(consultationRepository, docteurRepository);
        this.consultationRepository = consultationRepository;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Docteur docteur = (Docteur) session.getAttribute("user");
        String action = request.getParameter("action");

        try {
            if ("edit".equals(action)) {
                // Afficher le formulaire d'édition
                String consultationIdStr = request.getParameter("id");
                if (consultationIdStr != null) {
                    Long consultationId = Long.parseLong(consultationIdStr);
                    Optional<Consultation> consultationOpt = consultationRepository.findById(consultationId);
                    
                    if (consultationOpt.isPresent()) {
                        Consultation consultation = consultationOpt.get();
                        // Vérifier que c'est bien une consultation du docteur connecté
                        if (consultation.getDocteur().getId().equals(docteur.getId())) {
                            request.setAttribute("consultation", consultation);
                            request.getRequestDispatcher("/views/docteur/consultation-form.jsp").forward(request, response);
                            return;
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=not_found");
                return;
            }

            // Affichage de la liste des consultations
            List<Consultation> toutesConsultations = docteurService.consulterPlanning(docteur.getId());
            
            // Filtrer par statut si demandé
            String statutFilter = request.getParameter("statut");
            if (statutFilter != null && !statutFilter.isEmpty()) {
                try {
                    StatusConsultation statut = StatusConsultation.valueOf(statutFilter);
                    toutesConsultations = toutesConsultations.stream()
                            .filter(c -> c.getStatut() == statut)
                            .toList();
                    request.setAttribute("selectedStatut", statut);
                } catch (IllegalArgumentException e) {
                    // Statut invalide, on ignore le filtre
                }
            }

            request.setAttribute("consultations", toutesConsultations);
            request.setAttribute("docteur", docteur);
            request.getRequestDispatcher("/views/docteur/consultations.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des consultations: " + e.getMessage());
            request.getRequestDispatcher("/views/docteur/consultations.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getParameter("action");
        String consultationIdStr = request.getParameter("consultationId");

        if (consultationIdStr == null || consultationIdStr.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=missing_id");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdStr);

            switch (action) {
                case "updateStatus":
                    String nouveauStatutStr = request.getParameter("nouveauStatut");
                    if (nouveauStatutStr == null || nouveauStatutStr.isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=missing_status");
                        return;
                    }
                    StatusConsultation nouveauStatut = StatusConsultation.valueOf(nouveauStatutStr);
                    docteurService.mettreAJourStatutConsultation(consultationId, nouveauStatut);
                    response.sendRedirect(request.getContextPath() + "/docteur/consultations?success=status_updated");
                    break;

                case "realiser":
                    String compteRendu = request.getParameter("compteRendu");
                    String diagnostic = request.getParameter("diagnostic");
                    String traitement = request.getParameter("traitement");
                    
                    if (compteRendu == null || compteRendu.trim().isEmpty() ||
                        diagnostic == null || diagnostic.trim().isEmpty() ||
                        traitement == null || traitement.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=missing_fields");
                        return;
                    }
                    
                    docteurService.realiserConsultation(consultationId, compteRendu, diagnostic, traitement);
                    response.sendRedirect(request.getContextPath() + "/docteur/consultations?success=consultation_completed");
                    break;

                case "terminer":
                    docteurService.terminerConsultation(consultationId);
                    response.sendRedirect(request.getContextPath() + "/docteur/consultations?success=consultation_terminated");
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=invalid_action");
                    break;
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=invalid_id");
        } catch (IllegalArgumentException e) {
            response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=invalid_data");
        } catch (IllegalStateException e) {
            response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=invalid_state&message=" + e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/docteur/consultations?error=server_error");
        }
    }
}
