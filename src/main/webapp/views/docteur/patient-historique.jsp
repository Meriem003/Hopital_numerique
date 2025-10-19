<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Patient" %>
<%@ page import="com.clinic.clinicapp.entity.Consultation" %>
<%@ page import="com.clinic.clinicapp.enums.StatusConsultation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique Médical - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
    <style>
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
        .patient-header-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            padding: 30px;
            margin-bottom: 30px;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        .patient-header-content {
            display: flex;
            align-items: center;
            gap: 25px;
            margin-bottom: 20px;
        }
        .patient-avatar-xl {
            width: 100px;
            height: 100px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            font-weight: bold;
            border: 4px solid rgba(255, 255, 255, 0.3);
        }
        .patient-info h2 {
            margin: 0 0 10px 0;
            font-size: 32px;
        }
        .patient-info p {
            margin: 5px 0;
            opacity: 0.9;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .patient-details-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .detail-item {
            background: rgba(255, 255, 255, 0.15);
            padding: 15px;
            border-radius: 8px;
            backdrop-filter: blur(10px);
        }
        .detail-item .label {
            font-size: 13px;
            opacity: 0.8;
            margin-bottom: 5px;
        }
        .detail-item .value {
            font-size: 20px;
            font-weight: bold;
        }
        .timeline {
            position: relative;
            padding-left: 40px;
        }
        .timeline::before {
            content: '';
            position: absolute;
            left: 20px;
            top: 0;
            bottom: 0;
            width: 2px;
            background: linear-gradient(to bottom, #4A90E2, transparent);
        }
        .timeline-item {
            background: white;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            position: relative;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .timeline-item:hover {
            transform: translateX(5px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -31px;
            top: 30px;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: white;
            border: 4px solid #4A90E2;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .timeline-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        .timeline-date {
            display: flex;
            align-items: center;
            gap: 10px;
            color: #2c3e50;
            font-weight: 600;
        }
        .timeline-date i {
            color: #4A90E2;
        }
        .status-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }
        .status-terminee {
            background: #d4edda;
            color: #155724;
        }
        .status-validee {
            background: #d1ecf1;
            color: #0c5460;
        }
        .status-annulee {
            background: #f8d7da;
            color: #721c24;
        }
        .status-reservee {
            background: #fff3cd;
            color: #856404;
        }
        .timeline-body {
            margin-bottom: 15px;
        }
        .section {
            margin-bottom: 15px;
        }
        .section-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .section-content {
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #4A90E2;
            color: #333;
            line-height: 1.6;
        }
        .section-content.diagnostic {
            border-left-color: #28a745;
            background: #d4edda;
        }
        .section-content.traitement {
            border-left-color: #ffc107;
            background: #fff3cd;
        }
        .section-content.motif {
            border-left-color: #17a2b8;
            background: #d1ecf1;
        }
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .stat-card-small {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card-small .icon {
            font-size: 32px;
            margin-bottom: 10px;
        }
        .stat-card-small .number {
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-card-small .label {
            color: #7f8c8d;
            font-size: 13px;
        }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #999;
        }
        .empty-state i {
            font-size: 64px;
            margin-bottom: 20px;
            color: #ddd;
        }
        .filter-buttons {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
            flex-wrap: wrap;
        }
        .filter-btn {
            padding: 10px 20px;
            border: 2px solid #ddd;
            background: white;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }
        .filter-btn.active {
            background: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }
        .filter-btn:hover {
            border-color: #4A90E2;
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
                    <a href="${pageContext.request.contextPath}/docteur/consultations" class="nav-link">
                        <i class="fas fa-stethoscope"></i>
                        <span>Mes Consultations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/patients" class="nav-link active">
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
        <a href="${pageContext.request.contextPath}/docteur/patients" class="back-link">
            <i class="fas fa-arrow-left"></i> Retour aux patients
        </a>

        <%
            Patient patient = (Patient) request.getAttribute("patient");
            List<Consultation> historique = (List<Consultation>) request.getAttribute("historique");
            
            if (patient == null) {
        %>
            <div class="empty-state">
                <i class="fas fa-exclamation-circle"></i>
                <h3>Patient non trouvé</h3>
                <p>Ce patient n'existe pas ou vous n'avez pas accès à son dossier.</p>
            </div>
        <%
            } else {
                // Calculer les statistiques
                long totalConsultations = historique != null ? historique.size() : 0;
                long consultationsTerminees = 0;
                long consultationsValidees = 0;
                long consultationsAnnulees = 0;
                
                if (historique != null) {
                    for (Consultation c : historique) {
                        switch (c.getStatut()) {
                            case TERMINEE: consultationsTerminees++; break;
                            case VALIDEE: consultationsValidees++; break;
                            case ANNULEE: consultationsAnnulees++; break;
                        }
                    }
                }
                
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
        %>

        <!-- En-tête du patient -->
        <div class="patient-header-card">
            <div class="patient-header-content">
                <div class="patient-avatar-xl">
                    <%= patient.getNom().substring(0, 1) + patient.getPrenom().substring(0, 1) %>
                </div>
                <div class="patient-info">
                    <h2><%= patient.getNomComplet() %></h2>
                    <p><i class="fas fa-envelope"></i> <%= patient.getEmail() %></p>
                </div>
            </div>
            
            <div class="patient-details-grid">
                <% if (patient.getPoids() != null) { %>
                <div class="detail-item">
                    <div class="label"><i class="fas fa-weight"></i> Poids</div>
                    <div class="value"><%= patient.getPoids() %> kg</div>
                </div>
                <% } %>
                <% if (patient.getTaille() != null) { %>
                <div class="detail-item">
                    <div class="label"><i class="fas fa-ruler-vertical"></i> Taille</div>
                    <div class="value"><%= patient.getTaille() %> cm</div>
                </div>
                <% } %>
                <% if (patient.getIMC() != null) { %>
                <div class="detail-item">
                    <div class="label"><i class="fas fa-heartbeat"></i> IMC</div>
                    <div class="value"><%= String.format("%.1f", patient.getIMC()) %></div>
                </div>
                <% } %>
                <div class="detail-item">
                    <div class="label"><i class="fas fa-calendar-check"></i> Consultations</div>
                    <div class="value"><%= totalConsultations %></div>
                </div>
            </div>
        </div>

        <!-- Statistiques -->
        <div class="stats-row">
            <div class="stat-card-small">
                <div class="icon" style="color: #4A90E2;"><i class="fas fa-clipboard-list"></i></div>
                <div class="number" style="color: #4A90E2;"><%= totalConsultations %></div>
                <div class="label">Total Consultations</div>
            </div>
            <div class="stat-card-small">
                <div class="icon" style="color: #28a745;"><i class="fas fa-check-circle"></i></div>
                <div class="number" style="color: #28a745;"><%= consultationsTerminees %></div>
                <div class="label">Terminées</div>
            </div>
            <div class="stat-card-small">
                <div class="icon" style="color: #17a2b8;"><i class="fas fa-clock"></i></div>
                <div class="number" style="color: #17a2b8;"><%= consultationsValidees %></div>
                <div class="label">En cours</div>
            </div>
            <div class="stat-card-small">
                <div class="icon" style="color: #dc3545;"><i class="fas fa-times-circle"></i></div>
                <div class="number" style="color: #dc3545;"><%= consultationsAnnulees %></div>
                <div class="label">Annulées</div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="filter-buttons">
            <button class="filter-btn active" onclick="filterConsultations('all')">
                <i class="fas fa-list"></i> Toutes
            </button>
            <button class="filter-btn" onclick="filterConsultations('TERMINEE')">
                <i class="fas fa-check-double"></i> Terminées
            </button>
            <button class="filter-btn" onclick="filterConsultations('VALIDEE')">
                <i class="fas fa-check-circle"></i> Validées
            </button>
            <button class="filter-btn" onclick="filterConsultations('ANNULEE')">
                <i class="fas fa-times-circle"></i> Annulées
            </button>
        </div>

        <!-- Historique médical (Timeline) -->
        <h2 style="color: #2c3e50; margin-bottom: 20px;">
            <i class="fas fa-history"></i> Historique Médical
        </h2>

        <%
            if (historique == null || historique.isEmpty()) {
        %>
            <div class="empty-state">
                <i class="fas fa-file-medical"></i>
                <h3>Aucune consultation</h3>
                <p>Ce patient n'a pas encore de consultations dans son historique.</p>
            </div>
        <%
            } else {
                // Inverser l'ordre pour afficher les plus récentes en premier
                java.util.Collections.reverse(historique);
        %>
            <div class="timeline">
                <%
                    for (Consultation consultation : historique) {
                        String statusClass = "";
                        String statusIcon = "";
                        
                        switch (consultation.getStatut()) {
                            case TERMINEE:
                                statusClass = "status-terminee";
                                statusIcon = "fa-check-double";
                                break;
                            case VALIDEE:
                                statusClass = "status-validee";
                                statusIcon = "fa-check-circle";
                                break;
                            case ANNULEE:
                                statusClass = "status-annulee";
                                statusIcon = "fa-times-circle";
                                break;
                            case RESERVEE:
                                statusClass = "status-reservee";
                                statusIcon = "fa-clock";
                                break;
                        }
                %>
                    <div class="timeline-item" data-status="<%= consultation.getStatut() %>">
                        <div class="timeline-header">
                            <div class="timeline-date">
                                <i class="fas fa-calendar-alt"></i>
                                <%= consultation.getDateHeure().format(dateFormatter) %> à 
                                <%= consultation.getDateHeure().format(timeFormatter) %>
                            </div>
                            <span class="status-badge <%= statusClass %>">
                                <i class="fas <%= statusIcon %>"></i>
                                <%= consultation.getStatut().getLibelle() %>
                            </span>
                        </div>

                        <div class="timeline-body">
                            <% if (consultation.getMotif() != null && !consultation.getMotif().isEmpty()) { %>
                            <div class="section">
                                <div class="section-title">
                                    <i class="fas fa-notes-medical"></i> Motif de consultation
                                </div>
                                <div class="section-content motif">
                                    <%= consultation.getMotif() %>
                                </div>
                            </div>
                            <% } %>

                            <% if (consultation.getDiagnostic() != null && !consultation.getDiagnostic().isEmpty()) { %>
                            <div class="section">
                                <div class="section-title">
                                    <i class="fas fa-diagnoses"></i> Diagnostic
                                </div>
                                <div class="section-content diagnostic">
                                    <%= consultation.getDiagnostic() %>
                                </div>
                            </div>
                            <% } %>

                            <% if (consultation.getTraitement() != null && !consultation.getTraitement().isEmpty()) { %>
                            <div class="section">
                                <div class="section-title">
                                    <i class="fas fa-pills"></i> Traitement prescrit
                                </div>
                                <div class="section-content traitement">
                                    <%= consultation.getTraitement() %>
                                </div>
                            </div>
                            <% } %>

                            <% if (consultation.getCompteRendu() != null && !consultation.getCompteRendu().isEmpty()) { %>
                            <div class="section">
                                <div class="section-title">
                                    <i class="fas fa-file-medical-alt"></i> Compte-rendu
                                </div>
                                <div class="section-content">
                                    <%= consultation.getCompteRendu() %>
                                </div>
                            </div>
                            <% } %>

                            <% if (consultation.getSalle() != null) { %>
                            <div style="margin-top: 10px; color: #7f8c8d; font-size: 13px;">
                                <i class="fas fa-door-open"></i> Salle: <%= consultation.getSalle().getNomSalle() %>
                            </div>
                            <% } %>
                        </div>
                    </div>
                <%
                    }
                %>
            </div>
        <%
            }
        %>
        <% } %>
    </main>

    <script>
        function filterConsultations(status) {
            const items = document.querySelectorAll('.timeline-item');
            const buttons = document.querySelectorAll('.filter-btn');
            
            // Mettre à jour les boutons actifs
            buttons.forEach(btn => btn.classList.remove('active'));
            event.target.closest('.filter-btn').classList.add('active');
            
            // Filtrer les consultations
            items.forEach(item => {
                if (status === 'all' || item.getAttribute('data-status') === status) {
                    item.style.display = 'block';
                } else {
                    item.style.display = 'none';
                }
            });
        }
    </script>
</body>
</html>
