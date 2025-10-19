/**
 * Admin Dashboard - JavaScript Interactions
 * Gestion des animations, interactions et fonctionnalités dynamiques
 */

// Initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    initSidebar();
    initStatCards();
    initCharts();
    initActivityFeed();
    initTooltips();
    initSearchAndFilters();
    initNotifications();
    initThemeToggle();
});

/**
 * Gestion de la sidebar mobile
 */
function initSidebar() {
    const sidebar = document.querySelector('.sidebar');
    const toggleBtn = document.querySelector('.sidebar-toggle');
    const overlay = document.createElement('div');
    overlay.className = 'sidebar-overlay';
    
    if (toggleBtn) {
        toggleBtn.addEventListener('click', () => {
            sidebar.classList.toggle('active');
            overlay.classList.toggle('active');
        });
    }
    
    // Fermer la sidebar au clic sur l'overlay
    overlay.addEventListener('click', () => {
        sidebar.classList.remove('active');
        overlay.classList.remove('active');
    });
    
    document.body.appendChild(overlay);
    
    // Animation des liens de navigation
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });
}

/**
 * Animation et interactions des cartes statistiques
 */
function initStatCards() {
    const statCards = document.querySelectorAll('.stat-card');
    
    statCards.forEach((card, index) => {
        // Animation au scroll
        observeElement(card);
        
        // Effet de compteur animé pour les valeurs
        const valueElement = card.querySelector('.stat-value');
        if (valueElement) {
            const finalValue = parseInt(valueElement.textContent);
            if (!isNaN(finalValue)) {
                animateCounter(valueElement, 0, finalValue, 2000);
            }
        }
        
        // Effet de survol avancé
        card.addEventListener('mouseenter', function() {
            this.style.zIndex = '10';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.zIndex = '1';
        });
    });
}

/**
 * Animation de compteur pour les valeurs numériques
 */
function animateCounter(element, start, end, duration) {
    let startTime = null;
    const step = (timestamp) => {
        if (!startTime) startTime = timestamp;
        const progress = Math.min((timestamp - startTime) / duration, 1);
        const currentValue = Math.floor(progress * (end - start) + start);
        element.textContent = currentValue;
        if (progress < 1) {
            window.requestAnimationFrame(step);
        } else {
            element.textContent = end;
        }
    };
    window.requestAnimationFrame(step);
}

/**
 * Initialisation des graphiques (si Chart.js est disponible)
 */
function initCharts() {
    if (typeof Chart !== 'undefined') {
        // Graphique des consultations
        const consultationsChart = document.getElementById('consultationsChart');
        if (consultationsChart) {
            new Chart(consultationsChart, {
                type: 'line',
                data: {
                    labels: ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'],
                    datasets: [{
                        label: 'Consultations',
                        data: [12, 19, 15, 25, 22, 18, 20],
                        borderColor: 'rgb(59, 130, 246)',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
                        tension: 0.4,
                        fill: true
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: false
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        }
        
        // Graphique de répartition des départements
        const departmentsChart = document.getElementById('departmentsChart');
        if (departmentsChart) {
            new Chart(departmentsChart, {
                type: 'doughnut',
                data: {
                    labels: ['Cardiologie', 'Pédiatrie', 'Dermatologie', 'Neurologie', 'Autres'],
                    datasets: [{
                        data: [30, 25, 20, 15, 10],
                        backgroundColor: [
                            'rgb(59, 130, 246)',
                            'rgb(16, 185, 129)',
                            'rgb(245, 158, 11)',
                            'rgb(139, 92, 246)',
                            'rgb(236, 72, 153)'
                        ]
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            position: 'bottom'
                        }
                    }
                }
            });
        }
    }
}

/**
 * Fil d'activité en temps réel
 */
function initActivityFeed() {
    const activityList = document.querySelector('.activity-list');
    if (!activityList) return;
    
    // Simulation de nouvelles activités
    setInterval(() => {
        if (Math.random() > 0.7) { // 30% de chance
            addNewActivity();
        }
    }, 10000); // Toutes les 10 secondes
}

function addNewActivity() {
    const activityList = document.querySelector('.activity-list');
    if (!activityList) return;
    
    const activities = [
        { icon: 'fas fa-user-plus', color: 'blue', title: 'Nouveau patient enregistré', desc: 'Jean Dupont', time: 'À l\'instant' },
        { icon: 'fas fa-calendar-check', color: 'green', title: 'Consultation validée', desc: 'Dr. Martin', time: 'À l\'instant' },
        { icon: 'fas fa-stethoscope', color: 'orange', title: 'Nouveau rendez-vous', desc: 'Cardiologie', time: 'À l\'instant' }
    ];
    
    const activity = activities[Math.floor(Math.random() * activities.length)];
    
    const activityItem = document.createElement('div');
    activityItem.className = 'activity-item';
    activityItem.style.opacity = '0';
    activityItem.innerHTML = `
        <div class="activity-icon ${activity.color}">
            <i class="${activity.icon}"></i>
        </div>
        <div class="activity-content">
            <h4>${activity.title}</h4>
            <p>${activity.desc}</p>
        </div>
        <span class="activity-time">${activity.time}</span>
    `;
    
    activityList.insertBefore(activityItem, activityList.firstChild);
    
    // Animation d'apparition
    setTimeout(() => {
        activityItem.style.transition = 'opacity 0.5s ease, transform 0.5s ease';
        activityItem.style.opacity = '1';
        activityItem.style.transform = 'translateY(0)';
    }, 100);
    
    // Limiter à 5 activités
    while (activityList.children.length > 5) {
        activityList.removeChild(activityList.lastChild);
    }
}

/**
 * Tooltips personnalisés
 */
function initTooltips() {
    const elements = document.querySelectorAll('[data-tooltip]');
    
    elements.forEach(element => {
        const tooltip = document.createElement('div');
        tooltip.className = 'custom-tooltip';
        tooltip.textContent = element.getAttribute('data-tooltip');
        document.body.appendChild(tooltip);
        
        element.addEventListener('mouseenter', function(e) {
            tooltip.style.display = 'block';
            positionTooltip(e, tooltip);
        });
        
        element.addEventListener('mousemove', function(e) {
            positionTooltip(e, tooltip);
        });
        
        element.addEventListener('mouseleave', function() {
            tooltip.style.display = 'none';
        });
    });
}

function positionTooltip(e, tooltip) {
    const x = e.clientX;
    const y = e.clientY;
    tooltip.style.left = (x + 15) + 'px';
    tooltip.style.top = (y + 15) + 'px';
}

/**
 * Recherche et filtres
 */
function initSearchAndFilters() {
    const searchInput = document.querySelector('.search-input');
    const filterButtons = document.querySelectorAll('.filter-btn');
    
    if (searchInput) {
        searchInput.addEventListener('input', debounce(function(e) {
            const searchTerm = e.target.value.toLowerCase();
            filterTable(searchTerm);
        }, 300));
    }
    
    if (filterButtons) {
        filterButtons.forEach(btn => {
            btn.addEventListener('click', function() {
                filterButtons.forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                const filter = this.getAttribute('data-filter');
                applyFilter(filter);
            });
        });
    }
}

function filterTable(searchTerm) {
    const rows = document.querySelectorAll('.data-table tbody tr');
    rows.forEach(row => {
        const text = row.textContent.toLowerCase();
        row.style.display = text.includes(searchTerm) ? '' : 'none';
    });
}

function applyFilter(filter) {
    const rows = document.querySelectorAll('.data-table tbody tr');
    rows.forEach(row => {
        if (filter === 'all') {
            row.style.display = '';
        } else {
            const badge = row.querySelector('.badge');
            if (badge && badge.classList.contains(filter)) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        }
    });
}

/**
 * Système de notifications
 */
function initNotifications() {
    // Vérifier les nouvelles notifications toutes les 30 secondes
    setInterval(checkNotifications, 30000);
}

function checkNotifications() {
    // Simuler la vérification de nouvelles notifications
    if (Math.random() > 0.8) {
        showNotification('Nouvelle activité', 'Un nouveau patient s\'est inscrit', 'info');
    }
}

function showNotification(title, message, type = 'info') {
    const notification = document.createElement('div');
    notification.className = `notification notification-${type}`;
    notification.innerHTML = `
        <div class="notification-icon">
            <i class="fas fa-${getNotificationIcon(type)}"></i>
        </div>
        <div class="notification-content">
            <h4>${title}</h4>
            <p>${message}</p>
        </div>
        <button class="notification-close">
            <i class="fas fa-times"></i>
        </button>
    `;
    
    document.body.appendChild(notification);
    
    // Animation d'entrée
    setTimeout(() => {
        notification.classList.add('show');
    }, 100);
    
    // Bouton de fermeture
    const closeBtn = notification.querySelector('.notification-close');
    closeBtn.addEventListener('click', () => {
        notification.classList.remove('show');
        setTimeout(() => notification.remove(), 300);
    });
    
    // Auto-fermeture après 5 secondes
    setTimeout(() => {
        if (notification.parentElement) {
            notification.classList.remove('show');
            setTimeout(() => notification.remove(), 300);
        }
    }, 5000);
}

function getNotificationIcon(type) {
    const icons = {
        'info': 'info-circle',
        'success': 'check-circle',
        'warning': 'exclamation-triangle',
        'error': 'times-circle'
    };
    return icons[type] || 'info-circle';
}

/**
 * Toggle thème clair/sombre (optionnel)
 */
function initThemeToggle() {
    const themeToggle = document.querySelector('.theme-toggle');
    if (!themeToggle) return;
    
    const currentTheme = localStorage.getItem('theme') || 'light';
    document.documentElement.setAttribute('data-theme', currentTheme);
    
    themeToggle.addEventListener('click', function() {
        const theme = document.documentElement.getAttribute('data-theme');
        const newTheme = theme === 'light' ? 'dark' : 'light';
        document.documentElement.setAttribute('data-theme', newTheme);
        localStorage.setItem('theme', newTheme);
        
        // Animation de transition
        document.body.style.transition = 'background-color 0.3s ease';
    });
}

/**
 * Utilitaires
 */

// Debounce pour optimiser les performances
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// Observer les éléments pour les animations au scroll
function observeElement(element) {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('visible');
            }
        });
    }, {
        threshold: 0.1
    });
    
    observer.observe(element);
}

/**
 * Gestion des actions de table
 */
document.addEventListener('click', function(e) {
    // Bouton d'édition
    if (e.target.closest('.action-btn.edit')) {
        e.preventDefault();
        const row = e.target.closest('tr');
        handleEdit(row);
    }
    
    // Bouton de suppression
    if (e.target.closest('.action-btn.delete')) {
        e.preventDefault();
        const row = e.target.closest('tr');
        handleDelete(row);
    }
});

function handleEdit(row) {
    showNotification('Édition', 'Fonctionnalité en cours de développement', 'info');
    // Implémenter la logique d'édition
}

function handleDelete(row) {
    if (confirm('Êtes-vous sûr de vouloir supprimer cet élément ?')) {
        row.style.animation = 'fadeOutLeft 0.5s ease';
        setTimeout(() => {
            row.remove();
            showNotification('Suppression', 'Élément supprimé avec succès', 'success');
        }, 500);
    }
}

/**
 * Animations CSS additionnelles via JavaScript
 */
const style = document.createElement('style');
style.textContent = `
    .custom-tooltip {
        position: fixed;
        background: rgba(15, 23, 42, 0.95);
        color: white;
        padding: 0.5rem 1rem;
        border-radius: 8px;
        font-size: 0.85rem;
        pointer-events: none;
        z-index: 10000;
        display: none;
        box-shadow: 0 5px 15px rgba(0, 0, 0, 0.3);
        animation: tooltipFadeIn 0.2s ease;
    }
    
    @keyframes tooltipFadeIn {
        from {
            opacity: 0;
            transform: translateY(-5px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }
    
    .notification {
        position: fixed;
        top: 20px;
        right: -400px;
        width: 350px;
        background: white;
        border-radius: 12px;
        padding: 1rem;
        box-shadow: 0 10px 30px rgba(0, 0, 0, 0.2);
        display: flex;
        gap: 1rem;
        z-index: 10000;
        transition: right 0.3s ease;
    }
    
    .notification.show {
        right: 20px;
    }
    
    .notification-icon {
        width: 40px;
        height: 40px;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        flex-shrink: 0;
    }
    
    .notification-info .notification-icon {
        background: rgba(59, 130, 246, 0.1);
        color: #3b82f6;
    }
    
    .notification-success .notification-icon {
        background: rgba(16, 185, 129, 0.1);
        color: #10b981;
    }
    
    .notification-warning .notification-icon {
        background: rgba(245, 158, 11, 0.1);
        color: #f59e0b;
    }
    
    .notification-error .notification-icon {
        background: rgba(239, 68, 68, 0.1);
        color: #ef4444;
    }
    
    .notification-content h4 {
        font-size: 0.95rem;
        color: #1e293b;
        margin-bottom: 0.25rem;
    }
    
    .notification-content p {
        font-size: 0.85rem;
        color: #64748b;
    }
    
    .notification-close {
        background: none;
        border: none;
        color: #94a3b8;
        cursor: pointer;
        padding: 0;
        width: 24px;
        height: 24px;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 4px;
        transition: all 0.2s;
        margin-left: auto;
    }
    
    .notification-close:hover {
        background: rgba(0, 0, 0, 0.05);
        color: #475569;
    }
    
    .sidebar-overlay {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        background: rgba(0, 0, 0, 0.5);
        opacity: 0;
        visibility: hidden;
        transition: opacity 0.3s ease, visibility 0.3s ease;
        z-index: 999;
    }
    
    .sidebar-overlay.active {
        opacity: 1;
        visibility: visible;
    }
    
    @keyframes fadeOutLeft {
        from {
            opacity: 1;
            transform: translateX(0);
        }
        to {
            opacity: 0;
            transform: translateX(-20px);
        }
    }
    
    .stat-card.visible,
    .card.visible {
        animation: fadeInUp 0.6s ease forwards;
    }
`;
document.head.appendChild(style);

// Logs pour le développement
console.log('🎨 Admin Dashboard JavaScript initialized');
console.log('✅ All interactive features loaded');
