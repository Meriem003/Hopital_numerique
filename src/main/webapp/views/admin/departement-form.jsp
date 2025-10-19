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
    <link href="${pageContext.request.contextPath}/assets/css/departements.css" rel="stylesheet">
    <style>
        .form-page {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2rem;
        }
        
        .form-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
        
        .form-header {
            margin-bottom: 2rem;
            padding-bottom: 1rem;
            border-bottom: 2px solid #f0f0f0;
        }
        
        .form-header h2 {
            color: #2c3e50;
            margin-bottom: 0.5rem;
        }
        
        .form-header p {
            color: #7f8c8d;
            margin: 0;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #2c3e50;
            font-weight: 500;
        }
        
        .form-group label i {
            color: #3498db;
            margin-right: 0.5rem;
        }
        
        .form-group input[type="text"],
        .form-group textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 1rem;
            transition: border-color 0.3s;
        }
        
        .form-group input[type="text"]:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #3498db;
        }
        
        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }
        
        .form-group small {
            display: block;
            margin-top: 0.25rem;
            color: #7f8c8d;
            font-size: 0.875rem;
        }
        
        .checkbox-group {
            display: flex;
            align-items: center;
            margin-top: 1rem;
        }
        
        .checkbox-group input[type="checkbox"] {
            margin-right: 0.5rem;
            width: 18px;
            height: 18px;
            cursor: pointer;
        }
        
        .checkbox-group label {
            margin: 0;
            cursor: pointer;
        }
        
        .form-actions {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 2px solid #f0f0f0;
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border: none;
            border-radius: 4px;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.3s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
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
        
        .alert {
            padding: 1rem;
            border-radius: 4px;
            margin-bottom: 1.5rem;
        }
        
        .alert-error {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .alert-success {
            background: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
    </style>
</head>
<body>
    <div class="form-page">
        <div class="form-card">
            <div class="form-header">
                <h2>
                    <i class="fas <%= isEdit ? "fa-edit" : "fa-plus-circle" %>"></i>
                    <%= isEdit ? "Modifier le Département" : "Nouveau Département" %>
                </h2>
                <p><%= isEdit ? "Modifiez les informations du département" : "Ajoutez un nouveau département à la clinique" %></p>
            </div>
            
            <!-- Messages d'erreur -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-error">
                    <i class="fas fa-exclamation-circle"></i> ${errorMessage}
                </div>
            </c:if>
            
            <!-- Formulaire -->
            <form method="POST" action="${pageContext.request.contextPath}/admin/departements">
                <input type="hidden" name="action" value="<%= isEdit ? "modifier" : "creer" %>">
                <% if (isEdit && departement != null) { %>
                    <input type="hidden" name="id" value="<%= departement.getId() %>">
                <% } %>
                
                <div class="form-group">
                    <label for="nom">
                        <i class="fas fa-building"></i> Nom du Département <span style="color: red;">*</span>
                    </label>
                    <input 
                        type="text" 
                        id="nom" 
                        name="nom" 
                        required 
                        placeholder="Ex: Cardiologie"
                        value="<%= isEdit && departement != null ? departement.getNom() : "" %>"
                    >
                </div>
                
                <div class="form-group">
                    <label for="description">
                        <i class="fas fa-align-left"></i> Description
                    </label>
                    <textarea 
                        id="description" 
                        name="description" 
                        placeholder="Décrivez le département..."
                    ><%= isEdit && departement != null && departement.getDescription() != null ? departement.getDescription() : "" %></textarea>
                </div>
                
                <div class="form-group">
                    <label for="icone">
                        <i class="fas fa-icons"></i> Icône (Font Awesome)
                    </label>
                    <input 
                        type="text" 
                        id="icone" 
                        name="icone" 
                        placeholder="Ex: fa-heart, fa-brain, fa-bone"
                        value="<%= isEdit && departement != null && departement.getIcone() != null ? departement.getIcone() : "" %>"
                    >
                    <small>
                        Voir les icônes sur <a href="https://fontawesome.com/icons" target="_blank" style="color: #3498db;">fontawesome.com</a>
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
                    <label for="actif">Département actif</label>
                </div>
                
                <div class="form-actions">
                    <a href="${pageContext.request.contextPath}/admin/departements" class="btn btn-secondary">
                        <i class="fas fa-times"></i> Annuler
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i> <%= isEdit ? "Mettre à jour" : "Créer" %>
                    </button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>
