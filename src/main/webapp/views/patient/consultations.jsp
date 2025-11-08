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
    <link href="${pageContext.request.contextPath}/assets/css/patient-consultations.css" rel="stylesheet">
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header Section -->
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1>
                        <i class="fas fa-calendar-check"></i>
                        Mes Rendez-vous Médicaux
                    </h1>
                    <p>Gérez vos consultations et suivez votre parcours de soins</p>
                </div>
                <a href="${pageContext.request.contextPath}/patient/reserver" class="btn-primary-action">
                    <i class="fas fa-calendar-plus"></i>
                    Nouveau Rendez-vous
                </a>
            </div>
        </div>

        <!-- Messages -->
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

        <!-- Tabs Navigation -->
        <div class="tabs-container">
            <div class="tabs">
                <button class="tab active" onclick="switchTab('avenir')">
                    <i class="fas fa-calendar-day"></i> 
                    <span>À venir</span>
                    <span class="tab-badge">${not empty consultationsAVenir ? consultationsAVenir.size() : 0}</span>
                </button>
                <button class="tab" onclick="switchTab('passees')">
                    <i class="fas fa-history"></i> 
                    <span>Passées</span>
                    <span class="tab-badge">${not empty consultationsPassees ? consultationsPassees.size() : 0}</span>
                </button>
                <button class="tab" onclick="switchTab('annulees')">
                    <i class="fas fa-ban"></i> 
                    <span>Annulées</span>
                    <span class="tab-badge">${not empty consultationsAnnulees ? consultationsAnnulees.size() : 0}</span>
                </button>
            </div>
        </div>

        <!-- Onglet Consultations à venir -->
        <div id="tab-avenir" class="tab-content active">
            <c:choose>
                <c:when test="${not empty consultationsAVenir}">
                    <div class="consultations-grid">
                        <c:forEach items="${consultationsAVenir}" var="consultation">
                            <div class="consultation-card">
                                <!-- Card Header -->
                                <div class="card-header">
                                    <div class="doctor-info">
                                        <div class="doctor-avatar">
                                            <i class="fas fa-user-md"></i>
                                        </div>
                                        <div class="doctor-details">
                                            <h3>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                            <div class="doctor-specialty">
                                                <i class="fas fa-stethoscope"></i>
                                                <span>${consultation.docteur.specialite}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'VALIDEE'}">
                                                <span class="status-badge validated">
                                                    <i class="fas fa-check-circle"></i> Validé
                                                </span>
                                            </c:when>
                                            <c:when test="${consultation.statut == 'RESERVEE'}">
                                                <span class="status-badge pending">
                                                    <i class="fas fa-clock"></i> En attente
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                </div>

                                <!-- Card Body -->
                                <div class="card-body">
                                    <div class="consultation-details">
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-calendar-alt"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Date</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${consultation.date}" pattern="EEEE dd MMMM yyyy" />
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Heure</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${consultation.date}" pattern="HH:mm" />
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-door-open"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Salle</span>
                                                <span class="detail-value">
                                                    ${not empty consultation.salle ? consultation.salle.nomSalle : 'Non assignée'}
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-building"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Département</span>
                                                <span class="detail-value">
                                                    ${not empty consultation.docteur.departement ? consultation.docteur.departement.nom : 'N/A'}
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${not empty consultation.motif}">
                                        <div class="consultation-notes">
                                            <div class="notes-header">
                                                <i class="fas fa-notes-medical"></i>
                                                <span>Motif de consultation</span>
                                            </div>
                                            <p>${consultation.motif}</p>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Card Footer -->
                                <div class="card-footer">
                                    <div class="consultation-info-footer">
                                        <i class="fas fa-info-circle"></i>
                                        <span>Consultation ID: #${consultation.id}</span>
                                    </div>
                                    <div class="consultation-actions">
                                        <form method="post" action="${pageContext.request.contextPath}/patient/consultations" style="display: inline;" 
                                              onsubmit="return confirm('Êtes-vous sûr de vouloir annuler ce rendez-vous ?');">
                                            <input type="hidden" name="action" value="annuler">
                                            <input type="hidden" name="consultationId" value="${consultation.id}">
                                            <button type="submit" class="btn-action btn-cancel">
                                                <i class="fas fa-times-circle"></i>
                                                Annuler
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-calendar-times"></i>
                        </div>
                        <h3>Aucun rendez-vous à venir</h3>
                        <p>Vous n'avez pas de consultations programmées pour le moment</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Onglet Consultations passées -->
        <div id="tab-passees" class="tab-content">
            <c:choose>
                <c:when test="${not empty consultationsPassees}">
                    <div class="consultations-grid">
                        <c:forEach items="${consultationsPassees}" var="consultation">
                            <div class="consultation-card completed">
                                <!-- Card Header -->
                                <div class="card-header">
                                    <div class="doctor-info">
                                        <div class="doctor-avatar" style="background: linear-gradient(135deg, #10b981, #059669);">
                                            <i class="fas fa-user-md"></i>
                                        </div>
                                        <div class="doctor-details">
                                            <h3>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                            <div class="doctor-specialty">
                                                <i class="fas fa-stethoscope"></i>
                                                <span>${consultation.docteur.specialite}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <span class="status-badge completed">
                                            <i class="fas fa-check-double"></i> Terminée
                                        </span>
                                    </div>
                                </div>

                                <!-- Card Body -->
                                <div class="card-body">
                                    <div class="consultation-details">
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-calendar-alt"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Date</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${consultation.date}" pattern="EEEE dd MMMM yyyy" />
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Heure</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${consultation.date}" pattern="HH:mm" />
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-door-open"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Salle</span>
                                                <span class="detail-value">
                                                    ${not empty consultation.salle ? consultation.salle.nomSalle : 'N/A'}
                                                </span>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${not empty consultation.compteRendu}">
                                        <div class="compte-rendu-section">
                                            <div class="section-title">
                                                <i class="fas fa-file-medical-alt"></i>
                                                <span>Compte-rendu médical</span>
                                            </div>
                                            <p class="section-content">${consultation.compteRendu}</p>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Card Footer -->
                                <div class="card-footer">
                                    <div class="consultation-info-footer">
                                        <i class="fas fa-info-circle"></i>
                                        <span>Consultation ID: #${consultation.id}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-history"></i>
                        </div>
                        <h3>Aucune consultation passée</h3>
                        <p>Votre historique de consultations apparaîtra ici</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Onglet Consultations annulées -->
        <div id="tab-annulees" class="tab-content">
            <c:choose>
                <c:when test="${not empty consultationsAnnulees}">
                    <div class="consultations-grid">
                        <c:forEach items="${consultationsAnnulees}" var="consultation">
                            <div class="consultation-card cancelled">
                                <!-- Card Header -->
                                <div class="card-header">
                                    <div class="doctor-info">
                                        <div class="doctor-avatar" style="background: linear-gradient(135deg, #ef4444, #dc2626);">
                                            <i class="fas fa-user-md"></i>
                                        </div>
                                        <div class="doctor-details">
                                            <h3>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h3>
                                            <div class="doctor-specialty">
                                                <i class="fas fa-stethoscope"></i>
                                                <span>${consultation.docteur.specialite}</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div>
                                        <span class="status-badge cancelled">
                                            <i class="fas fa-ban"></i> Annulée
                                        </span>
                                    </div>
                                </div>

                                <!-- Card Body -->
                                <div class="card-body">
                                    <div class="consultation-details">
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-calendar-alt"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Date prévue</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${consultation.date}" pattern="EEEE dd MMMM yyyy" />
                                                </span>
                                            </div>
                                        </div>
                                        
                                        <div class="detail-item">
                                            <div class="detail-icon">
                                                <i class="fas fa-clock"></i>
                                            </div>
                                            <div class="detail-content">
                                                <span class="detail-label">Heure prévue</span>
                                                <span class="detail-value">
                                                    <fmt:formatDate value="${consultation.date}" pattern="HH:mm" />
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Card Footer -->
                                <div class="card-footer">
                                    <div class="consultation-info-footer">
                                        <i class="fas fa-info-circle"></i>
                                        <span>Consultation ID: #${consultation.id}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <div class="empty-state-icon">
                            <i class="fas fa-ban"></i>
                        </div>
                        <h3>Aucune consultation annulée</h3>
                        <p>Vous n'avez pas de rendez-vous annulés</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/patient-consultations.js"></script>
</body>
</html>