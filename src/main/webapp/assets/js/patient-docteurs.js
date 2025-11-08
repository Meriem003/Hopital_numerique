/**
 * Patient Docteurs - JavaScript
 * Gestion de la recherche, filtres et interactions
 */

let allDoctors = [];
let filteredDoctors = [];
let currentSpecialty = 'all';

// Fonction de recherche en temps réel
function filterDoctors() {
    const searchInput = document.getElementById('searchInput');
    const filter = searchInput.value.toLowerCase().trim();
    const cards = document.querySelectorAll('.doctor-card');
    let visibleCount = 0;
    
    cards.forEach(card => {
        const name = card.getAttribute('data-name').toLowerCase();
        const specialty = card.getAttribute('data-specialty').toLowerCase();
        
        // Vérifier si correspond au filtre de spécialité ET à la recherche
        const matchesSpecialty = currentSpecialty === 'all' || specialty === currentSpecialty.toLowerCase();
        const matchesSearch = filter === '' || name.includes(filter) || specialty.includes(filter);
        
        if (matchesSpecialty && matchesSearch) {
            card.style.display = 'block';
            visibleCount++;
            
            // Animation d'apparition
            setTimeout(() => {
                card.style.opacity = '1';
                card.style.transform = 'translateY(0)';
            }, 50);
        } else {
            card.style.opacity = '0';
            card.style.transform = 'translateY(20px)';
            setTimeout(() => {
                card.style.display = 'none';
            }, 300);
        }
    });
    
    // Gérer l'état vide
    handleEmptyState(visibleCount, filter);
    
    // Mettre à jour le compteur
    updateDoctorCount(visibleCount);
}

// Gérer l'affichage de l'état vide
function handleEmptyState(visibleCount, searchQuery) {
    const grid = document.getElementById('doctorsGrid');
    let emptyState = grid.querySelector('.empty-state');
    
    if (visibleCount === 0) {
        if (!emptyState) {
            emptyState = document.createElement('div');
            emptyState.className = 'empty-state';
            emptyState.innerHTML = `
                <div class="empty-state-icon">
                    <i class="fas fa-search"></i>
                </div>
                <h3>Aucun docteur trouvé</h3>
                <p>Aucun médecin ne correspond à votre recherche</p>
                <small>Essayez avec un autre nom ou spécialité</small>
            `;
            grid.appendChild(emptyState);
        }
        emptyState.style.display = 'block';
    } else if (emptyState) {
        emptyState.style.display = 'none';
    }
}

// Mettre à jour le compteur de docteurs
function updateDoctorCount(count) {
    const statNumber = document.querySelector('.stat-icon.primary').closest('.stat-card').querySelector('h3');
    if (statNumber) {
        statNumber.textContent = count;
    }
}

// Filtrer par spécialité
function filterBySpecialty(specialty) {
    currentSpecialty = specialty;
    
    // Mettre à jour les badges actifs
    const badges = document.querySelectorAll('.specialty-badge');
    badges.forEach(badge => {
        if (badge.getAttribute('data-specialty') === specialty) {
            badge.classList.add('active');
        } else {
            badge.classList.remove('active');
        }
    });
    
    // Appliquer le filtre
    filterDoctors();
}

// Fonction pour réserver avec un docteur spécifique
function reserverAvec(docteurId) {
    // Animation de chargement
    const button = event.target.closest('.btn-book-doctor');
    const originalHTML = button.innerHTML;
    
    button.disabled = true;
    button.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Redirection...';
    
    // Rediriger après un court délai
    setTimeout(() => {
        window.location.href = `${window.location.origin}${window.location.pathname.split('/patient')[0]}/patient/reserver?docteurId=${docteurId}`;
    }, 500);
}

// Collecter les spécialités uniques et créer les filtres
function generateSpecialtyFilters() {
    const cards = document.querySelectorAll('.doctor-card');
    const specialties = new Set();
    
    cards.forEach(card => {
        const specialty = card.getAttribute('data-specialty');
        if (specialty) {
            specialties.add(specialty);
        }
    });
    
    // Créer les badges de filtre
    const filtersContainer = document.getElementById('specialtyFilters');
    if (filtersContainer && specialties.size > 0) {
        // Badge "Tous"
        const allBadge = document.createElement('button');
        allBadge.className = 'specialty-badge active';
        allBadge.setAttribute('data-specialty', 'all');
        allBadge.innerHTML = '<i class="fas fa-th"></i> Tous les médecins';
        allBadge.onclick = () => filterBySpecialty('all');
        filtersContainer.appendChild(allBadge);
        
        // Badges par spécialité
        Array.from(specialties).sort().forEach(specialty => {
            const badge = document.createElement('button');
            badge.className = 'specialty-badge';
            badge.setAttribute('data-specialty', specialty);
            badge.textContent = specialty;
            badge.onclick = () => filterBySpecialty(specialty);
            filtersContainer.appendChild(badge);
        });
    }
}

// Animation au scroll
function animateOnScroll() {
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.animation = 'slideUp 0.6s ease forwards';
                observer.unobserve(entry.target);
            }
        });
    }, {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    });
    
    const cards = document.querySelectorAll('.doctor-card');
    cards.forEach(card => {
        observer.observe(card);
    });
}

// Effet de survol amélioré sur les cartes
function enhanceCardHover() {
    const cards = document.querySelectorAll('.doctor-card');
    
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transition = 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transition = 'all 0.4s cubic-bezier(0.4, 0, 0.2, 1)';
        });
    });
}

// Animation d'entrée progressive des cartes
function animateCardsOnLoad() {
    const cards = document.querySelectorAll('.doctor-card');
    
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.6s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
}

// Fonction pour copier l'email du docteur
function copyEmail(email) {
    if (navigator.clipboard) {
        navigator.clipboard.writeText(email).then(() => {
            showToast('Email copié dans le presse-papier', 'success');
        }).catch(err => {
            console.error('Erreur lors de la copie:', err);
        });
    }
}

// Afficher un toast notification
function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.className = `toast toast-${type}`;
    toast.style.cssText = `
        position: fixed;
        bottom: 2rem;
        right: 2rem;
        padding: 1rem 1.5rem;
        background: ${type === 'success' ? '#10b981' : '#0891b2'};
        color: white;
        border-radius: 12px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
        z-index: 10000;
        animation: slideInUp 0.3s ease;
        font-weight: 600;
        display: flex;
        align-items: center;
        gap: 0.75rem;
    `;
    
    const icon = type === 'success' ? 'fa-check-circle' : 'fa-info-circle';
    toast.innerHTML = `<i class="fas ${icon}"></i> ${message}`;
    
    document.body.appendChild(toast);
    
    setTimeout(() => {
        toast.style.animation = 'slideOutDown 0.3s ease';
        setTimeout(() => toast.remove(), 300);
    }, 3000);
}

// Initialiser les compteurs avec animation
function animateCounters() {
    const counters = document.querySelectorAll('.stat-content h3');
    
    counters.forEach(counter => {
        const target = parseInt(counter.textContent);
        if (isNaN(target)) return;
        
        let current = 0;
        const increment = target / 50;
        const duration = 1000;
        const stepTime = duration / 50;
        
        const timer = setInterval(() => {
            current += increment;
            if (current >= target) {
                counter.textContent = target;
                clearInterval(timer);
            } else {
                counter.textContent = Math.floor(current);
            }
        }, stepTime);
    });
}

// Raccourcis clavier
function initKeyboardShortcuts() {
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + K pour focus sur la recherche
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            document.getElementById('searchInput').focus();
        }
        
        // Échap pour effacer la recherche
        if (e.key === 'Escape') {
            const searchInput = document.getElementById('searchInput');
            if (searchInput.value) {
                searchInput.value = '';
                filterDoctors();
                searchInput.blur();
            }
        }
    });
}

// Auto-hide des alertes
function autoHideAlerts() {
    const alerts = document.querySelectorAll('.alert');
    
    alerts.forEach(alert => {
        setTimeout(() => {
            alert.style.transition = 'all 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-20px)';
            
            setTimeout(() => {
                alert.remove();
            }, 500);
        }, 5000);
    });
}

// Ajouter des tooltips aux boutons
function addTooltips() {
    const bookButtons = document.querySelectorAll('.btn-book-doctor');
    
    bookButtons.forEach(button => {
        button.setAttribute('title', 'Cliquez pour prendre rendez-vous avec ce médecin');
    });
}

// Initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    console.log('🏥 Initialisation de la page Docteurs...');
    
    // Initialiser toutes les fonctionnalités
    generateSpecialtyFilters();
    animateCardsOnLoad();
    enhanceCardHover();
    animateCounters();
    initKeyboardShortcuts();
    autoHideAlerts();
    addTooltips();
    
    // Ajouter l'événement de recherche
    const searchInput = document.getElementById('searchInput');
    if (searchInput) {
        searchInput.addEventListener('input', filterDoctors);
        
        // Focus sur la recherche avec animation
        searchInput.addEventListener('focus', function() {
            this.parentElement.style.transform = 'scale(1.02)';
        });
        
        searchInput.addEventListener('blur', function() {
            this.parentElement.style.transform = 'scale(1)';
        });
    }
    
    // Ajouter les événements de clic sur les emails (pour copier)
    const emailItems = document.querySelectorAll('.doctor-info-item');
    emailItems.forEach(item => {
        const icon = item.querySelector('i');
        if (icon && icon.classList.contains('fa-envelope')) {
            const email = item.querySelector('.info-content').textContent.trim();
            item.style.cursor = 'pointer';
            item.setAttribute('title', 'Cliquer pour copier l\'email');
            item.addEventListener('click', () => copyEmail(email));
        }
    });
    
    // Observer les animations au scroll
    animateOnScroll();
    
    console.log('✅ Page Docteurs - JavaScript initialisé avec succès');
});

// Exporter les fonctions pour une utilisation externe
window.docteursApp = {
    filterDoctors,
    filterBySpecialty,
    reserverAvec,
    copyEmail
};