<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Admin" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
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
    <title>Gestion des Départements - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/departements.css" rel="stylesheet">
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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link ">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/departements" class="nav-link active">
                        <i class="fas fa-building"></i>
                        <span>Départements</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/admin/docteurs" class="nav-link">
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
                        <i class="fas fa-building"></i>
                        Gestion des Départements
                    </h1>
                    <p>Gérez les départements de votre établissement médical</p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/departements?action=nouveau" class="btn-header">
                    <i class="fas fa-plus-circle"></i>
                    Ajouter un Département
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
                    <i class="fas fa-list-alt"></i>
                    Liste des Départements
                </h3>
            </div>
            <div class="table-container">
                <table class="data-table" id="departementsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th><i class="fas fa-building"></i> Nom du Département</th>
                            <th><i class="fas fa-align-left"></i> Description</th>
                            <th><i class="fas fa-toggle-on"></i> Statut</th>
                            <th style="text-align: center;"><i class="fas fa-cog"></i> Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <!-- Affichage dynamique des départements -->
                        <c:choose>
                            <c:when test="${not empty departements}">
                                <c:forEach items="${departements}" var="dept">
                                    <tr data-status="${dept.actif ? 'actif' : 'inactif'}">
                                        <td><strong class="id-badge">${dept.id}</strong></td>
                                        <td>
                                            <div class="departement-badge">
                                                <span>${dept.nom}</span>
                                            </div>
                                        </td>
                                        <td class="description-cell">
                                            <c:choose>
                                                <c:when test="${not empty dept.description}">
                                                    ${dept.description}
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="no-data">
                                                        <i class="fas fa-minus-circle"></i>
                                                        Aucune description
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${dept.actif}">
                                                    <span class="badge success">
                                                        <i class="fas fa-check-circle"></i> Actif
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge warning">
                                                        <i class="fas fa-pause-circle"></i> Inactif
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <a href="${pageContext.request.contextPath}/admin/departements?action=modifier&id=${dept.id}" 
                                                   class="action-btn editdep" 
                                                   title="Modifier le département">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/departements?action=supprimer&id=${dept.id}" 
                                                   class="action-btn deletedep" 
                                                   title="Supprimer le département"
                                                   onclick="return confirm('⚠️ Êtes-vous sûr de vouloir supprimer ce département ?\n\nCette action est irréversible.');">
                                                    <i class="fas fa-trash-alt"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <tr>
                                    <td colspan="5">
                                        <div class="empty-state">
                                            <i class="fas fa-folder-open"></i>
                                            <h3>Aucun département disponible</h3>
                                            <p>Commencez par créer votre premier département en cliquant sur le bouton ci-dessus</p>
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