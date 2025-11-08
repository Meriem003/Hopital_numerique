/**
 * Patient Reservation - JavaScript
 * Gestion des étapes de réservation avec validation
 */

let currentStep = 1;

// Navigation entre les étapes
function nextStep(stepNumber) {
    // Valider l'étape actuelle avant de continuer
    if (!validateCurrentStep()) {
        return;
    }

    // Masquer l'étape actuelle
    const currentSection = document.querySelector(`.form-section[data-section="${currentStep}"]`);
    const currentStepElement = document.querySelector(`.step[data-step="${currentStep}"]`);
    
    if (currentSection) {
        currentSection.classList.remove('active');
    }
    
    if (currentStepElement) {
        currentStepElement.classList.remove('active');
        currentStepElement.classList.add('completed');
    }

    // Afficher la nouvelle étape
    const nextSection = document.querySelector(`.form-section[data-section="${stepNumber}"]`);
    const nextStepElement = document.querySelector(`.step[data-step="${stepNumber}"]`);
    
    if (nextSection) {
        nextSection.classList.add('active');
    }
    
    if (nextStepElement) {
        nextStepElement.classList.add('active');
    }

    // Mettre à jour le numéro d'étape actuel
    currentStep = stepNumber;

    // Mettre à jour le résumé si on est à l'étape 3
    if (stepNumber === 3) {
        updateSummary();
    }

    // Scroll en haut
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

function prevStep(stepNumber) {
    // Masquer l'étape actuelle
    const currentSection = document.querySelector(`.form-section[data-section="${currentStep}"]`);
    const currentStepElement = document.querySelector(`.step[data-step="${currentStep}"]`);
    
    if (currentSection) {
        currentSection.classList.remove('active');
    }
    
    if (currentStepElement) {
        currentStepElement.classList.remove('active');
        currentStepElement.classList.remove('completed');
    }

    // Afficher l'étape précédente
    const prevSection = document.querySelector(`.form-section[data-section="${stepNumber}"]`);
    const prevStepElement = document.querySelector(`.step[data-step="${stepNumber}"]`);
    
    if (prevSection) {
        prevSection.classList.add('active');
    }
    
    if (prevStepElement) {
        prevStepElement.classList.add('active');
        // Retirer le statut completed de l'étape précédente
        prevStepElement.classList.remove('completed');
    }

    // Mettre à jour le numéro d'étape actuel
    currentStep = stepNumber;

    // Scroll en haut
    window.scrollTo({ top: 0, behavior: 'smooth' });
}

// Validation de l'étape actuelle
function validateCurrentStep() {
    switch(currentStep) {
        case 1:
            return validateStep1();
        case 2:
            return validateStep2();
        case 3:
            return true; // Pas de validation stricte pour l'étape 3
        default:
            return true;
    }
}

// Valider l'étape 1 (Sélection du docteur)
function validateStep1() {
    const docteurSelect = document.getElementById('docteurId');
    
    if (!docteurSelect.value) {
        showError('Veuillez sélectionner un docteur');
        docteurSelect.focus();
        return false;
    }
    
    return true;
}

// Valider l'étape 2 (Date et Heure)
function validateStep2() {
    const dateInput = document.getElementById('date');
    const heureInput = document.getElementById('heure');
    
    if (!dateInput.value) {
        showError('Veuillez sélectionner une date');
        dateInput.focus();
        return false;
    }
    
    if (!heureInput.value) {
        showError('Veuillez sélectionner une heure');
        heureInput.focus();
        return false;
    }
    
    // Vérifier que la date/heure n'est pas dans le passé
    const selectedDateTime = new Date(dateInput.value + 'T' + heureInput.value);
    const now = new Date();
    
    if (selectedDateTime <= now) {
        showError('La date et l\'heure doivent être dans le futur');
        dateInput.focus();
        return false;
    }
    
    return true;
}

// Afficher une erreur
function showError(message) {
    // Créer l'alerte si elle n'existe pas
    let alert = document.querySelector('.alert-danger');
    
    if (!alert) {
        alert = document.createElement('div');
        alert.className = 'alert alert-danger';
        
        const icon = document.createElement('i');
        icon.className = 'fas fa-exclamation-circle';
        
        const span = document.createElement('span');
        
        alert.appendChild(icon);
        alert.appendChild(span);
        
        const container = document.querySelector('.reservation-container');
        const infoCard = container.querySelector('.info-banner');
        container.insertBefore(alert, infoCard.nextSibling);
    }
    
    alert.querySelector('span').textContent = message;
    alert.style.display = 'flex';
    
    // Scroll vers l'alerte
    alert.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
    
    // Masquer après 5 secondes
    setTimeout(() => {
        alert.style.opacity = '0';
        setTimeout(() => {
            alert.style.display = 'none';
            alert.style.opacity = '1';
        }, 300);
    }, 5000);
}

// Mettre à jour les informations du docteur sélectionné
function updateDocteurInfo() {
    const select = document.getElementById('docteurId');
    const option = select.options[select.selectedIndex];
    const card = document.getElementById('docteurInfoCard');
    
    if (option.value) {
        const nom = option.getAttribute('data-nom');
        const prenom = option.getAttribute('data-prenom');
        const specialite = option.getAttribute('data-specialite');
        const departement = option.getAttribute('data-departement');
        
        // Mettre à jour le contenu de la carte
        document.getElementById('docteurName').textContent = `Dr. ${nom} ${prenom}`;
        document.getElementById('docteurSpecialite').textContent = specialite;
        document.getElementById('docteurDepartement').textContent = departement;
        
        // Afficher la carte avec animation
        card.style.display = 'flex';
        setTimeout(() => {
            card.style.opacity = '1';
        }, 10);
    } else {
        card.style.display = 'none';
    }
}

// Mettre à jour le résumé de la réservation
function updateSummary() {
    // Docteur
    const docteurSelect = document.getElementById('docteurId');
    const docteurOption = docteurSelect.options[docteurSelect.selectedIndex];
    if (docteurOption.value) {
        const nom = docteurOption.getAttribute('data-nom');
        const prenom = docteurOption.getAttribute('data-prenom');
        const specialite = docteurOption.getAttribute('data-specialite');
        document.getElementById('summaryDocteur').textContent = `Dr. ${nom} ${prenom} - ${specialite}`;
    }
    
    // Date
    const dateInput = document.getElementById('date');
    if (dateInput.value) {
        const date = new Date(dateInput.value);
        const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
        document.getElementById('summaryDate').textContent = date.toLocaleDateString('fr-FR', options);
    }
    
    // Heure
    const heureInput = document.getElementById('heure');
    if (heureInput.value) {
        document.getElementById('summaryHeure').textContent = heureInput.value;
    }
}

// Compteur de caractères pour le motif
function updateCharCount() {
    const motifTextarea = document.getElementById('motif');
    const charCount = document.getElementById('charCount');
    
    if (motifTextarea && charCount) {
        motifTextarea.addEventListener('input', function() {
            charCount.textContent = this.value.length;
            
            // Changer la couleur si proche de la limite
            if (this.value.length > 450) {
                charCount.style.color = 'var(--danger)';
                charCount.style.fontWeight = '700';
            } else if (this.value.length > 400) {
                charCount.style.color = 'var(--warning)';
                charCount.style.fontWeight = '600';
            } else {
                charCount.style.color = '';
                charCount.style.fontWeight = '';
            }
        });
    }
}

// Validation du formulaire avant soumission
function validateForm() {
    const form = document.getElementById('reservationForm');
    
    if (form) {
        form.addEventListener('submit', function(e) {
            const docteurId = document.getElementById('docteurId').value;
            const date = document.getElementById('date').value;
            const heure = document.getElementById('heure').value;
            
            // Vérifications de base
            if (!docteurId || !date || !heure) {
                e.preventDefault();
                showError('Veuillez remplir tous les champs obligatoires');
                return false;
            }
            
            // Vérifier que la date/heure n'est pas dans le passé
            const selectedDateTime = new Date(date + 'T' + heure);
            const now = new Date();
            
            if (selectedDateTime <= now) {
                e.preventDefault();
                showError('La date et l\'heure doivent être dans le futur');
                return false;
            }
            
            // Vérifier les horaires de travail (8h-18h)
            const [hours, minutes] = heure.split(':');
            const timeInMinutes = parseInt(hours) * 60 + parseInt(minutes);
            
            if (timeInMinutes < 480 || timeInMinutes > 1080) { // 8h = 480min, 18h = 1080min
                e.preventDefault();
                showError('Les rendez-vous sont disponibles uniquement entre 8h00 et 18h00');
                return false;
            }
            
            // Ajouter un indicateur de chargement
            const submitButton = form.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>Réservation en cours...</span>';
            }
            
            return true;
        });
    }
}

// Définir la date minimale à aujourd'hui
function setMinDate() {
    const dateInput = document.getElementById('date');
    if (dateInput) {
        const today = new Date().toISOString().split('T')[0];
        dateInput.min = today;
        
        // Définir la date par défaut à aujourd'hui
        if (!dateInput.value) {
            dateInput.value = today;
        }
    }
}

// Suggestions d'heures par tranches de 30 minutes
function setupTimePicker() {
    const heureInput = document.getElementById('heure');
    
    if (heureInput) {
        // Créer une liste de suggestions
        const datalist = document.createElement('datalist');
        datalist.id = 'time-suggestions';
        
        // Générer les créneaux de 8h à 18h par tranches de 30min
        for (let hour = 8; hour <= 17; hour++) {
            for (let minute = 0; minute < 60; minute += 30) {
                const option = document.createElement('option');
                const timeString = `${hour.toString().padStart(2, '0')}:${minute.toString().padStart(2, '0')}`;
                option.value = timeString;
                datalist.appendChild(option);
            }
        }
        
        heureInput.setAttribute('list', 'time-suggestions');
        heureInput.parentNode.appendChild(datalist);
    }
}

// Masquer les alertes automatiquement
function autoHideAlerts() {
    setTimeout(() => {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            if (alert.classList.contains('alert-success')) {
                alert.style.transition = 'all 0.5s ease';
                alert.style.opacity = '0';
                alert.style.transform = 'translateY(-20px)';
                
                setTimeout(() => {
                    alert.remove();
                }, 500);
            }
        });
    }, 5000);
}

// Animation des éléments au chargement
function animateElements() {
    const card = document.querySelector('.card');
    
    if (card) {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.6s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 200);
    }
}

// Initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    // Initialiser toutes les fonctionnalités
    setMinDate();
    setupTimePicker();
    updateCharCount();
    validateForm();
    autoHideAlerts();
    animateElements();
    
    // Gérer le changement de docteur
    const docteurSelect = document.getElementById('docteurId');
    if (docteurSelect) {
        docteurSelect.addEventListener('change', updateDocteurInfo);
    }
    
    // Initialiser la carte du docteur comme masquée
    const docteurCard = document.getElementById('docteurInfoCard');
    if (docteurCard) {
        docteurCard.style.opacity = '0';
        docteurCard.style.transition = 'opacity 0.3s ease';
    }
    
    // Ajouter des effets de focus sur les inputs
    const inputs = document.querySelectorAll('.form-input, .form-select, .form-textarea');
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.querySelector('label')?.style.setProperty('color', 'var(--secondary)');
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.querySelector('label')?.style.removeProperty('color');
        });
    });
    
    // Confirmation avant de quitter la page si le formulaire est en cours
    let formStarted = false;
    const form = document.getElementById('reservationForm');
    
    if (form) {
        form.addEventListener('input', () => {
            formStarted = true;
        });
        
        window.addEventListener('beforeunload', (e) => {
            if (formStarted && currentStep > 1) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
        
        form.addEventListener('submit', () => {
            formStarted = false;
        });
    }
    
    console.log('✅ Réservation Patient - JavaScript initialisé avec succès');
});