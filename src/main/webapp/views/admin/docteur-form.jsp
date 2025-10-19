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
    <link href="${pageContext.request.contextPath}/assets/css/departements.css" rel="stylesheet">
    <style>
        .form-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }
        
        .form-grid.full {
            grid-template-columns: 1fr;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 0.5rem;
        }
        
        .form-group label {
            font-weight: 600;
            color: #2d3748;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-group label .required {
            color: #e53e3e;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            padding: 0.75rem 1rem;
            border: 2px solid #e2e8f0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
            padding-top: 2rem;
            border-top: 2px solid #e2e8f0;
        }
        
        .help-text {
            font-size: 0.875rem;
            color: #718096;
            margin-top: 0.25rem;
        }
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: #2d3748;
            margin: 2rem 0 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e2e8f0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        
        .info-box h4 {
            margin: 0 0 0.5rem 0;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .info-box p {
            margin: 0;
            font-size: 0.875rem;
            opacity: 0.9;
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
                <h1>
                    <i class="fas fa-user-md"></i>
                    <%= isEdit ? "Modifier le Docteur" : "Nouveau Docteur" %>
                </h1>
                <p>
                    <%= isEdit ? "Modifiez les informations du docteur" : "Ajoutez un nouveau médecin à la clinique" %>
                </p>
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

        <div class="form-container">
            <div class="card">
                <% if (!isEdit) { %>
                <div class="info-box">
                    <h4>
                        <i class="fas fa-info-circle"></i>
                        Information importante
                    </h4>
                    <p>
                        Chaque docteur doit être associé à un département. 
                        L'affectation à une salle est optionnelle mais recommandée pour faciliter la gestion des consultations.
                    </p>
                </div>
                <% } %>
                
                <form action="${pageContext.request.contextPath}/admin/docteurs" method="post" id="docteurForm">
                    <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "creer" %>">
                    <% if (isEdit && docteur != null) { %>
                        <input type="hidden" name="id" value="<%= docteur.getId() %>">
                    <% } %>
                    
                    <!-- Section: Informations personnelles -->
                    <div class="section-title">
                        <i class="fas fa-user"></i>
                        Informations personnelles
                    </div>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-user"></i>
                                Nom <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   name="nom" 
                                   id="nom" 
                                   required
                                   value="<%= isEdit && docteur != null ? docteur.getNom() : "" %>"
                                   placeholder="Nom du docteur">
                        </div>
                        
                        <div class="form-group">
                            <label>
                                <i class="fas fa-user"></i>
                                Prénom <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   name="prenom" 
                                   id="prenom" 
                                   required
                                   value="<%= isEdit && docteur != null ? docteur.getPrenom() : "" %>"
                                   placeholder="Prénom du docteur">
                        </div>
                    </div>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-envelope"></i>
                                Email <span class="required">*</span>
                            </label>
                            <input type="email" 
                                   name="email" 
                                   id="email" 
                                   required
                                   value="<%= isEdit && docteur != null ? docteur.getEmail() : "" %>"
                                   placeholder="email@exemple.com">
                            <span class="help-text">Utilisé pour la connexion au système</span>
                        </div>
                        
                        <% if (!isEdit) { %>
                        <div class="form-group">
                            <label>
                                <i class="fas fa-lock"></i>
                                Mot de passe <span class="required">*</span>
                            </label>
                            <input type="password" 
                                   name="motDePasse" 
                                   id="motDePasse" 
                                   required
                                   placeholder="Mot de passe sécurisé"
                                   minlength="6">
                            <span class="help-text">Minimum 6 caractères</span>
                        </div>
                        <% } %>
                    </div>
                    
                    <!-- Section: Informations professionnelles -->
                    <div class="section-title">
                        <i class="fas fa-stethoscope"></i>
                        Informations professionnelles
                    </div>
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-stethoscope"></i>
                                Spécialité <span class="required">*</span>
                            </label>
                            <input type="text" 
                                   name="specialite" 
                                   id="specialite" 
                                   required
                                   value="<%= isEdit && docteur != null ? docteur.getSpecialite() : "" %>"
                                   placeholder="Ex: Cardiologie, Pédiatrie, etc.">
                        </div>
                        
                        <div class="form-group">
                            <label>
                                <i class="fas fa-building"></i>
                                Département <span class="required">*</span>
                            </label>
                            <select name="departementId" id="departementId" required onchange="chargerSallesDuDepartement(this.value)">
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
                    
                    <div class="form-grid">
                        <div class="form-group">
                            <label>
                                <i class="fas fa-door-open"></i>
                                Salle
                            </label>
                            <select name="salleId" id="salleId">
                                <option value="">Aucune salle (optionnel)</option>
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
                            <span class="help-text">La salle sera filtrée selon le département sélectionné</span>
                        </div>
                    </div>
                    
                    <!-- Actions -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/docteurs" class="btn-secondary">
                            <i class="fas fa-times"></i>
                            Annuler
                        </a>
                        <button type="submit" class="btn-primary">
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
