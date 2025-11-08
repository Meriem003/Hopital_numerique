<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Admin" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%@ page import="com.clinic.clinicapp.entity.Consultation" %>
<%@ page import="com.clinic.clinicapp.entity.Patient" %>
<%@ page import="com.clinic.clinicapp.enums.StatusConsultation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    Personne user = (Personne) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String userName = session.getAttribute("userName") != null ? 
                      (String) session.getAttribute("userName") : 
                      user.getPrenom() + " " + user.getNom();
    String userEmail = user.getEmail();
    
    // Récupérer les données du servlet
    Long totalPatients = (Long) request.getAttribute("totalPatients");
    Long totalDocteurs = (Long) request.getAttribute("totalDocteurs");
    Long totalConsultations = (Long) request.getAttribute("totalConsultations");
    Long tauxOccupation = (Long) request.getAttribute("tauxOccupation");
    List<Consultation> consultationsRecentes = (List<Consultation>) request.getAttribute("consultationsRecentes");
    List<Patient> patientsRecents = (List<Patient>) request.getAttribute("patientsRecents");
    Map<String, Long> consultationsByStatut = (Map<String, Long>) request.getAttribute("consultationsByStatut");
    
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
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
                    <a href="${pageContext.request.contextPath}/admin/patients" class="nav-link">
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
        <div class="consultations-header">
            <div class="header-content">
                <div class="header-text">
                    <h1>
                        <i class="fas fa-chart-line"></i>
                        Tableau de Bord
                    </h1>
                    <p>Bienvenue <%= userName %> - Panneau d'administration</p>
                </div>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon blue">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <div class="stat-value"><%= totalPatients != null ? totalPatients : 0 %></div>
                <div class="stat-label">Total Patients</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon green">
                        <i class="fas fa-user-md"></i>
                    </div>
                </div>
                <div class="stat-value"><%= totalDocteurs != null ? totalDocteurs : 0 %></div>
                <div class="stat-label">Docteurs Actifs</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon orange">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                </div>
                <div class="stat-value"><%= totalConsultations != null ? totalConsultations : 0 %></div>
                <div class="stat-label">Consultations</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon red">
                        <i class="fas fa-door-open"></i>
                    </div>
                </div>
                <div class="stat-value"><%= tauxOccupation != null ? tauxOccupation : 0 %>%</div>
                <div class="stat-label">Taux d'occupation</div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- All Consultations -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Toutes les Consultations</h3>
                </div>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Docteur</th>
                                <th>Date</th>
                                <th>Statut</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% 
                            if (consultationsRecentes != null && !consultationsRecentes.isEmpty()) {
                                for (Consultation consultation : consultationsRecentes) {
                                    String patientNom = consultation.getPatient() != null ? 
                                        consultation.getPatient().getPrenom() + " " + consultation.getPatient().getNom() : "N/A";
                                    String docteurNom = consultation.getDocteur() != null ? 
                                        "Dr. " + consultation.getDocteur().getPrenom() + " " + consultation.getDocteur().getNom() : "N/A";
                                    String dateHeure = consultation.getDateHeure() != null ? 
                                        consultation.getDateHeure().format(dateFormatter) : "N/A";
                                    String statutClass = "";
                                    String statutIcon = "";
                                    String statutText = "";
                                    
                                    if (consultation.getStatut() != null) {
                                        switch (consultation.getStatut()) {
                                            case VALIDEE:
                                                statutClass = "success";
                                                statutIcon = "fa-check";
                                                statutText = "Validée";
                                                break;
                                            case RESERVEE:
                                                statutClass = "warning";
                                                statutIcon = "fa-clock";
                                                statutText = "Réservée";
                                                break;
                                            case TERMINEE:
                                                statutClass = "info";
                                                statutIcon = "fa-check-double";
                                                statutText = "Terminée";
                                                break;
                                            case ANNULEE:
                                                statutClass = "danger";
                                                statutIcon = "fa-times";
                                                statutText = "Annulée";
                                                break;
                                        }
                                    }
                            %>
                            <tr>
                                <td><%= patientNom %></td>
                                <td><%= docteurNom %></td>
                                <td><%= dateHeure %></td>
                                <td><span class="badge <%= statutClass %>"><i class="fas <%= statutIcon %>"></i> <%= statutText %></span></td>
                            </tr>
                            <% 
                                }
                            } else {
                            %>
                            <tr>
                                <td colspan="4" style="text-align: center;">Aucune consultation enregistrée</td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- les patients récents -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Patients Récents</h3>
                </div>
                <ul class="activity-list">
                    <% 
                    if (patientsRecents != null && !patientsRecents.isEmpty()) {
                        for (Patient patient : patientsRecents) {
                            String patientNom = patient.getPrenom() + " " + patient.getNom();
                    %>
                    <li class="activity-item">
                        <div class="activity-icon blue">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Nouveau Patient</h4>
                            <p><%= patientNom %> s'est inscrit</p>
                        </div>
                        <span class="activity-time">ID: <%= patient.getId() %></span>
                    </li>
                    <% 
                        }
                    } else {
                    %>
                    <li class="activity-item">
                        <div class="activity-content">
                            <p style="text-align: center;">Aucun patient récent</p>
                        </div>
                    </li>
                    <% } %>
                </ul>
            </div>
        </div>
    </main>
    
    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>
</body>
</html>
