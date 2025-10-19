<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nos Docteurs - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/patient-dashboard.css" rel="stylesheet">
    <style>
        .search-bar {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .search-input {
            flex: 1;
            padding: 0.75rem 1rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 1rem;
        }
        
        .search-input:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        .doctors-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
            gap: 1.5rem;
        }
        
        .doctor-card {
            background: white;
            border-radius: 16px;
            padding: 2rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .doctor-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 6px;
            background: linear-gradient(90deg, var(--primary-500), var(--primary-600));
            transform: scaleX(0);
            transition: transform 0.3s ease;
        }
        
        .doctor-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 24px rgba(0,0,0,0.15);
        }
        
        .doctor-card:hover::before {
            transform: scaleX(1);
        }
        
        .doctor-avatar-large {
            width: 120px;
            height: 120px;
            margin: 0 auto 1.5rem;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary-100), var(--primary-200));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3rem;
            color: var(--primary-600);
            font-weight: 700;
            border: 4px solid white;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.2);
        }
        
        .doctor-name {
            font-size: 1.5rem;
            font-weight: 700;
            color: var(--gray-800);
            margin-bottom: 0.5rem;
        }
        
        .doctor-specialty {
            display: inline-block;
            padding: 0.5rem 1rem;
            background: var(--primary-100);
            color: var(--primary-700);
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            margin-bottom: 1rem;
        }
        
        .doctor-info-item {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
            padding: 0.5rem 0;
            color: var(--gray-600);
            font-size: 0.9rem;
        }
        
        .doctor-info-item i {
            color: var(--primary-500);
            width: 20px;
        }
        
        .btn-book {
            margin-top: 1.5rem;
            width: 100%;
            padding: 0.875rem;
            background: var(--primary-500);
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 0.5rem;
        }
        
        .btn-book:hover {
            background: var(--primary-600);
            transform: scale(1.02);
        }
        
        .specialties-filter {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
            margin-bottom: 2rem;
        }
        
        .specialty-badge {
            padding: 0.5rem 1rem;
            background: var(--gray-100);
            color: var(--gray-700);
            border-radius: 20px;
            font-size: 0.875rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }
        
        .specialty-badge:hover {
            background: var(--primary-100);
            color: var(--primary-700);
        }
        
        .specialty-badge.active {
            background: var(--primary-500);
            color: white;
            border-color: var(--primary-600);
        }
        
        .empty-state {
            text-align: center;
            padding: 4rem 2rem;
            color: var(--gray-600);
        }
        
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.3;
        }
        
        .stats-bar {
            background: linear-gradient(135deg, var(--primary-500), var(--primary-600));
            color: white;
            padding: 1.5rem;
            border-radius: 12px;
            margin-bottom: 2rem;
            display: flex;
            justify-content: space-around;
            align-items: center;
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .stat-item {
            text-align: center;
        }
        
        .stat-item .number {
            font-size: 2rem;
            font-weight: 700;
        }
        
        .stat-item .label {
            font-size: 0.875rem;
            opacity: 0.9;
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
                    <a href="${pageContext.request.contextPath}/patient/docteurs" class="nav-link active">
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

    <main class="main-content">
        <header class="header">
            <div class="header-title">
                <h1><i class="fas fa-user-md"></i> Nos Docteurs</h1>
                <p>Découvrez notre équipe médicale d'excellence</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/patient/reserver" class="header-btn">
                    <i class="fas fa-calendar-plus"></i>
                    Prendre Rendez-vous
                </a>
            </div>
        </header>

        <c:if test="${not empty error}">
            <div class="alert alert-danger" style="background: #fee; color: #c33; padding: 1rem; border-radius: 8px; margin-bottom: 1.5rem;">
                <i class="fas fa-exclamation-circle"></i>
                ${error}
            </div>
        </c:if>

        <!-- Statistiques -->
        <div class="stats-bar">
            <div class="stat-item">
                <div class="number">${not empty docteurs ? docteurs.size() : 0}</div>
                <div class="label">Docteurs Disponibles</div>
            </div>
            <div class="stat-item">
                <div class="number">15+</div>
                <div class="label">Spécialités</div>
            </div>
            <div class="stat-item">
                <div class="number">24/7</div>
                <div class="label">Service d'Urgence</div>
            </div>
        </div>

        <!-- Barre de recherche -->
        <div class="search-bar">
            <i class="fas fa-search" style="color: var(--gray-400); font-size: 1.25rem;"></i>
            <input type="text" 
                   id="searchInput" 
                   class="search-input" 
                   placeholder="Rechercher un docteur par nom ou spécialité..."
                   onkeyup="filterDoctors()">
        </div>

        <!-- Grille des docteurs -->
        <div class="doctors-grid" id="doctorsGrid">
            <c:choose>
                <c:when test="${not empty docteurs}">
                    <c:forEach items="${docteurs}" var="docteur">
                        <div class="doctor-card" data-name="${docteur.nom} ${docteur.prenom}" data-specialty="${docteur.specialite}">
                            <div class="doctor-avatar-large">
                                ${docteur.prenom.substring(0,1)}${docteur.nom.substring(0,1)}
                            </div>
                            
                            <h3 class="doctor-name">
                                Dr. ${docteur.nom} ${docteur.prenom}
                            </h3>
                            
                            <span class="doctor-specialty">
                                <i class="fas fa-stethoscope"></i>
                                ${docteur.specialite}
                            </span>
                            
                            <div style="margin-top: 1.5rem;">
                                <div class="doctor-info-item">
                                    <i class="fas fa-envelope"></i>
                                    <span>${docteur.email}</span>
                                </div>
                                
                                <c:if test="${not empty docteur.salle}">
                                    <div class="doctor-info-item">
                                        <i class="fas fa-door-open"></i>
                                        <span>Salle ${docteur.salle.nomSalle}</span>
                                    </div>
                                </c:if>
                                
                                <div class="doctor-info-item">
                                    <i class="fas fa-star"></i>
                                    <span>Expérience confirmée</span>
                                </div>
                            </div>
                            
                            <button class="btn-book" onclick="reserverAvec(${docteur.id})">
                                <i class="fas fa-calendar-check"></i>
                                Prendre Rendez-vous
                            </button>
                        </div>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <div class="empty-state" style="grid-column: 1 / -1;">
                        <i class="fas fa-user-md-times"></i>
                        <p>Aucun docteur trouvé</p>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>

    <script>
        // Fonction de recherche en temps réel
        function filterDoctors() {
            const searchInput = document.getElementById('searchInput');
            const filter = searchInput.value.toLowerCase();
            const cards = document.querySelectorAll('.doctor-card');
            let visibleCount = 0;
            
            cards.forEach(card => {
                const name = card.getAttribute('data-name').toLowerCase();
                const specialty = card.getAttribute('data-specialty').toLowerCase();
                
                if (name.includes(filter) || specialty.includes(filter)) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
            
            // Afficher un message si aucun résultat
            const emptyState = document.querySelector('.empty-state');
            if (visibleCount === 0 && filter !== '') {
                if (!emptyState) {
                    const grid = document.getElementById('doctorsGrid');
                    const div = document.createElement('div');
                    div.className = 'empty-state';
                    div.style.gridColumn = '1 / -1';
                    div.innerHTML = `
                        <i class="fas fa-search"></i>
                        <p>Aucun docteur ne correspond à votre recherche</p>
                        <small style="color: var(--gray-500);">Essayez avec un autre nom ou spécialité</small>
                    `;
                    grid.appendChild(div);
                }
            } else if (emptyState && visibleCount > 0) {
                emptyState.remove();
            }
        }
        
        // Fonction pour réserver avec un docteur spécifique
        function reserverAvec(docteurId) {
            window.location.href = '${pageContext.request.contextPath}/patient/reserver?docteurId=' + docteurId;
        }
        
        // Animation au chargement
        document.addEventListener('DOMContentLoaded', function() {
            const cards = document.querySelectorAll('.doctor-card');
            cards.forEach((card, index) => {
                setTimeout(() => {
                    card.style.opacity = '0';
                    card.style.transform = 'translateY(20px)';
                    card.style.transition = 'all 0.5s ease';
                    
                    setTimeout(() => {
                        card.style.opacity = '1';
                        card.style.transform = 'translateY(0)';
                    }, 50);
                }, index * 100);
            });
        });
    </script>
</body>
</html>
