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
    <style>
        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .alert-error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .search-bar {
            background: white;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .search-input {
            width: 100%;
            padding: 12px 15px 12px 45px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
        }
        .search-input:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }
        .search-wrapper {
            position: relative;
        }
        .search-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }
        .patients-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 20px;
            margin-bottom: 20px;
        }
        .patient-card {
            background: white;
            border-radius: 12px;
            padding: 25px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
            position: relative;
            overflow: hidden;
        }
        .patient-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
        }
        .patient-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 4px;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .patient-header {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 20px;
        }
        .patient-avatar-large {
            width: 70px;
            height: 70px;
            border-radius: 50%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-weight: bold;
            font-size: 24px;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        .patient-details {
            flex: 1;
        }
        .patient-details h3 {
            margin: 0 0 8px 0;
            color: #2c3e50;
            font-size: 20px;
        }
        .patient-details p {
            margin: 0;
            color: #7f8c8d;
            font-size: 14px;
            display: flex;
            align-items: center;
            gap: 5px;
        }
        .patient-info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 10px 0;
            border-bottom: 1px solid #f0f0f0;
        }
        .patient-info-row:last-child {
            border-bottom: none;
        }
        .info-label {
            color: #7f8c8d;
            font-size: 13px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .info-value {
            color: #2c3e50;
            font-weight: 600;
            font-size: 14px;
        }
        .patient-stats {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 10px;
            margin: 15px 0;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        .stat-item {
            text-align: center;
        }
        .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #4A90E2;
        }
        .stat-label {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        .patient-actions {
            display: flex;
            gap: 10px;
            margin-top: 15px;
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
            flex: 1;
            justify-content: center;
        }
        .btn-primary {
            background-color: #4A90E2;
            color: white;
        }
        .btn-primary:hover {
            background-color: #357ABD;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background-color: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background-color: #5a6268;
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
        .stats-summary {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        .stats-summary h3 {
            margin: 0 0 20px 0;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 15px;
        }
        .summary-card {
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 12px;
            text-align: center;
        }
        .summary-card .number {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .summary-card .label {
            font-size: 14px;
            opacity: 0.9;
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
        <header class="header">
            <div class="header-title">
                <h1>Patients Suivis</h1>
                <p><i class="fas fa-users"></i> Consultez l'historique médical de vos patients</p>
            </div>
        </header>

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

        <!-- Statistiques globales -->
        <div class="stats-summary">
            <h3><i class="fas fa-chart-bar"></i> Vue d'ensemble</h3>
            <div class="summary-grid">
                <div class="summary-card">
                    <div class="number"><%= totalPatients %></div>
                    <div class="label">Patients Suivis</div>
                </div>
                <div class="summary-card" style="background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);">
                    <div class="number"><%= totalConsultations %></div>
                    <div class="label">Consultations Totales</div>
                </div>
                <div class="summary-card" style="background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);">
                    <div class="number"><%= totalPatients > 0 ? String.format("%.1f", (double)totalConsultations / totalPatients) : "0" %></div>
                    <div class="label">Moyenne par Patient</div>
                </div>
            </div>
        </div>

        <!-- Barre de recherche -->
        <div class="search-bar">
            <div class="search-wrapper">
                <i class="fas fa-search search-icon"></i>
                <input type="text" id="searchInput" class="search-input" 
                       placeholder="Rechercher un patient par nom, prénom ou email...">
            </div>
        </div>

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
                    <div class="patient-card" data-patient-name="<%= patient.getNomComplet().toLowerCase() %>" 
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
                                <div class="stat-value" style="color: #28a745;"><%= consultationsTerminees %></div>
                                <div class="stat-label">Terminées</div>
                            </div>
                            <div class="stat-item">
                                <div class="stat-value" style="color: #ffc107;"><%= nbConsultations - consultationsTerminees %></div>
                                <div class="stat-label">En cours</div>
                            </div>
                        </div>

                        <div style="margin-top: 15px;">
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
                                            / <%= patient.getTaille() %> cm
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
            
            patientCards.forEach(card => {
                const patientName = card.getAttribute('data-patient-name');
                const patientEmail = card.getAttribute('data-patient-email');
                
                if (patientName.includes(searchTerm) || patientEmail.includes(searchTerm)) {
                    card.style.display = 'block';
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
