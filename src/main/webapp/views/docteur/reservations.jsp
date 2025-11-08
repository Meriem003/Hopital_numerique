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
   <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/reservations.css">
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
                <!-- Header Section -->
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1>
                        <i class="fas fa-calendar-check"></i>
                        Gestion des Réservations
                    </h1>
                    <p>Gérez les demandes de rendez-vous de vos patients</p>
                </div>
                <a href="${pageContext.request.contextPath}/docteur/consultations" class="btn-header">
                    <i class="fas fa-calendar-plus"></i>
                    consultations
                </a>
            </div>
        </div>
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