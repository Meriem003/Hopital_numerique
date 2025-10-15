<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tableau de bord - Patient</title>
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
    <style>
        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .dashboard-header {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .dashboard-header h1 {
            color: #667eea;
            margin-bottom: 10px;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .stat-card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            text-align: center;
        }
        
        .stat-card h3 {
            color: #666;
            font-size: 14px;
            margin-bottom: 10px;
        }
        
        .stat-card .stat-value {
            font-size: 36px;
            font-weight: bold;
            color: #667eea;
        }
        
        .section-card {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .section-card h2 {
            color: #333;
            margin-bottom: 20px;
            font-size: 24px;
        }
        
        .consultation-list {
            list-style: none;
            padding: 0;
        }
        
        .consultation-item {
            padding: 15px;
            border: 1px solid #e1e8ed;
            border-radius: 6px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .consultation-info {
            flex: 1;
        }
        
        .consultation-date {
            font-weight: bold;
            color: #667eea;
        }
        
        .consultation-doctor {
            color: #666;
            margin-top: 5px;
        }
        
        .consultation-status {
            padding: 5px 15px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 500;
        }
        
        .status-reservee { background: #fff3cd; color: #856404; }
        .status-validee { background: #d4edda; color: #155724; }
        .status-annulee { background: #f8d7da; color: #721c24; }
        .status-terminee { background: #d1ecf1; color: #0c5460; }
        
        .action-buttons {
            margin-top: 30px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }
        
        .empty-state {
            text-align: center;
            padding: 40px;
            color: #999;
        }
    </style>
</head>
<body>
    <jsp:include page="/views/shared/navbar.jsp" />
    
    <div class="dashboard-container">
        <div class="dashboard-header">
            <h1>Bienvenue, ${sessionScope.user.prenom} ${sessionScope.user.nom}</h1>
            <p>Voici un aperçu de vos consultations et informations médicales</p>
        </div>
        
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                ${error}
            </div>
        </c:if>
        
        <div class="stats-grid">
            <div class="stat-card">
                <h3>Consultations à venir</h3>
                <div class="stat-value">${not empty consultationsAVenir ? consultationsAVenir.size() : 0}</div>
            </div>
            
            <div class="stat-card">
                <h3>Total consultations</h3>
                <div class="stat-value">${not empty historique ? historique.size() : 0}</div>
            </div>
            
            <div class="stat-card">
                <h3>Poids</h3>
                <div class="stat-value">
                    ${not empty patient.poids ? patient.poids : 'N/A'} 
                    <c:if test="${not empty patient.poids}">kg</c:if>
                </div>
            </div>
            
            <div class="stat-card">
                <h3>Taille</h3>
                <div class="stat-value">
                    ${not empty patient.taille ? patient.taille : 'N/A'} 
                    <c:if test="${not empty patient.taille}">cm</c:if>
                </div>
            </div>
        </div>
        
        <div class="section-card">
            <h2>📅 Consultations à venir</h2>
            
            <c:choose>
                <c:when test="${not empty consultationsAVenir}">
                    <ul class="consultation-list">
                        <c:forEach items="${consultationsAVenir}" var="consultation">
                            <li class="consultation-item">
                                <div class="consultation-info">
                                    <div class="consultation-date">
                                        <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy à HH:mm" />
                                    </div>
                                    <div class="consultation-doctor">
                                        Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}
                                    </div>
                                    <c:if test="${not empty consultation.motif}">
                                        <div style="margin-top: 5px; color: #888; font-size: 14px;">
                                            Motif: ${consultation.motif}
                                        </div>
                                    </c:if>
                                </div>
                                <div>
                                    <span class="consultation-status status-${consultation.statut.toString().toLowerCase()}">
                                        ${consultation.statut}
                                    </span>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>Aucune consultation à venir</p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/patient/docteurs" class="btn btn-primary">
                    Réserver une consultation
                </a>
            </div>
        </div>
        
        <div class="section-card">
            <h2>📋 Historique des consultations</h2>
            
            <c:choose>
                <c:when test="${not empty historique}">
                    <ul class="consultation-list">
                        <c:forEach items="${historique}" var="consultation" begin="0" end="4">
                            <li class="consultation-item">
                                <div class="consultation-info">
                                    <div class="consultation-date">
                                        <fmt:formatDate value="${consultation.date}" pattern="dd/MM/yyyy à HH:mm" />
                                    </div>
                                    <div class="consultation-doctor">
                                        Dr. ${consultation.docteur.nom} ${consultation.docteur.prenom}
                                    </div>
                                    <c:if test="${not empty consultation.compteRendu}">
                                        <div style="margin-top: 5px; color: #555; font-size: 14px;">
                                            ${consultation.compteRendu}
                                        </div>
                                    </c:if>
                                </div>
                                <div>
                                    <span class="consultation-status status-${consultation.statut.toString().toLowerCase()}">
                                        ${consultation.statut}
                                    </span>
                                </div>
                            </li>
                        </c:forEach>
                    </ul>
                </c:when>
                <c:otherwise>
                    <div class="empty-state">
                        <p>Aucun historique de consultation</p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <c:if test="${not empty historique and historique.size() > 5}">
                <div class="action-buttons">
                    <a href="${pageContext.request.contextPath}/patient/consultations" class="btn btn-outline">
                        Voir tout l'historique
                    </a>
                </div>
            </c:if>
        </div>
    </div>
</body>
</html>
