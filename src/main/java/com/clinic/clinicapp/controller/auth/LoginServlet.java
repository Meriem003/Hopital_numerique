package com.clinic.clinicapp.controller.auth;

import com.clinic.clinicapp.entity.Personne;
import com.clinic.clinicapp.entity.Admin;
import com.clinic.clinicapp.entity.Docteur;
import com.clinic.clinicapp.entity.Patient;
import com.clinic.clinicapp.service.AuthService;
import com.clinic.clinicapp.service.impl.AuthServiceImpl;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    private final AuthService authService = new AuthServiceImpl();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);        
        if (session != null && session.getAttribute("user") != null) {
            response.sendRedirect(getDashboardUrl((String) session.getAttribute("role")));
            return;
        }
        request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String motDePasse = request.getParameter("motDePasse");
        
        try {
            Personne user = authService.authentifier(email, motDePasse);
            
            if (user != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", user);                
                String role = determineRole(user);
                session.setAttribute("role", role);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userName", user.getPrenom() + " " + user.getNom());
                session.setMaxInactiveInterval(1800);
                
                String dashboardUrl = getDashboardUrl(role);
                response.sendRedirect(request.getContextPath() + dashboardUrl);
            } else {
                request.setAttribute("error", "Identifiants incorrects");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Erreur de connexion : " + e.getMessage());
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }
    private String determineRole(Personne user) {
        if (user instanceof Admin) {
            return "ADMIN";
        } else if (user instanceof Docteur) {
            return "DOCTEUR";
        } else if (user instanceof Patient) {
            return "PATIENT";
        }
        return "UNKNOWN";
    }
    
    private String getDashboardUrl(String role) {
        switch (role) {
            case "ADMIN":
                return "/views/admin/dashboard.jsp";
            case "DOCTEUR":
                return "/views/docteur/dashboard.jsp";
            case "PATIENT":
                return "/views/patient/dashboard.jsp";
            default:
                return "/views/auth/login.jsp";
        }
    }
}
