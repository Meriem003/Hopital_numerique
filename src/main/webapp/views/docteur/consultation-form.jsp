<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Consultation" %>
<%@ page import="com.clinic.clinicapp.enums.StatusConsultation" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Détails Consultation - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/détailsConsultation.css">
</head>
<body>
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
                    <a href="${pageContext.request.contextPath}/docteur/dashboard" class="nav-link">
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
                    <a href="${pageContext.request.contextPath}/docteur/consultations" class="nav-link active">
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

    <main class="main-content">
        <a href="${pageContext.request.contextPath}/docteur/consultations" class="back-link">
            <i class="fas fa-arrow-left"></i> Retour
        </a>

        <%
            Consultation consultation = (Consultation) request.getAttribute("consultation");
            if (consultation == null) {
        %>
            <div class="empty-state">
                <i class="fas fa-exclamation-circle"></i>
                <h3>Consultation non trouvée</h3>
            </div>
        <%
            } else {
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                DateTimeFormatter fullFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm");
                
                String statusClass = "";
                String statusIcon = "";
                String statusLabel = "";
                
                switch (consultation.getStatut()) {
                    case RESERVEE:
                        statusClass = "reserved";
                        statusIcon = "fa-hourglass-half";
                        statusLabel = "Réservée";
                        break;
                    case VALIDEE:
                        statusClass = "confirmed";
                        statusIcon = "fa-check-circle";
                        statusLabel = "Validée";
                        break;
                    case TERMINEE:
                        statusClass = "completed";
                        statusIcon = "fa-check-double";
                        statusLabel = "Terminée";
                        break;
                    case ANNULEE:
                        statusClass = "cancelled";
                        statusIcon = "fa-times-circle";
                        statusLabel = "Annulée";
                        break;
                }
        %>

        <!-- Header -->
        <div class="detail-header">
            <div class="header-left">
                <h1><i class="fas fa-stethoscope"></i> Détails de la Consultation</h1>
                <p>Informations complètes et historique</p>
            </div>
            <span class="status-badge <%= statusClass %>">
                <i class="fas <%= statusIcon %>"></i>
                <%= statusLabel %>
            </span>
        </div>

        <!-- Patient Card -->
        <div class="patient-card">
            <div class="patient-header">
                <div class="patient-avatar-large">
                    <%= consultation.getPatient().getNom().substring(0, 1).toUpperCase() %>
                </div>
                <div class="patient-info">
                    <h2><%= consultation.getPatient().getNomComplet() %></h2>
                    <p><i class="fas fa-envelope"></i> <%= consultation.getPatient().getEmail() %></p>
                    <% if (consultation.getPatient().getPoids() != null || consultation.getPatient().getTaille() != null) { %>
                    <p class="patient-vitals">
                        <% if (consultation.getPatient().getPoids() != null) { %>
                            <span><i class="fas fa-weight"></i> <%= consultation.getPatient().getPoids() %> kg</span>
                        <% } %>
                        <% if (consultation.getPatient().getTaille() != null) { %>
                            <span><i class="fas fa-ruler-vertical"></i> <%= consultation.getPatient().getTaille() %> cm</span>
                        <% } %>
                    </p>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Consultation Details -->
        <div class="details-grid">
            <!-- Informations Consultation -->
            <div class="detail-section">
                <h3><i class="fas fa-calendar-alt"></i> Informations de la Consultation</h3>
                <div class="detail-rows">
                    <div class="detail-row">
                        <span class="detail-label">Date :</span>
                        <span class="detail-value"><%= consultation.getDateHeure().format(dateFormatter) %></span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Heure :</span>
                        <span class="detail-value"><%= consultation.getDateHeure().format(timeFormatter) %></span>
                    </div>
                    <% if (consultation.getSalle() != null) { %>
                    <div class="detail-row">
                        <span class="detail-label">Salle :</span>
                        <span class="detail-value"><%= consultation.getSalle().getNomSalle() %></span>
                    </div>
                    <% } %>
                    <div class="detail-row">
                        <span class="detail-label">Statut :</span>
                        <span class="detail-value">
                            <span class="status-badge <%= statusClass %>">
                                <i class="fas <%= statusIcon %>"></i>
                                <%= statusLabel %>
                            </span>
                        </span>
                    </div>
                </div>
            </div>

            <!-- Motif -->
            <% if (consultation.getMotif() != null && !consultation.getMotif().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-notes-medical"></i> Motif de la Consultation</h3>
                <div class="detail-content motif">
                    <%= consultation.getMotif() %>
                </div>
            </div>
            <% } %>

            <!-- Diagnostic -->
            <% if (consultation.getDiagnostic() != null && !consultation.getDiagnostic().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-diagnoses"></i> Diagnostic</h3>
                <div class="detail-content diagnostic">
                    <%= consultation.getDiagnostic() %>
                </div>
            </div>
            <% } %>

            <!-- Traitement -->
            <% if (consultation.getTraitement() != null && !consultation.getTraitement().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-pills"></i> Traitement Prescrit</h3>
                <div class="detail-content treatment">
                    <%= consultation.getTraitement() %>
                </div>
            </div>
            <% } %>

            <!-- Compte Rendu -->
            <% if (consultation.getCompteRendu() != null && !consultation.getCompteRendu().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-file-medical-alt"></i> Compte Rendu</h3>
                <div class="detail-content report">
                    <%= consultation.getCompteRendu() %>
                </div>
            </div>
            <% } %>

            <!-- Historique -->
            <div class="detail-section">
                <h3><i class="fas fa-history"></i> Historique</h3>
                <div class="detail-rows">
                    <% if (consultation.getDateCreation() != null) { %>
                    <div class="detail-row">
                        <span class="detail-label">Créée le :</span>
                        <span class="detail-value"><%= consultation.getDateCreation().format(fullFormatter) %></span>
                    </div>
                    <% } %>
                    <% if (consultation.getDateModification() != null) { %>
                    <div class="detail-row">
                        <span class="detail-label">Modifiée le :</span>
                        <span class="detail-value"><%= consultation.getDateModification().format(fullFormatter) %></span>
                    </div>
                    <% } %>
                </div>
            </div>
        </div>

        <!-- Actions -->
        <div class="actions-section">
            <a href="${pageContext.request.contextPath}/docteur/consultations" class="btn-action btn-back">
                <i class="fas fa-arrow-left"></i> Retour à la liste
            </a>
            
            <% if (consultation.getStatut() == StatusConsultation.RESERVEE) { %>
            <form method="post" action="${pageContext.request.contextPath}/docteur/consultations" style="display: inline;">
                <input type="hidden" name="action" value="updateStatus">
                <input type="hidden" name="consultationId" value="<%= consultation.getId() %>">
                <input type="hidden" name="nouveauStatut" value="VALIDEE">
                <button type="submit" class="btn-action btn-validate">
                    <i class="fas fa-check"></i> Valider
                </button>
            </form>
            <% } %>
        </div>

        <% } %>
    </main>

    <script>
        // Smooth scroll
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) target.scrollIntoView({ behavior: 'smooth' });
            });
        });
    </script>
</body>
</html>
