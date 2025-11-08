<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.clinic.clinicapp.entity.Patient" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Personne user = (Personne) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Integer totalPatients = (Integer) request.getAttribute("totalPatients");
    String critereRecherche = (String) request.getAttribute("critereRecherche");
    String imcFilter = (String) request.getAttribute("imcFilter");
    
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Patients - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patients-table.css" rel="stylesheet">
</head>
<body>
    <!-- Sidebar -->
    <aside class="sidebar">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-hospital-symbol"></i>
            </div>
            <div class="logo-text">
                <h3>Clinique Excellence</h3>
                <p>Admin Panel</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/departements" class="nav-link">
                        <i class="fas fa-building"></i>
                        <span>Départements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/docteurs" class="nav-link">
                        <i class="fas fa-user-md"></i>
                        <span>Docteurs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/patients" class="nav-link active">
                        <i class="fas fa-users"></i>
                        <span>Patients</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/salles" class="nav-link">
                        <i class="fas fa-door-open"></i>
                        <span>Salles</span>
                    </a>
                </li>
            </ul>
        </nav>

        <button class="logout-btn" onclick="location.href='${pageContext.request.contextPath}/logout'">
            <i class="fas fa-sign-out-alt"></i>
            Déconnexion
        </button>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <header class="consultations-header">
            <div class="header-content">
                <div class="header-text">
                    <h1>
                        <i class="fas fa-users"></i>
                        Gestion des Patients
                    </h1>
                    <p>Liste complète des patients inscrits</p>
                </div>
            </div>
        </header>

        <!-- Messages -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span><%= successMessage %></span>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= errorMessage %></span>
            </div>
        <% } %>

        <!-- Table des patients -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list-alt"></i>
                    Liste des Patients
                    <% if (critereRecherche != null || imcFilter != null) { %>
                        <span class="filter-badge">Résultats filtrés</span>
                    <% } %>
                </h3>
                <div class="card-actions">
                    <span class="total-count">
                        <i class="fas fa-users"></i>
                        <%= totalPatients != null ? totalPatients : 0 %> patient(s)
                    </span>
                </div>
            </div>
            
            <% if (patients != null && !patients.isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table" id="patientsTable">
                        <thead>
                            <tr>
                                <th><i class="fas fa-hashtag"></i> ID</th>
                                <th><i class="fas fa-user"></i> Nom Complet</th>
                                <th><i class="fas fa-envelope"></i> Email</th>
                                <th><i class="fas fa-weight"></i> Poids (kg)</th>
                                <th><i class="fas fa-ruler-vertical"></i> Taille (cm)</th>
                                <th><i class="fas fa-chart-line"></i> IMC</th>
                                <th style="text-align: center;"><i class="fas fa-cog"></i> Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Patient patient : patients) { 
                                BigDecimal imc = patient.getIMC();
                                String imcClass = "";
                                String imcLabel = "";
                                
                                if (imc != null) {
                                    if (imc.compareTo(new BigDecimal("18.5")) < 0) {
                                        imcClass = "imc-underweight";
                                        imcLabel = "Insuffisant";
                                    } else if (imc.compareTo(new BigDecimal("25")) < 0) {
                                        imcClass = "imc-normal";
                                        imcLabel = "Normal";
                                    } else if (imc.compareTo(new BigDecimal("30")) < 0) {
                                        imcClass = "imc-overweight";
                                        imcLabel = "Surpoids";
                                    } else {
                                        imcClass = "imc-obese";
                                        imcLabel = "Obésité";
                                    }
                                }
                            %>
                                <tr class="patient-row">
                                    <td>
                                        <strong class="id-badge"><%= patient.getId() %></strong>
                                    </td>
                                    <td>
                                        <div class="patient-info">
                                            <i class="fas fa-user-circle patient-icon"></i>
                                            <strong class="patient-name"><%= patient.getPrenom() %> <%= patient.getNom() %></strong>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="email-cell">
                                            <i class="fas fa-envelope"></i>
                                            <span><%= patient.getEmail() %></span>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="metric-cell">
                                            <% if (patient.getPoids() != null) { %>
                                                <span class="metric-value"><%= patient.getPoids() %></span>
                                                <span class="metric-unit">kg</span>
                                            <% } else { %>
                                                <span class="no-data">-</span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <div class="metric-cell">
                                            <% if (patient.getTaille() != null) { %>
                                                <span class="metric-value"><%= patient.getTaille() %></span>
                                                <span class="metric-unit">cm</span>
                                            <% } else { %>
                                                <span class="no-data">-</span>
                                            <% } %>
                                        </div>
                                    </td>
                                    <td>
                                        <% if (imc != null) { %>
                                            <span class="badge-imc <%= imcClass %>">
                                                <i class="fas fa-chart-line"></i>
                                                <%= imc %> - <%= imcLabel %>
                                            </span>
                                        <% } else { %>
                                            <span class="badge-imc badge-secondary">
                                                <i class="fas fa-minus-circle"></i>
                                                N/A
                                            </span>
                                        <% } %>
                                    </td>
                                    <td style="text-align: center;">
                                        <div class="action-buttons-modern">
                                            <a href="${pageContext.request.contextPath}/admin/patients?action=modifier&id=<%= patient.getId() %>" 
                                               class="action-btn btn-edit" 
                                               title="Modifier le patient">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form method="get" 
                                                  action="${pageContext.request.contextPath}/admin/patients" 
                                                  style="display: inline;"
                                                  onsubmit="return confirm('⚠️ Êtes-vous sûr de vouloir supprimer ce patient ?\nCette action est irréversible.');">
                                                <input type="hidden" name="action" value="supprimer">
                                                <input type="hidden" name="id" value="<%= patient.getId() %>">
                                                <button type="submit" class="action-btn btn-delete" title="Supprimer le patient">
                                                    <i class="fas fa-trash-alt"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                </div>
            <% } else { %>
                <div class="empty-state">
                    <i class="fas fa-users"></i>
                    <h3>Aucun patient trouvé</h3>
                    <% if (critereRecherche != null || imcFilter != null) { %>
                        <p>Essayez de modifier vos critères de recherche ou de filtre</p>
                    <% } else { %>
                        <p>Il n'y a pas encore de patients enregistrés dans le système</p>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>
</body>
</html>
