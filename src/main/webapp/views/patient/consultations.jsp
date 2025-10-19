<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mes Rendez-vous - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
    <style>
        .tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            border-bottom: 2px solid var(--gray-200);
        }
        
        .tab {
            padding: 1rem 1.5rem;
            background: none;
            border: none;
            font-size: 1rem;
            font-weight: 600;
            color: var(--gray-600);
            cursor: pointer;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .tab:hover {
            color: var(--primary-600);
        }
        
        .tab.active {
            color: var(--primary-600);
        }
        
        .tab.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            width: 100%;
            height: 2px;
            background: var(--primary-600);
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .consultation-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .consultation-card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.15);
            transform: translateY(-2px);
        }
        
        .consultation-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }
        
        .consultation-date {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .date-badge {
            background: var(--primary-100);
            color: var(--primary-700);
            padding: 0.75rem;
            border-radius: 8px;
            text-align: center;
            min-width: 70px;
        }
        
        .date-badge .day {
            font-size: 1.5rem;
            font-weight: 700;
        }
        
        .date-badge .month {
            font-size: 0.875rem;
            text-transform: uppercase;
        }
        
        .consultation-info h3 {
            margin: 0 0 0.5rem 0;
            color: var(--gray-800);
        }
        
        .consultation-info p {
            margin: 0.25rem 0;
            color: var(--gray-600);
            font-size: 0.9rem;
        }
        
        .consultation-info i {
            margin-right: 0.5rem;
            width: 16px;
        }
        
        .badge {
            padding: 0.375rem 0.75rem;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 600;
        }
        
        .badge.success {
            background: #dcfce7;
            color: #166534;
        }
        
        .badge.warning {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge.danger {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .badge.info {
            background: #dbeafe;
            color: #1e40af;
        }
        
        .consultation-actions {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid var(--gray-200);
        }
        
        .btn-action {
            padding: 0.5rem 1rem;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-danger {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .btn-danger:hover {
            background: #fecaca;
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
        
        .empty-state p {
            font-size: 1.125rem;
            margin-bottom: 1.5rem;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-success {
            background: #dcfce7;
            color: #166534;
            border: 1px solid #bbf7d0;
        }
        
        .alert-danger {
            background: #fee2e2;
            color: #991b1b;
            border: 1px solid #fecaca;
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
                    <a href="${pageContext.request.contextPath}/patient/consultations" class="nav-link active">
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
        <header class="header">
            <div class="header-title">
                <h1><i class="fas fa-calendar-check"></i> Mes Rendez-vous</h1>
                <p>Consultez et gérez vos consultations médicales</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/patient/reserver" class="header-btn">
                    <i class="fas fa-calendar-plus"></i>
                    Nouveau Rendez-vous
                </a>
            </div>
        </header>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <div class="tabs">
            <button class="tab active" onclick="switchTab('avenir')">
                <i class="fas fa-calendar-day"></i> À venir (${not empty consultationsAVenir ? consultationsAVenir.size() : 0})
            </button>
            <button class="tab" onclick="switchTab('passees')">
                <i class="fas fa-history"></i> Passées (${not empty consultationsPassees ? consultationsPassees.size() : 0})
            </button>
            <button class="tab" onclick="switchTab('annulees')">
                <i class="fas fa-times-circle"></i> Annulées (${not empty consultationsAnnulees ? consultationsAnnulees.size() : 0})
            </button>
        </div>

        <!-- Onglet Consultations à venir -->
        <div id="tab-avenir" class="tab-content active">
            <c:choose>
                <c:when test="${not empty consultationsAVenir}">
                    <c:forEach items="${consultationsAVenir}" var="consultation">
                        <div class="consultation-card">
                            <div class="consultation-header">
                                <div class="consultation-date">
                                    <div class="date-badge">
                                        <div class="day">
                                            <fmt:formatDate value="${consultation.date}" pattern="dd" />
                                        </div>
                                        <div class="month">
                                            <fmt:formatDate value="${consultation.date}" pattern="MMM" />
                                        </div>
                                    </div>
                                    <div class="consultation-info">
                                        <h3>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                        <p><i class="fas fa-stethoscope"></i>${consultation.docteur.specialite}</p>
                                        <p><i class="fas fa-clock"></i><fmt:formatDate value="${consultation.date}" pattern="HH:mm" /></p>
                                        <p><i class="fas fa-door-open"></i>Salle ${not empty consultation.salle ? consultation.salle.nomSalle : 'N/A'}</p>
                                        <c:if test="${not empty consultation.motif}">
                                            <p><i class="fas fa-notes-medical"></i>${consultation.motif}</p>
                                        </c:if>
                                    </div>
                                </div>
                                <div>
                                    <c:choose>
                                        <c:when test="${consultation.statut == 'VALIDEE'}">
                                            <span class="badge success"><i class="fas fa-check"></i> Validé</span>
                                        </c:when>
                                        <c:when test="${consultation.statut == 'RESERVEE'}">
                                            <span class="badge warning"><i class="fas fa-clock"></i> En attente</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </div>
                            
                            <div class="consultation-actions">
                                <form method="post" action="${pageContext.request.contextPath}/patient/consultations" style="display: inline;" 
                                      onsubmit="return confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous ?');">
                                    <input type="hidden" name="action" value="annuler">
                                    <input type="hidden" name="consultationId" value="${consultation.id}">
                                    <button type="submit" class="btn-action btn-danger">
                                        <i class="fas fa-times"></i>
                                        Annuler le rendez-vous
                                    </button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-calendar-times"></i>
                        <p>Aucun rendez-vous à venir</p>
                        <a href="${pageContext.request.contextPath}/patient/reserver" class="header-btn">
                            <i class="fas fa-calendar-plus"></i>
                            Réserver un rendez-vous
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Onglet Consultations passées -->
        <div id="tab-passees" class="tab-content">
            <c:choose>
                <c:when test="${not empty consultationsPassees}">
                    <c:forEach items="${consultationsPassees}" var="consultation">
                        <div class="consultation-card">
                            <div class="consultation-header">
                                <div class="consultation-date">
                                    <div class="date-badge" style="background: var(--gray-100); color: var(--gray-700);">
                                        <div class="day">
                                            <fmt:formatDate value="${consultation.date}" pattern="dd" />
                                        </div>
                                        <div class="month">
                                            <fmt:formatDate value="${consultation.date}" pattern="MMM" />
                                        </div>
                                    </div>
                                    <div class="consultation-info">
                                        <h3>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                        <p><i class="fas fa-stethoscope"></i>${consultation.docteur.specialite}</p>
                                        <p><i class="fas fa-clock"></i><fmt:formatDate value="${consultation.date}" pattern="HH:mm" /></p>
                                        <c:if test="${not empty consultation.compteRendu}">
                                            <p style="margin-top: 0.5rem; padding: 0.5rem; background: var(--gray-50); border-radius: 6px;">
                                                <strong>Compte-rendu:</strong><br>
                                                ${consultation.compteRendu}
                                            </p>
                                        </c:if>
                                    </div>
                                </div>
                                <div>
                                    <span class="badge info"><i class="fas fa-check-circle"></i> Terminée</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-history"></i>
                        <p>Aucune consultation passée</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Onglet Consultations annulées -->
        <div id="tab-annulees" class="tab-content">
            <c:choose>
                <c:when test="${not empty consultationsAnnulees}">
                    <c:forEach items="${consultationsAnnulees}" var="consultation">
                        <div class="consultation-card" style="opacity: 0.7;">
                            <div class="consultation-header">
                                <div class="consultation-date">
                                    <div class="date-badge" style="background: #fee2e2; color: #991b1b;">
                                        <div class="day">
                                            <fmt:formatDate value="${consultation.date}" pattern="dd" />
                                        </div>
                                        <div class="month">
                                            <fmt:formatDate value="${consultation.date}" pattern="MMM" />
                                        </div>
                                    </div>
                                    <div class="consultation-info">
                                        <h3>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                        <p><i class="fas fa-stethoscope"></i>${consultation.docteur.specialite}</p>
                                        <p><i class="fas fa-clock"></i><fmt:formatDate value="${consultation.date}" pattern="HH:mm" /></p>
                                    </div>
                                </div>
                                <div>
                                    <span class="badge danger"><i class="fas fa-times-circle"></i> Annulée</span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <i class="fas fa-times-circle"></i>
                        <p>Aucune consultation annulée</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <script>
        function switchTab(tabName) {
            // Désactiver tous les onglets
            document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
            
            // Activer l'onglet sélectionné
            event.target.closest('.tab').classList.add('active');
            document.getElementById('tab-' + tabName).classList.add('active');
        }
    </script>
</body>
</html>
