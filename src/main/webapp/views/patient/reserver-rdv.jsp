<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Réserver un Rendez-vous - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-reserver.css" rel="stylesheet">
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
                <p>Espace Patient</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/reserver" class="nav-link active">
                        <i class="fas fa-calendar-plus"></i>
                        <span>Réserver un RDV</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/consultations" class="nav-link">
                        <i class="fas fa-calendar-check"></i>
                        <span>Mes Rendez-vous</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/docteurs" class="nav-link">
                        <i class="fas fa-user-md"></i>
                        <span>Nos Docteurs</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/historique" class="nav-link">
                        <i class="fas fa-history"></i>
                        <span>Historique Médical</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/patient/profil" class="nav-link">
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

    <!-- Main Content -->
    <main class="main-content">
        <!-- Header -->
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1>
                        <i class="fas fa-calendar-check"></i>
                        Réserver un Rendez-vous
                    </h1>
                    <p>Gérez vos réservations et suivez votre parcours de soins</p>
                </div>
                <a href="${pageContext.request.contextPath}/patient/consultations" class="btn-header">
                    <i class="fas fa-calendar-plus"></i>
                    consulter mes rendez-vous
                </a>
            </div>
        </div>

        <!-- Messages -->
        <c:if test="${not empty error}">
            <div class="alert alert-danger">
                <i class="fas fa-exclamation-circle"></i>
                <span>${error}</span>
            </div>
        </c:if>

        <c:if test="${not empty success}">
            <div class="alert alert-success">
                <i class="fas fa-check-circle"></i>
                <span>${success}</span>
            </div>
        </c:if>

        <!-- Formulaire de réservation -->
        <div class="reservation-container">
            <!-- Progress Steps -->
            <div class="progress-steps">
                <div class="step active" data-step="1">
                    <div class="step-icon">
                        <i class="fas fa-user-md"></i>
                    </div>
                    <div class="step-label">Docteur</div>
                </div>
                <div class="step-line"></div>
                <div class="step" data-step="2">
                    <div class="step-icon">
                        <i class="fas fa-calendar"></i>
                    </div>
                    <div class="step-label">Date & Heure</div>
                </div>
                <div class="step-line"></div>
                <div class="step" data-step="3">
                    <div class="step-icon">
                        <i class="fas fa-notes-medical"></i>
                    </div>
                    <div class="step-label">Détails</div>
                </div>
            </div>
            <!-- Form Card -->
            <div class="card">
                <form method="post" action="${pageContext.request.contextPath}/patient/reserver" id="reservationForm">
                    <!-- Étape 1 : Sélection du docteur -->
                    <div class="form-section active" data-section="1">
                        <div class="section-header">
                            <h3 class="section-title">
                                <i class="fas fa-user-md"></i>
                                Sélectionner un Docteur
                            </h3>
                            <span class="required-badge">Obligatoire</span>
                        </div>

                        <div class="form-group">
                            <label for="docteurId">
                                <i class="fas fa-stethoscope"></i>
                                Choisir votre médecin
                                <span class="required">*</span>
                            </label>
                            <select name="docteurId" id="docteurId" class="form-select" required>
                                <option value="">-- Sélectionner un docteur --</option>
                                <c:forEach items="${docteurs}" var="docteur">
                                    <option value="${docteur.id}" 
                                            data-nom="${docteur.nom}" 
                                            data-prenom="${docteur.prenom}"
                                            data-specialite="${docteur.specialite}"
                                            data-departement="${not empty docteur.departement ? docteur.departement.nom : 'N/A'}">
                                        Dr. ${docteur.nom} ${docteur.prenom} - ${docteur.specialite}
                                    </option>
                                </c:forEach>
                            </select>
                        </div>

                        <!-- Docteur Info Card -->
                        <div id="docteurInfoCard" class="docteur-card" style="display: none;">
                            <div class="docteur-avatar">
                                <i class="fas fa-user-md"></i>
                            </div>
                            <div class="docteur-info">
                                <h4 id="docteurName"></h4>
                                <div class="docteur-meta">
                                    <span class="meta-item">
                                        <i class="fas fa-stethoscope"></i>
                                        <span id="docteurSpecialite"></span>
                                    </span>
                                    <span class="meta-item">
                                        <i class="fas fa-building"></i>
                                        <span id="docteurDepartement"></span>
                                    </span>
                                </div>
                            </div>
                            <div class="docteur-badge">
                                <i class="fas fa-check-circle"></i>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-primary" onclick="nextStep(2)">
                                <span>Suivant</span>
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Étape 2 : Date et Heure -->
                    <div class="form-section" data-section="2">
                        <div class="section-header">
                            <h3 class="section-title">
                                <i class="fas fa-calendar"></i>
                                Date et Heure du Rendez-vous
                            </h3>
                            <span class="required-badge">Obligatoire</span>
                        </div>

                        <div class="datetime-grid">
                            <div class="form-group">
                                <label for="date">
                                    <i class="fas fa-calendar-day"></i>
                                    Date du rendez-vous
                                    <span class="required">*</span>
                                </label>
                                <jsp:useBean id="now" class="java.util.Date"/>
                                <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today"/>
                                <input type="date" 
                                       name="date" 
                                       id="date" 
                                       class="form-input" 
                                       required
                                       min="${today}">
                                <small class="input-hint">
                                    <i class="fas fa-info-circle"></i>
                                    Sélectionnez une date à partir d'aujourd'hui
                                </small>
                            </div>

                            <div class="form-group">
                                <label for="heure">
                                    <i class="fas fa-clock"></i>
                                    Heure du rendez-vous
                                    <span class="required">*</span>
                                </label>
                                <input type="time" 
                                       name="heure" 
                                       id="heure" 
                                       class="form-input" 
                                       required
                                       min="08:00"
                                       max="18:00"
                                       step="1800">
                                <small class="input-hint">
                                    <i class="fas fa-clock"></i>
                                    Horaires : 08h00 - 18h00 (par tranches de 30min)
                                </small>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="prevStep(1)">
                                <i class="fas fa-arrow-left"></i>
                                <span>Précédent</span>
                            </button>
                            <button type="button" class="btn btn-primary" onclick="nextStep(3)">
                                <span>Suivant</span>
                                <i class="fas fa-arrow-right"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Étape 3 : Détails et Confirmation -->
                    <div class="form-section" data-section="3">
                        <div class="section-header">
                            <h3 class="section-title">
                                <i class="fas fa-notes-medical"></i>
                                Détails de la Consultation
                            </h3>
                        </div>

                        <div class="form-group">
                            <label for="motif">
                                <i class="fas fa-file-medical-alt"></i>
                                Motif de la consultation
                                <span class="optional">(Optionnel)</span>
                            </label>
                            <textarea name="motif" 
                                      id="motif" 
                                      class="form-textarea" 
                                      placeholder="Décrivez brièvement le motif de votre consultation..."
                                      maxlength="500"
                                      rows="5"></textarea>
                            <small class="input-hint">
                                <i class="fas fa-info-circle"></i>
                                Maximum 500 caractères (<span id="charCount">0</span>/500)
                            </small>
                        </div>

                        <!-- Résumé de la réservation -->
                        <div class="reservation-summary">
                            <h4>
                                <i class="fas fa-clipboard-check"></i>
                                Résumé de votre réservation
                            </h4>
                            <div class="summary-grid">
                                <div class="summary-item">
                                    <i class="fas fa-user-md"></i>
                                    <div>
                                        <span class="summary-label">Docteur</span>
                                        <span class="summary-value" id="summaryDocteur">-</span>
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <i class="fas fa-calendar-day"></i>
                                    <div>
                                        <span class="summary-label">Date</span>
                                        <span class="summary-value" id="summaryDate">-</span>
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <i class="fas fa-clock"></i>
                                    <div>
                                        <span class="summary-label">Heure</span>
                                        <span class="summary-value" id="summaryHeure">-</span>
                                    </div>
                                </div>
                                <div class="summary-item">
                                    <i class="fas fa-hourglass-half"></i>
                                    <div>
                                        <span class="summary-label">Durée</span>
                                        <span class="summary-value">30 minutes</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-actions">
                            <button type="button" class="btn btn-secondary" onclick="prevStep(2)">
                                <i class="fas fa-arrow-left"></i>
                                <span>Précédent</span>
                            </button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-calendar-check"></i>
                                <span>Confirmer la Réservation</span>
                            </button>
                        </div>
                    </div>
                </form>
            </div>

            <!-- Bouton Annuler -->
            <div class="cancel-action">
                <button type="button" class="btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/patient/dashboard'">
                    <i class="fas fa-times"></i>
                    <span>Annuler et retourner au dashboard</span>
                </button>
            </div>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/assets/js/patient-reserver.js"></script>
</body>
</html>