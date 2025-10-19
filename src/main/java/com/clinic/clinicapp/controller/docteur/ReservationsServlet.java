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

@WebServlet(name = "ReservationsServlet", urlPatterns = {"/docteur/reservations"})
public class ReservationsServlet extends HttpServlet {

    private DocteurService docteurService;

    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepository = new ConsultationRepositoryImpl();
        DocteurRepository docteurRepository = new DocteurRepositoryImpl();
        this.docteurService = new DocteurServiceImpl(consultationRepository, docteurRepository);
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

        try {
            // Récupérer toutes les réservations en attente du docteur
            List<Consultation> reservationsEnAttente = docteurService.consulterReservationsEnAttente(docteur.getId());
            
            // Récupérer toutes les consultations validées à venir
            List<Consultation> consultationsValidees = docteurService.consulterConsultationsAVenir(docteur.getId())
                    .stream()
                    .filter(c -> c.getStatut() == StatusConsultation.VALIDEE)
                    .toList();

            request.setAttribute("reservationsEnAttente", reservationsEnAttente);
            request.setAttribute("consultationsValidees", consultationsValidees);
            request.setAttribute("docteur", docteur);

            request.getRequestDispatcher("/views/docteur/reservations.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des réservations: " + e.getMessage());
            request.getRequestDispatcher("/views/docteur/reservations.jsp").forward(request, response);
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
            response.sendRedirect(request.getContextPath() + "/docteur/reservations?error=missing_id");
            return;
        }

        try {
            Long consultationId = Long.parseLong(consultationIdStr);

            switch (action) {
                case "valider":
                    docteurService.validerReservation(consultationId);
                    response.sendRedirect(request.getContextPath() + "/docteur/reservations?success=validated");
                    break;

                case "refuser":
                    String motifRefus = request.getParameter("motifRefus");
                    if (motifRefus == null || motifRefus.trim().isEmpty()) {
                        response.sendRedirect(request.getContextPath() + "/docteur/reservations?error=missing_motif");
                        return;
                    }
                    docteurService.refuserReservation(consultationId, motifRefus);
                    response.sendRedirect(request.getContextPath() + "/docteur/reservations?success=refused");
                    break;

                default:
                    response.sendRedirect(request.getContextPath() + "/docteur/reservations?error=invalid_action");
                    break;
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/docteur/reservations?error=invalid_id");
        } catch (IllegalStateException e) {
            response.sendRedirect(request.getContextPath() + "/docteur/reservations?error=invalid_state");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/docteur/reservations?error=server_error");
        }
    }
}
