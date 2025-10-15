package com.clinic.clinicapp.controller.auth;

import com.clinic.clinicapp.entity.Personne;
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
        
        // Rediriger si déjà connecté
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
                session.setAttribute("role", user.getClass().getSimpleName().toUpperCase());
                session.setMaxInactiveInterval(1800);
                
                response.sendRedirect(getDashboardUrl((String) session.getAttribute("role")));
            } else {
                request.setAttribute("error", "Identifiants incorrects");
                request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
            }
        } catch (Exception e) {
            request.setAttribute("error", "Erreur de connexion");
            request.getRequestDispatcher("/views/auth/login.jsp").forward(request, response);
        }
    }
    
    private String getDashboardUrl(String role) {
        return role.toLowerCase() + "/dashboard";
    }
}
