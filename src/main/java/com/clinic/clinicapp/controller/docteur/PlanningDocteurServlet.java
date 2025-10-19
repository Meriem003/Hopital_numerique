package com.clinic.clinicapp.controller.docteur;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.enums.StatusConsultation;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.repository.SalleRepository;
import com.clinic.clinicapp.repository.impl.SalleRepositoryImpl;
import com.clinic.clinicapp.service.ConsultationService;
import com.clinic.clinicapp.service.impl.ConsultationServiceImpl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAdjusters;
import java.util.*;
import java.util.stream.Collectors;

@WebServlet(name = "PlanningDocteurServlet", urlPatterns = {"/docteur/planning"})
public class PlanningDocteurServlet extends HttpServlet {

    private ConsultationService consultationService;

    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepository = new ConsultationRepositoryImpl();
        SalleRepository salleRepository = new SalleRepositoryImpl();
        this.consultationService = new ConsultationServiceImpl(consultationRepository, salleRepository);
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
            // Récupérer la semaine à afficher (par défaut: semaine courante)
            String weekOffset = request.getParameter("weekOffset");
            int offset = 0;
            if (weekOffset != null) {
                try {
                    offset = Integer.parseInt(weekOffset);
                } catch (NumberFormatException e) {
                    offset = 0;
                }
            }

            // Calculer les dates de début et fin de la semaine
            LocalDate today = LocalDate.now().plusWeeks(offset);
            LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(DayOfWeek.MONDAY));
            LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(DayOfWeek.SUNDAY));

            LocalDateTime startDateTime = startOfWeek.atStartOfDay();
            LocalDateTime endDateTime = endOfWeek.atTime(LocalTime.MAX);

            // Récupérer toutes les consultations du docteur pour cette semaine
            List<Consultation> allConsultations = consultationService.getConsultationsByDocteur(docteur.getId());
            
            // Filtrer les consultations de la semaine
            List<Consultation> weekConsultations = allConsultations.stream()
                    .filter(c -> c.getDateHeure() != null &&
                            !c.getDateHeure().isBefore(startDateTime) &&
                            !c.getDateHeure().isAfter(endDateTime))
                    .sorted(Comparator.comparing(Consultation::getDateHeure))
                    .collect(Collectors.toList());

            // Organiser les consultations par jour
            Map<LocalDate, List<Consultation>> consultationsByDay = new LinkedHashMap<>();
            for (LocalDate date = startOfWeek; !date.isAfter(endOfWeek); date = date.plusDays(1)) {
                final LocalDate currentDate = date;
                List<Consultation> dayConsultations = weekConsultations.stream()
                        .filter(c -> c.getDateHeure().toLocalDate().equals(currentDate))
                        .collect(Collectors.toList());
                consultationsByDay.put(date, dayConsultations);
            }

            // Calculer les statistiques de la semaine
            long reserveesCount = weekConsultations.stream()
                    .filter(c -> c.getStatut() == StatusConsultation.RESERVEE)
                    .count();
            
            long confirmeesCount = weekConsultations.stream()
                    .filter(c -> c.getStatut() == StatusConsultation.VALIDEE)
                    .count();
            
            long completeesCount = weekConsultations.stream()
                    .filter(c -> c.getStatut() == StatusConsultation.TERMINEE)
                    .count();
            
            long annuleesCount = weekConsultations.stream()
                    .filter(c -> c.getStatut() == StatusConsultation.ANNULEE)
                    .count();

            // Formater la période
            DateTimeFormatter formatter = DateTimeFormatter.ofPattern("dd MMMM yyyy", Locale.FRENCH);
            String periodLabel = startOfWeek.format(DateTimeFormatter.ofPattern("dd", Locale.FRENCH)) + 
                               " - " + endOfWeek.format(formatter);

            // Passer les données à la JSP
            request.setAttribute("consultationsByDay", consultationsByDay);
            request.setAttribute("startOfWeek", startOfWeek);
            request.setAttribute("endOfWeek", endOfWeek);
            request.setAttribute("periodLabel", periodLabel);
            request.setAttribute("weekOffset", offset);
            request.setAttribute("today", LocalDate.now());
            
            // Statistiques
            request.setAttribute("totalWeek", weekConsultations.size());
            request.setAttribute("reserveesCount", reserveesCount);
            request.setAttribute("confirmeesCount", confirmeesCount);
            request.setAttribute("completeesCount", completeesCount);
            request.setAttribute("annuleesCount", annuleesCount);

            request.getRequestDispatcher("/views/docteur/planning.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Erreur lors du chargement du planning: " + e.getMessage());
            request.getRequestDispatcher("/views/docteur/planning.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
