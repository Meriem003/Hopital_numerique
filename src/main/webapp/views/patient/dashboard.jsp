<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Patient - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
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
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link active">
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
                <h1>Bienvenue ${sessionScope.user.prenom}</h1>
                <p>Gérez vos rendez-vous et consultez votre dossier médical</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/patient/reserver" class="header-btn">
                    <i class="fas fa-calendar-plus"></i>
                    Nouveau Rendez-vous
                </a>
            </div>
        </header>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background: #fee; color: #c33; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">
                ${error}
            </div>
        </c:if>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon blue">
                        <i class="fas fa-calendar-check"></i>
                    </div>
                </div>
                <div class="stat-value">${not empty consultationsAVenir ? consultationsAVenir.size() : 0}</div>
                <div class="stat-label">RDV à Venir</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon green">
                        <i class="fas fa-check-circle"></i>
                    </div>
                </div>
                <div class="stat-value">${not empty historique ? historique.size() : 0}</div>
                <div class="stat-label">Consultations Effectuées</div>
            </div>

            <div class="stat-card">
                <div class="stat-header">
                    <div class="stat-icon orange">
                        <i class="fas fa-user-md"></i>
                    </div>
                </div>
                <div class="stat-value">2</div>
                <div class="stat-label">Docteurs Suivis</div>
            </div>
        </div>

        <div class="content-grid">
            <div class="card">
                <div class="card-header">
                    <h3 class="card-title">Prochains Rendez-vous</h3>
                    <a href="${pageContext.request.contextPath}/patient/consultations" class="card-action">
                        Voir tous <i class="fas fa-arrow-right"></i>
                    </a>
                </div>
                <div>
                    <c:choose>
                        <c:when test="${not empty consultationsAVenir}">
                            <c:forEach items="${consultationsAVenir}" var="consultation" begin="0" end="2">
                                <div class="appointment-item">
                                    <div class="appointment-date">
                                        <div class="day">
                                            <fmt:formatDate value="${consultation.date}" pattern="dd" />
                                        </div>
                                        <div class="month">
                                            <fmt:formatDate value="${consultation.date}" pattern="MMM" />
                                        </div>
                                    </div>
                                    <div class="appointment-info">
                                        <h4>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom} - ${consultation.docteur.departement.nom}</h4>
                                        <p><i class="fas fa-clock"></i> <fmt:formatDate value="${consultation.date}" pattern="HH:mm" /> - Salle ${not empty consultation.salle ? consultation.salle.numero : 'N/A'}</p>
                                        <p><i class="fas fa-notes-medical"></i> ${not empty consultation.motif ? consultation.motif : 'Consultation'}</p>
                                        <c:choose>
                                            <c:when test="${consultation.statut == 'VALIDEE'}">
                                                <span class="badge success"><i class="fas fa-check"></i> Validé</span>
                                            </c:when>
                                            <c:when test="${consultation.statut == 'RESERVEE'}">
                                                <span class="badge warning"><i class="fas fa-clock"></i> En attente</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge info"><i class="fas fa-calendar"></i> ${consultation.statut}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                    <div class="appointment-actions">
                                        <button class="btn-sm btn-outline"><i class="fas fa-edit"></i> Modifier</button>
                                        <button class="btn-sm btn-danger"><i class="fas fa-times"></i></button>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div style="text-align: center; padding: 3rem; color: var(--gray-600);">
                                <i class="fas fa-calendar-times" style="font-size: 3rem; margin-bottom: 1rem; opacity: 0.3;"></i>
                                <p>Aucun rendez-vous à venir</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div>
                <div class="card" style="margin-bottom: 1.5rem;">
                    <div class="card-header">
                        <h3 class="card-title">Informations Santé</h3>
                    </div>
                    <div class="health-info">
                        <div class="health-item">
                            <div class="label">Poids</div>
                            <div class="value">
                                ${not empty patient.poids ? patient.poids : '--'} 
                                <span class="unit"><c:if test="${not empty patient.poids}">kg</c:if></span>
                            </div>
                        </div>
                        <div class="health-item">
                            <div class="label">Taille</div>
                            <div class="value">
                                ${not empty patient.taille ? patient.taille : '--'} 
                                <span class="unit"><c:if test="${not empty patient.taille}">cm</c:if></span>
                            </div>
                        </div>
                        <div class="health-item">
                            <div class="label">Âge</div>
                            <div class="value">
                                <c:choose>
                                    <c:when test="${not empty patient.dateNaissance}">
                                        <jsp:useBean id="now" class="java.util.Date"/>
                                        <c:set var="age" value="${(now.time - patient.dateNaissance.time) / (1000 * 60 * 60 * 24 * 365)}" />
                                        <fmt:formatNumber value="${age}" pattern="#" var="ageFormatted"/>
                                        ${ageFormatted}
                                    </c:when>
                                    <c:otherwise>--</c:otherwise>
                                </c:choose>
                                <span class="unit"><c:if test="${not empty patient.dateNaissance}">ans</c:if></span>
                            </div>
                        </div>
                        <div class="health-item">
                            <div class="label">Groupe Sanguin</div>
                            <div class="value" style="font-size: 1.2rem;">
                                ${not empty patient.groupeSanguin ? patient.groupeSanguin : '--'}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-header">
                        <h3 class="card-title">Dernières Consultations</h3>
                        <a href="${pageContext.request.contextPath}/patient/historique" class="card-action">
                            Voir tous <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                    <div>
                        <c:choose>
                            <c:when test="${not empty historique}">
                                <c:forEach items="${historique}" var="consultation" begin="0" end="2">
                                    <div class="doctor-card">
                                        <div class="doctor-avatar">
                                            <i class="fas fa-user-md"></i>
                                        </div>
                                        <div class="doctor-info">
                                            <h4>Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}</h4>
                                            <p><fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy à HH:mm" /></p>
                                            <c:if test="${not empty consultation.compteRendu}">
                                                <p style="font-size: 0.75rem; margin-top: 0.25rem;">
                                                    ${consultation.compteRendu.length() > 50 ? consultation.compteRendu.substring(0, 50).concat('...') : consultation.compteRendu}
                                                </p>
                                            </c:if>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <div style="text-align: center; padding: 2rem; color: var(--gray-600);">
                                    <i class="fas fa-history" style="font-size: 2rem; margin-bottom: 0.5rem; opacity: 0.3;"></i>
                                    <p style="font-size: 0.9rem;">Aucun historique</p>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
    </main>
</body>
</html>
