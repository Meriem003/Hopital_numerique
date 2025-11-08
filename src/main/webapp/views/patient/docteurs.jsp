<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nos Docteurs - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-docteurs.css" rel="stylesheet">
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
                <p>Espace Patient</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/reserver" class="nav-link">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Réserver un RDV</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/consultations" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Mes Rendez-vous</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/docteurs" class="nav-link active">
                        <i class="fas fa-user-md"></i>
                        <span>Nos Docteurs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/historique" class="nav-link">
                        <i class="fas fa-history"></i>
                        <span>Historique Médical</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/profil" class="nav-link">
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header Section -->
        <header class="consultations-header">
            <div class="header-content">
                <div class="header-text">
                    <h1>
                        <i class="fas fa-user-md"></i>
                        Notre Équipe Médicale
                    </h1>
                    <p>Découvrez nos médecins spécialistes qualifiés et expérimentés</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/patient/reserver" class="btn-header">
                        <i class="fas fa-calendar-plus"></i>
                        Prendre Rendez-vous
                    </a>
                </div>
            </div>
        </header>

        <!-- Alert Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Search & Filter Section -->
        <div class="search-filter-section">
            <div class="search-bar">
                <i class="fas fa-search"></i>
                <input type="text" 
                       id="searchInput" 
                       class="search-input" 
                       placeholder="Rechercher un médecin par nom ou spécialité... (Ctrl + K)">
            </div>
        </div>

        <!-- Doctors Grid -->
        <div class="doctors-grid" id="doctorsGrid">
            <c:choose>
                <c:when test="${not empty docteurs}">
                    <c:forEach items="${docteurs}" var="docteur">
                        <div class="doctor-card" 
                             data-name="${docteur.nom} ${docteur.prenom}" 
                             data-specialty="${docteur.specialite}">
                            
                            <!-- Card Header -->
                            <div class="doctor-card-header">
                                <h3 class="doctor-name">
                                    Dr. ${docteur.nom} ${docteur.prenom}
                                </h3>
                                
                                <span class="doctor-specialty">
                                    <i class="fas fa-stethoscope"></i>
                                    ${docteur.specialite}
                                </span>
                            </div>
                            
                            <!-- Card Body -->
                            <div class="doctor-card-body">
                                <div class="doctor-info-list">
                                    <div class="doctor-info-item">
                                        <div class="info-icon">
                                            <i class="fas fa-envelope"></i>
                                        </div>
                                        <div class="info-content">
                                            ${docteur.email}
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty docteur.departement}">
                                        <div class="doctor-info-item">
                                            <div class="info-icon">
                                                <i class="fas fa-building"></i>
                                            </div>
                                            <div class="info-content">
                                                Département ${docteur.departement.nom}
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${not empty docteur.salle}">
                                        <div class="doctor-info-item">
                                            <div class="info-icon">
                                                <i class="fas fa-door-open"></i>
                                            </div>
                                            <div class="info-content">
                                                Salle ${docteur.salle.nomSalle}
                                            </div>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <!-- Card Footer -->
                            <div class="doctor-card-footer">
                                <button class="btn-book-doctor" onclick="reserverAvec('${docteur.id}')">
                                    <i class="fas fa-calendar-check"></i>
                                    Prendre Rendez-vous
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <h3>Aucun médecin disponible</h3>
                        <p>Aucun docteur n'est actuellement enregistré dans le système</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/patient-docteurs.js"></script>
</body>
</html>