<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Docteur - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
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
                    <a href="#" class="nav-link active">
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

        <button class="logout-btn" onclick="location.href='LogoutServlet'">
            <i class="fas fa-sign-out-alt"></i>
            Déconnexion
        </button>
    </aside>

    <main class="main-content">
        <header class="header">
            <div class="header-title">
                <h1>Bienvenue Dr. Alami</h1>
                <p><i class="fas fa-calendar-day"></i> Vous avez 5 consultations aujourd'hui</p>
            </div>
            <div class="header-actions">
                <button class="header-btn">
                    <i class="fas fa-calendar-plus"></i>
                    Nouvelle Consultation
                </button>
            </div>
        </header>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon blue">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                </div>
                <div class="stat-value">5</div>
                <div class="stat-label">Aujourd'hui</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon orange">
                        <i class="fas fa-clock"></i>
                    </div>
                </div>
                <div class="stat-value">8</div>
                <div class="stat-label">En Attente</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-value">142</div>
                <div class="stat-label">Ce Mois</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon purple">
                        <i class="fas fa-users"></i>
                    </div>
                </div>
                <div class="stat-value">89</div>
                <div class="stat-label">Patients Suivis</div>
            </div>
        </div>

        <div class="content-grid">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-calendar-check"></i>
                        Rendez-vous d'Aujourd'hui
                    </h3>
                    <a href="${pageContext.request.contextPath}/docteur/planning" class="card-action">
                        Voir le planning <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <ul class="appointment-list">
                    <li class="appointment-item">
                        <div class="appointment-time">
                            <div class="hour">09:00</div>
                            <div class="date">15 Oct</div>
                        </div>
                        <div class="appointment-info">
                            <h4>Ahmed Benali</h4>
                            <p><i class="fas fa-heartbeat"></i> Contrôle cardiaque</p>
                            <span class="badge warning"><i class="fas fa-clock"></i> En attente</span>
                        </div>
                        <div class="appointment-actions">
                            <button class="btn-sm btn-success"><i class="fas fa-check"></i> Valider</button>
                            <button class="btn-sm btn-danger"><i class="fas fa-times"></i></button>
                        </div>
                    </li>
                    <li class="appointment-item">
                        <div class="appointment-time">
                            <div class="hour">10:30</div>
                            <div class="date">15 Oct</div>
                        </div>
                        <div class="appointment-info">
                            <h4>Fatima Zahra</h4>
                            <p><i class="fas fa-notes-medical"></i> Consultation de suivi</p>
                            <span class="badge warning"><i class="fas fa-clock"></i> En attente</span>
                        </div>
                        <div class="appointment-actions">
                            <button class="btn-sm btn-success"><i class="fas fa-check"></i> Valider</button>
                            <button class="btn-sm btn-danger"><i class="fas fa-times"></i></button>
                        </div>
                    </li>
                    <li class="appointment-item">
                        <div class="appointment-time">
                            <div class="hour">14:00</div>
                            <div class="date">15 Oct</div>
                        </div>
                        <div class="appointment-info">
                            <h4>Youssef Idrissi</h4>
                            <p><i class="fas fa-stethoscope"></i> Première consultation</p>
                            <span class="badge warning"><i class="fas fa-clock"></i> En attente</span>
                        </div>
                        <div class="appointment-actions">
                            <button class="btn-sm btn-success"><i class="fas fa-check"></i> Valider</button>
                            <button class="btn-sm btn-danger"><i class="fas fa-times"></i></button>
                        </div>
                    </li>
                </ul>
            </div>

            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">
                        <i class="fas fa-users-medical"></i>
                        Patients Récents
                    </h3>
                    <a href="patients-suivis.jsp" class="card-action">
                        Voir tout <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <div>
                    <div class="patient-card">
                        <div class="patient-avatar">AB</div>
                        <div class="patient-info">
                            <h4>Ahmed Benali</h4>
                            <p><i class="fas fa-clock"></i> Dernière visite: 10 Oct 2025</p>
                        </div>
                    </div>
                    <div class="patient-card">
                        <div class="patient-avatar">FZ</div>
                        <div class="patient-info">
                            <h4>Fatima Zahra</h4>
                            <p><i class="fas fa-clock"></i> Dernière visite: 08 Oct 2025</p>
                        </div>
                    </div>
                    <div class="patient-card">
                        <div class="patient-avatar">YI</div>
                        <div class="patient-info">
                            <h4>Youssef Idrissi</h4>
                            <p><i class="fas fa-user-plus"></i> Première consultation</p>
                        </div>
                    </div>
                    <div class="patient-card">
                        <div class="patient-avatar">AR</div>
                        <div class="patient-info">
                            <h4>Amina Rahali</h4>
                            <p><i class="fas fa-clock"></i> Dernière visite: 05 Oct 2025</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
