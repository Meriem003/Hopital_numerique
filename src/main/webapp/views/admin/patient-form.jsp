<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Patient" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%
    Personne user = (Personne) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    Patient patient = (Patient) request.getAttribute("patient");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("errorMessage");
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Modifier Patient - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-form.css" rel="stylesheet">
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
                    <a href="${pageContext.request.contextPath}/admin/patients" class="nav-link active">
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
                        <i class="fas fa-user-edit"></i>
                        Modifier Patient
                    </h1>
                    <p>Modification des informations du patient</p>
                </div>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/admin/patients" class="btn-header">
                        <i class="fas fa-arrow-left"></i>
                        Retour à la liste
                    </a>
                </div>
            </div>
        </header>

        <!-- Messages -->
        <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= errorMessage %>
            </div>
        <% } %>

        <div class="form-page">
            <div class="form-card">
                <% if (patient != null) { %>
                    <!-- Step Indicator -->
                    <div class="form-step-indicator">
                        <div class="step active">
                            <div class="step-number">1</div>
                            <div class="step-label">Informations personnelles</div>
                        </div>
                        <div class="step">
                            <div class="step-number">2</div>
                            <div class="step-label">Informations médicales</div>
                        </div>
                    </div>

                    <!-- Informations actuelles -->
                    <div class="info-banner">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong>Informations actuelles</strong>
                            <p>Patient ID:<%= patient.getId() %><% if (patient.getIMC() != null) { %> - IMC actuel: <%= patient.getIMC() %><% } %></p>
                        </div>
                    </div>

                    <!-- Formulaire -->
                    <form method="post" action="${pageContext.request.contextPath}/admin/patients">
                        <input type="hidden" name="action" value="modifier">
                        <input type="hidden" name="id" value="<%= patient.getId() %>">

                        <!-- Section: Informations personnelles -->
                        <div class="form-section">
                            <div class="section-header">
                                <div class="section-icon">
                                    <i class="fas fa-user"></i>
                                </div>
                                <div>
                                    <h3 class="section-title">Informations personnelles</h3>
                                    <p class="section-subtitle">Coordonnées du patient</p>
                                </div>
                            </div>

                            <div class="form-grid-2">
                                <!-- Nom -->
                                <div class="form-group">
                                    <label class="form-label">
                                        Nom <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-user input-icon"></i>
                                        <input 
                                            type="text" 
                                            id="nom" 
                                            name="nom" 
                                            class="form-input" 
                                            value="<%= patient.getNom() %>"
                                            required>
                                    </div>
                                </div>

                                <!-- Prénom -->
                                <div class="form-group">
                                    <label class="form-label">
                                        Prénom <span class="required">*</span>
                                    </label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-user input-icon"></i>
                                        <input 
                                            type="text" 
                                            id="prenom" 
                                            name="prenom" 
                                            class="form-input" 
                                            value="<%= patient.getPrenom() %>"
                                            required>
                                    </div>
                                </div>
                            </div>

                            <!-- Email -->
                            <div class="form-group">
                                <label class="form-label">
                                    Email <span class="required">*</span>
                                </label>
                                <div class="input-wrapper">
                                    <i class="fas fa-envelope input-icon"></i>
                                    <input 
                                        type="email" 
                                        id="email" 
                                        name="email" 
                                        class="form-input" 
                                        value="<%= patient.getEmail() %>"
                                        required>
                                </div>
                            </div>
                        </div>

                        <!-- Section: Informations médicales -->
                        <div class="form-section">
                            <div class="section-header">
                                <div class="section-icon">
                                    <i class="fas fa-heartbeat"></i>
                                </div>
                                <div>
                                    <h3 class="section-title">Informations médicales</h3>
                                    <p class="section-subtitle">Données de santé</p>
                                </div>
                            </div>

                            <div class="form-grid-2">
                                <!-- Poids -->
                                <div class="form-group">
                                    <label class="form-label">
                                        Poids (kg)
                                    </label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-weight input-icon"></i>
                                        <input 
                                            type="number" 
                                            step="0.1" 
                                            id="poids" 
                                            name="poids" 
                                            class="form-input" 
                                            value="<%= patient.getPoids() != null ? patient.getPoids() : "" %>"
                                            placeholder="Ex: 70.5">
                                    </div>
                                    <span class="help-text">Entrez le poids en kilogrammes</span>
                                </div>

                                <!-- Taille -->
                                <div class="form-group">
                                    <label class="form-label">
                                        Taille (cm)
                                    </label>
                                    <div class="input-wrapper">
                                        <i class="fas fa-ruler-vertical input-icon"></i>
                                        <input 
                                            type="number" 
                                            id="taille" 
                                            name="taille" 
                                            class="form-input" 
                                            value="<%= patient.getTaille() != null ? patient.getTaille() : "" %>"
                                            placeholder="Ex: 175">
                                    </div>
                                    <span class="help-text">Entrez la taille en centimètres</span>
                                </div>
                            </div>
                        </div>

                        <!-- Boutons d'action -->
                        <div class="form-actions">
                            <a href="${pageContext.request.contextPath}/admin/patients" class="btn-cancel">
                                <i class="fas fa-times"></i>
                                Annuler
                            </a>
                            <button type="submit" class="btn-submit">
                                <i class="fas fa-save"></i>
                                Enregistrer les modifications
                            </button>
                        </div>
                        </div>
                    </form>
                <% } else { %>
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        Patient introuvable
                    </div>
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/patients" class="btn-cancel">
                            <i class="fas fa-arrow-left"></i>
                            Retour à la liste
                        </a>
                    </div>
                <% } %>
            </div>
        </div>
    </main>
</body>
</html>
