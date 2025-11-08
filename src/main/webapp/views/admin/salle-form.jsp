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
    <link href="${pageContext.request.contextPath}/assets/css/salle-form.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/departement-form.css">
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
                        <i class="fas <%= isEdit ? "fa-edit" : "fa-plus-circle" %>"></i>
                        <%= isEdit ? "Modifier la Salle" : "Nouvelle Salle" %>
                    </h1>
                    <p><%= isEdit ? "Modifiez les informations de la salle" : "Ajoutez une nouvelle salle de consultation à votre établissement" %></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/salles" class="btn-header-back">
                    <i class="fas fa-arrow-left"></i>
                    Retour à la liste
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

        <!-- Form Card -->
        <div class="form-page">
            <div class="form-card">
                <div class="form-header">
                    <div class="form-step-indicator">
                        <div class="step-item active">
                            <div class="step-number">1</div>
                            <div class="step-label">Informations</div>
                        </div>
                        <div class="step-line"></div>
                        <div class="step-item">
                            <div class="step-number">2</div>
                            <div class="step-label">Validation</div>
                        </div>
                    </div>
                </div>

                <form method="POST" action="${pageContext.request.contextPath}/admin/salles">
                    <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "creer" %>">
                    <% if (isEdit && salle != null) { %>
                        <input type="hidden" name="id" value="<%= salle.getId() %>">
                    <% } %>

                    <!-- Nom de la salle -->
                    <div class="form-group">
                        <label for="nomSalle">
                            <i class="fas fa-door-open"></i> Nom de la Salle <span class="required">*</span>
                        </label>
                        <div class="input-wrapper">
                            <input 
                                type="text" 
                                id="nomSalle" 
                                name="nomSalle" 
                                required 
                                placeholder="Ex: Salle 101, Cabinet A, Bloc Opératoire 1..."
                                value="<%= isEdit && salle != null ? salle.getNomSalle() : "" %>"
                            >
                            <i class="input-icon fas fa-door-open"></i>
                        </div>
                        <small class="help-text">Le nom doit être unique et descriptif</small>
                    </div>

                    <!-- Département -->
                    <div class="form-group">
                        <label for="departementId">
                            <i class="fas fa-building"></i> Département <span class="required">*</span>
                        </label>
                        <div class="input-wrapper">
                            <select id="departementId" name="departementId" required>
                                <option value="">-- Sélectionner un département --</option>
                                <c:forEach items="${departements}" var="dept">
                                    <option value="${dept.id}" 
                                            <c:if test="${isEdit && salle != null && salle.departement != null && salle.departement.id == dept.id}">selected</c:if>>
                                        ${dept.nom}
                                    </option>
                                </c:forEach>
                            </select>
                            <i class="input-icon fas fa-building"></i>
                        </div>
                        <small class="help-text">
                            <i class="fas fa-info-circle"></i>
                            Choisissez le département auquel cette salle appartient
                        </small>
                    </div>

                    <!-- Capacité -->
                    <div class="form-group">
                        <label for="capacite">
                            <i class="fas fa-users"></i> Capacité
                        </label>
                        <div class="input-wrapper">
                            <input 
                                type="number" 
                                id="capacite" 
                                name="capacite" 
                                placeholder="Ex: 1, 2, 5..."
                                min="1"
                                max="100"
                                value="<%= isEdit && salle != null && salle.getCapacite() != null ? salle.getCapacite() : "" %>"
                            >
                            <i class="input-icon fas fa-users"></i>
                        </div>
                        <small class="help-text">
                            <i class="fas fa-lightbulb"></i>
                            Nombre de personnes pouvant être accueillies simultanément
                        </small>
                    </div>

                    <!-- Description -->
                    <div class="form-group">
                        <label for="description">
                            <i class="fas fa-align-left"></i> Description
                        </label>
                        <div class="input-wrapper">
                            <textarea 
                                id="description" 
                                name="description" 
                                rows="5"
                                placeholder="Décrivez l'équipement et les caractéristiques de la salle..."
                            ><%= isEdit && salle != null && salle.getDescription() != null ? salle.getDescription() : "" %></textarea>
                            <i class="input-icon fas fa-align-left"></i>
                        </div>
                        <small class="help-text">
                            <i class="fas fa-info-circle"></i>
                            Ajoutez des détails sur l'équipement, les spécificités ou les particularités
                        </small>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/salles" class="btn btn-secondary">
                            <i class="fas fa-times-circle"></i>
                            Annuler
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas <%= isEdit ? "fa-save" : "fa-plus-circle" %>"></i>
                            <%= isEdit ? "Mettre à jour la salle" : "Créer la salle" %>
                        </button>
                    </div>
                </form>
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
            
            // Pre-select department if editing
            <% if (isEdit && salle != null && salle.getDepartement() != null) { %>
                const departementSelect = document.getElementById('departementId');
                if (departementSelect) {
                    departementSelect.value = '<%= salle.getDepartement().getId() %>';
                }
            <% } %>
        });
    </script>
</body>
</html>
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
