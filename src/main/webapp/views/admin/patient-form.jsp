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
    <style>
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            max-width: 800px;
        }
        
        .form-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #e0e0e0;
        }
        
        .form-header h2 {
            color: #2c3e50;
            margin-bottom: 5px;
        }
        
        .form-header p {
            color: #7f8c8d;
            font-size: 14px;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .form-group-full {
            grid-column: 1 / -1;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: 600;
            margin-bottom: 8px;
            color: #2c3e50;
            font-size: 14px;
        }
        
        .form-group label .required {
            color: #e74c3c;
        }
        
        .form-control {
            padding: 12px 15px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.3s;
        }
        
        .form-control:focus {
            outline: none;
            border-color: #3498db;
            box-shadow: 0 0 0 3px rgba(52, 152, 219, 0.1);
        }
        
        .form-control:disabled {
            background: #f5f5f5;
            cursor: not-allowed;
        }
        
        .form-help {
            font-size: 12px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        .info-box {
            background: #e8f4f8;
            border-left: 4px solid #3498db;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 20px;
        }
        
        .info-box h4 {
            color: #2c3e50;
            margin-bottom: 10px;
            font-size: 14px;
        }
        
        .info-box p {
            color: #555;
            font-size: 13px;
            margin: 5px 0;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 30px;
            padding-top: 20px;
            border-top: 2px solid #e0e0e0;
        }
        
        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 14px;
        }
        
        .btn-primary {
            background: #3498db;
            color: white;
        }
        
        .btn-primary:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
        }
        
        .btn-secondary {
            background: #95a5a6;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #7f8c8d;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .btn-group {
                flex-direction: column;
            }
            
            .btn {
                width: 100%;
                justify-content: center;
            }
        }
    </style>
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
        <header class="header">
            <div class="header-title">
                <h1><i class="fas fa-user-edit"></i> Modifier Patient</h1>
                <p>Modification des informations du patient</p>
            </div>
        </header>

        <!-- Messages -->
        <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= errorMessage %>
            </div>
        <% } %>

        <% if (patient != null) { %>
            <!-- Informations actuelles -->
            <div class="info-box">
                <h4><i class="fas fa-info-circle"></i> Informations actuelles</h4>
                <p><strong>Patient ID:</strong> #<%= patient.getId() %></p>
                <% if (patient.getIMC() != null) { %>
                    <p><strong>IMC actuel:</strong> <%= patient.getIMC() %></p>
                <% } %>
            </div>

            <!-- Formulaire -->
            <div class="form-container">
                <div class="form-header">
                    <h2>Formulaire de modification</h2>
                    <p>Modifiez les informations du patient ci-dessous</p>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/patients">
                    <input type="hidden" name="action" value="modifier">
                    <input type="hidden" name="id" value="<%= patient.getId() %>">

                    <div class="form-grid">
                        <!-- Nom -->
                        <div class="form-group">
                            <label for="nom">
                                <i class="fas fa-user"></i> Nom <span class="required">*</span>
                            </label>
                            <input 
                                type="text" 
                                id="nom" 
                                name="nom" 
                                class="form-control" 
                                value="<%= patient.getNom() %>"
                                required>
                        </div>

                        <!-- Prénom -->
                        <div class="form-group">
                            <label for="prenom">
                                <i class="fas fa-user"></i> Prénom <span class="required">*</span>
                            </label>
                            <input 
                                type="text" 
                                id="prenom" 
                                name="prenom" 
                                class="form-control" 
                                value="<%= patient.getPrenom() %>"
                                required>
                        </div>

                        <!-- Email -->
                        <div class="form-group form-group-full">
                            <label for="email">
                                <i class="fas fa-envelope"></i> Email <span class="required">*</span>
                            </label>
                            <input 
                                type="email" 
                                id="email" 
                                name="email" 
                                class="form-control" 
                                value="<%= patient.getEmail() %>"
                                required>
                        </div>

                        <!-- Poids -->
                        <div class="form-group">
                            <label for="poids">
                                <i class="fas fa-weight"></i> Poids (kg)
                            </label>
                            <input 
                                type="number" 
                                step="0.1" 
                                id="poids" 
                                name="poids" 
                                class="form-control" 
                                value="<%= patient.getPoids() != null ? patient.getPoids() : "" %>"
                                placeholder="Ex: 70.5">
                            <span class="form-help">Entrez le poids en kilogrammes</span>
                        </div>

                        <!-- Taille -->
                        <div class="form-group">
                            <label for="taille">
                                <i class="fas fa-ruler-vertical"></i> Taille (cm)
                            </label>
                            <input 
                                type="number" 
                                id="taille" 
                                name="taille" 
                                class="form-control" 
                                value="<%= patient.getTaille() != null ? patient.getTaille() : "" %>"
                                placeholder="Ex: 175">
                            <span class="form-help">Entrez la taille en centimètres</span>
                        </div>
                    </div>

                    <!-- Boutons d'action -->
                    <div class="btn-group">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-save"></i>
                            Enregistrer les modifications
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-secondary">
                            <i class="fas fa-times"></i>
                            Annuler
                        </a>
                    </div>
                </form>
            </div>
        <% } else { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                Patient introuvable
            </div>
            <a href="${pageContext.request.contextPath}/admin/patients" class="btn btn-secondary">
                <i class="fas fa-arrow-left"></i>
                Retour à la liste
            </a>
        <% } %>
    </main>
</body>
</html>
