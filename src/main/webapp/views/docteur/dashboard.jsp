<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Consultation" %>
<%@ page import="com.clinic.clinicapp.entity.Docteur" %>
<%@ page import="com.clinic.clinicapp.enums.StatusConsultation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%
    Docteur docteur = (Docteur) request.getAttribute("docteur");
    List<Consultation> prochainesConsultations = (List<Consultation>) request.getAttribute("prochainesConsultations");
    Integer totalAujourdhui = (Integer) request.getAttribute("totalAujourdhui");
    Integer totalEnAttente = (Integer) request.getAttribute("totalEnAttente");
    Integer totalMois = (Integer) request.getAttribute("totalMois");
    Long nombrePatientsUniques = (Long) request.getAttribute("nombrePatientsUniques");
    
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Docteur - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
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
                <p>Espace Docteur</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/dashboard" class="nav-link active">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/planning" class="nav-link">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Mon Planning</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/reservations" class="nav-link">
                        <i class="fas fa-clock"></i>
                        <span>Réservations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/consultations" class="nav-link">
                        <i class="fas fa-stethoscope"></i>
                        <span>Mes Consultations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/patients" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Patients Suivis</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/profil" class="nav-link">
                        <i class="fas fa-user-circle"></i>
                        <span>Mon Profil</span>
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
                    <h1><i class="fas fa-chart-line"></i> Tableau de Bord</h1>
                </div>
            </div>
        </header>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon blue">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                </div>
                <div class="stat-value"><%= totalAujourdhui != null ? totalAujourdhui : 0 %></div>
                <div class="stat-label">Aujourd'hui</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon orange">
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
                <div class="stat-value"><%= totalEnAttente != null ? totalEnAttente : 0 %></div>
                <div class="stat-label">En Attente</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-value"><%= totalMois != null ? totalMois : 0 %></div>
                <div class="stat-label">Ce Mois</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon purple">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <div class="stat-value"><%= nombrePatientsUniques != null ? nombrePatientsUniques : 0 %></div>
                <div class="stat-label">Patients Suivis</div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Rendez-vous d'Aujourd'hui -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Prochains Rendez-vous</h3>
                    <a href="${pageContext.request.contextPath}/docteur/planning" class="card-action">
                        Voir tout <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Date & Heure</th>
                                <th>Patient</th>
                                <th>Motif</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (prochainesConsultations != null && !prochainesConsultations.isEmpty()) {
                                    for (Consultation consultation : prochainesConsultations) {
                                        String statutClass = "";
                                        String statutIcon = "";
                                        String statutText = "";
                                        
                                        switch (consultation.getStatut()) {
                                            case RESERVEE:
                                                statutClass = "warning";
                                                statutIcon = "fa-clock";
                                                statutText = "En attente";
                                                break;
                                            case VALIDEE:
                                                statutClass = "info";
                                                statutIcon = "fa-check-circle";
                                                statutText = "Validée";
                                                break;
                                            case TERMINEE:
                                                statutClass = "success";
                                                statutIcon = "fa-check-double";
                                                statutText = "Terminée";
                                                break;
                                            case ANNULEE:
                                                statutClass = "danger";
                                                statutIcon = "fa-times-circle";
                                                statutText = "Annulée";
                                                break;
                                        }
                            %>
                            <tr>
                                <td>
                                    <div class="time-badge">
                                        <span class="time"><%= consultation.getDateHeure().format(timeFormatter) %></span>
                                        <span class="date"><%= consultation.getDateHeure().format(dateFormatter) %></span>
                                    </div>
                                </td>
                                <td>
                                    <strong><%= consultation.getPatient().getNom() %> <%= consultation.getPatient().getPrenom() %></strong>
                                </td>
                                <td><%= consultation.getMotif() != null ? consultation.getMotif() : "Non spécifié" %></td>
                                <td>
                                    <span class="badge <%= statutClass %>">
                                        <i class="fas <%= statutIcon %>"></i> <%= statutText %>
                                    </span>
                                </td>
                                <td>
                                    <div class="action-btns">
                                        <a href="${pageContext.request.contextPath}/docteur/consultation/details?id=<%= consultation.getId() %>" 
                                           class="action-btn edit" title="Voir détails">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <% if (consultation.getStatut() == StatusConsultation.RESERVEE) { %>
                                        <a href="${pageContext.request.contextPath}/docteur/consultation/valider?id=<%= consultation.getId() %>" 
                                           class="action-btn delete" title="Valider">
                                            <i class="fas fa-check"></i>
                                        </a>
                                        <% } %>
                                    </div>
                                </td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 40px; color: #6b7280;">
                                    <i class="fas fa-calendar-times" style="font-size: 48px; margin-bottom: 16px; display: block;"></i>
                                    <p style="font-size: 16px; margin: 0;">Aucun rendez-vous à venir</p>
                                </td>
                            </tr>
                            <%
                                }
                            %>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Consultations Récentes -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Consultations Récentes</h3>
                </div>
                <ul class="activity-list">
                    <%
                        List<Consultation> consultationsAujourdhui = (List<Consultation>) request.getAttribute("consultationsAujourdhui");
                        if (consultationsAujourdhui != null && !consultationsAujourdhui.isEmpty()) {
                            int count = 0;
                            for (Consultation consultation : consultationsAujourdhui) {
                                if (count >= 5) break; // Limiter à 5
                                String iconClass = "";
                                switch (consultation.getStatut()) {
                                    case TERMINEE:
                                        iconClass = "green";
                                        break;
                                    case VALIDEE:
                                        iconClass = "blue";
                                        break;
                                    case RESERVEE:
                                        iconClass = "orange";
                                        break;
                                    case ANNULEE:
                                        iconClass = "red";
                                        break;
                                }
                    %>
                    <li class="activity-item">
                        <div class="activity-icon <%= iconClass %>">
                            <i class="fas fa-user-check"></i>
                        </div>
                        <div class="activity-content">
                            <h4><%= consultation.getPatient().getNom() %> <%= consultation.getPatient().getPrenom() %></h4>
                            <p>Consultation: <%= consultation.getDateHeure().format(dateFormatter) %> à <%= consultation.getDateHeure().format(timeFormatter) %></p>
                        </div>
                        <span class="activity-time"><%= consultation.getDateHeure().format(timeFormatter) %></span>
                    </li>
                    <%
                                count++;
                            }
                        } else {
                    %>
                    <li class="activity-item" style="justify-content: center; padding: 30px;">
                        <div style="text-align: center; color: #6b7280;">
                            <i class="fas fa-calendar-times" style="font-size: 36px; margin-bottom: 12px; display: block;"></i>
                            <p style="margin: 0;">Aucune consultation aujourd'hui</p>
                        </div>
                    </li>
                    <%
                        }
                    %>
                </ul>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>
</body>
</html>