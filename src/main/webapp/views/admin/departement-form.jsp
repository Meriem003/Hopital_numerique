<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Admin" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%@ page import="com.clinic.clinicapp.entity.Departement" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    Personne user = (Personne) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    String action = (String) request.getAttribute("action");
    Departement departement = (Departement) request.getAttribute("departement");
    boolean isEdit = "modifier".equals(action);
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= isEdit ? "Modifier" : "Nouveau" %> Département - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/departement-form.css" rel="stylesheet">
</head>
<body>
    <aside class="sidebar">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-hospital-symbol"></i>
            </div>
            <div class="logo-text">
                <h3>Clinique Excellence</h3>
                <p>Espace Admin</p>
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

    <main class="main-content">
        <!-- Header avec style élégant -->
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1>
                        <i class="fas <%= isEdit ? "fa-edit" : "fa-plus-circle" %>"></i>
                        <%= isEdit ? "Modifier le Département" : "Nouveau Département" %>
                    </h1>
                    <p><%= isEdit ? "Modifiez les informations du département" : "Ajoutez un nouveau département à votre établissement médical" %></p>
                </div>
                <a href="${pageContext.request.contextPath}/admin/departements" class="btn-header-back">
                    <i class="fas fa-arrow-left"></i>
                    Retour à la liste
                </a>
            </div>
        </div>

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
                
                <!-- Messages d'erreur -->
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">
                        <i class="fas fa-exclamation-circle"></i>
                        <span>${errorMessage}</span>
                    </div>
                </c:if>
                
                <!-- Formulaire -->
                <form method="POST" action="${pageContext.request.contextPath}/admin/departements" id="departementForm">
                    <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "creer" %>">
                    <% if (isEdit && departement != null) { %>
                        <input type="hidden" name="id" value="<%= departement.getId() %>">
                    <% } %>
                    
                    <div class="form-group">
                        <label for="nom">
                            <i class="fas fa-building"></i> Nom du Département <span class="required">*</span>
                        </label>
                        <div class="input-wrapper">
                            <input 
                                type="text" 
                                id="nom" 
                                name="nom" 
                                required 
                                placeholder="Ex: Cardiologie, Pédiatrie, Radiologie..."
                                value="<%= isEdit && departement != null ? departement.getNom() : "" %>"
                            >
                            <i class="input-icon fas fa-building"></i>
                        </div>
                        <small class="help-text">Le nom doit être unique et descriptif</small>
                    </div>
                    
                    <div class="form-group">
                        <label for="description">
                            <i class="fas fa-align-left"></i> Description
                        </label>
                        <div class="input-wrapper">
                            <textarea 
                                id="description" 
                                name="description" 
                                rows="5"
                                placeholder="Décrivez les services et spécialités du département..."
                            ><%= isEdit && departement != null && departement.getDescription() != null ? departement.getDescription() : "" %></textarea>
                            <i class="input-icon fas fa-align-left"></i>
                        </div>
                        <small class="help-text">
                            <i class="fas fa-info-circle"></i>
                            Décrivez brièvement les activités et services du département
                        </small>
                    </div>
                    
                    
                    <div class="checkbox-group">
                        <input 
                            type="checkbox" 
                            id="actif" 
                            name="actif" 
                            value="true"
                            <%= !isEdit || (departement != null && departement.isActif()) ? "checked" : "" %>
                        >
                        <label for="actif">
                            <i class="fas fa-check-circle"></i>
                            Département actif et visible
                        </label>
                        <small class="checkbox-help">Ce département sera visible pour tous les utilisateurs</small>
                    </div>
                    
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/admin/departements" class="btn btn-secondary">
                            <i class="fas fa-times-circle"></i> 
                            Annuler
                        </a>
                        <button type="submit" class="btn btn-primary">
                            <i class="fas <%= isEdit ? "fa-save" : "fa-plus-circle" %>"></i> 
                            <%= isEdit ? "Mettre à jour le département" : "Créer le département" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        // Aperçu de l'icône en temps réel
        function updateIconPreview() {
            const iconeInput = document.getElementById('icone');
            const iconPreview = document.getElementById('iconPreview');
            const previewIcon = document.getElementById('previewIcon');
            
            const iconeValue = iconeInput.value.trim();
            
            if (iconeValue) {
                // Retirer les anciennes classes
                previewIcon.className = 'fas';
                
                // Ajouter la nouvelle icône
                if (iconeValue.startsWith('fa-')) {
                    previewIcon.classList.add(iconeValue);
                } else {
                    previewIcon.classList.add('fa-' + iconeValue);
                }
                
                iconPreview.style.display = 'flex';
            } else {
                iconPreview.style.display = 'none';
            }
        }
        
        // Initialiser l'aperçu au chargement de la page
        window.addEventListener('DOMContentLoaded', () => {
            updateIconPreview();
            
            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.opacity = '0';
                    setTimeout(() => alert.remove(), 300);
                }, 5000);
            });
        });
        
        // Validation du formulaire
        document.getElementById('departementForm')?.addEventListener('submit', function(e) {
            const nom = document.getElementById('nom').value.trim();
            
            if (!nom) {
                e.preventDefault();
                alert('Le nom du département est obligatoire !');
                return false;
            }
            
            if (nom.length < 3) {
                e.preventDefault();
                alert('Le nom du département doit contenir au moins 3 caractères !');
                return false;
            }
        });
    </script>
</body>
</html>