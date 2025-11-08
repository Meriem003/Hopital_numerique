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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/planning.css">
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
                    <a href="${pageContext.request.contextPath}/docteur/planning" class="nav-link active">
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
                    <a href="${pageContext.request.contextPath}/docteur/profil" class="nav-link">
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
                <!-- Header Section -->
        <div class="consultations-header">
            <div class="header-content">
                <div>
                    <h1>
                        <i class="fas fa-calendar-check"></i>
                        Mon Planning
                    </h1>
                    <p>Consultez et gérez vos consultations</p>
                </div>
                <a href="${pageContext.request.contextPath}/docteur/reservations" class="btn-header">
                    <i class="fas fa-calendar-plus"></i>
                    Réservations
                </a>
            </div>
        </div>
        <!-- Calendar Navigation -->
        <div class="calendar-nav">
            <button class="nav-btn" onclick="navigateWeek(-1)">
                <i class="fas fa-chevron-left"></i>
            </button>
            <span class="current-period">${periodLabel != null ? periodLabel : 'Semaine actuelle'}</span>
            <button class="nav-btn" onclick="navigateWeek(1)">
                <i class="fas fa-chevron-right"></i>
            </button>
        </div>

        <!-- Planning Grid -->
        <div class="planning-container">
            <div class="planning-grid">
                <c:forEach var="entry" items="${consultationsByDay}">
                    <%
                        java.util.Map.Entry<LocalDate, java.util.List> entry = 
                            (java.util.Map.Entry<LocalDate, java.util.List>) pageContext.getAttribute("entry");
                        LocalDate date = entry.getKey();
                        LocalDate today = (LocalDate) request.getAttribute("today");
                        boolean isToday = date.equals(today);
                        
                        String dayName = date.getDayOfWeek().getDisplayName(TextStyle.SHORT, Locale.FRENCH);
                        dayName = dayName.substring(0, 1).toUpperCase() + dayName.substring(1);
                        int dayNumber = date.getDayOfMonth();
                        
                        pageContext.setAttribute("dayName", dayName);
                        pageContext.setAttribute("dayNumber", dayNumber);
                        pageContext.setAttribute("isToday", isToday);
                        pageContext.setAttribute("dayConsultations", entry.getValue());
                    %>
                    
                    <div class="day-card ${isToday ? 'today' : ''}">
                        <div class="day-header">
                            <div class="day-label">
                                <span class="day-name">${dayName}</span>
                                <span class="day-number">${dayNumber}</span>
                            </div>
                            <c:if test="${not empty dayConsultations}">
                                <span class="consultation-count">${dayConsultations.size()}</span>
                            </c:if>
                        </div>
                        
                        <div class="day-slots">
                            <c:choose>
                                <c:when test="${empty dayConsultations}">
                                    <div class="empty-state">
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
                                            String statusIcon = "";
                                            
                                            switch (consultation.getStatut()) {
                                                case RESERVEE:
                                                    statusClass = "reserved";
                                                    statusIcon = "fa-hourglass-half";
                                                    break;
                                                case VALIDEE:
                                                    statusClass = "confirmed";
                                                    statusIcon = "fa-check";
                                                    break;
                                                case TERMINEE:
                                                    statusClass = "completed";
                                                    statusIcon = "fa-check-double";
                                                    break;
                                                case ANNULEE:
                                                    statusClass = "cancelled";
                                                    statusIcon = "fa-times";
                                                    break;
                                            }
                                            
                                            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");
                                            String heureDebut = consultation.getDateHeure().format(timeFormatter);
                                            
                                            pageContext.setAttribute("statusClass", statusClass);
                                            pageContext.setAttribute("statusIcon", statusIcon);
                                            pageContext.setAttribute("heureDebut", heureDebut);
                                        %>
                                        
                                        <div class="consultation-slot ${statusClass}" data-consultation-id="${consultation.id}">
                                            <div class="slot-time">
                                                <i class="fas fa-clock"></i> ${heureDebut}
                                            </div>
                                            <div class="slot-patient">
                                                ${consultation.patient.nom} ${consultation.patient.prenom}
                                            </div>
                                            <div class="slot-status">
                                                <i class="fas ${statusIcon}"></i>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- Legend -->
        <div class="legend">
            <div class="legend-item">
                <div class="legend-dot reserved"></div>
                <span>Réservé</span>
            </div>
            <div class="legend-item">
                <div class="legend-dot confirmed"></div>
                <span>Confirmé</span>
            </div>
            <div class="legend-item">
                <div class="legend-dot completed"></div>
                <span>Complété</span>
            </div>
            <div class="legend-item">
                <div class="legend-dot cancelled"></div>
                <span>Annulé</span>
            </div>
        </div>
    </main>

    <script>
        function navigateWeek(offset) {
            const currentOffset = <c:out value="${weekOffset != null ? weekOffset : 0}" />;
            const newOffset = currentOffset + offset;
            window.location.href = '<c:url value="/docteur/planning" />?weekOffset=' + newOffset;
        }

        function exportPlanning() {
            const element = document.querySelector('.planning-container');
            const opt = {
                margin: 10,
                filename: 'planning.pdf',
                image: { type: 'jpeg', quality: 0.98 },
                html2canvas: { scale: 2 },
                jsPDF: { orientation: 'landscape', unit: 'mm', format: 'a4' }
            };
            // Note: Requires html2pdf library
            alert('Export en PDF - À implémenter avec html2pdf');
        }

        // Click handler for consultation slots
        document.querySelectorAll('.consultation-slot').forEach(slot => {
            slot.addEventListener('click', function() {
                if (!this.classList.contains('cancelled')) {
                    const consultationId = this.getAttribute('data-consultation-id');
                    window.location.href = '<c:url value="/docteur/consultation-details" />?id=' + consultationId;
                }
            });
        });
    </script>
</body>
</html>
