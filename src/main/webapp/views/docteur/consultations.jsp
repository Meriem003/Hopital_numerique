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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/mesConsultations.css">
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
        <!-- Header -->
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1><i class="fas fa-stethoscope"></i> Mes Consultations</h1>
                    <p>Gérez et suivez vos consultations</p>
                </div>
            </div>
        </div>

        <!-- Alerts -->
        <%
            String success = request.getParameter("success");
            String error = request.getParameter("error");
            String message = request.getParameter("message");
            
            if (success != null) {
                String msg = "";
                switch(success) {
                    case "status_updated":
                        msg = "Le statut a été mis à jour avec succès !";
                        break;
                    case "consultation_completed":
                        msg = "La consultation a été réalisée !";
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
                String msg = message != null ? message : "Une erreur est survenue.";
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= msg %></span>
            </div>
        <%
            }
        %>

        <!-- Stats -->
        <%
            List<Consultation> consultations = (List<Consultation>) request.getAttribute("consultations");
            long countReservee = 0, countValidee = 0, countTerminee = 0, countAnnulee = 0;
            
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
        <div class="stats-grid">
            <div class="stat-card stat-reserved">
                <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
                <div class="stat-content">
                    <div class="stat-value"><%= countReservee %></div>
                    <div class="stat-label">Réservées</div>
                </div>
            </div>
            <div class="stat-card stat-confirmed">
                <div class="stat-icon"><i class="fas fa-check-circle"></i></div>
                <div class="stat-content">
                    <div class="stat-value"><%= countValidee %></div>
                    <div class="stat-label">Validées</div>
                </div>
            </div>
            <div class="stat-card stat-completed">
                <div class="stat-icon"><i class="fas fa-check-double"></i></div>
                <div class="stat-content">
                    <div class="stat-value"><%= countTerminee %></div>
                    <div class="stat-label">Terminées</div>
                </div>
            </div>
            <div class="stat-card stat-cancelled">
                <div class="stat-icon"><i class="fas fa-times-circle"></i></div>
                <div class="stat-content">
                    <div class="stat-value"><%= countAnnulee %></div>
                    <div class="stat-label">Annulées</div>
                </div>
            </div>
        </div>
        <!-- Consultations List -->
        <div class="consultations-list">
            <% 
                if (consultations == null || consultations.isEmpty()) {
            %>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    <h3>Aucune consultation</h3>
                    <p>Vous n'avez pas encore de consultations.</p>
                </div>
            <% 
                } else {
                    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd MMM yyyy");
                    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                    
                    for (Consultation consultation : consultations) {
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
                <div class="consultation-item <%= statusClass %>">
                    <div class="consultation-left">
                        <div class="patient-avatar">
                            <%= consultation.getPatient().getNom().substring(0, 1).toUpperCase() %>
                        </div>
                        <div class="consultation-info">
                            <h4><%= consultation.getPatient().getNomComplet() %></h4>
                            <p class="consultation-date">
                                <i class="fas fa-calendar"></i>
                                <%= consultation.getDateHeure().format(dateFormatter) %> à 
                                <%= consultation.getDateHeure().format(timeFormatter) %>
                            </p>
                            <% if (consultation.getMotif() != null) { %>
                            <p class="consultation-motif">
                                <i class="fas fa-notes-medical"></i>
                                <%= consultation.getMotif() %>
                            </p>
                            <% } %>
                        </div>
                    </div>
                    <div class="consultation-right">
                        <span class="status-badge <%= statusClass %>">
                            <i class="fas <%= statusIcon %>"></i>
                            <%= statusLabel %>
                        </span>
                        <div class="consultation-actions">
                            <% 
                                if (consultation.getStatut() == StatusConsultation.RESERVEE) {
                            %>
                                <button class="btn-action btn-validate" onclick="changeStatus(<%= consultation.getId() %>, 'VALIDEE')" title="Valider">
                                    <i class="fas fa-check"></i>
                                </button>
                                <button class="btn-action btn-cancel" onclick="changeStatus(<%= consultation.getId() %>, 'ANNULEE')" title="Annuler">
                                    <i class="fas fa-times"></i>
                                </button>
                            <% 
                                } else if (consultation.getStatut() == StatusConsultation.VALIDEE) {
                            %>
                                <button class="btn-action btn-realize" onclick="openRealiserModal(<%= consultation.getId() %>)" title="Réaliser">
                                    <i class="fas fa-file-medical"></i>
                                </button>
                            <% 
                                }
                            %>
                            <a href="${pageContext.request.contextPath}/docteur/consultations?action=edit&id=<%= consultation.getId() %>" class="btn-action btn-view" title="Détails">
                                <i class="fas fa-eye"></i>
                            </a>
                        </div>
                    </div>
                </div>
            <% 
                    }
                }
            %>
        </div>
    </main>

    <!-- Modal Réaliser Consultation -->
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
                    <label for="compteRendu">Compte-rendu <span class="required">*</span></label>
                    <textarea id="compteRendu" name="compteRendu" required placeholder="Décrivez le déroulement..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="diagnostic">Diagnostic <span class="required">*</span></label>
                    <textarea id="diagnostic" name="diagnostic" required placeholder="Indiquez le diagnostic..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="traitement">Traitement <span class="required">*</span></label>
                    <textarea id="traitement" name="traitement" required placeholder="Prescrivez le traitement..."></textarea>
                </div>
                
                <div class="modal-footer">
                    <button type="button" class="btn-modal btn-cancel" onclick="closeRealiserModal()">Annuler</button>
                    <button type="submit" class="btn-modal btn-success">
                        <i class="fas fa-check"></i> Terminer
                    </button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function filterByStatus(statut) {
            window.location.href = statut 
                ? '${pageContext.request.contextPath}/docteur/consultations?statut=' + statut
                : '${pageContext.request.contextPath}/docteur/consultations';
        }

        function changeStatus(consultationId, nouveauStatut) {
            if (confirm('Êtes-vous sûr ?')) {
                const form = document.createElement('form');
                form.method = 'POST';
                form.action = '${pageContext.request.contextPath}/docteur/consultations';
                
                form.innerHTML = `
                    <input type="hidden" name="action" value="updateStatus">
                    <input type="hidden" name="consultationId" value="${consultationId}">
                    <input type="hidden" name="nouveauStatut" value="${nouveauStatut}">
                `;
                
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

        window.onclick = function(event) {
            const modal = document.getElementById('realiserModal');
            if (event.target == modal) closeRealiserModal();
        }

        // Auto-hide alerts
        document.addEventListener('DOMContentLoaded', () => {
            document.querySelectorAll('.alert').forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 300);
                }, 5000);
            });
        });
    </script>
</body>
</html>
