package com.clinic.clinicapp.controller.docteur;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/docteur/dashboard")
public class DocteurDashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Vérifier si l'utilisateur est connecté
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
        }
        
        // Vérifier si l'utilisateur est un docteur
        String role = (String) session.getAttribute("role");
        if (!"DOCTEUR".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
            return;
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
