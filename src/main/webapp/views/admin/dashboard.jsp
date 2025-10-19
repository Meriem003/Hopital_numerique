<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Admin" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%
    Personne user = (Personne) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String userName = session.getAttribute("userName") != null ? 
                      (String) session.getAttribute("userName") : 
                      user.getPrenom() + " " + user.getNom();
    String userEmail = user.getEmail();
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
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
                <p>Admin Panel</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/departements" class="nav-link">
                        <i class="fas fa-building"></i>
                        <span>Départements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/docteurs" class="nav-link">
                        <i class="fas fa-user-md"></i>
                        <span>Docteurs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/patients" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Patients</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/salles" class="nav-link">
                        <i class="fas fa-door-open"></i>
                        <span>Salles</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/views/admin/consultations.jsp" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Consultations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/views/admin/statistiques.jsp" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <span>Statistiques</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/views/admin/parametres.jsp" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
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
        <header class="header">
            <div class="header-title">
                <h1>Tableau de Bord</h1>
                <p>Bienvenue <%= userName %> - Panneau d'administration</p>
            </div>
        </header>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon blue">
                        <i class="fas fa-users"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i>
                        12%
                    </div>
                </div>
                <div class="stat-value">1,245</div>
                <div class="stat-label">Total Patients</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon green">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i>
                        8%
                    </div>
                </div>
                <div class="stat-value">48</div>
                <div class="stat-label">Docteurs Actifs</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon orange">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                    <div class="stat-trend up">
                        <i class="fas fa-arrow-up"></i>
                        25%
                    </div>
                </div>
                <div class="stat-value">324</div>
                <div class="stat-label">Consultations</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon red">
                        <i class="fas fa-door-open"></i>
                    </div>
                    <div class="stat-trend down">
                        <i class="fas fa-arrow-down"></i>
                        3%
                    </div>
                </div>
                <div class="stat-value">85%</div>
                <div class="stat-label">Taux d'occupation</div>
            </div>
        </div>

        <!-- Content Grid -->
        <div class="content-grid">
            <!-- Recent Consultations -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Consultations Récentes</h3>
                    <a href="consultations.jsp" class="card-action">
                        Voir tout <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>Patient</th>
                                <th>Docteur</th>
                                <th>Date</th>
                                <th>Statut</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>Ahmed Benali</td>
                                <td>Dr. Sara Alami</td>
                                <td>15 Oct 2025, 14:30</td>
                                <td><span class="badge success"><i class="fas fa-check"></i> Validée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Fatima Zahra</td>
                                <td>Dr. Mohammed Tazi</td>
                                <td>15 Oct 2025, 15:00</td>
                                <td><span class="badge warning"><i class="fas fa-clock"></i> Réservée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Youssef Idrissi</td>
                                <td>Dr. Laila Benjelloun</td>
                                <td>15 Oct 2025, 16:00</td>
                                <td><span class="badge info"><i class="fas fa-check-double"></i> Terminée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td>Amina Rahali</td>
                                <td>Dr. Karim Fassi</td>
                                <td>14 Oct 2025, 10:30</td>
                                <td><span class="badge danger"><i class="fas fa-times"></i> Annulée</span></td>
                                <td>
                                    <div class="action-btns">
                                        <button class="action-btn edit"><i class="fas fa-eye"></i></button>
                                        <button class="action-btn delete"><i class="fas fa-trash"></i></button>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Recent Activity -->
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Activité Récente</h3>
                </div>
                <ul class="activity-list">
                    <li class="activity-item">
                        <div class="activity-icon blue">
                            <i class="fas fa-user-plus"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Nouveau Patient</h4>
                            <p>Hassan Amrani s'est inscrit</p>
                        </div>
                        <span class="activity-time">Il y a 5 min</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon green">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Consultation Validée</h4>
                            <p>Dr. Sara Alami a validé une consultation</p>
                        </div>
                        <span class="activity-time">Il y a 15 min</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon orange">
                            <i class="fas fa-door-open"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Nouvelle Salle</h4>
                            <p>Salle 305 a été ajoutée</p>
                        </div>
                        <span class="activity-time">Il y a 1 heure</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon blue">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Nouveau Docteur</h4>
                            <p>Dr. Khalid Senhaji a rejoint l'équipe</p>
                        </div>
                        <span class="activity-time">Il y a 3 heures</span>
                    </li>
                    <li class="activity-item">
                        <div class="activity-icon green">
                            <i class="fas fa-building"></i>
                        </div>
                        <div class="activity-content">
                            <h4>Département Mis à Jour</h4>
                            <p>Département Cardiologie modifié</p>
                        </div>
                        <span class="activity-time">Il y a 5 heures</span>
                    </li>
                </ul>
            </div>
        </div>
    </main>
    
    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/assets/js/admin-dashboard.js"></script>
</body>
</html>
