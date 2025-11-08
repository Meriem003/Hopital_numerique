<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Consultation" %>
<%@ page import="com.clinic.clinicapp.entity.Patient" %>
<%@ page import="com.clinic.clinicapp.enums.StatusConsultation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.util.List" %>
<%
    Patient patient = (Patient) request.getAttribute("patient");
    List<Consultation> consultationsAVenir = (List<Consultation>) request.getAttribute("consultationsAVenir");
    List<Consultation> historique = (List<Consultation>) request.getAttribute("historique");
    Long nombreDocteursUniques = (Long) request.getAttribute("nombreDocteursUniques");
    
    String userName = patient != null ? patient.getPrenom() + " " + patient.getNom() : "";
    
    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
    DateTimeFormatter dateTimeFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy, HH:mm");
%>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Patient - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
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
                <p>Espace Patient</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link active">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/reserver" class="nav-link">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Réserver un RDV</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/consultations" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Mes Rendez-vous</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/docteurs" class="nav-link">
                        <i class="fas fa-user-md"></i>
                        <span>Nos Docteurs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/historique" class="nav-link">
                        <i class="fas fa-history"></i>
                        <span>Historique Médical</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/profil" class="nav-link">
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
                    <p>Bienvenue <%= userName %> - Gérez vos rendez-vous et consultez votre dossier médical</p>
                </div>
            </div>
        </header>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon blue">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                </div>
                <div class="stat-value"><%= consultationsAVenir != null ? consultationsAVenir.size() : 0 %></div>
                <div class="stat-label">RDV à Venir</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-value"><%= historique != null ? historique.size() : 0 %></div>
                <div class="stat-label">Consultations Effectuées</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon orange">
                        <i class="fas fa-user-md"></i>
                    </div>
                </div>
                <div class="stat-value"><%= nombreDocteursUniques != null ? nombreDocteursUniques : 0 %></div>
                <div class="stat-label">Docteurs Suivis</div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Prochains Rendez-vous -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Prochains Rendez-vous</h3>
                    <a href="${pageContext.request.contextPath}/patient/consultations" class="card-action">
                        Voir tout <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <div class="table-container">
                    <%
                        if (consultationsAVenir != null && !consultationsAVenir.isEmpty()) {
                            int count = 0;
                    %>
                            <table class="data-table">
                                <thead>
                                    <tr>
                                        <th>Date & Heure</th>
                                        <th>Docteur</th>
                                        <th>Département</th>
                                        <th>Statut</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (Consultation consultation : consultationsAVenir) {
                                            if (count >= 4) break; // Limiter à 4
                                            
                                            String statutClass = "";
                                            String statutIcon = "";
                                            String statutText = "";
                                            
                                            switch (consultation.getStatut()) {
                                                case RESERVEE:
                                                    statutClass = "warning";
                                                    statutIcon = "fa-clock";
                                                    statutText = "Réservée";
                                                    break;
                                                case VALIDEE:
                                                    statutClass = "success";
                                                    statutIcon = "fa-check";
                                                    statutText = "Validée";
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
                                    %>
                                        <tr>
                                            <td>
                                                <%= consultation.getDateHeure().format(dateTimeFormatter) %>
                                            </td>
                                            <td>Dr. <%= consultation.getDocteur().getNom() %> <%= consultation.getDocteur().getPrenom() %></td>
                                            <td><%= consultation.getDocteur().getDepartement() != null ? consultation.getDocteur().getDepartement().getNom() : "N/A" %></td>
                                            <td>
                                                <span class="badge <%= statutClass %>">
                                                    <i class="fas <%= statutIcon %>"></i> <%= statutText %>
                                                </span>
                                            </td>
                                            <td>
                                                <div class="action-btns">
                                                    <a href="${pageContext.request.contextPath}/patient/consultation/details?id=<%= consultation.getId() %>" 
                                                       class="action-btn edit" title="Voir détails">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <% if (consultation.getStatut() == StatusConsultation.RESERVEE) { %>
                                                    <a href="${pageContext.request.contextPath}/patient/consultation/annuler?id=<%= consultation.getId() %>" 
                                                       class="action-btn delete" title="Annuler"
                                                       onclick="return confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous ?');">
                                                        <i class="fas fa-times"></i>
                                                    </a>
                                                    <% } %>
                                                </div>
                                            </td>
                                        </tr>
                                    <%
                                            count++;
                                        }
                                    %>
                                </tbody>
                            </table>
                    <%
                        } else {
                    %>
                            <div style="text-align: center; padding: 3rem; color: #6c757d;">
                                <i class="fas fa-calendar-times" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                                <p style="margin-bottom: 1rem;">Aucun rendez-vous à venir</p>
                                <a href="${pageContext.request.contextPath}/patient/reserver" class="btn-primary">
                                    <i class="fas fa-calendar-plus"></i> Réserver maintenant
                                </a>
                            </div>
                    <%
                        }
                    %>
                </div>
            </div>
    </main>

    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>
</body>
</html>