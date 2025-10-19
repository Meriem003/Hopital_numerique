<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Profil - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
    <style>
        .profile-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .profile-header {
            background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
            color: white;
            padding: 2rem;
            border-radius: 16px;
            margin-bottom: 2rem;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
            display: flex;
            align-items: center;
            gap: 2rem;
        }
        
        .profile-avatar-large {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            background: white;
            color: var(--primary-600);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            font-weight: 700;
            border: 4px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.2);
        }
        
        .profile-header-info h2 {
            margin: 0 0 0.5rem 0;
            font-size: 2rem;
        }
        
        .profile-header-info p {
            margin: 0.25rem 0;
            opacity: 0.9;
        }
        
        .profile-tabs {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            border-bottom: 2px solid var(--gray-200);
        }
        
        .profile-tab {
            padding: 1rem 1.5rem;
            background: none;
            border: none;
            color: var(--gray-600);
            font-weight: 600;
            cursor: pointer;
            position: relative;
            transition: all 0.3s ease;
        }
        
        .profile-tab:hover {
            color: var(--primary-600);
        }
        
        .profile-tab.active {
            color: var(--primary-600);
        }
        
        .profile-tab.active::after {
            content: '';
            position: absolute;
            bottom: -2px;
            left: 0;
            right: 0;
            height: 2px;
            background: var(--primary-600);
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .form-section {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 1.5rem;
        }
        
        .form-section-title {
            font-size: 1.25rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .form-section-title i {
            color: var(--primary-500);
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-weight: 600;
            color: var(--gray-700);
            margin-bottom: 0.5rem;
            font-size: 0.875rem;
        }
        
        .form-group input,
        .form-group select,
        .form-group textarea {
            padding: 0.75rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .form-group textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        .info-card {
            background: var(--gray-50);
            padding: 1rem;
            border-radius: 8px;
            border-left: 4px solid var(--primary-500);
        }
        
        .info-card p {
            margin: 0;
            color: var(--gray-700);
            font-size: 0.875rem;
        }
        
        .btn-group {
            display: flex;
            gap: 1rem;
            justify-content: flex-end;
            margin-top: 2rem;
        }
        
        .btn {
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn-primary {
            background: var(--primary-500);
            color: white;
        }
        
        .btn-primary:hover {
            background: var(--primary-600);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .btn-secondary {
            background: var(--gray-200);
            color: var(--gray-700);
        }
        
        .btn-secondary:hover {
            background: var(--gray-300);
        }
        
        .alert {
            padding: 1rem 1.5rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }
        
        .alert-success {
            background: #d1fae5;
            color: #065f46;
            border-left: 4px solid #10b981;
        }
        
        .alert-danger {
            background: #fee;
            color: #c33;
            border-left: 4px solid #ef4444;
        }
        
        .stat-badge {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: var(--gray-100);
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            color: var(--gray-700);
        }
        
        .health-metrics {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-top: 1rem;
        }
        
        .metric-card {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            border: 2px solid var(--gray-200);
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .metric-card:hover {
            border-color: var(--primary-500);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.1);
        }
        
        .metric-icon {
            width: 50px;
            height: 50px;
            margin: 0 auto 1rem;
            border-radius: 50%;
            background: var(--primary-100);
            color: var(--primary-600);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
        }
        
        .metric-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--gray-800);
        }
        
        .metric-label {
            color: var(--gray-600);
            font-size: 0.875rem;
            margin-top: 0.5rem;
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
                <p>Espace Patient</p>
            </div>
        </div>

        <div class="user-profile">
            <div class="user-avatar">
                ${sessionScope.user.prenom.substring(0,1)}${sessionScope.user.nom.substring(0,1)}
            </div>
            <div class="user-info">
                <h4>${sessionScope.user.prenom} ${sessionScope.user.nom}</h4>
                <p>Patient ID: #${sessionScope.user.id}</p>
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
                    <a href="${pageContext.request.contextPath}/patient/reserver" class="nav-link">
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
                    <a href="${pageContext.request.contextPath}/patient/profil" class="nav-link active">
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
        <div class="profile-container">
            <!-- En-tête du profil -->
            <div class="profile-header">
                <div class="profile-avatar-large">
                    ${sessionScope.user.prenom.substring(0,1)}${sessionScope.user.nom.substring(0,1)}
                </div>
                <div class="profile-header-info">
                    <h2>${sessionScope.user.prenom} ${sessionScope.user.nom}</h2>
                    <p><i class="fas fa-id-card"></i> Patient ID: #${sessionScope.user.id}</p>
                    <p><i class="fas fa-envelope"></i> ${sessionScope.user.email}</p>
                    <c:if test="${not empty sessionScope.user.poids}">
                        <p><i class="fas fa-weight"></i> Poids: ${sessionScope.user.poids} kg</p>
                    </c:if>
                </div>
            </div>

            <!-- Messages -->
            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <!-- Onglets -->
            <div class="profile-tabs">
                <button class="profile-tab active" onclick="switchTab('info')">
                    <i class="fas fa-user"></i> Informations Personnelles
                </button>
                <button class="profile-tab" onclick="switchTab('health')">
                    <i class="fas fa-heartbeat"></i> Santé & Mesures
                </button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/patient/profil">
                <!-- Onglet Informations Personnelles -->
                <div id="info" class="tab-content active">
                    <div class="form-section">
                        <h3 class="form-section-title">
                            <i class="fas fa-user"></i>
                            Informations de Base
                        </h3>
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="nom">Nom *</label>
                                <input type="text" id="nom" name="nom" 
                                       value="${sessionScope.user.nom}" required>
                            </div>
                            <div class="form-group">
                                <label for="prenom">Prénom *</label>
                                <input type="text" id="prenom" name="prenom" 
                                       value="${sessionScope.user.prenom}" required>
                            </div>
                            <div class="form-group full-width">
                                <label for="email">Email *</label>
                                <input type="email" id="email" name="email" 
                                       value="${sessionScope.user.email}" required>
                            </div>
                        </div>
                        
                        <div class="info-card" style="margin-top: 1.5rem;">
                            <p>
                                <i class="fas fa-info-circle"></i>
                                Pour modifier votre mot de passe ou d'autres informations sensibles, veuillez contacter l'administration.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Onglet Santé -->
                <div id="health" class="tab-content">
                    <div class="form-section">
                        <h3 class="form-section-title">
                            <i class="fas fa-heartbeat"></i>
                            Mesures de Santé
                        </h3>
                        
                        <!-- Métriques actuelles -->
                        <div class="health-metrics">
                            <div class="metric-card">
                                <div class="metric-icon">
                                    <i class="fas fa-weight"></i>
                                </div>
                                <div class="metric-value">
                                    ${not empty sessionScope.user.poids ? sessionScope.user.poids : '--'}
                                </div>
                                <div class="metric-label">Poids (kg)</div>
                            </div>
                            <div class="metric-card">
                                <div class="metric-icon">
                                    <i class="fas fa-ruler-vertical"></i>
                                </div>
                                <div class="metric-value">
                                    ${not empty sessionScope.user.taille ? sessionScope.user.taille : '--'}
                                </div>
                                <div class="metric-label">Taille (cm)</div>
                            </div>
                            <div class="metric-card">
                                <div class="metric-icon">
                                    <i class="fas fa-calculator"></i>
                                </div>
                                <div class="metric-value">
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.user.IMC}">
                                            <fmt:formatNumber value="${sessionScope.user.IMC}" pattern="#.#"/>
                                        </c:when>
                                        <c:otherwise>--</c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="metric-label">IMC</div>
                            </div>
                        </div>
                        
                        <!-- Formulaire de mise à jour -->
                        <div class="form-grid" style="margin-top: 2rem;">
                            <div class="form-group">
                                <label for="poids">Poids (kg)</label>
                                <input type="number" step="0.1" id="poids" name="poids" 
                                       value="${sessionScope.user.poids}"
                                       placeholder="Ex: 70.5">
                            </div>
                            <div class="form-group">
                                <label for="taille">Taille (cm)</label>
                                <input type="number" id="taille" name="taille" 
                                       value="${sessionScope.user.taille}"
                                       placeholder="Ex: 175">
                            </div>
                        </div>
                        
                        <div class="info-card" style="margin-top: 1.5rem;">
                            <p>
                                <i class="fas fa-info-circle"></i>
                                L'IMC (Indice de Masse Corporelle) est calculé automatiquement à partir de votre poids et taille.
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Boutons d'action -->
                <div class="btn-group">
                    <button type="button" class="btn btn-secondary" onclick="resetForm()">
                        <i class="fas fa-undo"></i>
                        Annuler
                    </button>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-save"></i>
                        Enregistrer les modifications
                    </button>
                </div>
            </form>
        </div>
    </main>

    <script>
        function switchTab(tabName) {
            // Cacher tous les onglets
            document.querySelectorAll('.tab-content').forEach(tab => {
                tab.classList.remove('active');
            });
            
            // Désactiver tous les boutons d'onglets
            document.querySelectorAll('.profile-tab').forEach(button => {
                button.classList.remove('active');
            });
            
            // Afficher l'onglet sélectionné
            document.getElementById(tabName).classList.add('active');
            event.target.closest('.profile-tab').classList.add('active');
        }
        
        function resetForm() {
            if (confirm('Êtes-vous sûr de vouloir annuler vos modifications ?')) {
                location.reload();
            }
        }
        
        // Animation au chargement
        document.addEventListener('DOMContentLoaded', function() {
            const sections = document.querySelectorAll('.form-section');
            sections.forEach((section, index) => {
                setTimeout(() => {
                    section.style.opacity = '0';
                    section.style.transform = 'translateY(20px)';
                    section.style.transition = 'all 0.5s ease';
                    
                    setTimeout(() => {
                        section.style.opacity = '1';
                        section.style.transform = 'translateY(0)';
                    }, 50);
                }, index * 150);
            });
        });
    </script>
</body>
</html>
