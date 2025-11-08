<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Admin" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%@ page import="com.clinic.clinicapp.entity.Docteur" %>
<%@ page import="com.clinic.clinicapp.entity.Departement" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
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
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Docteurs - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <!-- <link href="${pageContext.request.contextPath}/assets/css/departements.css" rel="stylesheet"> -->
    <link href="${pageContext.request.contextPath}/assets/css/docteurs.css" rel="stylesheet">
</head>
<body data-context-path="${pageContext.request.contextPath}">
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
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
                    <a href="${pageContext.request.contextPath}/admin/docteurs" class="nav-link active">
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
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1>
                        <i class="fas fa-user-md"></i>
                        Gestion des Docteurs
                    </h1>
                    <p>Gérez les médecins et leurs affectations de votre établissement</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/docteurs?action=nouveau" class="btn-header">
                    <i class="fas fa-user-plus"></i>
                    Ajouter un Docteur
                </a>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${sessionScope.successMessage}</span>
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <span>${sessionScope.errorMessage}</span>
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Table Card -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-list-alt"></i> Liste des Docteurs
                </h3>
            </div>

            <div class="table-container">
                <table class="data-table" id="docteursTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th><i class="fas fa-user-md"></i> Docteur</th>
                            <th><i class="fas fa-stethoscope"></i> Spécialité</th>
                            <th><i class="fas fa-building"></i> Département</th>
                            <th><i class="fas fa-door-open"></i> Salle</th>
                            <th style="text-align: center;"><i class="fas fa-cog"></i> Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <c:choose>
                            <c:when test="${not empty docteurs}">
                                <c:forEach items="${docteurs}" var="docteur">
                                    <tr>
                                        <td><strong class="id-badge">${docteur.id}</strong></td>
                                        <td>
                                            <div class="contact-info">
                                                <span class="name">
                                                    <i class="fas fa-user-md"></i>
                                                    Dr. ${docteur.prenom} ${docteur.nom}
                                                </span>
                                                <span class="email">
                                                    <i class="fas fa-envelope"></i>
                                                    ${docteur.email}
                                                </span>
                                            </div>
                                        </td>
                                        <td>
                                            <span class="specialite-badge">
                                                <i class="fas fa-stethoscope"></i>
                                                ${docteur.specialite}
                                            </span>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty docteur.departement}">
                                                    <span class="badge success">
                                                        <i class="fas ${not empty docteur.departement.icone ? docteur.departement.icone : 'fa-building'}"></i>
                                                        ${docteur.departement.nom}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge warning">
                                                        <i class="fas fa-exclamation-triangle"></i>
                                                        Non affecté
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${not empty docteur.salle}">
                                                    <span class="status-badge assigned">
                                                        <i class="fas fa-door-open"></i>
                                                        ${docteur.salle.nomSalle}
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge unassigned">
                                                        <i class="fas fa-times-circle"></i>
                                                        Aucune salle
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <a href="${pageContext.request.contextPath}/admin/docteurs?action=modifier&id=${docteur.id}" 
                                                   class="btn-icon btn-edit" 
                                                   title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <button onclick="confirmerSuppression(${docteur.id}, '${docteur.prenom} ${docteur.nom}')" 
                                                        class="btn-icon btn-delete" 
                                                        title="Supprimer">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="6">
                                        <div class="empty-state">
                                            <i class="fas fa-user-md"></i>
                                            <h3>Aucun docteur trouvé</h3>
                                            <c:choose>
                                                <c:when test="${not empty critereRecherche}">
                                                    <p>Aucun résultat pour "${critereRecherche}"</p>
                                                </c:when>
                                                <c:otherwise>
                                                    <p>Cliquez sur "Ajouter un Docteur" pour créer votre premier médecin</p>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <script>
        const contextPath = '${pageContext.request.contextPath}';
        
        function confirmerSuppression(id, nom) {
            if (confirm('Êtes-vous sûr de vouloir supprimer le docteur "' + nom + '" ?\n\nCette action est irréversible et supprimera également toutes les consultations associées.')) {
                window.location.href = contextPath + '/admin/docteurs?action=supprimer&id=' + id;
            }
        }
        
        function filtrerParDepartement(departementId) {
            if (departementId) {
                window.location.href = contextPath + '/admin/docteurs?action=filtrer&departementId=' + departementId;
            } else {
                window.location.href = contextPath + '/admin/docteurs';
            }
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
            
            // Animation au chargement
            const rows = document.querySelectorAll('#tableBody tr');
            rows.forEach((row, index) => {
                row.style.animation = `fadeIn 0.5s ease-in-out ${index * 0.05}s both`;
            });
        });
    </script>
</body>
</html>