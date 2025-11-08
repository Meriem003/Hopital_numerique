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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/profil-docteur.css">
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
                <a href="${pageContext.request.contextPath}/docteur/dashboard" class="nav-link">
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
                </div>
            </div>
        </div>

        <!-- Messages d'alerte -->
        <% if (successMessage != null) { %>
        <div class="alert alert-success">
            <i class="fas fa-check-circle"></i>
            <span><%= successMessage %></span>
        </div>
        <% } %>

        <% if (errorMessage != null) { %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i>
            <span><%= errorMessage %></span>
        </div>
        <% } %>

        <!-- Onglets -->
        <div class="tabs">
            <button class="tab-btn active" onclick="openTab(event, 'informations')">
                <i class="fas fa-user"></i> Informations Personnelles
            </button>
            <button class="tab-btn" onclick="openTab(event, 'affectations')">
                <i class="fas fa-building"></i> Affectations
            </button>
            <button class="tab-btn" onclick="openTab(event, 'securite')">
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
                            <label for="nom">Nom <span style="color: var(--danger);">*</span></label>
                            <input type="text" id="nom" name="nom" value="<%= docteur.getNom() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="prenom">Prénom <span style="color: var(--danger);">*</span></label>
                            <input type="text" id="prenom" name="prenom" value="<%= docteur.getPrenom() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="email">Email <span style="color: var(--danger);">*</span></label>
                            <input type="email" id="email" name="email" value="<%= docteur.getEmail() %>" required>
                        </div>
                        <div class="form-group">
                            <label for="specialite">Spécialité <span style="color: var(--danger);">*</span></label>
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

                <div style="margin-bottom: 2rem;">
                    <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-building" style="color: var(--secondary); margin-right: 0.5rem;"></i>
                                Département actuel
                            </span>
                        <span class="info-value">
                                <% if (docteur.getDepartement() != null) { %>
                                    <span class="badge badge-primary">
                                        <%= docteur.getDepartement().getNom() %>
                                    </span>
                                <% } else { %>
                                    <span style="color: var(--gray-600); font-style: italic;">Non assigné</span>
                                <% } %>
                            </span>
                    </div>
                    <div class="info-row">
                            <span class="info-label">
                                <i class="fas fa-door-open" style="color: var(--secondary); margin-right: 0.5rem;"></i>
                                Salle actuelle
                            </span>
                        <span class="info-value">
                                <% if (docteur.getSalle() != null) { %>
                                    <span class="badge badge-primary">
                                        <%= docteur.getSalle().getNomSalle() %><%= docteur.getSalle().getDescription() != null ? " - " + docteur.getSalle().getDescription() : "" %>
                                    </span>
                                <% } else { %>
                                    <span style="color: var(--gray-600); font-style: italic;">Non assignée</span>
                                <% } %>
                            </span>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/docteur/profil">
                    <input type="hidden" name="action" value="updateInfo">
                    <div class="form-grid">
                        <div class="form-group">
                            <label for="departementId">
                                <i class="fas fa-building"></i> Département
                            </label>
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
                            <label for="salleId">
                                <i class="fas fa-door-open"></i> Salle
                            </label>
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

                    <button type="submit" class="btn-primary">
                        <i class="fas fa-save"></i> Mettre à jour les affectations
                    </button>
                </form>
            </div>
        </div>

        <!-- Onglet Sécurité -->
        <div id="securite" class="tab-content">
            <div class="info-card">
                <h2><i class="fas fa-lock"></i> Modifier mon mot de passe</h2>
                <form method="post" action="${pageContext.request.contextPath}/docteur/profil" id="passwordForm">
                    <input type="hidden" name="action" value="changePassword">
                    <div class="form-group">
                        <label for="currentPassword">Mot de passe actuel <span style="color: var(--danger);">*</span></label>
                        <input type="password" id="currentPassword" name="currentPassword" required>
                    </div>
                    <div class="form-group">
                        <label for="newPassword">Nouveau mot de passe <span style="color: var(--danger);">*</span></label>
                        <input type="password" id="newPassword" name="newPassword" required minlength="6">
                        <small>Le mot de passe doit contenir au moins 6 caractères</small>
                    </div>
                    <div class="form-group">
                        <label for="confirmPassword">Confirmer le nouveau mot de passe <span style="color: var(--danger);">*</span></label>
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
                        <span class="info-label">
                            <i class="fas fa-id-badge" style="color: var(--secondary); margin-right: 0.5rem;"></i>
                            ID Docteur
                        </span>
                    <span class="info-value"><%= docteur.getId() %></span>
                </div>
                <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-envelope" style="color: var(--secondary); margin-right: 0.5rem;"></i>
                            Email
                        </span>
                    <span class="info-value"><%= docteur.getEmail() %></span>
                </div>
                <div class="info-row">
                        <span class="info-label">
                            <i class="fas fa-shield-alt" style="color: var(--secondary); margin-right: 0.5rem;"></i>
                            Statut du compte
                        </span>
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
    function openTab(event, tabName) {
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
        event.currentTarget.classList.add('active');
    }

    // Validation du formulaire de changement de mot de passe
    document.getElementById('passwordForm')?.addEventListener('submit', function(e) {
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

    // Auto-hide alerts after 5 seconds
    window.addEventListener('DOMContentLoaded', () => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            setTimeout(() => {
                alert.style.opacity = '0';
                setTimeout(() => alert.remove(), 300);
            }, 5000);
        });
    });
</script>
</body>
</html>