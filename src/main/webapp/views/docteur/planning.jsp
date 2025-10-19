<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%@ page import="java.time.format.TextStyle" %>
<%@ page import="java.util.Locale" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mon Planning - Clinique Excellence</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/docteur-dashboard.css">
    <style>
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            padding: 1.5rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .calendar-navigation {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .calendar-navigation button {
            background: var(--primary-color, #4F46E5);
            color: white;
            border: none;
            padding: 0.5rem 1rem;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .calendar-navigation button:hover {
            background: #4338CA;
            transform: translateY(-2px);
        }

        .current-month {
            font-size: 1.5rem;
            font-weight: 600;
            color: #1F2937;
        }

        .view-toggle {
            display: flex;
            gap: 0.5rem;
        }

        .view-toggle button {
            padding: 0.5rem 1rem;
            border: 2px solid #E5E7EB;
            background: white;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .view-toggle button.active {
            background: var(--primary-color, #4F46E5);
            color: white;
            border-color: var(--primary-color, #4F46E5);
        }

        .planning-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .day-column {
            background: white;
            border-radius: 12px;
            padding: 1rem;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .day-header {
            text-align: center;
            padding-bottom: 1rem;
            border-bottom: 2px solid #E5E7EB;
            margin-bottom: 1rem;
        }

        .day-name {
            font-size: 0.875rem;
            color: #6B7280;
            font-weight: 500;
            text-transform: uppercase;
        }

        .day-number {
            font-size: 1.5rem;
            font-weight: 700;
            color: #1F2937;
            margin-top: 0.25rem;
        }

        .day-column.today .day-header {
            background: linear-gradient(135deg, #4F46E5 0%, #7C3AED 100%);
            color: white;
            border-radius: 8px;
            padding: 0.75rem;
            border-bottom: none;
        }

        .day-column.today .day-name,
        .day-column.today .day-number {
            color: white;
        }

        .time-slot {
            background: #F9FAFB;
            padding: 0.75rem;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            border-left: 3px solid #E5E7EB;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .time-slot:hover {
            transform: translateX(4px);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }

        .time-slot.reserved {
            background: linear-gradient(135deg, #EFF6FF 0%, #DBEAFE 100%);
            border-left-color: #3B82F6;
        }

        .time-slot.confirmed {
            background: linear-gradient(135deg, #F0FDF4 0%, #DCFCE7 100%);
            border-left-color: #10B981;
        }

        .time-slot.completed {
            background: linear-gradient(135deg, #F3F4F6 0%, #E5E7EB 100%);
            border-left-color: #6B7280;
        }

        .time-slot.cancelled {
            background: linear-gradient(135deg, #FEF2F2 0%, #FEE2E2 100%);
            border-left-color: #EF4444;
            opacity: 0.7;
        }

        .slot-time {
            font-weight: 600;
            font-size: 0.875rem;
            color: #1F2937;
            margin-bottom: 0.25rem;
        }

        .slot-patient {
            font-size: 0.813rem;
            color: #4B5563;
            margin-bottom: 0.25rem;
            display: flex;
            align-items: center;
            gap: 0.25rem;
        }

        .slot-type {
            font-size: 0.75rem;
            color: #6B7280;
            font-style: italic;
        }

        .slot-status {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-top: 0.5rem;
        }

        .slot-status.reserved {
            background: #DBEAFE;
            color: #1E40AF;
        }

        .slot-status.confirmed {
            background: #DCFCE7;
            color: #166534;
        }

        .slot-status.completed {
            background: #E5E7EB;
            color: #374151;
        }

        .slot-status.cancelled {
            background: #FEE2E2;
            color: #991B1B;
        }

        .legend {
            display: flex;
            gap: 2rem;
            padding: 1.5rem;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        .legend-color {
            width: 20px;
            height: 20px;
            border-radius: 4px;
        }

        .legend-color.reserved {
            background: #3B82F6;
        }

        .legend-color.confirmed {
            background: #10B981;
        }

        .legend-color.completed {
            background: #6B7280;
        }

        .legend-color.cancelled {
            background: #EF4444;
        }

        .stats-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
            margin-bottom: 2rem;
        }

        .stat-box {
            background: white;
            padding: 1.5rem;
            border-radius: 12px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            text-align: center;
        }

        .stat-box .number {
            font-size: 2rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }

        .stat-box .label {
            color: #6B7280;
            font-size: 0.875rem;
        }

        .stat-box.blue .number {
            color: #3B82F6;
        }

        .stat-box.green .number {
            color: #10B981;
        }

        .stat-box.gray .number {
            color: #6B7280;
        }

        .stat-box.red .number {
            color: #EF4444;
        }

        .empty-slot {
            text-align: center;
            padding: 2rem;
            color: #9CA3AF;
            font-size: 0.875rem;
        }

        @media (max-width: 1400px) {
            .planning-grid {
                grid-template-columns: repeat(5, 1fr);
            }
        }

        @media (max-width: 1024px) {
            .planning-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .planning-grid {
                grid-template-columns: 1fr;
            }

            .calendar-header {
                flex-direction: column;
                gap: 1rem;
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

        <div class="user-profile">
            <div class="user-avatar">SA</div>
            <div class="user-info">
                <h4>Dr. Sara Alami</h4>
                <p>Cardiologie</p>
            </div>
        </div>

        <nav>
            <ul class="nav-menu">
                <li class="nav-item">
                    <a href="dashboard.jsp" class="nav-link">
                        <i class="fas fa-chart-line"></i>
                        <span>Dashboard</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="${pageContext.request.contextPath}/docteur/planning" class="nav-link active">
                        <i class="fas fa-calendar-alt"></i>
                        <span>Mon Planning</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="reservations.jsp" class="nav-link">
                        <i class="fas fa-clock"></i>
                        <span>Réservations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="mes-consultations.jsp" class="nav-link">
                        <i class="fas fa-stethoscope"></i>
                        <span>Mes Consultations</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="patients-suivis.jsp" class="nav-link">
                        <i class="fas fa-users"></i>
                        <span>Patients Suivis</span>
                    </a>
                </li>
                <li class="nav-item">
                    <a href="profil.jsp" class="nav-link">
                        <i class="fas fa-user-circle"></i>
                        <span>Mon Profil</span>
                    </a>
                </li>
            </ul>
        </nav>

        <button class="logout-btn" onclick="location.href='LogoutServlet'">
            <i class="fas fa-sign-out-alt"></i>
            Déconnexion
        </button>
    </aside>

    <main class="main-content">
        <header class="header">
            <div class="header-title">
                <h1><i class="fas fa-calendar-alt"></i> Mon Planning</h1>
                <p>Consultez et gérez vos consultations</p>
            </div>
            <div class="header-actions">
                <button class="header-btn" onclick="window.print()">
                    <i class="fas fa-print"></i>
                    Imprimer
                </button>
                <button class="header-btn">
                    <i class="fas fa-download"></i>
                    Exporter
                </button>
            </div>
        </header>

        <div class="stats-row">
            <div class="stat-box blue">
                <div class="number">${totalWeek != null ? totalWeek : 0}</div>
                <div class="label">Consultations cette semaine</div>
            </div>
            <div class="stat-box blue">
                <div class="number">${reserveesCount != null ? reserveesCount : 0}</div>
                <div class="label">Réservées</div>
            </div>
            <div class="stat-box green">
                <div class="number">${confirmeesCount != null ? confirmeesCount : 0}</div>
                <div class="label">Validées</div>
            </div>
            <div class="stat-box gray">
                <div class="number">${completeesCount != null ? completeesCount : 0}</div>
                <div class="label">Terminées</div>
            </div>
            <div class="stat-box red">
                <div class="number">${annuleesCount != null ? annuleesCount : 0}</div>
                <div class="label">Annulées</div>
            </div>
        </div>

        <div class="calendar-header">
            <div class="calendar-navigation">
                <button onclick="navigateWeek(-1)">
                    <i class="fas fa-chevron-left"></i>
                </button>
                <span class="current-month">${periodLabel != null ? periodLabel : ''}</span>
                <button onclick="navigateWeek(1)">
                    <i class="fas fa-chevron-right"></i>
                </button>
            </div>
            <div class="view-toggle">
                <button class="active">
                    <i class="fas fa-calendar-week"></i> Semaine
                </button>
                <button>
                    <i class="fas fa-calendar-day"></i> Jour
                </button>
                <button>
                    <i class="fas fa-calendar"></i> Mois
                </button>
            </div>
        </div>

        <div class="legend">
            <div class="legend-item">
                <div class="legend-color reserved"></div>
                <span>Réservé</span>
            </div>
            <div class="legend-item">
                <div class="legend-color confirmed"></div>
                <span>Confirmé</span>
            </div>
            <div class="legend-item">
                <div class="legend-color completed"></div>
                <span>Complété</span>
            </div>
            <div class="legend-item">
                <div class="legend-color cancelled"></div>
                <span>Annulé</span>
            </div>
        </div>

        <div class="planning-grid">
            <c:forEach var="entry" items="${consultationsByDay}">
                <%
                    java.util.Map.Entry<LocalDate, java.util.List> entry = 
                        (java.util.Map.Entry<LocalDate, java.util.List>) pageContext.getAttribute("entry");
                    LocalDate date = entry.getKey();
                    LocalDate today = (LocalDate) request.getAttribute("today");
                    boolean isToday = date.equals(today);
                    
                    String dayName = date.getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.FRENCH);
                    dayName = dayName.substring(0, 1).toUpperCase() + dayName.substring(1);
                    int dayNumber = date.getDayOfMonth();
                    
                    pageContext.setAttribute("dayName", dayName);
                    pageContext.setAttribute("dayNumber", dayNumber);
                    pageContext.setAttribute("isToday", isToday);
                    pageContext.setAttribute("dayConsultations", entry.getValue());
                %>
                
                <div class="day-column ${isToday ? 'today' : ''}">
                    <div class="day-header">
                        <div class="day-name">${isToday ? 'Aujourd\'hui' : dayName}</div>
                        <div class="day-number">${dayNumber}</div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${empty dayConsultations}">
                            <div class="empty-slot">
                                <i class="fas fa-calendar-times"></i>
                                <p>Aucune consultation</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="consultation" items="${dayConsultations}">
                                <%
                                    com.clinic.clinicapp.entity.Consultation consultation = 
                                        (com.clinic.clinicapp.entity.Consultation) pageContext.getAttribute("consultation");
                                    String statusClass = "";
                                    String statusLabel = "";
                                    
                                    switch (consultation.getStatut()) {
                                        case RESERVEE:
                                            statusClass = "reserved";
                                            statusLabel = "Réservé";
                                            break;
                                        case VALIDEE:
                                            statusClass = "confirmed";
                                            statusLabel = "Validé";
                                            break;
                                        case TERMINEE:
                                            statusClass = "completed";
                                            statusLabel = "Terminé";
                                            break;
                                        case ANNULEE:
                                            statusClass = "cancelled";
                                            statusLabel = "Annulé";
                                            break;
                                    }
                                    
                                    DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                                    String heureDebut = consultation.getDateHeure().format(timeFormatter);
                                    String heureFin = consultation.getDateHeure().plusMinutes(30).format(timeFormatter);
                                    
                                    pageContext.setAttribute("statusClass", statusClass);
                                    pageContext.setAttribute("statusLabel", statusLabel);
                                    pageContext.setAttribute("heureDebut", heureDebut);
                                    pageContext.setAttribute("heureFin", heureFin);
                                %>
                                
                                <div class="time-slot ${statusClass}" data-consultation-id="${consultation.id}">
                                    <div class="slot-time">
                                        <i class="fas fa-clock"></i> ${heureDebut} - ${heureFin}
                                    </div>
                                    <div class="slot-patient">
                                        <i class="fas fa-user"></i> 
                                        ${consultation.patient.nom} ${consultation.patient.prenom}
                                    </div>
                                    <div class="slot-type">
                                        ${consultation.motif != null ? consultation.motif : 'Consultation'}
                                    </div>
                                    <span class="slot-status ${statusClass}">${statusLabel}</span>
                                </div>
                            </c:forEach>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:forEach>
        </div>
    </main>

    <script>
        function navigateWeek(offset) {
            const currentOffset = <c:out value="${weekOffset != null ? weekOffset : 0}" />;
            const newOffset = currentOffset + offset;
            window.location.href = '<c:url value="/docteur/planning" />?weekOffset=' + newOffset;
        }

        // Ajouter des événements de clic sur les créneaux
        document.querySelectorAll('.time-slot').forEach(slot => {
            slot.addEventListener('click', function() {
                if (!this.classList.contains('cancelled')) {
                    const consultationId = this.getAttribute('data-consultation-id');
                    // Rediriger vers la page de détails de la consultation
                    window.location.href = '<c:url value="/docteur/consultation-details" />?id=' + consultationId;
                }
            });
        });
    </script>
</body>
</html>
