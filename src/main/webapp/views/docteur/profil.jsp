<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.clinic.clinicapp.entity.Docteur" %>
<%@ page import="com.clinic.clinicapp.entity.Departement" %>
<%@ page import="com.clinic.clinicapp.entity.Salle" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Docteur</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
    <style>
        .profil-container {
            padding: 2rem;
            max-width: 1400px;
            margin: 0 auto;
        }

        .profil-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 20px;
            padding: 2rem;
            color: white;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(102, 126, 234, 0.3);
        }

        .profil-header-content {
            display: flex;
            align-items: center;
            gap: 2rem;
        }

        .profil-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            color: #667eea;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: bold;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }

        .profil-info h1 {
            margin: 0 0 0.5rem 0;
            font-size: 2rem;
        }

        .profil-specialite {
            display: inline-block;
            background: rgba(255, 255, 255, 0.2);
            padding: 0.5rem 1rem;
            border-radius: 20px;
            margin-bottom: 0.5rem;
        }

        .profil-stats {
            display: flex;
            gap: 2rem;
            margin-top: 1rem;
        }

        .stat-item {
            text-align: center;
        }

        .stat-item .number {
            font-size: 1.8rem;
            font-weight: bold;
            display: block;
        }

        .stat-item .label {
            font-size: 0.9rem;
            opacity: 0.9;
        }

        .tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            border-bottom: 2px solid #e0e0e0;
        }

        .tab-btn {
            padding: 1rem 2rem;
            border: none;
            background: none;
            color: #666;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            border-bottom: 3px solid transparent;
            transition: all 0.3s;
        }

        .tab-btn:hover {
            color: #667eea;
        }

        .tab-btn.active {
            color: #667eea;
            border-bottom-color: #667eea;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        .info-card {
            background: white;
            border-radius: 15px;
            padding: 2rem;
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.08);
            margin-bottom: 2rem;
        }

        .info-card h2 {
            margin: 0 0 1.5rem 0;
            color: #333;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .info-card h2 i {
            color: #667eea;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1.5rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        .form-group.full-width {
            grid-column: 1 / -1;
        }

        .form-group label {
            display: block;
            margin-bottom: 0.5rem;
            color: #555;
            font-weight: 500;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 0.75rem;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }

        .form-group input:disabled {
            background-color: #f5f5f5;
            cursor: not-allowed;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            padding: 0.75rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .alert-success {
            background-color: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
            border-left: 4px solid #dc3545;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 1rem 0;
            border-bottom: 1px solid #f0f0f0;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #666;
            font-weight: 500;
        }

        .info-value {
            color: #333;
            font-weight: 600;
        }

        .badge {
            display: inline-block;
            padding: 0.25rem 0.75rem;
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .badge-primary {
            background: #e7eaff;
            color: #667eea;
        }

        .badge-success {
            background: #d4edda;
            color: #28a745;
        }

        @media (max-width: 768px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
            
            .profil-header-content {
                flex-direction: column;
                text-align: center;
            }

            .profil-stats {
                justify-content: center;
            }
        }
    </style>
</head>
<body>
    <aside class="sidebar">
        <div class="logo-section">
            <div class="logo-icon">
                <i class="fas fa-hospital-symbol"></i>
            </div>
            <div class="logo-text">
                <h3>Clinique Excellence</h3>
                <p>Espace Docteur</p>
            </div>
        </div>
        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/views/docteur/dashboard.jsp" class="nav-link">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/planning" class="nav-link">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Mon Planning</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/reservations" class="nav-link">
                        <i class="fas fa-clock"></i>
                        <span>Réservations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/consultations" class="nav-link">
                        <i class="fas fa-stethoscope"></i>
                        <span>Mes Consultations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/patients" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Patients Suivis</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/profil" class="nav-link active">
                        <i class="fas fa-user-circle"></i>
                        <span>Mon Profil</span>
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
        <%
            Docteur docteur = (Docteur) request.getAttribute("docteur");
            List<Departement> departements = (List<Departement>) request.getAttribute("departements");
            List<Salle> salles = (List<Salle>) request.getAttribute("salles");
            Integer totalConsultations = (Integer) request.getAttribute("totalConsultations");
            Long consultationsMoisActuel = (Long) request.getAttribute("consultationsMoisActuel");
            Long patientsUniques = (Long) request.getAttribute("patientsUniques");
            
            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
            
            if (successMessage != null) {
                session.removeAttribute("successMessage");
            }
            if (errorMessage != null) {
                session.removeAttribute("errorMessage");
            }
            
            String initiales = "";
            if (docteur != null) {
                initiales = (docteur.getNom().substring(0, 1) + docteur.getPrenom().substring(0, 1)).toUpperCase();
            }
        %>

        <div class="profil-container">
            <!-- En-tête du profil -->
            <div class="profil-header">
                <div class="profil-header-content">
                    <div class="profil-avatar">
                        <%= initiales %>
                    </div>
                    <div class="profil-info">
                        <h1>Dr. <%= docteur.getNom() %> <%= docteur.getPrenom() %></h1>
                        <div class="profil-specialite">
                            <i class="fas fa-stethoscope"></i> <%= docteur.getSpecialite() %>
                        </div>
                        <div class="profil-stats">
                            <div class="stat-item">
                                <span class="number"><%= totalConsultations %></span>
                                <span class="label">Consultations totales</span>
                            </div>
                            <div class="stat-item">
                                <span class="number"><%= consultationsMoisActuel %></span>
                                <span class="label">Ce mois</span>
                            </div>
                            <div class="stat-item">
                                <span class="number"><%= patientsUniques %></span>
                                <span class="label">Patients suivis</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Messages d'alerte -->
            <% if (successMessage != null) { %>
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    <%= successMessage %>
                </div>
            <% } %>
            
            <% if (errorMessage != null) { %>
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    <%= errorMessage %>
                </div>
            <% } %>

            <!-- Onglets -->
            <div class="tabs">
                <button class="tab-btn active" onclick="openTab('informations')">
                    <i class="fas fa-user"></i> Informations Personnelles
                </button>
                <button class="tab-btn" onclick="openTab('affectations')">
                    <i class="fas fa-building"></i> Affectations
                </button>
                <button class="tab-btn" onclick="openTab('securite')">
                    <i class="fas fa-lock"></i> Sécurité
                </button>
            </div>

            <!-- Onglet Informations Personnelles -->
            <div id="informations" class="tab-content active">
                <div class="info-card">
                    <h2><i class="fas fa-id-card"></i> Modifier mes informations</h2>
                    <form method="post" action="${pageContext.request.contextPath}/docteur/profil">
                        <input type="hidden" name="action" value="updateInfo">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nom">Nom</label>
                                <input type="text" id="nom" name="nom" value="<%= docteur.getNom() %>" required>
                            </div>
                            <div class="form-group">
                                <label for="prenom">Prénom</label>
                                <input type="text" id="prenom" name="prenom" value="<%= docteur.getPrenom() %>" required>
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" name="email" value="<%= docteur.getEmail() %>" required>
                            </div>
                            <div class="form-group">
                                <label for="specialite">Spécialité</label>
                                <input type="text" id="specialite" name="specialite" value="<%= docteur.getSpecialite() %>" required>
                            </div>
                        </div>
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-save"></i> Enregistrer les modifications
                        </button>
                    </form>
                </div>
            </div>

            <!-- Onglet Affectations -->
            <div id="affectations" class="tab-content">
                <div class="info-card">
                    <h2><i class="fas fa-building"></i> Mes affectations</h2>
                    <form method="post" action="${pageContext.request.contextPath}/docteur/profil">
                        <input type="hidden" name="action" value="updateInfo">
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="departementId">Département</label>
                                <select id="departementId" name="departementId">
                                    <option value="">-- Sélectionner un département --</option>
                                    <% for (Departement dep : departements) { %>
                                        <option value="<%= dep.getId() %>" 
                                            <%= docteur.getDepartement() != null && docteur.getDepartement().getId().equals(dep.getId()) ? "selected" : "" %>>
                                            <%= dep.getNom() %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="salleId">Salle</label>
                                <select id="salleId" name="salleId">
                                    <option value="">-- Sélectionner une salle --</option>
                                    <% for (Salle salle : salles) { %>
                                        <option value="<%= salle.getId() %>" 
                                            <%= docteur.getSalle() != null && docteur.getSalle().getId().equals(salle.getId()) ? "selected" : "" %>>
                                            <%= salle.getNomSalle() %><%= salle.getDescription() != null ? " - " + salle.getDescription() : "" %>
                                        </option>
                                    <% } %>
                                </select>
                            </div>
                        </div>
                        
                        <div class="info-row">
                            <span class="info-label">Département actuel:</span>
                            <span class="info-value">
                                <%= docteur.getDepartement() != null ? docteur.getDepartement().getNom() : "Non assigné" %>
                            </span>
                        </div>
                        <div class="info-row">
                            <span class="info-label">Salle actuelle:</span>
                            <span class="info-value">
                                <%= docteur.getSalle() != null ? docteur.getSalle().getNomSalle() + (docteur.getSalle().getDescription() != null ? " - " + docteur.getSalle().getDescription() : "") : "Non assignée" %>
                            </span>
                        </div>
                        
                        <button type="submit" class="btn-primary" style="margin-top: 1.5rem;">
                            <i class="fas fa-save"></i> Mettre à jour les affectations
                        </button>
                    </form>
                </div>
            </div>

            <!-- Onglet Sécurité -->
            <div id="securite" class="tab-content">
                <div class="info-card">
                    <h2><i class="fas fa-lock"></i> Modifier mon mot de passe</h2>
                    <form method="post" action="${pageContext.request.contextPath}/docteur/profil">
                        <input type="hidden" name="action" value="changePassword">
                        <div class="form-group">
                            <label for="currentPassword">Mot de passe actuel</label>
                            <input type="password" id="currentPassword" name="currentPassword" required>
                        </div>
                        <div class="form-group">
                            <label for="newPassword">Nouveau mot de passe</label>
                            <input type="password" id="newPassword" name="newPassword" required minlength="6">
                            <small style="color: #666;">Le mot de passe doit contenir au moins 6 caractères</small>
                        </div>
                        <div class="form-group">
                            <label for="confirmPassword">Confirmer le nouveau mot de passe</label>
                            <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6">
                        </div>
                        <button type="submit" class="btn-primary">
                            <i class="fas fa-key"></i> Changer le mot de passe
                        </button>
                    </form>
                </div>

                <div class="info-card">
                    <h2><i class="fas fa-info-circle"></i> Informations du compte</h2>
                    <div class="info-row">
                        <span class="info-label">ID Docteur:</span>
                        <span class="info-value"><%= docteur.getId() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Email:</span>
                        <span class="info-value"><%= docteur.getEmail() %></span>
                    </div>
                    <div class="info-row">
                        <span class="info-label">Statut du compte:</span>
                        <span class="info-value">
                            <span class="badge badge-success">
                                <i class="fas fa-check"></i> Actif
                            </span>
                        </span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function openTab(tabName) {
            // Masquer tous les contenus d'onglets
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(content => {
                content.classList.remove('active');
            });

            // Désactiver tous les boutons d'onglets
            const tabButtons = document.querySelectorAll('.tab-btn');
            tabButtons.forEach(button => {
                button.classList.remove('active');
            });

            // Afficher le contenu de l'onglet sélectionné
            document.getElementById(tabName).classList.add('active');

            // Activer le bouton d'onglet sélectionné
            event.target.classList.add('active');
        }

        // Validation du formulaire de changement de mot de passe
        document.querySelector('form[action*="changePassword"]')?.addEventListener('submit', function(e) {
            const newPassword = document.getElementById('newPassword').value;
            const confirmPassword = document.getElementById('confirmPassword').value;

            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas!');
                return false;
            }

            if (newPassword.length < 6) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins 6 caractères!');
                return false;
            }
        });
    </script>
</body>
</html>
