package com.clinic.clinicapp.controller.docteur;

import com.clinic.clinicapp.entity.Consultation;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.repository.ConsultationRepository;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.PatientRepository;
import com.clinic.clinicapp.repository.impl.ConsultationRepositoryImpl;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;
import com.clinic.clinicapp.repository.impl.PatientRepositoryImpl;
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

@WebServlet(name = "PatientsSuivisServlet", urlPatterns = {"/docteur/patients"})
public class PatientsSuivisServlet extends HttpServlet {

    private DocteurService docteurService;
    private PatientRepository patientRepository;

    @Override
    public void init() throws ServletException {
        super.init();
        ConsultationRepository consultationRepository = new ConsultationRepositoryImpl();
        DocteurRepository docteurRepository = new DocteurRepositoryImpl();
        this.docteurService = new DocteurServiceImpl(consultationRepository, docteurRepository);
        this.patientRepository = new PatientRepositoryImpl();
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
            if ("historique".equals(action)) {
                // Afficher l'historique médical d'un patient
                String patientIdStr = request.getParameter("patientId");
                if (patientIdStr != null) {
                    Long patientId = Long.parseLong(patientIdStr);
                    
                    // Récupérer le patient
                    Optional<Patient> patientOpt = patientRepository.findById(patientId);
                    if (patientOpt.isPresent()) {
                        Patient patient = patientOpt.get();
                        
                        // Récupérer l'historique médical
                        List<Consultation> historique = docteurService.consulterHistoriqueMedicalPatient(
                                docteur.getId(), patientId);
                        
                        request.setAttribute("patient", patient);
                        request.setAttribute("historique", historique);
                        request.setAttribute("docteur", docteur);
                        
                        request.getRequestDispatcher("/views/docteur/patient-historique.jsp")
                                .forward(request, response);
                        return;
                    }
                }
                response.sendRedirect(request.getContextPath() + "/docteur/patients?error=patient_not_found");
                return;
            }

            // Affichage de la liste des patients suivis
            List<Patient> patientsSuivis = docteurService.consulterPatientssSuivis(docteur.getId());
            
            // Pour chaque patient, compter le nombre de consultations
            for (Patient patient : patientsSuivis) {
                List<Consultation> consultations = docteurService.consulterHistoriqueMedicalPatient(
                        docteur.getId(), patient.getId());
                patient.setConsultations(consultations);
            }

            request.setAttribute("patientsSuivis", patientsSuivis);
            request.setAttribute("docteur", docteur);
            request.getRequestDispatcher("/views/docteur/patients-suivis.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur lors du chargement des patients: " + e.getMessage());
            request.getRequestDispatcher("/views/docteur/patients-suivis.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Redirection vers GET pour l'instant
        doGet(request, response);
    }
}
