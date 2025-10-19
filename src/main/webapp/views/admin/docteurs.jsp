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
    <link href="${pageContext.request.contextPath}/assets/css/departements.css" rel="stylesheet">
    <style>
        .specialite-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }
        
        .contact-info {
            display: flex;
            flex-direction: column;
            gap: 0.25rem;
        }
        
        .contact-info .name {
            font-weight: 600;
            color: #2d3748;
        }
        
        .contact-info .email {
            font-size: 0.875rem;
            color: #718096;
        }
        
        .filter-section {
            display: flex;
            gap: 1rem;
            margin-bottom: 1.5rem;
            align-items: center;
        }
        
        .filter-group {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .filter-group label {
            font-weight: 500;
            color: #4a5568;
        }
        
        .filter-group select {
            padding: 0.5rem 1rem;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            font-size: 0.875rem;
            min-width: 200px;
        }
        
        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .status-badge.assigned {
            background-color: #c6f6d5;
            color: #22543d;
        }
        
        .status-badge.unassigned {
            background-color: #fed7d7;
            color: #742a2a;
        }
    </style>
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
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/views/admin/consultations.jsp" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Consultations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/views/admin/statistiques.jsp" class="nav-link">
                        <i class="fas fa-chart-pie"></i>
                        <span>Statistiques</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/views/admin/parametres.jsp" class="nav-link">
                        <i class="fas fa-cog"></i>
                        <span>Paramètres</span>
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
        <header class="header">
            <div class="header-title">
                <h1>Gestion des Docteurs</h1>
                <p>Gérez les médecins et leurs affectations</p>
            </div>
        </header>

        <!-- Messages -->
        <c:if test="${not empty sessionScope.successMessage}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i> ${sessionScope.successMessage}
            </div>
            <c:remove var="successMessage" scope="session" />
        </c:if>
        
        <c:if test="${not empty sessionScope.errorMessage}">
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i> ${sessionScope.errorMessage}
            </div>
            <c:remove var="errorMessage" scope="session" />
        </c:if>

        <!-- Filter and Search Section -->
        <div class="search-section">
            <div class="filter-section">
                <div class="filter-group">
                    <label for="departementFilter">
                        <i class="fas fa-filter"></i> Filtrer par département:
                    </label>
                    <select id="departementFilter" onchange="filtrerParDepartement(this.value)">
                        <option value="">Tous les départements</option>
                        <c:forEach items="${departements}" var="dept">
                            <option value="${dept.id}" ${departementIdFiltre == dept.id ? 'selected' : ''}>
                                ${dept.nom}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="search-container">
                    <form action="${pageContext.request.contextPath}/admin/docteurs" method="get" style="display: flex; gap: 0.5rem;">
                        <input type="hidden" name="action" value="rechercher">
                        <input type="text" 
                               name="critere" 
                               placeholder="Rechercher un docteur (nom, prénom, email, spécialité)..." 
                               value="${critereRecherche}"
                               style="min-width: 300px; padding: 0.5rem 1rem; border: 1px solid #e2e8f0; border-radius: 8px;">
                        <button type="submit" class="btn-primary" style="white-space: nowrap;">
                            <i class="fas fa-search"></i> Rechercher
                        </button>
                        <c:if test="${not empty critereRecherche}">
                            <a href="${pageContext.request.contextPath}/admin/docteurs" class="btn-secondary">
                                <i class="fas fa-times"></i> Réinitialiser
                            </a>
                        </c:if>
                    </form>
                </div>
            </div>
            
            <a href="${pageContext.request.contextPath}/admin/docteurs?action=nouveau" class="btn-primary">
                <i class="fas fa-plus"></i>
                Ajouter Docteur
            </a>
        </div>

        <!-- Table Card -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-user-md"></i> Liste des Docteurs
                </h3>
            </div>

            <div class="table-actions">
                <div class="table-info">
                    <span id="tableInfo">
                        Affichage de <strong>${docteurs != null ? docteurs.size() : 0}</strong> docteur(s)
                        <c:if test="${not empty critereRecherche}">
                            pour "<strong>${critereRecherche}</strong>"
                        </c:if>
                        <c:if test="${not empty departementIdFiltre}">
                            dans le département sélectionné
                        </c:if>
                    </span>
                </div>
            </div>

            <div class="table-container">
                <table class="data-table" id="docteursTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Docteur</th>
                            <th>Spécialité</th>
                            <th>Département</th>
                            <th>Salle</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <c:choose>
                            <c:when test="${not empty docteurs}">
                                <c:forEach items="${docteurs}" var="docteur">
                                    <tr>
                                        <td>#${docteur.id}</td>
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
                                                    <span class="badge info">
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
                                                        <i class="fas fa-times"></i>
                                                        Aucune salle
                                                    </span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <a href="${pageContext.request.contextPath}/admin/docteurs?action=modifier&id=${docteur.id}" class="btn-icon btn-edit" title="Modifier">
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
                                    <td colspan="6" class="empty-state">
                                        <i class="fas fa-user-md" style="font-size: 3rem; color: #cbd5e0; margin-bottom: 1rem;"></i>
                                        <p style="color: #718096; font-size: 1.1rem;">Aucun docteur trouvé</p>
                                        <c:if test="${not empty critereRecherche}">
                                            <p style="color: #a0aec0; margin-top: 0.5rem;">
                                                Aucun résultat pour "${critereRecherche}"
                                            </p>
                                        </c:if>
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
        
        // Animation au chargement
        document.addEventListener('DOMContentLoaded', function() {
            const rows = document.querySelectorAll('#tableBody tr');
            rows.forEach((row, index) => {
                row.style.animation = `fadeIn 0.5s ease-in-out ${index * 0.05}s both`;
            });
        });
        
        // Style pour l'animation
        const style = document.createElement('style');
        style.textContent = `
            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(10px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }
        `;
        document.head.appendChild(style);
    </script>
</body>
</html>
