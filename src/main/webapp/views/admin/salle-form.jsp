<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Admin" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%@ page import="com.clinic.clinicapp.entity.Salle" %>
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
    
    Salle salle = (Salle) request.getAttribute("salle");
    Boolean isEdit = (Boolean) request.getAttribute("isEdit");
    if (isEdit == null) isEdit = false;
    
    String userName = session.getAttribute("userName") != null ? 
                      (String) session.getAttribute("userName") : 
                      user.getPrenom() + " " + user.getNom();
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Modifier" : "Ajouter" %> Salle - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/departements.css" rel="stylesheet">
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
                    <a href="${pageContext.request.contextPath}/admin/salles" class="nav-link active">
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
                <h1><%= isEdit ? "Modifier" : "Ajouter" %> une Salle</h1>
                <p><%= isEdit ? "Modifiez les informations de la salle" : "Ajoutez une nouvelle salle de consultation" %></p>
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

        <!-- Form Card -->
        <div class="card form-card">
            <div class="card-header">
                <h3 class="card-title">
                    <i class="fas fa-door-open"></i>
                    Informations de la Salle
                </h3>
            </div>

            <form method="POST" action="${pageContext.request.contextPath}/admin/salles">
                <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "creer" %>">
                <% if (isEdit && salle != null) { %>
                    <input type="hidden" name="id" value="<%= salle.getId() %>">
                <% } %>

                <div class="form-grid">
                    <!-- Nom de la salle -->
                    <div class="form-group">
                        <label for="nomSalle" class="form-label">
                            <i class="fas fa-door-open"></i>
                            Nom de la Salle <span class="required">*</span>
                        </label>
                        <input 
                            type="text" 
                            id="nomSalle" 
                            name="nomSalle" 
                            class="form-control"
                            placeholder="Ex: Salle 101"
                            value="<%= isEdit && salle != null ? salle.getNomSalle() : "" %>"
                            required
                        >
                    </div>

                    <!-- Département -->
                    <div class="form-group">
                        <label for="departementId" class="form-label">
                            <i class="fas fa-building"></i>
                            Département <span class="required">*</span>
                        </label>
                        <select id="departementId" name="departementId" class="form-control" required>
                            <option value="">-- Sélectionner un département --</option>
                            <c:forEach items="${departements}" var="dept">
                                <option value="${dept.id}">
                                    ${dept.nom}
                                </option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Capacité -->
                    <div class="form-group">
                        <label for="capacite" class="form-label">
                            <i class="fas fa-users"></i>
                            Capacité
                        </label>
                        <input 
                            type="number" 
                            id="capacite" 
                            name="capacite" 
                            class="form-control"
                            placeholder="Ex: 1"
                            min="1"
                            value="<%= isEdit && salle != null && salle.getCapacite() != null ? salle.getCapacite() : "" %>"
                        >
                    </div>
                </div>

                <!-- Description -->
                <div class="form-group">
                    <label for="description" class="form-label">
                        <i class="fas fa-align-left"></i>
                        Description
                    </label>
                    <textarea 
                        id="description" 
                        name="description" 
                        class="form-control"
                        rows="4"
                        placeholder="Ajoutez une description de la salle..."
                    ><%= isEdit && salle != null && salle.getDescription() != null ? salle.getDescription() : "" %></textarea>
                </div>

                <!-- Boutons d'action -->
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/salles" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas <%= isEdit ? "fa-save" : "fa-plus" %>"></i>
                        <%= isEdit ? "Enregistrer" : "Créer" %>
                    </button>
                </div>
            </form>
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

        .form-card {
            max-width: 900px;
            margin: 0 auto;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 1.5rem;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-label {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            font-weight: 500;
            margin-bottom: 0.5rem;
            color: #2c3e50;
        }

        .form-label i {
            color: #3498db;
        }

        .required {
            color: #e74c3c;
        }

        .form-control {
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }

        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }

        textarea.form-control {
            resize: vertical;
            min-height: 100px;
        }

        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid #eee;
        }

        .btn {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
        }

        .btn-primary {
            background: #3498db;
            color: white;
        }

        .btn-primary:hover {
            background: #2980b9;
        }

        .btn-secondary {
            background: #95a5a6;
            color: white;
        }

        .btn-secondary:hover {
            background: #7f8c8d;
        }
    </style>

    <script>
        // Pré-sélectionner le département en mode édition
        document.addEventListener('DOMContentLoaded', function() {
            <% if (isEdit && salle != null && salle.getDepartement() != null) { %>
                const departementSelect = document.getElementById('departementId');
                const departementId = '<%= salle.getDepartement().getId() %>';
                departementSelect.value = departementId;
            <% } %>
        });
    </script>
</body>
</html>
