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
    <style>
        .page-header {
            background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
            color: white;
            padding: 2rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .page-header h1 {
            margin: 0 0 0.5rem 0;
            font-size: 2rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .page-header p {
            margin: 0;
            opacity: 0.9;
        }
        
        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card-mini {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: all 0.3s ease;
        }
        
        .stat-card-mini:hover {
            transform: translateY(-4px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        
        .stat-icon-circle {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        
        .stat-icon-circle.blue {
            background: var(--primary-100);
            color: var(--primary-600);
        }
        
        .stat-icon-circle.green {
            background: #d1fae5;
            color: #065f46;
        }
        
        .stat-icon-circle.orange {
            background: #fed7aa;
            color: #c2410c;
        }
        
        .stat-content h3 {
            margin: 0;
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        
        .stat-content p {
            margin: 0.25rem 0 0 0;
            color: var(--gray-600);
            font-size: 0.875rem;
        }
        
        .filters-bar {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            align-items: center;
        }
        
        .filter-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .filter-group label {
            font-weight: 600;
            color: var(--gray-700);
            font-size: 0.875rem;
        }
        
        .filter-group select {
            padding: 0.5rem 1rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 0.875rem;
            cursor: pointer;
        }
        
        .filter-group select:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .btn-reset-filter {
            padding: 0.5rem 1rem;
            background: var(--gray-200);
            color: var(--gray-700);
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-size: 0.875rem;
        }
        
        .btn-reset-filter:hover {
            background: var(--gray-300);
        }
        
        .timeline {
            position: relative;
            padding-left: 2rem;
        }
        
        .timeline::before {
            content: '';
            position: absolute;
            left: 0;
            top: 0;
            bottom: 0;
            width: 2px;
            background: var(--gray-200);
        }
        
        .timeline-item {
            position: relative;
            margin-bottom: 2rem;
            padding-left: 2rem;
        }
        
        .timeline-marker {
            position: absolute;
            left: -2rem;
            top: 1.5rem;
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: var(--primary-500);
            border: 3px solid white;
            box-shadow: 0 0 0 3px var(--primary-100);
        }
        
        .consultation-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .consultation-card:hover {
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            transform: translateX(8px);
        }
        
        .consultation-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .consultation-date-badge {
            background: var(--primary-100);
            color: var(--primary-700);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            font-weight: 600;
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .doctor-info-section {
            display: flex;
            align-items: center;
            gap: 1rem;
            margin-bottom: 1rem;
            padding: 1rem;
            background: var(--gray-50);
            border-radius: 8px;
        }
        
        .doctor-avatar-small {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-100), var(--primary-200));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: var(--primary-600);
            font-weight: 700;
        }
        
        .doctor-details h4 {
            margin: 0 0 0.25rem 0;
            color: var(--gray-800);
            font-size: 1rem;
        }
        
        .doctor-details p {
            margin: 0;
            color: var(--gray-600);
            font-size: 0.875rem;
        }
        
        .consultation-details {
            display: grid;
            gap: 0.75rem;
        }
        
        .detail-row {
            display: flex;
            align-items: start;
            gap: 0.75rem;
        }
        
        .detail-row i {
            color: var(--primary-500);
            margin-top: 0.25rem;
            width: 20px;
        }
        
        .detail-content {
            flex: 1;
        }
        
        .detail-label {
            font-weight: 600;
            color: var(--gray-700);
            font-size: 0.875rem;
            margin-bottom: 0.25rem;
        }
        
        .detail-value {
            color: var(--gray-600);
            font-size: 0.9rem;
            line-height: 1.5;
        }
        
        .diagnostic-box {
            background: #f0f9ff;
            border-left: 4px solid var(--primary-500);
            padding: 1rem;
            border-radius: 8px;
            margin-top: 1rem;
        }
        
        .diagnostic-box h5 {
            margin: 0 0 0.5rem 0;
            color: var(--primary-700);
            font-size: 0.875rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .diagnostic-box p {
            margin: 0;
            color: var(--gray-700);
            line-height: 1.6;
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--gray-600);
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }
        
        .empty-state h3 {
            margin: 0 0 0.5rem 0;
            color: var(--gray-700);
        }
        
        .empty-state p {
            margin: 0 0 1.5rem 0;
        }
        
        .btn-primary-action {
            display: inline-block;
            padding: 0.875rem 2rem;
            background: var(--primary-500);
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .btn-primary-action:hover {
            background: var(--primary-600);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .specialty-badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            background: var(--gray-200);
            color: var(--gray-700);
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 600;
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
                <p>Espace Patient</p>
            </div>
        </div>

        <div class="user-profile">
            <div class="user-avatar">
                ${sessionScope.user.prenom.substring(0,1)}${sessionScope.user.nom.substring(0,1)}
            </div>
            <div class="user-info">
                <h4>${sessionScope.user.prenom} ${sessionScope.user.nom}</h4>
                <p>Patient ID: #${sessionScope.user.id}</p>
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

        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background: #fee; color: #c33; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">
                <i class="fas fa-exclamation-circle"></i>
                ${error}
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
                                            <i class="fas fa-stethoscope"></i> ${consultation.docteur.specialite}
                                            <c:if test="${not empty consultation.docteur.departement}">
                                                • ${consultation.docteur.departement.nom}
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
                                    
                                    <c:if test="${not empty consultation.compteRendu}">
                                        <div class="diagnostic-box">
                                            <h5>
                                                <i class="fas fa-file-medical"></i>
                                                Compte Rendu & Diagnostic
                                            </h5>
                                            <p>${consultation.compteRendu}</p>
                                        </div>
                                    </c:if>
                                    
                                    <c:if test="${empty consultation.compteRendu}">
                                        <div class="detail-row">
                                            <i class="fas fa-info-circle"></i>
                                            <div class="detail-content">
                                                <div class="detail-value" style="font-style: italic; color: var(--gray-500);">
                                                    Aucun compte rendu disponible pour cette consultation
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
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
                    <a href="${pageContext.request.contextPath}/patient/reserver" class="btn-primary-action">
                        <i class="fas fa-calendar-plus"></i>
                        Prendre un rendez-vous
                    </a>
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
            
            if (annee) {
                params.push('annee=' + encodeURIComponent(annee));
            }
            if (specialite) {
                params.push('specialite=' + encodeURIComponent(specialite));
            }
            
            url += params.join('&');
            window.location.href = url;
        }
        
        function resetFilters() {
            window.location.href = '${pageContext.request.contextPath}/patient/historique';
        }
        
        // Animation au chargement
        document.addEventListener('DOMContentLoaded', function() {
            const timelineItems = document.querySelectorAll('.timeline-item');
            timelineItems.forEach((item, index) => {
                setTimeout(() => {
                    item.style.opacity = '0';
                    item.style.transform = 'translateX(-20px)';
                    item.style.transition = 'all 0.5s ease';
                    
                    setTimeout(() => {
                        item.style.opacity = '1';
                        item.style.transform = 'translateX(0)';
                    }, 50);
                }, index * 100);
            });
        });
    </script>
</body>
</html>
