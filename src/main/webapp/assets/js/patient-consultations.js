/**
 * Patient Consultations - JavaScript
 * Gestion des consultations avec animations et modal personnalisée
 */

// Fonction pour changer d'onglet
function switchTab(tabName) {
    // Désactiver tous les onglets
    document.querySelectorAll('.tab').forEach(tab => tab.classList.remove('active'));
    document.querySelectorAll('.tab-content').forEach(content => content.classList.remove('active'));
    
    // Activer l'onglet sélectionné
    event.target.closest('.tab').classList.add('active');
    document.getElementById('tab-' + tabName).classList.add('active');
    
    // Animation smooth
    window.scrollTo({ top: 0, behavior: 'smooth' });
    
    // Ré-animer les cartes
    animateCards();
}

// Fonction pour animer les cartes
function animateCards() {
    const cards = document.querySelectorAll('.tab-content.active .consultation-card');
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
}

// Fonction pour fermer la modal
function closeModal(modal) {
    modal.querySelector('.confirmation-overlay').style.opacity = '0';
    modal.querySelector('.confirmation-content').style.opacity = '0';
    modal.querySelector('.confirmation-content').style.transform = 'translate(-50%, -50%) scale(0.9)';
    
    setTimeout(() => {
        modal.remove();
    }, 300);
}

// Fonction pour créer la modal de confirmation
function createConfirmationModal(form) {
    const modal = document.createElement('div');
    modal.className = 'confirmation-modal';
    modal.innerHTML = `
        <div class="confirmation-overlay"></div>
        <div class="confirmation-content">
            <div class="confirmation-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h3>Confirmer l'annulation</h3>
            <p>Êtes-vous sûr de vouloir annuler ce rendez-vous ?</p>
            <p class="warning-text">Cette action est irréversible.</p>
            <div class="confirmation-actions">
                <button type="button" class="btn-confirm-cancel">
                    <i class="fas fa-times"></i>
                    Oui, annuler
                </button>
                <button type="button" class="btn-confirm-keep">
                    <i class="fas fa-check"></i>
                    Non, garder
                </button>
            </div>
        </div>
    `;
    
    document.body.appendChild(modal);
    
    // Animation d'apparition
    setTimeout(() => {
        modal.querySelector('.confirmation-overlay').style.opacity = '1';
        modal.querySelector('.confirmation-content').style.opacity = '1';
        modal.querySelector('.confirmation-content').style.transform = 'translate(-50%, -50%) scale(1)';
    }, 10);
    
    // Bouton confirmer l'annulation
    modal.querySelector('.btn-confirm-cancel').addEventListener('click', () => {
        // Désactiver le bouton pour éviter les doubles soumissions
        modal.querySelector('.btn-confirm-cancel').disabled = true;
        modal.querySelector('.btn-confirm-cancel').innerHTML = '<i class="fas fa-spinner fa-spin"></i> Annulation...';
        
        // Soumettre le formulaire
        form.onsubmit = null;
        form.submit();
    });
    
    // Bouton garder le RDV
    modal.querySelector('.btn-confirm-keep').addEventListener('click', () => {
        closeModal(modal);
    });
    
    // Fermer en cliquant sur l'overlay
    modal.querySelector('.confirmation-overlay').addEventListener('click', () => {
        closeModal(modal);
    });
    
    // Fermer avec la touche Echap
    const escapeHandler = (e) => {
        if (e.key === 'Escape') {
            closeModal(modal);
            document.removeEventListener('keydown', escapeHandler);
        }
    };
    document.addEventListener('keydown', escapeHandler);
}

// Fonction pour ajouter des badges temporels
function addTimeBadges() {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    const tomorrow = new Date(today);
    tomorrow.setDate(tomorrow.getDate() + 1);
    
    // Parcourir toutes les cartes de consultation à venir
    document.querySelectorAll('#tab-avenir .consultation-card').forEach(card => {
        try {
            // Extraire la date de la carte
            const dateElements = card.querySelectorAll('.date-badge .day, .date-badge .month');
            if (dateElements.length < 2) return;
            
            const day = parseInt(dateElements[0].textContent.trim());
            const monthText = dateElements[1].textContent.trim().toLowerCase();
            
            // Map des mois en français
            const monthMap = {
                'jan': 0, 'fév': 1, 'mar': 2, 'avr': 3, 'mai': 4, 'juin': 5,
                'juil': 6, 'août': 7, 'sep': 8, 'oct': 9, 'nov': 10, 'déc': 11
            };
            
            const month = monthMap[monthText];
            if (month === undefined) return;
            
            const consultationDate = new Date(today.getFullYear(), month, day);
            consultationDate.setHours(0, 0, 0, 0);
            
            const h3 = card.querySelector('.consultation-info h3');
            if (!h3) return;
            
            // Vérifier si le badge n'existe pas déjà
            if (h3.querySelector('.time-badge')) return;
            
            let badge = null;
            
            if (consultationDate.getTime() === today.getTime()) {
                badge = document.createElement('span');
                badge.className = 'time-badge today';
                badge.innerHTML = '<i class="fas fa-star"></i> Aujourd\'hui';
            } else if (consultationDate.getTime() === tomorrow.getTime()) {
                badge = document.createElement('span');
                badge.className = 'time-badge tomorrow';
                badge.innerHTML = '<i class="fas fa-clock"></i> Demain';
            }
            
            if (badge) {
                h3.appendChild(badge);
            }
        } catch (error) {
            console.error('Erreur lors de l\'ajout du badge temporel:', error);
        }
    });
}

// Fonction pour auto-masquer les alertes
function autoHideAlerts() {
    setTimeout(() => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            alert.style.transition = 'all 0.5s ease';
            alert.style.opacity = '0';
            alert.style.transform = 'translateY(-20px)';
            
            setTimeout(() => {
                alert.remove();
            }, 500);
        });
    }, 5000);
}

// Fonction pour initialiser les gestionnaires d'événements
function initEventHandlers() {
    // Confirmation personnalisée avant annulation
    const cancelForms = document.querySelectorAll('form[onsubmit*="annuler"]');
    cancelForms.forEach(form => {
        // Retirer l'attribut onsubmit pour gérer l'événement en JS
        form.removeAttribute('onsubmit');
        
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            createConfirmationModal(form);
        });
    });
}

// Fonction pour ajouter des effets de survol améliorés
function enhanceHoverEffects() {
    const cards = document.querySelectorAll('.consultation-card');
    
    cards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transition = 'all 0.3s cubic-bezier(0.4, 0, 0.2, 1)';
        });
    });
}

// Fonction pour initialiser les compteurs animés (si vous avez des stats)
function initCounters() {
    const statCards = document.querySelectorAll('.stat-card h4');
    
    statCards.forEach(stat => {
        const finalValue = parseInt(stat.textContent);
        if (isNaN(finalValue)) return;
        
        let currentValue = 0;
        const increment = finalValue / 30;
        const duration = 1000;
        const stepTime = duration / 30;
        
        const counter = setInterval(() => {
            currentValue += increment;
            if (currentValue >= finalValue) {
                stat.textContent = finalValue;
                clearInterval(counter);
            } else {
                stat.textContent = Math.floor(currentValue);
            }
        }, stepTime);
    });
}

// Fonction pour gérer le scroll smooth sur les ancres
function initSmoothScroll() {
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });
}

// Initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    console.log('🏥 Initialisation de la page Consultations...');
    
    // Initialiser toutes les fonctionnalités
    autoHideAlerts();
    animateCards();
    initEventHandlers();
    addTimeBadges();
    enhanceHoverEffects();
    initCounters();
    initSmoothScroll();
    
    // Observer pour détecter les changements d'onglet
    const tabs = document.querySelectorAll('.tab');
    tabs.forEach(tab => {
        tab.addEventListener('click', () => {
            setTimeout(addTimeBadges, 100);
        });
    });
    
    console.log('✅ Page Consultations - JavaScript initialisé avec succès');
});

// Exporter les fonctions pour une utilisation externe si nécessaire
window.consultationsApp = {
    switchTab,
    animateCards,
    addTimeBadges,
    closeModal
};