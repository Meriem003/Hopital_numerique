package com.clinic.clinicapp.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebFilter("/*")
public class AuthenticationFilter implements Filter {
    
    private static final String[] PUBLIC_PATHS = {
        "/login", 
        "/register", 
        "/logout", 
        "/assets/", 
        "/views/auth/",
        "/index.jsp",
        "/contact.jsp"
    };
    private static final String[] ADMIN_PATHS = {"/admin/", "/views/admin/"};
    private static final String[] DOCTEUR_PATHS = {"/docteur/", "/views/docteur/"};
    private static final String[] PATIENT_PATHS = {"/patient/", "/views/patient/"};
    
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest request = (HttpServletRequest) servletRequest;
        HttpServletResponse response = (HttpServletResponse) servletResponse;
        
        String path = request.getRequestURI().substring(request.getContextPath().length());
        
        if (isPublic(path)) {
            chain.doFilter(request, response);
            return;
        }
        
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            String role = (String) session.getAttribute("role");            
            if (hasAccess(path, role)) {
                chain.doFilter(request, response);
            } else {
                response.sendRedirect(request.getContextPath() + getDashboardForRole(role));
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
    
    private boolean isPublic(String path) {
        if (path.equals("/") || path.isEmpty()) return true;
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath)) return true;
        }
        return false;
    }
    private boolean hasAccess(String path, String role) {
        if (role == null) return false;        
        if ("ADMIN".equals(role)) {
            return true;
        }
        if ("DOCTEUR".equals(role)) {
            for (String docteurPath : DOCTEUR_PATHS) {
                if (path.startsWith(docteurPath)) return true;
            }
            for (String adminPath : ADMIN_PATHS) {
                if (path.startsWith(adminPath)) return false;
            }
            for (String patientPath : PATIENT_PATHS) {
                if (path.startsWith(patientPath)) return false;
            }
        }        
        if ("PATIENT".equals(role)) {
            for (String patientPath : PATIENT_PATHS) {
                if (path.startsWith(patientPath)) return true;
            }
            for (String adminPath : ADMIN_PATHS) {
                if (path.startsWith(adminPath)) return false;
            }
            for (String docteurPath : DOCTEUR_PATHS) {
                if (path.startsWith(docteurPath)) return false;
            }
        }
        
        return true; 
    }
    private String getDashboardForRole(String role) {
        switch (role) {
            case "ADMIN":
                return "/admin/dashboard";
            case "DOCTEUR":
                return "/views/docteur/dashboard.jsp";
            case "PATIENT":
                return "/views/patient/dashboard.jsp";
            default:
                return "/login";
        }
    }
}
