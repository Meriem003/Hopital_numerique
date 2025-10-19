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
    <style>
        .form-container {
            max-width: 800px;
            margin: 2rem auto;
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        .form-group label {
            display: block;
            font-weight: 600;
            margin-bottom: 0.5rem;
            color: var(--gray-700);
        }
        
        .form-group label .required {
            color: var(--danger-500);
            margin-left: 0.25rem;
        }
        
        .form-control {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid var(--gray-300);
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        
        .form-control:focus {
            outline: none;
            border-color: var(--primary-500);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }
        
        textarea.form-control {
            min-height: 100px;
            resize: vertical;
        }
        
        .btn-submit {
            background: var(--primary-500);
            color: white;
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 1rem;
        }
        
        .btn-submit:hover {
            background: var(--primary-600);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(59, 130, 246, 0.3);
        }
        
        .btn-cancel {
            background: var(--gray-200);
            color: var(--gray-700);
            padding: 0.875rem 2rem;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            width: 100%;
            margin-top: 0.5rem;
        }
        
        .btn-cancel:hover {
            background: var(--gray-300);
        }
        
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        
        .alert-danger {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }
        
        .alert-success {
            background: #efe;
            color: #3c3;
            border: 1px solid #cfc;
        }
        
        .form-info {
            background: #f0f9ff;
            border-left: 4px solid var(--primary-500);
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        
        .form-info i {
            color: var(--primary-500);
            margin-right: 0.5rem;
        }
        
        .time-slots {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
            gap: 0.5rem;
            margin-top: 0.5rem;
        }
        
        .time-slot {
            padding: 0.5rem;
            border: 2px solid var(--gray-300);
            border-radius: 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .time-slot:hover {
            border-color: var(--primary-500);
            background: var(--primary-50);
        }
        
        .time-slot.selected {
            background: var(--primary-500);
            color: white;
            border-color: var(--primary-500);
        }
        
        .docteur-info {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem;
            border: 1px solid var(--gray-200);
            border-radius: 8px;
            margin-top: 0.5rem;
        }
        
        .docteur-avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: var(--primary-100);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
            color: var(--primary-600);
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

    <main class="main-content">
        <header class="header">
            <div class="header-title">
                <h1><i class="fas fa-calendar-plus"></i> Réserver un Rendez-vous</h1>
                <p>Choisissez un docteur, une date et une heure pour votre consultation</p>
            </div>
            <div class="header-actions">
                <a href="${pageContext.request.contextPath}/patient/dashboard" class="header-btn" style="background: var(--gray-200); color: var(--gray-700);">
                    <i class="fas fa-arrow-left"></i>
                    Retour
                </a>
            </div>
        </header>

        <div class="form-container">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-circle"></i>
                    ${error}
                </div>
            </c:if>

            <c:if test="${not empty success}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${success}
                </div>
            </c:if>

            <div class="form-info">
                <i class="fas fa-info-circle"></i>
                <strong>Information :</strong> Chaque consultation dure 30 minutes. Le créneau sera automatiquement bloqué dans la salle correspondante.
            </div>

            <form method="post" action="${pageContext.request.contextPath}/patient/reserver" id="reservationForm">
                <div class="form-group">
                    <label for="docteurId">
                        Sélectionner un Docteur
                        <span class="required">*</span>
                    </label>
                    <select name="docteurId" id="docteurId" class="form-control" required onchange="updateDocteurInfo()">
                        <option value="">-- Choisir un docteur --</option>
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
                    <div id="docteurInfo" style="display: none;"></div>
                </div>

                <div class="form-group">
                    <label for="date">
                        Date du Rendez-vous
                        <span class="required">*</span>
                    </label>
                    <jsp:useBean id="now" class="java.util.Date"/>
                    <fmt:formatDate value="${now}" pattern="yyyy-MM-dd" var="today"/>
                    <input type="date" 
                           name="date" 
                           id="date" 
                           class="form-control" 
                           required
                           min="${today}">
                </div>

                <div class="form-group">
                    <label for="heure">
                        Heure du Rendez-vous
                        <span class="required">*</span>
                    </label>
                    <input type="time" 
                           name="heure" 
                           id="heure" 
                           class="form-control" 
                           required
                           min="08:00"
                           max="18:00"
                           step="1800">
                    <small style="color: var(--gray-600); font-size: 0.875rem; margin-top: 0.25rem; display: block;">
                        <i class="fas fa-clock"></i> Horaires disponibles : 08h00 - 18h00 (par tranches de 30 minutes)
                    </small>
                </div>

                <div class="form-group">
                    <label for="motif">
                        Motif de la Consultation
                    </label>
                    <textarea name="motif" 
                              id="motif" 
                              class="form-control" 
                              placeholder="Décrivez brièvement le motif de votre consultation (optionnel)"
                              maxlength="500"></textarea>
                    <small style="color: var(--gray-600); font-size: 0.875rem; margin-top: 0.25rem; display: block;">
                        Maximum 500 caractères
                    </small>
                </div>

                <button type="submit" class="btn-submit">
                    <i class="fas fa-calendar-check"></i>
                    Confirmer la Réservation
                </button>
                
                <button type="button" class="btn-cancel" onclick="window.location.href='${pageContext.request.contextPath}/patient/dashboard'">
                    <i class="fas fa-times"></i>
                    Annuler
                </button>
            </form>
        </div>
    </main>

    <script>
        // Mettre à jour la date minimale pour aujourd'hui
        document.addEventListener('DOMContentLoaded', function() {
            const dateInput = document.getElementById('date');
            const today = new Date().toISOString().split('T')[0];
            dateInput.min = today;
        });

        // Afficher les informations du docteur sélectionné
        function updateDocteurInfo() {
            const select = document.getElementById('docteurId');
            const option = select.options[select.selectedIndex];
            const infoDiv = document.getElementById('docteurInfo');
            
            if (option.value) {
                const nom = option.getAttribute('data-nom');
                const prenom = option.getAttribute('data-prenom');
                const specialite = option.getAttribute('data-specialite');
                const departement = option.getAttribute('data-departement');
                
                infoDiv.innerHTML = `
                    <div class="docteur-info">
                        <div class="docteur-avatar">
                            <i class="fas fa-user-md"></i>
                        </div>
                        <div>
                            <strong>Dr. ${nom} ${prenom}</strong><br>
                            <span style="color: var(--gray-600); font-size: 0.875rem;">
                                ${specialite} - ${departement}
                            </span>
                        </div>
                    </div>
                `;
                infoDiv.style.display = 'block';
            } else {
                infoDiv.style.display = 'none';
            }
        }

        // Validation du formulaire
        document.getElementById('reservationForm').addEventListener('submit', function(e) {
            const date = document.getElementById('date').value;
            const heure = document.getElementById('heure').value;
            const docteurId = document.getElementById('docteurId').value;
            
            // Vérifier que la date/heure n'est pas dans le passé
            const selectedDateTime = new Date(date + 'T' + heure);
            const now = new Date();
            
            if (selectedDateTime <= now) {
                e.preventDefault();
                alert('La date et l\'heure doivent être dans le futur');
                return;
            }
        });
    </script>
</body>
</html>
