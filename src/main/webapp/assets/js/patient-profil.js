/**
 * Patient Profile - JavaScript
 * Gestion des interactions du profil patient
 */

// Fonction pour changer d'onglet
function switchTab(event, tabName) {
    // Empêcher le comportement par défaut
    event.preventDefault();
    
    // Masquer tous les contenus d'onglets
    const tabContents = document.querySelectorAll('.tab-content');
    tabContents.forEach(content => {
        content.classList.remove('active');
    });
    
    // Désactiver tous les boutons d'onglets
    const tabButtons = document.querySelectorAll('.profile-tab');
    tabButtons.forEach(button => {
        button.classList.remove('active');
    });
    
    // Activer l'onglet sélectionné
    document.getElementById(tabName).classList.add('active');
    event.currentTarget.classList.add('active');
    
    // Sauvegarder l'onglet actif dans le sessionStorage
    sessionStorage.setItem('activeTab', tabName);
}

// Fonction pour réinitialiser le formulaire
function resetForm() {
    if (confirm('Êtes-vous sûr de vouloir annuler vos modifications ?')) {
        location.reload();
    }
}

// Calcul automatique de l'IMC
function calculateIMC() {
    const poidsInput = document.getElementById('poids');
    const tailleInput = document.getElementById('taille');
    
    if (poidsInput && tailleInput) {
        const updateIMC = () => {
            const poids = parseFloat(poidsInput.value);
            const taille = parseFloat(tailleInput.value);
            
            if (poids > 0 && taille > 0) {
                const imc = poids / Math.pow(taille / 100, 2);
                const imcValue = imc.toFixed(1);
                
                // Mettre à jour l'affichage de l'IMC si l'élément existe
                const imcDisplay = document.querySelector('.metric-card:nth-child(3) .metric-value');
                if (imcDisplay && !imcDisplay.textContent.includes('--')) {
                    // Animation de changement
                    imcDisplay.style.transform = 'scale(1.1)';
                    imcDisplay.style.color = 'var(--secondary)';
                    
                    setTimeout(() => {
                        imcDisplay.innerHTML = imcValue;
                        setTimeout(() => {
                            imcDisplay.style.transform = 'scale(1)';
                            imcDisplay.style.color = 'var(--primary)';
                        }, 200);
                    }, 200);
                }
                
                // Déterminer la catégorie IMC
                let category = '';
                let categoryColor = '';
                
                if (imc < 18.5) {
                    category = 'Insuffisance pondérale';
                    categoryColor = '#f59e0b';
                } else if (imc >= 18.5 && imc < 25) {
                    category = 'Poids normal';
                    categoryColor = '#10b981';
                } else if (imc >= 25 && imc < 30) {
                    category = 'Surpoids';
                    categoryColor = '#f59e0b';
                } else {
                    category = 'Obésité';
                    categoryColor = '#ef4444';
                }
                
                // Afficher la catégorie si l'élément existe
                showIMCCategory(category, categoryColor);
            }
        };
        
        poidsInput.addEventListener('input', updateIMC);
        tailleInput.addEventListener('input', updateIMC);
    }
}

// Afficher la catégorie IMC
function showIMCCategory(category, color) {
    let categoryElement = document.getElementById('imc-category');
    
    if (!categoryElement) {
        // Créer l'élément s'il n'existe pas
        const metricLabel = document.querySelector('.metric-card:nth-child(3) .metric-label');
        if (metricLabel) {
            categoryElement = document.createElement('div');
            categoryElement.id = 'imc-category';
            categoryElement.style.marginTop = '0.5rem';
            categoryElement.style.fontSize = '0.8rem';
            categoryElement.style.fontWeight = '600';
            categoryElement.style.padding = '0.25rem 0.75rem';
            categoryElement.style.borderRadius = '12px';
            categoryElement.style.display = 'inline-block';
            metricLabel.parentElement.appendChild(categoryElement);
        }
    }
    
    if (categoryElement) {
        categoryElement.textContent = category;
        categoryElement.style.backgroundColor = color + '20';
        categoryElement.style.color = color;
    }
}

// Validation du formulaire
function validateForm() {
    const form = document.querySelector('form');
    
    if (form) {
        form.addEventListener('submit', function(event) {
            const nom = document.getElementById('nom');
            const prenom = document.getElementById('prenom');
            const email = document.getElementById('email');
            
            let isValid = true;
            let errorMessage = '';
            
            // Validation du nom
            if (nom && nom.value.trim().length < 2) {
                isValid = false;
                errorMessage += '- Le nom doit contenir au moins 2 caractères\n';
                nom.style.borderColor = 'var(--danger)';
            }
            
            // Validation du prénom
            if (prenom && prenom.value.trim().length < 2) {
                isValid = false;
                errorMessage += '- Le prénom doit contenir au moins 2 caractères\n';
                prenom.style.borderColor = 'var(--danger)';
            }
            
            // Validation de l'email
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (email && !emailRegex.test(email.value)) {
                isValid = false;
                errorMessage += '- L\'adresse email n\'est pas valide\n';
                email.style.borderColor = 'var(--danger)';
            }
            
            if (!isValid) {
                event.preventDefault();
                alert('Veuillez corriger les erreurs suivantes :\n\n' + errorMessage);
                return false;
            }
            
            // Ajouter un indicateur de chargement
            const submitButton = form.querySelector('button[type="submit"]');
            if (submitButton) {
                submitButton.disabled = true;
                submitButton.innerHTML = '<i class="fas fa-spinner fa-spin"></i> <span>Enregistrement...</span>';
            }
            
            return true;
        });
        
        // Réinitialiser la couleur des bordures lors de la saisie
        const inputs = form.querySelectorAll('input');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                this.style.borderColor = '';
            });
        });
    }
}

// Animation des cartes au chargement
function animateCards() {
    const cards = document.querySelectorAll('.card, .metric-card');
    
    cards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        
        setTimeout(() => {
            card.style.transition = 'all 0.5s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 100 * index);
    });
}

// Afficher des conseils santé basés sur l'IMC
function showHealthTips() {
    const healthTab = document.getElementById('health');
    if (!healthTab) return;
    
    const tipsContainer = document.createElement('div');
    tipsContainer.className = 'health-tips-container';
    tipsContainer.style.marginTop = '2rem';
    
    const tips = [
        {
            icon: 'fa-apple-alt',
            title: 'Alimentation équilibrée',
            description: 'Privilégiez les fruits, légumes et protéines maigres',
            color: '#10b981'
        },
        {
            icon: 'fa-running',
            title: 'Activité physique',
            description: 'Pratiquez au moins 30 minutes d\'exercice par jour',
            color: '#0891b2'
        },
        {
            icon: 'fa-bed',
            title: 'Sommeil réparateur',
            description: 'Dormez 7-8 heures par nuit pour une récupération optimale',
            color: '#7c3aed'
        }
    ];
    
    const tipsGrid = document.createElement('div');
    tipsGrid.style.display = 'grid';
    tipsGrid.style.gridTemplateColumns = 'repeat(auto-fit, minmax(250px, 1fr))';
    tipsGrid.style.gap = '1rem';
    
    tips.forEach(tip => {
        const tipCard = document.createElement('div');
        tipCard.style.background = 'var(--white)';
        tipCard.style.padding = '1.5rem';
        tipCard.style.borderRadius = '12px';
        tipCard.style.border = '1px solid var(--gray-200)';
        tipCard.style.transition = 'all 0.3s ease';
        
        tipCard.innerHTML = `
            <div style="width: 48px; height: 48px; border-radius: 12px; background: ${tip.color}20; color: ${tip.color}; display: flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                <i class="fas ${tip.icon}" style="font-size: 1.5rem;"></i>
            </div>
            <h4 style="color: var(--primary); margin-bottom: 0.5rem; font-size: 1rem;">${tip.title}</h4>
            <p style="color: var(--gray-600); font-size: 0.875rem; line-height: 1.5;">${tip.description}</p>
        `;
        
        tipCard.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 8px 24px rgba(8, 145, 178, 0.1)';
        });
        
        tipCard.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
            this.style.boxShadow = 'none';
        });
        
        tipsGrid.appendChild(tipCard);
    });
    
    tipsContainer.appendChild(tipsGrid);
    
    // Ajouter après les cartes métriques
    const metricsGrid = healthTab.querySelector('.health-metrics-grid');
    if (metricsGrid && metricsGrid.nextElementSibling) {
        metricsGrid.parentNode.insertBefore(tipsContainer, metricsGrid.nextElementSibling);
    }
}

// Initialisation au chargement de la page
document.addEventListener('DOMContentLoaded', function() {
    // Restaurer l'onglet actif
    const activeTab = sessionStorage.getItem('activeTab');
    if (activeTab) {
        const tabButton = document.querySelector(`[onclick*="${activeTab}"]`);
        if (tabButton) {
            tabButton.click();
        }
    }
    
    // Initialiser les fonctionnalités
    calculateIMC();
    validateForm();
    animateCards();
    showHealthTips();
    
    // Masquer les alertes après 5 secondes
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
    
    // Ajouter des effets de focus sur les inputs
    const inputs = document.querySelectorAll('.form-input');
    inputs.forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.querySelector('label')?.style.setProperty('color', 'var(--secondary)');
        });
        
        input.addEventListener('blur', function() {
            this.parentElement.querySelector('label')?.style.removeProperty('color');
        });
    });
    
    // Confirmation avant de quitter la page si le formulaire est modifié
    let formModified = false;
    const form = document.querySelector('form');
    
    if (form) {
        form.addEventListener('change', () => {
            formModified = true;
        });
        
        window.addEventListener('beforeunload', (e) => {
            if (formModified) {
                e.preventDefault();
                e.returnValue = '';
            }
        });
        
        form.addEventListener('submit', () => {
            formModified = false;
        });
    }
    
    console.log('✅ Profil Patient - JavaScript initialisé avec succès');
});