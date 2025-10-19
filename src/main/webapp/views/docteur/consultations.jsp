<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Consultation" %>
<%@ page import="com.clinic.clinicapp.enums.StatusConsultation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Consultations - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
    <style>
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.3s ease-out;
        }
        @keyframes slideDown {
            from { transform: translateY(-20px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }
        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .filters {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }
        .filter-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .filter-group label {
            font-weight: 500;
            color: #2c3e50;
        }
        .filter-select {
            padding: 10px 15px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            cursor: pointer;
            transition: border-color 0.3s;
        }
        .filter-select:focus {
            outline: none;
            border-color: #4A90E2;
        }
        .consultation-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .consultation-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .consultation-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        .patient-info {
            display: flex;
            align-items: center;
            gap: 15px;
        }
        .patient-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 18px;
        }
        .patient-details h4 {
            margin: 0 0 5px 0;
            color: #2c3e50;
        }
        .patient-details p {
            margin: 0;
            color: #7f8c8d;
            font-size: 14px;
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
        .consultation-body {
            margin-bottom: 15px;
        }
        .info-row {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
            color: #555;
        }
        .info-row i {
            width: 20px;
            color: #4A90E2;
        }
        .consultation-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn {
            padding: 10px 20px;
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
        .btn-primary:hover { background-color: #357ABD; transform: translateY(-1px); }
        .btn-success { background-color: #28a745; color: white; }
        .btn-success:hover { background-color: #218838; }
        .btn-warning { background-color: #ffc107; color: #333; }
        .btn-warning:hover { background-color: #e0a800; }
        .btn-danger { background-color: #dc3545; color: white; }
        .btn-danger:hover { background-color: #c82333; }
        .btn-secondary { background-color: #6c757d; color: white; }
        .btn-secondary:hover { background-color: #5a6268; }
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
        }
        .modal-content {
            background-color: #fff;
            margin: 5% auto;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 600px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.2);
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f0f0f0;
        }
        .modal-header h3 {
            margin: 0;
            color: #2c3e50;
        }
        .close {
            font-size: 28px;
            font-weight: bold;
            color: #999;
            cursor: pointer;
            transition: color 0.3s;
        }
        .close:hover { color: #333; }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
        }
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
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
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
            margin-bottom: 30px;
        }
        .stat-card-mini {
            background: white;
            padding: 20px;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            text-align: center;
        }
        .stat-card-mini .number {
            font-size: 32px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .stat-card-mini .label {
            color: #7f8c8d;
            font-size: 14px;
        }
        .stat-reservee { border-left: 4px solid #ffc107; }
        .stat-validee { border-left: 4px solid #17a2b8; }
        .stat-terminee { border-left: 4px solid #28a745; }
        .stat-annulee { border-left: 4px solid #dc3545; }
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
        <header class="header">
            <div class="header-title">
                <h1>Mes Consultations</h1>
                <p><i class="fas fa-stethoscope"></i> Gérez l'état de vos consultations</p>
            </div>
        </header>

        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            String message = request.getParameter("message");
            
            if (success != null) {
                String msg = "";
                switch(success) {
                    case "status_updated":
                        msg = "Le statut de la consultation a été mis à jour avec succès !";
                        break;
                    case "consultation_completed":
                        msg = "La consultation a été réalisée et marquée comme terminée !";
                        break;
                    case "consultation_terminated":
                        msg = "La consultation a été terminée avec succès !";
                        break;
                }
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span><%= msg %></span>
            </div>
        <%
            }
            
            if (error != null) {
                String msg = message != null ? message : "";
                if (msg.isEmpty()) {
                    switch(error) {
                        case "missing_id":
                            msg = "ID de consultation manquant.";
                            break;
                        case "missing_status":
                            msg = "Statut manquant.";
                            break;
                        case "missing_fields":
                            msg = "Tous les champs sont obligatoires pour réaliser une consultation.";
                            break;
                        case "invalid_action":
                            msg = "Action invalide.";
                            break;
                        case "invalid_state":
                            msg = "Impossible de modifier cette consultation.";
                            break;
                        case "invalid_data":
                            msg = "Données invalides.";
                            break;
                        case "not_found":
                            msg = "Consultation non trouvée.";
                            break;
                        default:
                            msg = "Une erreur est survenue.";
                    }
                }
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= msg %></span>
            </div>
        <%
            }
            
            List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
            StatusConsultation selectedStatut = (StatusConsultation) request.getAttribute("selectedStatut");
            
            // Calculer les statistiques
            long countReservee = 0;
            long countValidee = 0;
            long countTerminee = 0;
            long countAnnulee = 0;
            
            if (consultations != null) {
                for (Consultation c : consultations) {
                    switch (c.getStatut()) {
                        case RESERVEE: countReservee++; break;
                        case VALIDEE: countValidee++; break;
                        case TERMINEE: countTerminee++; break;
                        case ANNULEE: countAnnulee++; break;
                    }
                }
            }
        %>

        <!-- Statistiques -->
        <div class="stats-row">
            <div class="stat-card-mini stat-reservee">
                <div class="number" style="color: #ffc107;"><%= countReservee %></div>
                <div class="label">Réservées</div>
            </div>
            <div class="stat-card-mini stat-validee">
                <div class="number" style="color: #17a2b8;"><%= countValidee %></div>
                <div class="label">Validées</div>
            </div>
            <div class="stat-card-mini stat-terminee">
                <div class="number" style="color: #28a745;"><%= countTerminee %></div>
                <div class="label">Terminées</div>
            </div>
            <div class="stat-card-mini stat-annulee">
                <div class="number" style="color: #dc3545;"><%= countAnnulee %></div>
                <div class="label">Annulées</div>
            </div>
        </div>

        <!-- Filtres -->
        <div class="filters">
            <div class="filter-group">
                <label for="statutFilter"><i class="fas fa-filter"></i> Filtrer par statut :</label>
                <select id="statutFilter" class="filter-select" onchange="filterByStatus(this.value)">
                    <option value="">Tous les statuts</option>
                    <option value="RESERVEE" <%= selectedStatut == StatusConsultation.RESERVEE ? "selected" : "" %>>Réservée</option>
                    <option value="VALIDEE" <%= selectedStatut == StatusConsultation.VALIDEE ? "selected" : "" %>>Validée</option>
                    <option value="TERMINEE" <%= selectedStatut == StatusConsultation.TERMINEE ? "selected" : "" %>>Terminée</option>
                    <option value="ANNULEE" <%= selectedStatut == StatusConsultation.ANNULEE ? "selected" : "" %>>Annulée</option>
                </select>
            </div>
        </div>

        <!-- Liste des consultations -->
        <% 
            if (consultations == null || consultations.isEmpty()) {
        %>
            <div class="empty-state">
                <i class="fas fa-stethoscope"></i>
                <h3>Aucune consultation</h3>
                <p>Vous n'avez pas encore de consultations.</p>
            </div>
        <% 
            } else {
                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                
                for (Consultation consultation : consultations) {
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
            <div class="consultation-card">
                <div class="consultation-header">
                    <div class="patient-info">
                        <div class="patient-avatar">
                            <%= consultation.getPatient().getNom().substring(0, 1) + consultation.getPatient().getPrenom().substring(0, 1) %>
                        </div>
                        <div class="patient-details">
                            <h4><%= consultation.getPatient().getNomComplet() %></h4>
                            <p><i class="fas fa-envelope"></i> <%= consultation.getPatient().getEmail() %></p>
                        </div>
                    </div>
                    <span class="status-badge <%= statusClass %>">
                        <i class="fas <%= statusIcon %>"></i>
                        <%= consultation.getStatut().getLibelle() %>
                    </span>
                </div>
                
                <div class="consultation-body">
                    <div class="info-row">
                        <i class="fas fa-calendar"></i>
                        <span><strong>Date:</strong> <%= consultation.getDateHeure().format(dateFormatter) %></span>
                    </div>
                    <div class="info-row">
                        <i class="fas fa-clock"></i>
                        <span><strong>Heure:</strong> <%= consultation.getDateHeure().format(timeFormatter) %></span>
                    </div>
                    <% if (consultation.getMotif() != null) { %>
                    <div class="info-row">
                        <i class="fas fa-notes-medical"></i>
                        <span><strong>Motif:</strong> <%= consultation.getMotif() %></span>
                    </div>
                    <% } %>
                    <% if (consultation.getSalle() != null) { %>
                    <div class="info-row">
                        <i class="fas fa-door-open"></i>
                        <span><strong>Salle:</strong> <%= consultation.getSalle().getNomSalle() %></span>
                    </div>
                    <% } %>
                    <% if (consultation.getDiagnostic() != null && !consultation.getDiagnostic().isEmpty()) { %>
                    <div class="info-row">
                        <i class="fas fa-diagnoses"></i>
                        <span><strong>Diagnostic:</strong> <%= consultation.getDiagnostic() %></span>
                    </div>
                    <% } %>
                    <% if (consultation.getTraitement() != null && !consultation.getTraitement().isEmpty()) { %>
                    <div class="info-row">
                        <i class="fas fa-pills"></i>
                        <span><strong>Traitement:</strong> <%= consultation.getTraitement() %></span>
                    </div>
                    <% } %>
                </div>
                
                <div class="consultation-actions">
                    <% 
                        // Actions selon le statut
                        if (consultation.getStatut() == StatusConsultation.RESERVEE) {
                    %>
                        <button class="btn btn-success" onclick="changeStatus(<%= consultation.getId() %>, 'VALIDEE')">
                            <i class="fas fa-check"></i> Valider
                        </button>
                        <button class="btn btn-danger" onclick="changeStatus(<%= consultation.getId() %>, 'ANNULEE')">
                            <i class="fas fa-times"></i> Annuler
                        </button>
                    <% 
                        } else if (consultation.getStatut() == StatusConsultation.VALIDEE) {
                    %>
                        <button class="btn btn-primary" onclick="openRealiserModal(<%= consultation.getId() %>)">
                            <i class="fas fa-file-medical"></i> Réaliser la consultation
                        </button>
                        <button class="btn btn-danger" onclick="changeStatus(<%= consultation.getId() %>, 'ANNULEE')">
                            <i class="fas fa-times"></i> Annuler
                        </button>
                    <% 
                        } else if (consultation.getStatut() == StatusConsultation.ANNULEE) {
                    %>
                        <button class="btn btn-warning" onclick="changeStatus(<%= consultation.getId() %>, 'RESERVEE')">
                            <i class="fas fa-undo"></i> Réactiver
                        </button>
                    <% 
                        }
                    %>
                    <a href="${pageContext.request.contextPath}/docteur/consultations?action=edit&id=<%= consultation.getId() %>" class="btn btn-secondary">
                        <i class="fas fa-eye"></i> Détails
                    </a>
                </div>
            </div>
        <% 
                }
            }
        %>
    </main>

    <!-- Modal pour réaliser une consultation -->
    <div id="realiserModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-file-medical"></i> Réaliser la Consultation</h3>
                <span class="close" onclick="closeRealiserModal()">&times;</span>
            </div>
            <form id="realiserForm" method="post" action="${pageContext.request.contextPath}/docteur/consultations">
                <input type="hidden" name="action" value="realiser">
                <input type="hidden" id="realiserConsultationId" name="consultationId">
                
                <div class="form-group">
                    <label for="compteRendu">Compte-rendu <span style="color: red;">*</span></label>
                    <textarea id="compteRendu" name="compteRendu" required 
                              placeholder="Décrivez le déroulement de la consultation..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="diagnostic">Diagnostic <span style="color: red;">*</span></label>
                    <textarea id="diagnostic" name="diagnostic" required 
                              placeholder="Indiquez le diagnostic médical..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="traitement">Traitement <span style="color: red;">*</span></label>
                    <textarea id="traitement" name="traitement" required 
                              placeholder="Prescrivez le traitement..."></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" onclick="closeRealiserModal()">Annuler</button>
                    <button type="submit" class="btn btn-success">
                        <i class="fas fa-check"></i> Terminer la consultation
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function filterByStatus(statut) {
            if (statut) {
                window.location.href = '${pageContext.request.contextPath}/docteur/consultations?statut=' + statut;
            } else {
                window.location.href = '${pageContext.request.contextPath}/docteur/consultations';
            }
        }

        function changeStatus(consultationId, nouveauStatut) {
            if (confirm('Êtes-vous sûr de vouloir changer le statut de cette consultation ?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/docteur/consultations';
                
                const actionInput = document.createElement('input');
                actionInput.type = 'hidden';
                actionInput.name = 'action';
                actionInput.value = 'updateStatus';
                
                const idInput = document.createElement('input');
                idInput.type = 'hidden';
                idInput.name = 'consultationId';
                idInput.value = consultationId;
                
                const statutInput = document.createElement('input');
                statutInput.type = 'hidden';
                statutInput.name = 'nouveauStatut';
                statutInput.value = nouveauStatut;
                
                form.appendChild(actionInput);
                form.appendChild(idInput);
                form.appendChild(statutInput);
                
                document.body.appendChild(form);
                form.submit();
            }
        }

        function openRealiserModal(consultationId) {
            document.getElementById('realiserConsultationId').value = consultationId;
            document.getElementById('realiserModal').style.display = 'block';
        }

        function closeRealiserModal() {
            document.getElementById('realiserModal').style.display = 'none';
            document.getElementById('realiserForm').reset();
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('realiserModal');
            if (event.target == modal) {
                closeRealiserModal();
            }
        }

        // Auto-hide alerts after 5 seconds
        window.addEventListener('DOMContentLoaded', () => {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>
