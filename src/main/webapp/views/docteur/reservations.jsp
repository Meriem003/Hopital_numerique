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
    <title>Réservations - Clinique Excellence</title>
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
            margin: 10% auto;
            padding: 30px;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
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
        .close:hover {
            color: #333;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            color: #333;
            font-weight: 500;
        }
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            resize: vertical;
            min-height: 100px;
            font-family: inherit;
        }
        .form-group textarea:focus {
            outline: none;
            border-color: #4A90E2;
        }
        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 10px;
            margin-top: 20px;
        }
        .btn-modal {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.3s;
        }
        .btn-cancel {
            background-color: #e0e0e0;
            color: #333;
        }
        .btn-cancel:hover {
            background-color: #d0d0d0;
        }
        .btn-submit {
            background-color: #dc3545;
            color: white;
        }
        .btn-submit:hover {
            background-color: #c82333;
        }
        .reservation-card {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .reservation-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .reservation-header {
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
            font-size: 18px;
        }
        .patient-details p {
            margin: 0;
            color: #7f8c8d;
            font-size: 14px;
        }
        .reservation-body {
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
        .reservation-actions {
            display: flex;
            gap: 10px;
        }
        .btn {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s;
        }
        .btn-success {
            background-color: #28a745;
            color: white;
        }
        .btn-success:hover {
            background-color: #218838;
        }
        .btn-danger {
            background-color: #dc3545;
            color: white;
        }
        .btn-danger:hover {
            background-color: #c82333;
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
        .empty-state h3 {
            color: #666;
            margin-bottom: 10px;
        }
        .section-title {
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-title i {
            color: #4A90E2;
        }
        .tabs {
            display: flex;
            gap: 10px;
            margin-bottom: 30px;
            border-bottom: 2px solid #f0f0f0;
        }
        .tab {
            padding: 12px 24px;
            cursor: pointer;
            border: none;
            background: none;
            color: #7f8c8d;
            font-size: 16px;
            font-weight: 500;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }
        .tab.active {
            color: #4A90E2;
            border-bottom-color: #4A90E2;
        }
        .tab:hover {
            color: #4A90E2;
        }
        .tab-content {
            display: none;
        }
        .tab-content.active {
            display: block;
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
                    <a href="${pageContext.request.contextPath}/docteur/reservations" class="nav-link active">
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

    <main class="main-content">
        <header class="header">
            <div class="header-title">
                <h1>Gestion des Réservations</h1>
                <p><i class="fas fa-calendar-check"></i> Gérez les demandes de rendez-vous de vos patients</p>
            </div>
        </header>

        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            
            if (success != null) {
                String message = "";
                switch(success) {
                    case "validated":
                        message = "La réservation a été validée avec succès !";
                        break;
                    case "refused":
                        message = "La réservation a été refusée.";
                        break;
                }
        %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span><%= message %></span>
            </div>
        <%
            }
            
            if (error != null) {
                String message = "";
                switch(error) {
                    case "missing_id":
                        message = "ID de consultation manquant.";
                        break;
                    case "missing_motif":
                        message = "Motif de refus obligatoire.";
                        break;
                    case "invalid_action":
                        message = "Action invalide.";
                        break;
                    case "invalid_state":
                        message = "Impossible de modifier cette consultation.";
                        break;
                    case "server_error":
                        message = "Une erreur est survenue. Veuillez réessayer.";
                        break;
                    default:
                        message = "Une erreur est survenue.";
                }
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= message %></span>
            </div>
        <%
            }
        %>

        <div class="tabs">
            <button class="tab active" onclick="switchTab('enAttente')">
                <i class="fas fa-clock"></i> En Attente
                <% 
                    List<Consultation> reservationsEnAttente = (List<Consultation>) request.getAttribute("reservationsEnAttente");
                    if (reservationsEnAttente != null && !reservationsEnAttente.isEmpty()) {
                %>
                    <span class="badge" style="background: #ff6b6b; color: white; padding: 2px 8px; border-radius: 12px; margin-left: 5px; font-size: 12px;">
                        <%= reservationsEnAttente.size() %>
                    </span>
                <% } %>
            </button>
            <button class="tab" onclick="switchTab('validees')">
                <i class="fas fa-check-circle"></i> Validées
                <% 
                    List<Consultation> consultationsValidees = (List<Consultation>) request.getAttribute("consultationsValidees");
                    if (consultationsValidees != null && !consultationsValidees.isEmpty()) {
                %>
                    <span class="badge" style="background: #51cf66; color: white; padding: 2px 8px; border-radius: 12px; margin-left: 5px; font-size: 12px;">
                        <%= consultationsValidees.size() %>
                    </span>
                <% } %>
            </button>
        </div>

        <!-- Réservations en attente -->
        <div id="enAttente" class="tab-content active">
            <h2 class="section-title">
                <i class="fas fa-clock"></i>
                Réservations en Attente de Validation
            </h2>

            <% 
                if (reservationsEnAttente == null || reservationsEnAttente.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="fas fa-calendar-check"></i>
                    <h3>Aucune réservation en attente</h3>
                    <p>Toutes vos demandes de rendez-vous ont été traitées.</p>
                </div>
            <% 
                } else {
                    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
                    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                    
                    for (Consultation consultation : reservationsEnAttente) {
            %>
                <div class="reservation-card">
                    <div class="reservation-header">
                        <div class="patient-info">
                            <div class="patient-avatar">
                                <%= consultation.getPatient().getNom().substring(0, 1) + consultation.getPatient().getPrenom().substring(0, 1) %>
                            </div>
                            <div class="patient-details">
                                <h4><%= consultation.getPatient().getNomComplet() %></h4>
                                <p><i class="fas fa-envelope"></i> <%= consultation.getPatient().getEmail() %></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="reservation-body">
                        <div class="info-row">
                            <i class="fas fa-calendar"></i>
                            <span><strong>Date:</strong> <%= consultation.getDateHeure().format(dateFormatter) %></span>
                        </div>
                        <div class="info-row">
                            <i class="fas fa-clock"></i>
                            <span><strong>Heure:</strong> <%= consultation.getDateHeure().format(timeFormatter) %></span>
                        </div>
                        <div class="info-row">
                            <i class="fas fa-notes-medical"></i>
                            <span><strong>Motif:</strong> <%= consultation.getMotif() != null ? consultation.getMotif() : "Non spécifié" %></span>
                        </div>
                        <% if (consultation.getSalle() != null) { %>
                        <div class="info-row">
                            <i class="fas fa-door-open"></i>
                            <span><strong>Salle:</strong> <%= consultation.getSalle().getNomSalle() %></span>
                        </div>
                        <% } %>
                    </div>
                    
                    <div class="reservation-actions">
                        <form method="post" action="${pageContext.request.contextPath}/docteur/reservations" style="display: inline;">
                            <input type="hidden" name="action" value="valider">
                            <input type="hidden" name="consultationId" value="<%= consultation.getId() %>">
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check"></i> Valider
                            </button>
                        </form>
                        <button type="button" class="btn btn-danger" onclick="openRefuseModal(<%= consultation.getId() %>)">
                            <i class="fas fa-times"></i> Refuser
                        </button>
                    </div>
                </div>
            <% 
                    }
                }
            %>
        </div>

        <!-- Consultations validées -->
        <div id="validees" class="tab-content">
            <h2 class="section-title">
                <i class="fas fa-check-circle"></i>
                Consultations Validées
            </h2>

            <% 
                if (consultationsValidees == null || consultationsValidees.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="fas fa-check-circle"></i>
                    <h3>Aucune consultation validée</h3>
                    <p>Les consultations validées apparaîtront ici.</p>
                </div>
            <% 
                } else {
                    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMMM yyyy");
                    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                    
                    for (Consultation consultation : consultationsValidees) {
            %>
                <div class="reservation-card">
                    <div class="reservation-header">
                        <div class="patient-info">
                            <div class="patient-avatar" style="background: linear-gradient(135deg, #51cf66 0%, #37b24d 100%);">
                                <%= consultation.getPatient().getNom().substring(0, 1) + consultation.getPatient().getPrenom().substring(0, 1) %>
                            </div>
                            <div class="patient-details">
                                <h4><%= consultation.getPatient().getNomComplet() %></h4>
                                <p><i class="fas fa-envelope"></i> <%= consultation.getPatient().getEmail() %></p>
                            </div>
                        </div>
                        <span class="badge" style="background: #51cf66; color: white; padding: 8px 16px; border-radius: 20px;">
                            <i class="fas fa-check-circle"></i> Validée
                        </span>
                    </div>
                    
                    <div class="reservation-body">
                        <div class="info-row">
                            <i class="fas fa-calendar"></i>
                            <span><strong>Date:</strong> <%= consultation.getDateHeure().format(dateFormatter) %></span>
                        </div>
                        <div class="info-row">
                            <i class="fas fa-clock"></i>
                            <span><strong>Heure:</strong> <%= consultation.getDateHeure().format(timeFormatter) %></span>
                        </div>
                        <div class="info-row">
                            <i class="fas fa-notes-medical"></i>
                            <span><strong>Motif:</strong> <%= consultation.getMotif() != null ? consultation.getMotif() : "Non spécifié" %></span>
                        </div>
                        <% if (consultation.getSalle() != null) { %>
                        <div class="info-row">
                            <i class="fas fa-door-open"></i>
                            <span><strong>Salle:</strong> <%= consultation.getSalle().getNomSalle() %></span>
                        </div>
                        <% } %>
                    </div>
                </div>
            <% 
                    }
                }
            %>
        </div>
    </main>

    <!-- Modal de refus -->
    <div id="refuseModal" class="modal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-times-circle"></i> Refuser la réservation</h3>
                <span class="close" onclick="closeRefuseModal()">&times;</span>
            </div>
            <form id="refuseForm" method="post" action="${pageContext.request.contextPath}/docteur/reservations">
                <input type="hidden" name="action" value="refuser">
                <input type="hidden" id="refuseConsultationId" name="consultationId">
                <div class="form-group">
                    <label for="motifRefus">Motif du refus <span style="color: red;">*</span></label>
                    <textarea id="motifRefus" name="motifRefus" required 
                              placeholder="Veuillez indiquer la raison du refus de cette réservation..."></textarea>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn-modal btn-cancel" onclick="closeRefuseModal()">Annuler</button>
                    <button type="submit" class="btn-modal btn-submit">Confirmer le refus</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function switchTab(tabName) {
            // Hide all tab contents
            const contents = document.querySelectorAll('.tab-content');
            contents.forEach(content => content.classList.remove('active'));
            
            // Deactivate all tabs
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Show selected tab content
            document.getElementById(tabName).classList.add('active');
            
            // Activate clicked tab
            event.target.closest('.tab').classList.add('active');
        }

        function openRefuseModal(consultationId) {
            document.getElementById('refuseConsultationId').value = consultationId;
            document.getElementById('refuseModal').style.display = 'block';
        }

        function closeRefuseModal() {
            document.getElementById('refuseModal').style.display = 'none';
            document.getElementById('motifRefus').value = '';
        }

        // Close modal when clicking outside
        window.onclick = function(event) {
            const modal = document.getElementById('refuseModal');
            if (event.target == modal) {
                closeRefuseModal();
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
