package com.clinic.clinicapp.controller.patient;

import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.repository.DocteurRepository;
import com.clinic.clinicapp.repository.impl.DocteurRepositoryImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/patient/docteurs")
public class NosDocteursServlet extends HttpServlet {
    
    private DocteurRepository docteurRepository;
    
    @Override
    public void init() throws ServletException {
        super.init();
        docteurRepository = new DocteurRepositoryImpl();
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
        
        try {
            // Récupérer tous les docteurs
            List<Docteur> docteurs = docteurRepository.findAll();
            request.setAttribute("docteurs", docteurs);
            
            // Filtrer par spécialité si demandé
            String specialiteFilter = request.getParameter("specialite");
            if (specialiteFilter != null && !specialiteFilter.isEmpty()) {
                List<Docteur> docteursFiltres = docteurRepository.findBySpecialite(specialiteFilter);
                request.setAttribute("docteurs", docteursFiltres);
                request.setAttribute("specialiteFilter", specialiteFilter);
            }
            
        } catch (Exception e) {
            request.setAttribute("error", "Erreur lors du chargement des docteurs: " + e.getMessage());
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/views/patient/docteurs.jsp").forward(request, response);
    }
}
