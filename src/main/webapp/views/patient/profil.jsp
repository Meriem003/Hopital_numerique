<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-profil.css" rel="stylesheet">
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
                    <a href="${pageContext.request.contextPath}/patient/docteurs" class="nav-link">
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
                    <a href="${pageContext.request.contextPath}/patient/profil" class="nav-link active">
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
        <div class="profile-container">
            <!-- Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <span>${sessionScope.successMessage}</span>
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- En-tête du profil -->
            <div class="profile-header-card">
                <div class="profile-avatar-large">
                    <div class="avatar-circle">
                        ${sessionScope.user.prenom.substring(0,1)}${sessionScope.user.nom.substring(0,1)}
                    </div>
                    <div class="avatar-badge">
                        <i class="fas fa-check"></i>
                    </div>
                </div>
                <div class="profile-header-info">
                    <h2>${sessionScope.user.prenom} ${sessionScope.user.nom}</h2>
                    <div class="profile-meta">
                        <span class="meta-item">
                            <i class="fas fa-envelope"></i>
                            ${sessionScope.user.email}
                        </span>
                    </div>
                </div>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/patient/profil">
                <!-- Onglet Informations Personnelles -->
                <div id="info" class="tab-content active">
                    <div class="card">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nom">
                                    <i class="fas fa-user-tag"></i>
                                    Nom *
                                </label>
                                <input type="text" id="nom" name="nom" 
                                       value="${sessionScope.user.nom}" required
                                       class="form-input">
                            </div>
                            <div class="form-group">
                                <label for="prenom">
                                    <i class="fas fa-user"></i>
                                    Prénom *
                                </label>
                                <input type="text" id="prenom" name="prenom" 
                                       value="${sessionScope.user.prenom}" required
                                       class="form-input">
                            </div>
                            <div class="form-group form-group-full">
                                <label for="email">
                                    <i class="fas fa-envelope"></i>
                                    Email *
                                </label>
                                <input type="email" id="email" name="email" 
                                       value="${sessionScope.user.email}" required
                                       class="form-input">
                            </div>
                        </div>
                                          <div class="health-metrics-grid">
                        <div class="metric-card">
                            <div class="metric-icon blue">
                                <i class="fas fa-weight"></i>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">
                                    ${not empty sessionScope.user.poids ? sessionScope.user.poids : '--'}
                                    <span class="metric-unit">kg</span>
                                </div>
                                <div class="metric-label">Poids</div>
                            </div>
                        </div>

                        <div class="metric-card">
                            <div class="metric-icon green">
                                <i class="fas fa-ruler-vertical"></i>
                            </div>
                            <div class="metric-content">
                                <div class="metric-value">
                                    ${not empty sessionScope.user.taille ? sessionScope.user.taille : '--'}
                                    <span class="metric-unit">cm</span>
                                </div>
                                <div class="metric-label">Taille</div>
                            </div>
                        </div>
                    </div>
                        <div class="info-banner">
                            <div class="info-banner-icon">
                                <i class="fas fa-info-circle"></i>
                            </div>
                            <div class="info-banner-content">
                                <strong>Information importante</strong>
                                <p>Pour modifier votre mot de passe ou d'autres informations sensibles, veuillez contacter l'administration.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/patient-profil.js"></script>
</body>
</html>