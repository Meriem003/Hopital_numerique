// Initialize when DOM is loaded
document.addEventListener('DOMContentLoaded', function() {
    // Section collapse/expand functionality
    initializeSectionToggle();
    
    // Password strength checker
    initializePasswordStrength();
    
    // Form validation
    initializeFormValidation();
    
    // Password visibility toggle
    initializePasswordToggle();
    
    // Input animations
    initializeInputAnimations();
    
    // Email validation
    initializeEmailValidation();
    
    // Weight and height validation
    initializeWeightHeightValidation();
});

// Section toggle functionality
function initializeSectionToggle() {
    const sections = document.querySelectorAll('.form-section');
    
    sections.forEach((section, index) => {
        const header = section.querySelector('.section-header');
        const content = section.querySelector('.section-content');
        const toggleBtn = section.querySelector('.toggle-btn');
        
        // First section is open by default
        if (index === 0) {
            header.classList.add('active');
        } else {
            content.classList.add('collapsed');
            if (toggleBtn) {
                toggleBtn.classList.add('rotated');
            }
        }
        
        header.addEventListener('click', function() {
            const isCollapsed = content.classList.contains('collapsed');
            
            if (isCollapsed) {
                // Expand this section
                content.classList.remove('collapsed');
                header.classList.add('active');
                if (toggleBtn) {
                    toggleBtn.classList.remove('rotated');
                }
            } else {
                // Collapse this section
                content.classList.add('collapsed');
                header.classList.remove('active');
                if (toggleBtn) {
                    toggleBtn.classList.add('rotated');
                }
            }
        });
    });
    
    // Watch for input changes to update section badges
    document.addEventListener('input', function(e) {
        if (e.target.classList.contains('form-input') || e.target.type === 'checkbox') {
            const section = e.target.closest('.form-section');
            if (section) {
                checkSectionCompletion(section);
            }
        }
    });
}

// Check if section is completed
function checkSectionCompletion(sectionElement) {
    const inputs = sectionElement.querySelectorAll('input[required]');
    let allFilled = true;
    
    inputs.forEach(input => {
        if (!input.value || (input.type === 'checkbox' && !input.checked)) {
            allFilled = false;
        }
    });
    
    const header = sectionElement.querySelector('.section-header');
    const badge = header.querySelector('.section-badge');
    
    if (allFilled) {
        if (!badge) {
            const newBadge = document.createElement('span');
            newBadge.className = 'section-badge';
            newBadge.innerHTML = '<i class="fas fa-check"></i> Complété';
            header.insertBefore(newBadge, header.querySelector('.toggle-btn'));
        }
    } else {
        if (badge) {
            badge.remove();
        }
    }
}

// Password strength checker
function initializePasswordStrength() {
    const passwordInput = document.getElementById('password');
    const strengthBar = document.getElementById('passwordStrengthBar');

    if (passwordInput && strengthBar) {
        passwordInput.addEventListener('input', function() {
            const password = this.value;
            let strength = 0;

            if (password.length >= 8) strength++;
            if (password.match(/[a-z]/) && password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;

            strengthBar.className = 'password-strength-bar';
            
            if (strength === 0 || strength === 1) {
                strengthBar.classList.add('strength-weak');
            } else if (strength === 2 || strength === 3) {
                strengthBar.classList.add('strength-medium');
            } else if (strength === 4) {
                strengthBar.classList.add('strength-strong');
            }
        });
    }
}

// Form validation
function initializeFormValidation() {
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            const terms = document.getElementById('terms');

            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Les mots de passe ne correspondent pas');
                return false;
            }

            if (terms && !terms.checked) {
                e.preventDefault();
                alert('Veuillez accepter les conditions d\'utilisation');
                return false;
            }

            if (password.length < 8) {
                e.preventDefault();
                alert('Le mot de passe doit contenir au moins 8 caractères');
                return false;
            }
        });
    }
}

// Toggle password visibility
function initializePasswordToggle() {
    document.querySelectorAll('.input-icon.fa-lock').forEach(icon => {
        icon.style.cursor = 'pointer';
        icon.addEventListener('click', function() {
            const input = this.parentElement.querySelector('input');
            if (input.type === 'password') {
                input.type = 'text';
                this.classList.remove('fa-lock');
                this.classList.add('fa-lock-open');
            } else {
                input.type = 'password';
                this.classList.remove('fa-lock-open');
                this.classList.add('fa-lock');
            }
        });
    });
}

// Input animations
function initializeInputAnimations() {
    document.querySelectorAll('.form-input').forEach(input => {
        input.addEventListener('focus', function() {
            this.parentElement.style.transform = 'scale(1.01)';
            this.parentElement.style.transition = 'transform 0.3s';
        });

        input.addEventListener('blur', function() {
            this.parentElement.style.transform = 'scale(1)';
        });
    });
}

// Email validation
function initializeEmailValidation() {
    const emailInput = document.getElementById('email');
    if (emailInput) {
        emailInput.addEventListener('blur', function() {
            const email = this.value;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            
            if (email && !emailRegex.test(email)) {
                this.style.borderColor = 'var(--danger)';
            } else {
                this.style.borderColor = 'var(--gray-200)';
            }
        });
    }
}

// Weight and height validation
function initializeWeightHeightValidation() {
    const poidsInput = document.getElementById('poids');
    const tailleInput = document.getElementById('taille');

    if (poidsInput) {
        poidsInput.addEventListener('input', function() {
            if (this.value < 20 || this.value > 300) {
                this.setCustomValidity('Le poids doit être entre 20 et 300 kg');
            } else {
                this.setCustomValidity('');
            }
        });
    }

    if (tailleInput) {
        tailleInput.addEventListener('input', function() {
            if (this.value < 100 || this.value > 250) {
                this.setCustomValidity('La taille doit être entre 100 et 250 cm');
            } else {
                this.setCustomValidity('');
            }
        });
    }
}
