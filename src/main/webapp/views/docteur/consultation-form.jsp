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
    <style>
        .detail-card {
            background: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .detail-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding-bottom: 20px;
            margin-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }
        .detail-title {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .detail-title h2 {
            margin: 0;
            color: #2c3e50;
        }
        .detail-section {
            margin-bottom: 30px;
        }
        .detail-section h3 {
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .detail-row {
            display: grid;
            grid-template-columns: 200px 1fr;
            padding: 12px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .detail-row:last-child {
            border-bottom: none;
        }
        .detail-label {
            font-weight: 600;
            color: #555;
        }
        .detail-value {
            color: #333;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .status-reservee { background: #fff3cd; color: #856404; }
        .status-validee { background: #d1ecf1; color: #0c5460; }
        .status-annulee { background: #f8d7da; color: #721c24; }
        .status-terminee { background: #d4edda; color: #155724; }
        .patient-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
        }
        .patient-card h3 {
            margin: 0 0 10px 0;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .patient-card p {
            margin: 5px 0;
            opacity: 0.9;
        }
        .action-buttons {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
            text-decoration: none;
        }
        .btn-primary { background-color: #4A90E2; color: white; }
        .btn-primary:hover { background-color: #357ABD; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #5a6268; }
        .btn-success { background-color: #28a745; color: white; }
        .btn-success:hover { background-color: #218838; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-danger:hover { background-color: #c82333; }
        .back-link {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            color: #4A90E2;
            text-decoration: none;
            margin-bottom: 20px;
            font-weight: 500;
            transition: color 0.3s;
        }
        .back-link:hover {
            color: #357ABD;
        }
    </style>
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
            <i class="fas fa-arrow-left"></i> Retour à la liste
        </a>

        <%
            Consultation consultation = (Consultation) request.getAttribute("consultation");
            if (consultation == null) {
        %>
            <div class="empty-state">
                <i class="fas fa-exclamation-circle"></i>
                <h3>Consultation non trouvée</h3>
                <p>Cette consultation n'existe pas ou vous n'avez pas les droits pour y accéder.</p>
            </div>
        <%
            } else {
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                
                String statusClass = "";
                String statusIcon = "";
                
                switch (consultation.getStatut()) {
                    case RESERVEE:
                        statusClass = "status-reservee";
                        statusIcon = "fa-clock";
                        break;
                    case VALIDEE:
                        statusClass = "status-validee";
                        statusIcon = "fa-check-circle";
                        break;
                    case TERMINEE:
                        statusClass = "status-terminee";
                        statusIcon = "fa-check-double";
                        break;
                    case ANNULEE:
                        statusClass = "status-annulee";
                        statusIcon = "fa-times-circle";
                        break;
                }
        %>

        <div class="detail-card">
            <div class="detail-header">
                <div class="detail-title">
                    <i class="fas fa-stethoscope" style="font-size: 32px; color: #4A90E2;"></i>
                    <h2>Détails de la Consultation</h2>
                </div>
                <span class="status-badge <%= statusClass %>">
                    <i class="fas <%= statusIcon %>"></i>
                    <%= consultation.getStatut().getLibelle() %>
                </span>
            </div>

            <!-- Informations Patient -->
            <div class="patient-card">
                <h3><i class="fas fa-user-injured"></i> Patient</h3>
                <p><strong>Nom complet :</strong> <%= consultation.getPatient().getNomComplet() %></p>
                <p><strong>Email :</strong> <%= consultation.getPatient().getEmail() %></p>
                <% if (consultation.getPatient().getPoids() != null) { %>
                <p><strong>Poids :</strong> <%= consultation.getPatient().getPoids() %> kg</p>
                <% } %>
                <% if (consultation.getPatient().getTaille() != null) { %>
                <p><strong>Taille :</strong> <%= consultation.getPatient().getTaille() %> cm</p>
                <% } %>
            </div>

            <!-- Informations Consultation -->
            <div class="detail-section">
                <h3><i class="fas fa-calendar-alt"></i> Informations de la Consultation</h3>
                <div class="detail-row">
                    <div class="detail-label">Date :</div>
                    <div class="detail-value"><%= consultation.getDateHeure().format(dateFormatter) %></div>
                </div>
                <div class="detail-row">
                    <div class="detail-label">Heure :</div>
                    <div class="detail-value"><%= consultation.getDateHeure().format(timeFormatter) %></div>
                </div>
                <% if (consultation.getSalle() != null) { %>
                <div class="detail-row">
                    <div class="detail-label">Salle :</div>
                    <div class="detail-value"><%= consultation.getSalle().getNomSalle() %></div>
                </div>
                <% } %>
                <div class="detail-row">
                    <div class="detail-label">Statut :</div>
                    <div class="detail-value"><span class="status-badge <%= statusClass %>">
                        <i class="fas <%= statusIcon %>"></i>
                        <%= consultation.getStatut().getLibelle() %>
                    </span></div>
                </div>
            </div>

            <!-- Motif -->
            <% if (consultation.getMotif() != null && !consultation.getMotif().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-notes-medical"></i> Motif de la Consultation</h3>
                <div style="padding: 15px; background: #f8f9fa; border-radius: 8px;">
                    <%= consultation.getMotif() %>
                </div>
            </div>
            <% } %>

            <!-- Diagnostic -->
            <% if (consultation.getDiagnostic() != null && !consultation.getDiagnostic().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-diagnoses"></i> Diagnostic</h3>
                <div style="padding: 15px; background: #e7f3ff; border-radius: 8px; border-left: 4px solid #4A90E2;">
                    <%= consultation.getDiagnostic() %>
                </div>
            </div>
            <% } %>

            <!-- Traitement -->
            <% if (consultation.getTraitement() != null && !consultation.getTraitement().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-pills"></i> Traitement Prescrit</h3>
                <div style="padding: 15px; background: #d4edda; border-radius: 8px; border-left: 4px solid #28a745;">
                    <%= consultation.getTraitement() %>
                </div>
            </div>
            <% } %>

            <!-- Compte Rendu -->
            <% if (consultation.getCompteRendu() != null && !consultation.getCompteRendu().isEmpty()) { %>
            <div class="detail-section">
                <h3><i class="fas fa-file-medical-alt"></i> Compte Rendu</h3>
                <div style="padding: 15px; background: #fff3cd; border-radius: 8px; border-left: 4px solid #ffc107;">
                    <%= consultation.getCompteRendu() %>
                </div>
            </div>
            <% } %>

            <!-- Dates -->
            <div class="detail-section">
                <h3><i class="fas fa-history"></i> Historique</h3>
                <% if (consultation.getDateCreation() != null) { %>
                <div class="detail-row">
                    <div class="detail-label">Date de création :</div>
                    <div class="detail-value"><%= consultation.getDateCreation().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %></div>
                </div>
                <% } %>
                <% if (consultation.getDateModification() != null) { %>
                <div class="detail-row">
                    <div class="detail-label">Dernière modification :</div>
                    <div class="detail-value"><%= consultation.getDateModification().format(DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %></div>
                </div>
                <% } %>
            </div>

            <!-- Actions -->
            <div class="detail-section">
                <h3><i class="fas fa-tasks"></i> Actions</h3>
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/docteur/consultations" class="btn btn-secondary">
                        <i class="fas fa-arrow-left"></i> Retour
                    </a>
                    
                    <% if (consultation.getStatut() == StatusConsultation.RESERVEE) { %>
                        <form method="post" action="${pageContext.request.contextPath}/docteur/consultations" style="display: inline;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="consultationId" value="<%= consultation.getId() %>">
                            <input type="hidden" name="nouveauStatut" value="VALIDEE">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check"></i> Valider
                            </button>
                        </form>
                    <% } else if (consultation.getStatut() == StatusConsultation.VALIDEE) { %>
                        <button class="btn btn-primary" onclick="alert('Utilisez le formulaire dans la liste des consultations pour réaliser la consultation.')">
                            <i class="fas fa-file-medical"></i> Réaliser la consultation
                        </button>
                    <% } %>
                </div>
            </div>
        </div>
        <% } %>
    </main>
</body>
</html>
