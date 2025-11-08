<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Historique Médical - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/medical-history.css" rel="stylesheet">
</head>
<body>
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
                <a href="${pageContext.request.contextPath}/patient/historique" class="nav-link active">
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

<main class="main-content">
    <!-- En-tête de page -->
    <div class="page-header">
        <h1>
            <i class="fas fa-history"></i>
            Historique Médical
        </h1>
        <p>Consultez l'historique complet de vos consultations et diagnostics</p>
    </div>

    <!-- Alerts -->
    <c:if test="${not empty error}">
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span>${error}</span>
        </div>
    </c:if>

    <!-- Statistiques -->
    <div class="stats-row">
        <div class="stat-card-mini">
            <div class="stat-icon-circle blue">
                <i class="fas fa-calendar-check"></i>
            </div>
            <div class="stat-content">
                <h3>${nombreConsultationsTotal}</h3>
                <p>Consultations Totales</p>
            </div>
        </div>

        <div class="stat-card-mini">
            <div class="stat-icon-circle green">
                <i class="fas fa-user-md"></i>
            </div>
            <div class="stat-content">
                <h3>${nombreDifferentsDocteurs}</h3>
                <p>Docteurs Consultés</p>
            </div>
        </div>

        <div class="stat-card-mini">
            <div class="stat-icon-circle orange">
                <i class="fas fa-stethoscope"></i>
            </div>
            <div class="stat-content">
                <h3>${not empty specialitesDisponibles ? specialitesDisponibles.size() : 0}</h3>
                <p>Spécialités Différentes</p>
            </div>
        </div>
    </div>

    <!-- Filtres -->
    <c:if test="${not empty consultations}">
        <div class="filters-bar">
            <div class="filter-group">
                <label for="anneeFilter">
                    <i class="fas fa-calendar-alt"></i> Année :
                </label>
                <select id="anneeFilter" onchange="applyFilter()">
                    <option value="">Toutes les années</option>
                    <c:forEach items="${anneesDisponibles}" var="annee">
                        <option value="${annee}" ${anneeSelectionnee == annee ? 'selected' : ''}>
                                ${annee}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="filter-group">
                <label for="specialiteFilter">
                    <i class="fas fa-stethoscope"></i> Spécialité :
                </label>
                <select id="specialiteFilter" onchange="applyFilter()">
                    <option value="">Toutes les spécialités</option>
                    <c:forEach items="${specialitesDisponibles}" var="specialite">
                        <option value="${specialite}" ${specialiteSelectionnee == specialite ? 'selected' : ''}>
                                ${specialite}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <button class="btn-reset-filter" onclick="resetFilters()">
                <i class="fas fa-redo"></i> Réinitialiser
            </button>
        </div>
    </c:if>

    <!-- Timeline des consultations -->
    <c:choose>
        <c:when test="${not empty consultations}">
            <div class="timeline">
                <c:forEach items="${consultations}" var="consultation">
                    <div class="timeline-item">
                        <div class="timeline-marker"></div>
                        <div class="consultation-card">
                            <div class="consultation-header">
                                <div class="consultation-date-badge">
                                    <i class="fas fa-calendar"></i>
                                    <fmt:formatDate value="${consultation.date}" pattern="dd MMMM yyyy à HH:mm" />
                                </div>
                                <c:if test="${not empty consultation.salle}">
                                        <span class="specialty-badge">
                                            <i class="fas fa-door-open"></i> Salle ${consultation.salle.numero}
                                        </span>
                                </c:if>
                            </div>

                            <!-- Informations du docteur -->
                            <div class="doctor-info-section">
                                <div class="doctor-avatar-small">
                                        ${consultation.docteur.prenom.substring(0,1)}${consultation.docteur.nom.substring(0,1)}
                                </div>
                                <div class="doctor-details">
                                    <h4>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h4>
                                    <p>
                                        <i class="fas fa-stethoscope"></i>
                                        <span>${consultation.docteur.specialite}</span>
                                        <c:if test="${not empty consultation.docteur.departement}">
                                            <span>•</span>
                                            <span>${consultation.docteur.departement.nom}</span>
                                        </c:if>
                                    </p>
                                </div>
                            </div>

                            <!-- Détails de la consultation -->
                            <div class="consultation-details">
                                <c:if test="${not empty consultation.motif}">
                                    <div class="detail-row">
                                        <i class="fas fa-comment-medical"></i>
                                        <div class="detail-content">
                                            <div class="detail-label">Motif de consultation</div>
                                            <div class="detail-value">${consultation.motif}</div>
                                        </div>
                                    </div>
                                </c:if>

                                <c:choose>
                                    <c:when test="${not empty consultation.compteRendu}">
                                        <div class="diagnostic-box">
                                            <h5>
                                                <i class="fas fa-file-medical"></i>
                                                Compte Rendu & Diagnostic
                                            </h5>
                                            <p>${consultation.compteRendu}</p>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="detail-row">
                                            <i class="fas fa-info-circle"></i>
                                            <div class="detail-content">
                                                <div class="detail-value" style="font-style: italic; color: var(--gray-600);">
                                                    Aucun compte rendu disponible pour cette consultation
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <i class="fas fa-folder-open"></i>
                <h3>Aucune consultation dans l'historique</h3>
                <p>Vous n'avez pas encore de consultations terminées</p>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<script>
    function applyFilter() {
        const annee = document.getElementById('anneeFilter').value;
        const specialite = document.getElementById('specialiteFilter').value;

        let url = '${pageContext.request.contextPath}/patient/historique?';
        const params = [];

        if (annee) params.push('annee=' + encodeURIComponent(annee));
        if (specialite) params.push('specialite=' + encodeURIComponent(specialite));

        url += params.join('&');
        window.location.href = url;
    }

    function resetFilters() {
        window.location.href = '${pageContext.request.contextPath}/patient/historique';
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