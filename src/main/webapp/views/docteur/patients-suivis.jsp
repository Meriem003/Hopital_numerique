<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Patient" %>
<%@ page import="com.clinic.clinicapp.entity.Consultation" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patients Suivis - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/patients.css">
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
        <!-- Header Section -->
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1><i class="fas fa-users"></i> Patients Suivis</h1>
                <p>Consultez l'historique médical de vos patients</p>
                </div>
                <a href="${pageContext.request.contextPath}/patient/consultations" class="btn-header">
                    <i class="fas fa-calendar-plus"></i>
                    consultations
                </a>
            </div>
        </div>
        <!-- Alerts -->
        <%
            String error = request.getParameter("error");
            
            if (error != null) {
                String msg = "";
                switch(error) {
                    case "patient_not_found":
                        msg = "Patient non trouvé.";
                        break;
                    default:
                        msg = "Une erreur est survenue.";
                }
        %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span><%= msg %></span>
            </div>
        <%
            }
            
            List<Patient> patientsSuivis = (List<Patient>) request.getAttribute("patientsSuivis");
            
            // Calculer les statistiques
            int totalPatients = patientsSuivis != null ? patientsSuivis.size() : 0;
            int totalConsultations = 0;
            
            if (patientsSuivis != null) {
                for (Patient p : patientsSuivis) {
                    totalConsultations += p.getConsultations() != null ? p.getConsultations().size() : 0;
                }
            }
        %>

        <!-- Liste des patients -->
        <% 
            if (patientsSuivis == null || patientsSuivis.isEmpty()) {
        %>
            <div class="empty-state">
                <i class="fas fa-user-injured"></i>
                <h3>Aucun patient suivi</h3>
                <p>Vous n'avez pas encore de patients en suivi.</p>
            </div>
        <% 
            } else {
        %>
            <div class="patients-grid" id="patientsGrid">
                <% 
                    DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                    
                    for (Patient patient : patientsSuivis) {
                        List<Consultation> consultations = patient.getConsultations();
                        int nbConsultations = consultations != null ? consultations.size() : 0;
                        
                        // Dernière consultation
                        Consultation derniere = null;
                        if (consultations != null && !consultations.isEmpty()) {
                            derniere = consultations.get(consultations.size() - 1);
                        }
                        
                        // Calculer le nombre de consultations terminées
                        long consultationsTerminees = 0;
                        if (consultations != null) {
                            consultationsTerminees = consultations.stream()
                                .filter(c -> c.getStatut() == com.clinic.clinicapp.enums.StatusConsultation.TERMINEE)
                                .count();
                        }
                %>
                    <div class="patient-card" 
                         data-patient-name="<%= patient.getNomComplet().toLowerCase() %>" 
                         data-patient-email="<%= patient.getEmail().toLowerCase() %>">
                        
                        <div class="patient-header">
                            <div class="patient-avatar-large">
                                <%= patient.getNom().substring(0, 1) + patient.getPrenom().substring(0, 1) %>
                            </div>
                            <div class="patient-details">
                                <h3><%= patient.getNomComplet() %></h3>
                                <p><i class="fas fa-envelope"></i> <%= patient.getEmail() %></p>
                            </div>
                        </div>

                        <div class="patient-stats">
                            <div class="stat-item">
                                <div class="stat-value"><%= nbConsultations %></div>
                                <div class="stat-label">Consultations</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" style="color: #10b981;"><%= consultationsTerminees %></div>
                                <div class="stat-label">Terminées</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" style="color: #f59e0b;"><%= nbConsultations - consultationsTerminees %></div>
                                <div class="stat-label">En cours</div>
                            </div>
                        </div>

                        <div>
                            <% if (patient.getPoids() != null || patient.getTaille() != null) { %>
                                <div class="patient-info-row">
                                    <span class="info-label">
                                        <i class="fas fa-weight"></i> Informations
                                    </span>
                                    <span class="info-value">
                                        <% if (patient.getPoids() != null) { %>
                                            <%= patient.getPoids() %> kg
                                        <% } %>
                                        <% if (patient.getTaille() != null) { %>
                                            <%= patient.getPoids() != null ? " / " : "" %><%= patient.getTaille() %> cm
                                        <% } %>
                                    </span>
                                </div>
                            <% } %>
                            <% if (derniere != null) { %>
                                <div class="patient-info-row">
                                    <span class="info-label">
                                        <i class="fas fa-calendar"></i> Dernière consultation
                                    </span>
                                    <span class="info-value">
                                        <%= derniere.getDateHeure().format(dateFormatter) %>
                                    </span>
                                </div>
                            <% } %>
                        </div>

                        <div class="patient-actions">
                            <a href="${pageContext.request.contextPath}/docteur/patients?action=historique&patientId=<%= patient.getId() %>" 
                               class="btn btn-primary">
                                <i class="fas fa-history"></i> Historique médical
                            </a>
                        </div>
                    </div>
                <% 
                    }
                %>
            </div>
        <% 
            }
        %>
    </main>

    <script>
        // Recherche en temps réel
        document.getElementById('searchInput').addEventListener('input', function(e) {
            const searchTerm = e.target.value.toLowerCase();
            const patientCards = document.querySelectorAll('.patient-card');
            
            let visibleCount = 0;
            
            patientCards.forEach(card => {
                const patientName = card.getAttribute('data-patient-name');
                const patientEmail = card.getAttribute('data-patient-email');
                
                if (patientName.includes(searchTerm) || patientEmail.includes(searchTerm)) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
        });

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