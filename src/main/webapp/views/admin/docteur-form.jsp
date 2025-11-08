<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%@ page import="com.clinic.clinicapp.entity.Docteur" %>
<%@ page import="com.clinic.clinicapp.entity.Departement" %>
<%@ page import="com.clinic.clinicapp.entity.Salle" %>
<%@ page import="java.util.List" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Personne user = (Personne) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Boolean isEdit = (Boolean) request.getAttribute("isEdit");
    Docteur docteur = (Docteur) request.getAttribute("docteur");
    List<Departement> departements = (List<Departement>) request.getAttribute("departements");
    List<Salle> salles = (List<Salle>) request.getAttribute("salles");
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Modifier" : "Nouveau" %> Docteur - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/docteur-form.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/departement-form.css">
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
        <header class="consultations-header">
            <div class="header-content">
                <div class="header-text">
                    <h1>
                        <i class="fas fa-user-md"></i>
                        <%= isEdit ? "Modifier le Docteur" : "Nouveau Docteur" %>
                    </h1>
                    <p><%= isEdit ? "Modifiez les informations du docteur" : "Ajoutez un nouveau médecin à la clinique" %></p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/admin/docteurs" class="btn-header">
                        <i class="fas fa-arrow-left"></i>
                        Retour à la liste
                    </a>
                </div>
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

        <div class="form-page">
            <div class="form-card">
                <!-- Step Indicator -->
                <div class="form-step-indicator">
                    <div class="step active">
                        <div class="step-number">1</div>
                        <div class="step-label">Informations personnelles</div>
                    </div>
                    <div class="step">
                        <div class="step-number">2</div>
                        <div class="step-label">Informations professionnelles</div>
                    </div>
                </div>

                <% if (!isEdit) { %>
                <div class="info-banner">
                    <i class="fas fa-info-circle"></i>
                    <div>
                        <strong>Information importante</strong>
                        <p>Chaque docteur doit être associé à un département. L'affectation à une salle est optionnelle mais recommandée.</p>
                    </div>
                </div>
                <% } %>
                
                <form action="${pageContext.request.contextPath}/admin/docteurs" method="post" id="docteurForm">
                    <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "creer" %>">
                    <% if (isEdit && docteur != null) { %>
                        <input type="hidden" name="id" value="<%= docteur.getId() %>">
                    <% } %>
                    
                    <!-- Section: Informations personnelles -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-user"></i>
                            </div>
                            <div>
                                <h3 class="section-title">Informations personnelles</h3>
                                <p class="section-subtitle">Renseignez les coordonnées du docteur</p>
                            </div>
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label">
                                    Nom <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-user input-icon"></i>
                                    <input type="text" 
                                           name="nom" 
                                           id="nom" 
                                           class="form-input"
                                           required
                                           value="<%= isEdit && docteur != null ? docteur.getNom() : "" %>"
                                           placeholder="Nom du docteur">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    Prénom <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-user input-icon"></i>
                                    <input type="text" 
                                           name="prenom" 
                                           id="prenom" 
                                           class="form-input"
                                           required
                                           value="<%= isEdit && docteur != null ? docteur.getPrenom() : "" %>"
                                           placeholder="Prénom du docteur">
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label">
                                    Email <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-envelope input-icon"></i>
                                    <input type="email" 
                                           name="email" 
                                           id="email" 
                                           class="form-input"
                                           required
                                           value="<%= isEdit && docteur != null ? docteur.getEmail() : "" %>"
                                           placeholder="email@exemple.com">
                                </div>
                                <span class="help-text">Utilisé pour la connexion au système</span>
                            </div>
                            
                            <% if (!isEdit) { %>
                            <div class="form-group">
                                <label class="form-label">
                                    Mot de passe <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-lock input-icon"></i>
                                    <input type="password" 
                                           name="motDePasse" 
                                           id="motDePasse" 
                                           class="form-input"
                                           required
                                           placeholder="Mot de passe sécurisé"
                                           minlength="6">
                                </div>
                                <span class="help-text">Minimum 6 caractères</span>
                            </div>
                            <% } %>
                        </div>
                    </div>
                    
                    <!-- Section: Informations professionnelles -->
                    <div class="form-section">
                        <div class="section-header">
                            <div class="section-icon">
                                <i class="fas fa-stethoscope"></i>
                            </div>
                            <div>
                                <h3 class="section-title">Informations professionnelles</h3>
                                <p class="section-subtitle">Spécialité et affectation</p>
                            </div>
                        </div>

                        <div class="form-grid-2">
                            <div class="form-group">
                                <label class="form-label">
                                    Spécialité <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-stethoscope input-icon"></i>
                                    <input type="text" 
                                           name="specialite" 
                                           id="specialite" 
                                           class="form-input"
                                           required
                                           value="<%= isEdit && docteur != null ? docteur.getSpecialite() : "" %>"
                                           placeholder="Ex: Cardiologie, Pédiatrie, etc.">
                                </div>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">
                                    Département <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-building input-icon"></i>
                                    <select name="departementId" id="departementId" class="form-input" required onchange="chargerSallesDuDepartement(this.value)">
                                        <option value="">Sélectionnez un département</option>
                                        <% if (departements != null) {
                                            for (Departement dept : departements) { %>
                                                <option value="<%= dept.getId() %>" 
                                                        <%= isEdit && docteur != null && docteur.getDepartement() != null && 
                                                            docteur.getDepartement().getId().equals(dept.getId()) ? "selected" : "" %>>
                                                    <%= dept.getNom() %>
                                                </option>
                                            <% }
                                        } %>
                                    </select>
                                </div>
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">
                                Salle <span class="required">*</span>
                            </label>
                            <div class="input-wrapper">
                                <i class="fas fa-door-open input-icon"></i>
                                <select name="salleId" id="salleId" class="form-input">
                                    <option value="">Aucune salle </option>
                                    <% if (salles != null) {
                                        for (Salle salle : salles) { %>
                                            <option value="<%= salle.getId() %>" 
                                                    data-departement="<%= salle.getDepartement().getId() %>"
                                                    <%= isEdit && docteur != null && docteur.getSalle() != null && 
                                                        docteur.getSalle().getId().equals(salle.getId()) ? "selected" : "" %>>
                                                <%= salle.getNomSalle() %> - <%= salle.getDepartement().getNom() %>
                                            </option>
                                        <% }
                                    } %>
                                </select>
                            </div>
                            <span class="help-text">La salle sera filtrée selon le département sélectionné</span>
                        </div>
                    </div>
                    
                    <!-- Actions -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/docteurs" class="btn-cancel">
                            <i class="fas fa-times"></i>
                            Annuler
                        </a>
                        <button type="submit" class="btn-submit">
                            <i class="fas fa-save"></i>
                            <%= isEdit ? "Enregistrer les modifications" : "Créer le docteur" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</body>
</html>
