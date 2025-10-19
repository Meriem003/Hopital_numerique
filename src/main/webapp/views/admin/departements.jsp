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
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link">
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
                <h1>Gestion des Départements</h1>
                <p>Gérez les départements de la clinique</p>
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

        <!-- Action Section -->
        <div class="search-section">
            <div class="search-container">
                <a href="${pageContext.request.contextPath}/admin/departements?action=nouveau" class="btn-primary">
                    <i class="fas fa-plus"></i>
                    Ajouter Département
                </a>
            </div>
        </div>

        <!-- Table Card -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">Liste des Départements</h3>
            </div>

            <div class="table-actions">
                <div class="table-info">
                    <span id="tableInfo">Affichage de <strong>${departements != null ? departements.size() : 0}</strong> département(s)</span>
                </div>
            </div>

            <div class="table-container">
                <table class="data-table" id="departementsTable">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom du Département</th>
                            <th>Description</th>
                            <th>Nombre de Docteurs</th>
                            <th>Nombre de Salles</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody id="tableBody">
                        <!-- Affichage dynamique des départements depuis la base de données -->
                        <c:choose>
                            <c:when test="${not empty departements}">
                                <c:forEach items="${departements}" var="dept">
                                    <tr data-status="${dept.actif ? 'actif' : 'inactif'}">
                                        <td>#${dept.id}</td>
                                        <td>
                                            <div class="departement-badge">
                                                <i class="fas ${not empty dept.icone ? dept.icone : 'fa-building'}"></i>
                                                ${dept.nom}
                                            </div>
                                        </td>
                                        <td>${dept.description}</td>
                                        <td>-</td>
                                        <td>-</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${dept.actif}">
                                                    <span class="badge success"><i class="fas fa-check"></i> Actif</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge warning"><i class="fas fa-pause"></i> Inactif</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <div class="action-btns">
                                                <a href="${pageContext.request.contextPath}/admin/departements?action=modifier&id=${dept.id}" 
                                                   class="action-btn edit" 
                                                   title="Modifier">
                                                    <i class="fas fa-edit"></i>
                                                </a>
                                                <a href="${pageContext.request.contextPath}/admin/departements?action=supprimer&id=${dept.id}" 
                                                   class="action-btn delete" 
                                                   title="Supprimer"
                                                   onclick="return confirm('Êtes-vous sûr de vouloir supprimer ce département ?');">
                                                    <i class="fas fa-trash"></i>
                                                </a>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <!-- Données exemples si aucune donnée n'est disponible -->
                                <tr data-status="actif">
                                    <td colspan="7" style="text-align: center; padding: 2rem; color: var(--gray-600);">
                                        <i class="fas fa-inbox" style="font-size: 3rem; color: var(--gray-300); display: block; margin-bottom: 1rem;"></i>
                                        <h3>Aucun département disponible</h3>
                                        <p>Cliquez sur "Ajouter Département" pour créer votre premier département</p>
                                    </td>
                                </tr>
                            </c:otherwise>
                        </c:choose>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <style>
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        
        .alert i {
            font-size: 1.25rem;
        }
        
        .action-btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            color: white;
            font-size: 0.9rem;
            margin: 0 0.25rem;
        }
        
        .action-btn.edit {
            background: #3498db;
        }
        
        .action-btn.edit:hover {
            background: #2980b9;
        }
        
        .action-btn.delete {
            background: #e74c3c;
        }
        
        .action-btn.delete:hover {
            background: #c0392b;
        }
        
        .btn-primary {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            background: #3498db;
            color: white;
            border: none;
            border-radius: 4px;
            text-decoration: none;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .btn-primary:hover {
            background: #2980b9;
        }
    </style>
</body>
</html>
