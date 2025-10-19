<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.clinic.clinicapp.entity.Patient" %>
<%@ page import="com.clinic.clinicapp.entity.Personne" %>
<%@ page import="java.math.BigDecimal" %>
<%
    Personne user = (Personne) session.getAttribute("user");
    String role = (String) session.getAttribute("role");
    
    if (user == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
    
    List<Patient> patients = (List<Patient>) request.getAttribute("patients");
    Integer totalPatients = (Integer) request.getAttribute("totalPatients");
    String critereRecherche = (String) request.getAttribute("critereRecherche");
    String imcFilter = (String) request.getAttribute("imcFilter");
    
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gestion des Patients - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/admin-dashboard.css" rel="stylesheet">
    <style>
        .search-filter-section {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .search-filter-grid {
            display: grid;
            grid-template-columns: 2fr 1fr auto;
            gap: 15px;
            align-items: end;
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
        
        .form-control {
            padding: 10px 15px;
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
        
        .btn-group {
            display: flex;
            gap: 10px;
        }
        
        .btn-search, .btn-reset {
            padding: 10px 20px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-search {
            background: #3498db;
            color: white;
        }
        
        .btn-search:hover {
            background: #2980b9;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(52, 152, 219, 0.4);
        }
        
        .btn-reset {
            background: #95a5a6;
            color: white;
        }
        
        .btn-reset:hover {
            background: #7f8c8d;
        }
        
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }
        
        .alert-error {
            background: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }
        
        .stats-bar {
            display: flex;
            gap: 20px;
            margin-bottom: 20px;
        }
        
        .stat-item {
            background: white;
            padding: 15px 20px;
            border-radius: 8px;
            flex: 1;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        
        .stat-item .stat-value {
            font-size: 24px;
            font-weight: bold;
            color: #2c3e50;
        }
        
        .stat-item .stat-label {
            font-size: 14px;
            color: #7f8c8d;
            margin-top: 5px;
        }
        
        .imc-badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .imc-underweight {
            background: #fff3cd;
            color: #856404;
        }
        
        .imc-normal {
            background: #d4edda;
            color: #155724;
        }
        
        .imc-overweight {
            background: #fff3cd;
            color: #856404;
        }
        
        .imc-obese {
            background: #f8d7da;
            color: #721c24;
        }
        
        .no-data {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
        }
        
        .no-data i {
            font-size: 64px;
            margin-bottom: 20px;
            opacity: 0.3;
        }
        
        @media (max-width: 768px) {
            .search-filter-grid {
                grid-template-columns: 1fr;
            }
            
            .stats-bar {
                flex-direction: column;
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
                <h1><i class="fas fa-users"></i> Gestion des Patients</h1>
                <p>Liste complète des patients inscrits</p>
            </div>
        </header>

        <!-- Messages -->
        <% if (successMessage != null) { %>
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <%= successMessage %>
            </div>
        <% } %>
        
        <% if (errorMessage != null) { %>
            <div class="alert alert-error">
                <i class="fas fa-exclamation-circle"></i>
                <%= errorMessage %>
            </div>
        <% } %>

        <!-- Statistiques -->
        <div class="stats-bar">
            <div class="stat-item">
                <div class="stat-value"><%= totalPatients != null ? totalPatients : 0 %></div>
                <div class="stat-label">Total Patients</div>
            </div>
            <div class="stat-item">
                <div class="stat-value">
                    <%= patients != null ? patients.stream().filter(p -> p.getIMC() != null).count() : 0 %>
                </div>
                <div class="stat-label">Avec données médicales</div>
            </div>
        </div>

        <!-- Recherche et Filtres -->
        <div class="search-filter-section">
            <form method="get" action="${pageContext.request.contextPath}/admin/patients">
                <input type="hidden" name="action" value="rechercher">
                <div class="search-filter-grid">
                    <div class="form-group">
                        <label for="critere">
                            <i class="fas fa-search"></i> Rechercher un patient
                        </label>
                        <input 
                            type="text" 
                            id="critere" 
                            name="critere" 
                            class="form-control" 
                            placeholder="Nom, prénom ou email..."
                            value="<%= critereRecherche != null ? critereRecherche : "" %>">
                    </div>
                    
                    <div class="btn-group">
                        <button type="submit" class="btn-search">
                            <i class="fas fa-search"></i>
                            Rechercher
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/patients" class="btn-reset">
                            <i class="fas fa-redo"></i>
                            Réinitialiser
                        </a>
                    </div>
                </div>
            </form>
            
            <hr style="margin: 20px 0; border: none; border-top: 1px solid #e0e0e0;">
            
            <!-- Filtre IMC -->
            <form method="get" action="${pageContext.request.contextPath}/admin/patients">
                <input type="hidden" name="action" value="filtrer">
                <div class="search-filter-grid">
                    <div class="form-group">
                        <label for="imcFilter">
                            <i class="fas fa-filter"></i> Filtrer par catégorie IMC
                        </label>
                        <select id="imcFilter" name="imcFilter" class="form-control">
                            <option value="">Tous les patients</option>
                            <option value="underweight" <%= "underweight".equals(imcFilter) ? "selected" : "" %>>
                                Insuffisance pondérale (IMC &lt; 18.5)
                            </option>
                            <option value="normal" <%= "normal".equals(imcFilter) ? "selected" : "" %>>
                                Poids normal (18.5 ≤ IMC &lt; 25)
                            </option>
                            <option value="overweight" <%= "overweight".equals(imcFilter) ? "selected" : "" %>>
                                Surpoids (25 ≤ IMC &lt; 30)
                            </option>
                            <option value="obese" <%= "obese".equals(imcFilter) ? "selected" : "" %>>
                                Obésité (IMC ≥ 30)
                            </option>
                        </select>
                    </div>
                    
                    <div class="btn-group">
                        <button type="submit" class="btn-search">
                            <i class="fas fa-filter"></i>
                            Filtrer
                        </button>
                    </div>
                </div>
            </form>
        </div>

        <!-- Table des patients -->
        <div class="card">
            <div class="card-header">
                <h3 class="card-title">
                    Liste des Patients
                    <% if (critereRecherche != null || imcFilter != null) { %>
                        <span style="font-size: 14px; font-weight: normal; color: #7f8c8d;">
                            (Résultats filtrés)
                        </span>
                    <% } %>
                </h3>
                <div class="card-action">
                    <%= totalPatients != null ? totalPatients : 0 %> patient(s)
                </div>
            </div>
            
            <% if (patients != null && !patients.isEmpty()) { %>
                <div class="table-container">
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nom Complet</th>
                                <th>Email</th>
                                <th>Poids (kg)</th>
                                <th>Taille (cm)</th>
                                <th>IMC</th>
                                <th>Consultations</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <% for (Patient patient : patients) { 
                                BigDecimal imc = patient.getIMC();
                                String imcClass = "";
                                String imcLabel = "";
                                
                                if (imc != null) {
                                    if (imc.compareTo(new BigDecimal("18.5")) < 0) {
                                        imcClass = "imc-underweight";
                                        imcLabel = "Insuffisant";
                                    } else if (imc.compareTo(new BigDecimal("25")) < 0) {
                                        imcClass = "imc-normal";
                                        imcLabel = "Normal";
                                    } else if (imc.compareTo(new BigDecimal("30")) < 0) {
                                        imcClass = "imc-overweight";
                                        imcLabel = "Surpoids";
                                    } else {
                                        imcClass = "imc-obese";
                                        imcLabel = "Obésité";
                                    }
                                }
                            %>
                                <tr>
                                    <td>#<%= patient.getId() %></td>
                                    <td>
                                        <strong><%= patient.getPrenom() %> <%= patient.getNom() %></strong>
                                    </td>
                                    <td><%= patient.getEmail() %></td>
                                    <td>
                                        <%= patient.getPoids() != null ? patient.getPoids() : "-" %>
                                    </td>
                                    <td>
                                        <%= patient.getTaille() != null ? patient.getTaille() : "-" %>
                                    </td>
                                    <td>
                                        <% if (imc != null) { %>
                                            <span class="imc-badge <%= imcClass %>">
                                                <%= imc %> - <%= imcLabel %>
                                            </span>
                                        <% } else { %>
                                            <span style="color: #95a5a6;">N/A</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <span class="badge info">
                                            -
                                        </span>
                                    </td>
                                    <td>
                                        <div class="action-btns">
                                            <a href="${pageContext.request.contextPath}/admin/patients?action=modifier&id=<%= patient.getId() %>" 
                                               class="action-btn edit" 
                                               title="Modifier">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <form method="get" 
                                                  action="${pageContext.request.contextPath}/admin/patients" 
                                                  style="display: inline;"
                                                  onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce patient ?');">
                                                <input type="hidden" name="action" value="supprimer">
                                                <input type="hidden" name="id" value="<%= patient.getId() %>">
                                                <button type="submit" class="action-btn delete" title="Supprimer">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            <% } else { %>
                <div class="no-data">
                    <i class="fas fa-users"></i>
                    <h3>Aucun patient trouvé</h3>
                    <% if (critereRecherche != null || imcFilter != null) { %>
                        <p>Essayez de modifier vos critères de recherche ou de filtre</p>
                    <% } else { %>
                        <p>Il n'y a pas encore de patients enregistrés dans le système</p>
                    <% } %>
                </div>
            <% } %>
        </div>
    </main>
</body>
</html>
